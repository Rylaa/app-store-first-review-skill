#!/usr/bin/env bash
# preflight.sh - READ-ONLY App Store first-submission preflight for an iOS/Xcode project.
#
# Never modifies the project, App Store Connect, or any remote state. Writes only
# temporary file lists under $TMPDIR (removed on exit). Never prints secret values:
# key-like matches are reported as file:line only.
#
# Exit code: 1 if any FAIL, 0 otherwise (WARN does not fail), 2 on usage error.

set -uo pipefail

usage() {
  cat <<'EOF'
Usage: preflight.sh [options] [PROJECT_ROOT]

Read-only App Store first-review preflight. Prints PASS / WARN / FAIL lines.

Options:
  --metadata-dir DIR   Extra metadata directory to scan (fastlane or `asc metadata pull`
                       output). Repeatable. Auto-detected: fastlane/metadata, metadata,
                       .asc/metadata under PROJECT_ROOT.
  --ipa PATH           Built .ipa to inspect for bundled .storekit/.xcconfig/.env files.
  --no-color           Disable colors.
  -h, --help           Show this help.

Environment (optional, App Store Connect checks via the `asc` CLI, read-only):
  APP_ID       App Store Connect app ID
  VERSION_ID   App Store version ID
  When both are set and `asc` is installed, runs `asc validate` and checks that
  Review Notes are non-empty and within 4000 bytes. Passwords are never requested.

Checks:
   1 deployment target >= iOS 13         8 test / secret API keys (file:line only)
   2 purpose strings vs APIs used        9 account deletion present
   3 PrivacyInfo.xcprivacy               10 Restore Purchases present
   4 ITSAppUsesNonExemptEncryption       11 Terms / Privacy links in app code
   5 placeholder text in UI strings      12 Sign in with Apple when social login exists
   6 other platforms in metadata         13 SIWA relay domain allowlist
   7 metadata: EULA link, price words    14 .storekit / config files in bundle
                                         15 rating prompt in onboarding
                                         16 asc validate + Review Notes (optional)

Exit: 1 if any FAIL, else 0.
EOF
}

ROOT=""
META_DIRS=()
IPA=""
COLOR=1
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --metadata-dir) [ $# -ge 2 ] || { echo "--metadata-dir needs a value" >&2; exit 2; }; META_DIRS+=("$2"); shift 2 ;;
    --ipa) [ $# -ge 2 ] || { echo "--ipa needs a value" >&2; exit 2; }; IPA="$2"; shift 2 ;;
    --no-color) COLOR=0; shift ;;
    -*) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
    *) ROOT="$1"; shift ;;
  esac
done
ROOT="${ROOT:-.}"
[ -d "$ROOT" ] || { echo "Not a directory: $ROOT" >&2; exit 2; }
ROOT="$(cd "$ROOT" && pwd)"

if [ "$COLOR" -eq 1 ] && [ -t 1 ]; then
  G=$'\033[0;32m'; Y=$'\033[0;33m'; R=$'\033[0;31m'; N=$'\033[0m'
else
  G=""; Y=""; R=""; N=""
fi

NPASS=0; NWARN=0; NFAIL=0
pass() { NPASS=$((NPASS+1)); echo "${G}PASS${N} [$1] $2"; }
warn() { NWARN=$((NWARN+1)); echo "${Y}WARN${N} [$1] $2"; }
fail() { NFAIL=$((NFAIL+1)); echo "${R}FAIL${N} [$1] $2"; }
info() { echo "      -> $1"; }

TMP="$(mktemp -d "${TMPDIR:-/tmp}/preflight.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT

EXCL='/(Pods|Carthage|build|DerivedData|\.build|SourcePackages|node_modules|\.git|xcuserdata|\.swiftpm)/'
TESTS='/[^/]*(Tests|UITests|Mocks?)/|Tests?\.swift$|/Preview Content/|/Previews?/'

# File lists (one path per line, read via tr+xargs -0 so spaces are safe).
list() { find "$ROOT" -type f \( "$@" \) 2>/dev/null | grep -vE "$EXCL" || true; }
list -name '*.swift' -o -name '*.m' -o -name '*.mm' -o -name '*.h' > "$TMP/src"
grep -vE "$TESTS" "$TMP/src" > "$TMP/src_app" || true
list -name '*.strings' -o -name '*.xcstrings' -o -name '*.stringsdict' > "$TMP/strings"
list -name 'Info.plist' -o -name '*-Info.plist' > "$TMP/plists"
list -name 'project.pbxproj' -o -name '*.xcconfig' > "$TMP/build"
list -name '*.swift' -o -name '*.plist' -o -name '*.xcconfig' -o -name '*.json' -o -name '*.strings' -o -name '*.xcstrings' -o -name '*.m' > "$TMP/keyscan"
grep -vE "$TESTS" "$TMP/keyscan" > "$TMP/keyscan_app" || true
list -name '*.swift' -o -name '*.ts' -o -name '*.js' -o -name '*.py' -o -name '*.go' -o -name '*.json' -o -name '*.yaml' -o -name '*.yml' > "$TMP/backend"

# g FLAGS PATTERN LISTFILE -> grep over files in list (no output if list empty)
# shellcheck disable=SC2086 # FLAGS may hold several options ("-nE -i"), word splitting intended
g() { [ -s "$3" ] || return 1; tr '\n' '\0' < "$3" | xargs -0 grep -H $1 -- "$2" 2>/dev/null; }
has() { g "-qE" "$1" "$2"; }
hasi() { g "-qiE" "$1" "$2"; }
# where PATTERN LIST [FLAGS] -> up to 5 file:line refs, relative to ROOT, never the matched text
where() { g "-nE ${3:-}" "$1" "$2" | cut -d: -f1,2 | sed "s|^$ROOT/||" | head -5; }

SWIFT_COUNT=$(wc -l < "$TMP/src" | tr -d ' ')
echo "=== App Store first-review preflight (read-only) ==="
echo "Root: $ROOT   source files: $SWIFT_COUNT   Info.plist: $(wc -l < "$TMP/plists" | tr -d ' ')   project/xcconfig: $(wc -l < "$TMP/build" | tr -d ' ')"
echo
if [ "$SWIFT_COUNT" -eq 0 ]; then
  # every other check would report noise (false FAILs) on a non-project directory
  fail "project" "no Swift/ObjC sources found under $ROOT (wrong root?); nothing else checked"
  exit 1
fi

# --- helpers for Info.plist keys (Info.plist, INFOPLIST_KEY_* build settings) ---
key_value() { # KEY -> prints first value found, empty if none
  local k="$1" f v
  while IFS= read -r f; do
    if command -v plutil >/dev/null 2>&1; then
      v=$(plutil -extract "$k" raw -o - "$f" 2>/dev/null) && { printf '%s' "$v"; return 0; }
    else
      v=$(grep -A1 "<key>$k</key>" "$f" 2>/dev/null | sed -nE 's:.*<string>(.*)</string>.*:\1:p;s:.*<(true|false)/>.*:\1:p' | head -1)
      [ -n "$v" ] && { printf '%s' "$v"; return 0; }
    fi
  done < "$TMP/plists"
  v=$(g "-hE" "INFOPLIST_KEY_$k *= *" "$TMP/build" | head -1 | sed -E 's/.*= *"?([^";]*)"?;?.*/\1/')
  [ -n "$v" ] && { printf '%s' "$v"; return 0; }
  return 1
}

# ---------------- 1. Deployment target ----------------
MIN_DT=$(g "-hoE" "IPHONEOS_DEPLOYMENT_TARGET = [0-9.]+" "$TMP/build" | awk '{print $3}' | sort -t. -k1,1n -k2,2n | head -1)
if [ -z "$MIN_DT" ]; then
  warn "deploy-target" "IPHONEOS_DEPLOYMENT_TARGET not found; uploads must target iOS 13+ (since 2026-09-09)"
elif [ "${MIN_DT%%.*}" -lt 13 ]; then
  fail "deploy-target" "lowest IPHONEOS_DEPLOYMENT_TARGET is $MIN_DT; uploads must target iOS 13+ (since 2026-09-09)"
else
  pass "deploy-target" "lowest IPHONEOS_DEPLOYMENT_TARGET = $MIN_DT"
fi
info "also confirm Xcode 26+ / iOS 26 SDK on the upload machine: xcodebuild -version"

# ---------------- 2. Purpose strings vs APIs ----------------
# KEYS(any of, comma-separated)~API regex~label
while IFS='~' read -r keys api label; do
  [ -z "$keys" ] && continue
  # .addOnly photo access needs only the Add key, so those lines don't count as library reads
  if g "-nE" "$api" "$TMP/src_app" | grep -qv 'addOnly'; then
    found=""; val=""
    IFS=',' read -r -a karr <<< "$keys"
    for k in "${karr[@]}"; do
      if val=$(key_value "$k"); then found="$k"; break; fi
    done
    if [ -z "$found" ]; then
      fail "purpose-string" "$label API used but none of {$keys} is set (crash + 5.1.1 rejection)"
      g "-nE" "$api" "$TMP/src_app" | grep -v 'addOnly' | cut -d: -f1,2 | sed "s|^$ROOT/||" | head -5 | while read -r l; do info "$l"; done
    elif [ "${#val}" -lt 40 ] || printf '%s' "$val" | grep -qiE 'needs? (access|permission)|requires? (access|permission)|is required|to function|access to your'; then
      warn "purpose-string" "$found looks vague (${#val} chars): \"$val\" -- name the feature and give an example"
    else
      pass "purpose-string" "$found set for $label"
    fi
  fi
done <<'EOF'
NSCameraUsageDescription~AVCapture(Device|Session|PhotoOutput)|sourceType *= *\.camera~camera
NSPhotoLibraryUsageDescription~PHPhotoLibrary\.(requestAuthorization|authorizationStatus)|PHAsset\.fetch|PHImageManager~photo library (read)
NSPhotoLibraryAddUsageDescription,NSPhotoLibraryUsageDescription~UIImageWriteToSavedPhotosAlbum|UISaveVideoAtPathToSavedPhotosAlbum|PHAssetCreationRequest|PHAssetChangeRequest~photo library (save)
NSMicrophoneUsageDescription~AVAudioRecorder|requestRecordPermission|installTap\(onBus~microphone
NSSpeechRecognitionUsageDescription~SFSpeechRecognizer~speech recognition
NSLocationWhenInUseUsageDescription,NSLocationAlwaysAndWhenInUseUsageDescription~CLLocationManager~location
NSContactsUsageDescription~CNContactStore~contacts
NSCalendarsFullAccessUsageDescription,NSCalendarsWriteOnlyAccessUsageDescription,NSCalendarsUsageDescription,NSRemindersFullAccessUsageDescription~EKEventStore~calendars/reminders
NSHealthShareUsageDescription,NSHealthUpdateUsageDescription~HKHealthStore~HealthKit
NSBluetoothAlwaysUsageDescription~CBCentralManager|CBPeripheralManager~Bluetooth
NSFaceIDUsageDescription~LAContext~Face ID
NSMotionUsageDescription~CMMotionActivityManager|CMPedometer~motion
NSUserTrackingUsageDescription~ATTrackingManager|requestTrackingAuthorization~App Tracking Transparency
EOF
if has 'PhotosPicker|PHPickerViewController' "$TMP/src_app"; then
  pass "purpose-string" "out-of-process photo picker in use (no photo-library permission needed for picking)"
fi
info "also check every localization of InfoPlist.strings/.xcstrings, and strings injected by SDKs"

# ---------------- 3. Privacy manifest ----------------
list -name 'PrivacyInfo.xcprivacy' > "$TMP/manifests"
APP_MANIFESTS=$(grep -vE "$TESTS" "$TMP/manifests" || true)
if [ -z "$APP_MANIFESTS" ]; then
  fail "privacy-manifest" "no PrivacyInfo.xcprivacy in the app (required-reason APIs: upload rejected since 2024-05-01)"
else
  pass "privacy-manifest" "found: $(printf '%s\n' "$APP_MANIFESTS" | sed "s|^$ROOT/||" | head -3 | tr '\n' ' ')"
  printf '%s\n' "$APP_MANIFESTS" > "$TMP/appmanifests"
  if has 'UserDefaults|@AppStorage' "$TMP/src_app" && ! has 'NSPrivacyAccessedAPICategoryUserDefaults' "$TMP/appmanifests"; then
    warn "privacy-manifest" "UserDefaults/@AppStorage used but no NSPrivacyAccessedAPICategoryUserDefaults reason (e.g. CA92.1)"
  fi
  if has 'ATTrackingManager' "$TMP/src_app" && ! g "-A1" "NSPrivacyTracking<" "$TMP/appmanifests" | grep -q '<true/>'; then
    warn "privacy-manifest" "ATT is used but NSPrivacyTracking is not true in the app manifest; align with App Privacy 'Used to track you'"
  fi
fi
info "run Xcode > Product > Archive > Generate Privacy Report to see every SDK's manifest"

# ---------------- 4. Export compliance ----------------
if ENC=$(key_value ITSAppUsesNonExemptEncryption); then
  pass "encryption" "ITSAppUsesNonExemptEncryption = $ENC"
else
  warn "encryption" "ITSAppUsesNonExemptEncryption not set; ASC will ask the export-compliance questions for each build before it can be submitted"
fi

# ---------------- 5. Placeholder text in user-facing strings ----------------
STRONG='lorem|ipsum'
WEAK='\b(coming soon|todo|tbd|fixme|placeholder|dummy|beta|test|testing)\b'
WEAK_SRC='\b(coming soon|todo|tbd|fixme|dummy|beta|test|testing)\b'  # "placeholder:" is a SwiftUI argument label
UI_CALL='(Text|Button|Label|Toggle|TextField|Section|Link|navigationTitle|alert|confirmationDialog|LocalizedStringKey|String\(localized:)'
g "-nE" "$UI_CALL" "$TMP/src_app" | grep -iE "\"[^\"]*($STRONG)[^\"]*\"" | cut -d: -f1,2 | sed "s|^$ROOT/||" > "$TMP/ph_strong_src" || true
g "-niE" "$STRONG" "$TMP/strings" | cut -d: -f1,2 | sed "s|^$ROOT/||" >> "$TMP/ph_strong_src" || true
g "-nE" "$UI_CALL" "$TMP/src_app" | grep -iE "\"[^\"]*${WEAK_SRC}[^\"]*\"" | cut -d: -f1,2 | sed "s|^$ROOT/||" > "$TMP/ph_weak" || true
g "-niE" "\"[^\"]*${WEAK}[^\"]*\"" "$TMP/strings" | grep -viE '"comment"' | cut -d: -f1,2 | sed "s|^$ROOT/||" >> "$TMP/ph_weak" || true
if [ -s "$TMP/ph_strong_src" ]; then
  fail "placeholder" "lorem/ipsum in user-facing strings (2.1(a) placeholder content)"
  head -5 "$TMP/ph_strong_src" | while read -r l; do info "$l"; done
fi
if [ -s "$TMP/ph_weak" ]; then
  warn "placeholder" "$(wc -l < "$TMP/ph_weak" | tr -d ' ') user-facing string(s) contain coming soon/TODO/beta/test/placeholder -- verify each"
  head -5 "$TMP/ph_weak" | while read -r l; do info "$l"; done
fi
[ -s "$TMP/ph_strong_src" ] || [ -s "$TMP/ph_weak" ] || pass "placeholder" "no placeholder words in UI string literals or string catalogs"

# ---------------- 6/7. Metadata directories ----------------
for d in "$ROOT/fastlane/metadata" "$ROOT/metadata" "$ROOT/.asc/metadata"; do [ -d "$d" ] && META_DIRS+=("$d"); done
if [ "${#META_DIRS[@]}" -eq 0 ]; then
  warn "metadata" "no metadata directory found; pull it with 'asc metadata pull --app APP_ID --version X --dir /tmp/meta' and rerun with --metadata-dir /tmp/meta"
else
  : > "$TMP/meta"
  for d in "${META_DIRS[@]}"; do
    [ -d "$d" ] || { warn "metadata" "not a directory: $d"; continue; }
    find "$d" -type f \( -name '*.txt' -o -name '*.json' -o -name '*.md' \) >> "$TMP/meta" 2>/dev/null
  done
  if hasi 'android|google play|play store' "$TMP/meta"; then
    fail "other-platform" "Android / Google Play mentioned in App Store metadata (2.3.10)"
    where 'android|google play|play store' "$TMP/meta" -i | while read -r l; do info "$l"; done
  else
    pass "other-platform" "no Android / Google Play mentions in metadata"
  fi
  # EULA link per description file (fastlane description.txt, asc version/*/<locale>.json)
  grep -E '/description\.txt$|/version/[^/]+/[^/]+\.json$' "$TMP/meta" > "$TMP/desc" || true
  if [ ! -s "$TMP/desc" ]; then
    warn "eula-link" "no description files found in metadata dirs; check each locale for a Terms of Use (EULA) link manually"
  else
    missing=0
    while IFS= read -r f; do
      if ! grep -qiE 'stdeula|https?://[^ "]*(terms|eula|tos)|(terms of use|eula|terms of service)[^"]*https?://' "$f"; then
        missing=$((missing+1)); info "no Terms of Use link: ${f#"$ROOT"/}"
      fi
    done < "$TMP/desc"
    if [ "$missing" -gt 0 ]; then
      fail "eula-link" "$missing description file(s) lack a Terms of Use (EULA) link (top 3.1.2(c) rejection; needed in EVERY locale unless a custom EULA is set in ASC)"
    else
      pass "eula-link" "every description file contains a Terms of Use link"
    fi
  fi
  # Price words in name/subtitle (2.3.7). Screenshots must be checked by eye/OCR.
  grep -E '/(name|subtitle|promotional_text)\.txt$|/app-info/[^/]+\.json$' "$TMP/meta" > "$TMP/namefiles" || true
  NAMEHITS=$( { g "-liE" '\b(free|trial|discount|sale|% off)\b|[$€£]' "$TMP/namefiles" | grep -E '\.txt$'; \
                g "-liE" '"(name|subtitle)" *: *"[^"]*(\bfree\b|\btrial\b|\bdiscount\b|[$€£]|% off)' "$TMP/namefiles"; } 2>/dev/null | sed "s|^$ROOT/||" | sort -u)
  if [ -n "$NAMEHITS" ]; then
    warn "price-words" "price/free/trial words in name, subtitle or promo text (2.3.7)"
    printf '%s\n' "$NAMEHITS" | head -5 | while read -r l; do info "$l"; done
  else
    pass "price-words" "no price/free/trial words in name/subtitle files"
  fi
  info "screenshots: check by eye that >50% show the app in use and none show prices or 'free'"
fi
if hasi '\b(android|google play|play store)\b' "$TMP/strings"; then
  warn "other-platform" "Android / Google Play mentioned in app string catalogs"
  where '\b(android|google play|play store)\b' "$TMP/strings" -i | while read -r l; do info "$l"; done
fi

# ---------------- 8. Test / secret API keys (file:line only) ----------------
if has '"test_[A-Za-z0-9]{20,}"|= *test_[A-Za-z0-9]{20,}' "$TMP/keyscan_app"; then
  if has '"appl_[A-Za-z0-9]{20,}"|= *appl_[A-Za-z0-9]{20,}' "$TMP/keyscan_app"; then
    warn "api-keys" "RevenueCat test_ key present alongside an appl_ key; confirm Release builds use appl_ (values not shown)"
  else
    fail "api-keys" "RevenueCat test_ key found and no production appl_ key (Test Store purchases will not work in review; values not shown)"
  fi
  where '"test_[A-Za-z0-9]{20,}"|= *test_[A-Za-z0-9]{20,}' "$TMP/keyscan_app" | while read -r l; do info "$l"; done
else
  pass "api-keys" "no RevenueCat test_ keys in app sources"
fi
if has '\bsk_(live_|test_)?[A-Za-z0-9]{20,}' "$TMP/keyscan_app"; then
  fail "api-keys" "secret-key pattern (sk_...) in client files -- secret keys must never ship in the app (values not shown)"
  where '\bsk_(live_|test_)?[A-Za-z0-9]{20,}' "$TMP/keyscan_app" | while read -r l; do info "$l"; done
fi

# ---------------- 9. Account deletion ----------------
ACCOUNT='ASAuthorizationAppleIDProvider|SignInWithAppleButton|GIDSignIn|FBLoginButton|LoginManager\(\)|Auth\.auth\(\)|createUser|signUp|Purchases\.shared\.logIn'
DELETE='delete ?account|deleteAccount|delete ?my ?data|deleteMyData|deleteUser|accountDeletion'
cat "$TMP/src_app" "$TMP/strings" > "$TMP/src_and_strings"
if hasi "$DELETE" "$TMP/src_and_strings"; then
  pass "account-deletion" "account/data deletion found in code or strings"
  if has 'ASAuthorizationAppleIDProvider|SignInWithAppleButton' "$TMP/src_app" && ! hasi 'revoke' "$TMP/backend"; then
    warn "account-deletion" "Sign in with Apple is used but no 'revoke' call found; deletion should revoke SIWA tokens (may live in another repo)"
  fi
elif has "$ACCOUNT" "$TMP/src_app"; then
  fail "account-deletion" "accounts/identity detected but no in-app deletion found (5.1.1(v); guest/device accounts included)"
  where "$ACCOUNT" "$TMP/src_app" | head -3 | while read -r l; do info "$l"; done
else
  warn "account-deletion" "no deletion keywords found; if the server stores any per-user data (even device IDs), offer in-app deletion"
fi

# ---------------- 10. Restore Purchases ----------------
PURCHASE='Purchases\.(shared|configure)|import RevenueCat|Product\.purchase|\.purchase\(|SubscriptionStoreView|ProductView|PaywallView|SKPaymentQueue'
RESTORE='restorePurchases|AppStore\.sync|restoreCompletedTransactions'
if has "$PURCHASE" "$TMP/src_app"; then
  if has "$RESTORE" "$TMP/src_app"; then
    pass "restore" "restore call found"
  elif has 'PaywallView|presentPaywall' "$TMP/src_app"; then
    warn "restore" "only RevenueCatUI paywall found; confirm its template shows Restore, and add Restore in Settings"
  else
    fail "restore" "purchases detected but no restorePurchases / AppStore.sync call (3.1.1 / 3.1.2)"
  fi
else
  pass "restore" "no in-app purchase code detected (skip)"
fi

# ---------------- 11. Terms / Privacy links in app ----------------
if has "$PURCHASE" "$TMP/src_app"; then
  T=0; P=0
  hasi 'https?://[^" ]*(terms|eula|tos|stdeula)' "$TMP/keyscan_app" && T=1
  hasi 'https?://[^" ]*privacy' "$TMP/keyscan_app" && P=1
  if [ $T -eq 1 ] && [ $P -eq 1 ]; then
    pass "legal-links" "Terms and Privacy URLs present in app files; confirm both are tappable ON the paywall"
  else
    warn "legal-links" "Terms URL found=$T, Privacy URL found=$P in app files; paywall must link both (3.1.2(c)) unless provided by a remote paywall config"
  fi
fi

# ---------------- 12. Sign in with Apple when social login exists ----------------
SOCIAL='GIDSignIn|GoogleSignIn|FBSDKLoginKit|FBLoginButton|LoginManager\(\)|TWTRTwitter|LineSDK|KakaoSDK'
if has "$SOCIAL" "$TMP/src_app"; then
  if has 'ASAuthorizationAppleIDProvider|SignInWithAppleButton' "$TMP/src_app"; then
    pass "siwa" "social login and Sign in with Apple both present (check equal prominence)"
  else
    warn "siwa" "third-party social login without Sign in with Apple; 4.8 requires an equivalent privacy-preserving login option (SIWA is the usual one) unless an exception applies"
    where "$SOCIAL" "$TMP/src_app" | head -3 | while read -r l; do info "$l"; done
  fi
else
  pass "siwa" "no third-party social login detected"
fi

# ---------------- 13. SIWA relay domain ----------------
if has 'privaterelay\.appleid\.com' "$TMP/backend" && ! has 'private\.icloud\.com' "$TMP/backend"; then
  warn "siwa-relay" "privaterelay.appleid.com referenced without private.icloud.com (new relay domain since 2026-08-24)"
  where 'privaterelay\.appleid\.com' "$TMP/backend" | while read -r l; do info "$l"; done
fi

# ---------------- 14. Bundled config files ----------------
STOREKIT=$(list -name '*.storekit' | sed "s|^$ROOT/||")
if [ -n "$IPA" ]; then
  if [ ! -f "$IPA" ]; then
    fail "bundle" "--ipa file not found: $IPA"
  elif ! command -v unzip >/dev/null 2>&1; then
    warn "bundle" "unzip not available; cannot inspect $IPA"
  else
    BAD=$(unzip -Z1 "$IPA" 2>/dev/null | grep -iE '\.storekit$|\.xcconfig$|(^|/)\.env|secrets?\.(json|plist|env)$' || true)
    if [ -n "$BAD" ]; then
      fail "bundle" "IPA contains config/test files (2.3.1(a) hidden features; reported as 5.6 rejections)"
      printf '%s\n' "$BAD" | head -5 | while read -r l; do info "$l"; done
    else
      pass "bundle" "IPA has no .storekit/.xcconfig/.env/secrets files"
    fi
  fi
elif [ -n "$STOREKIT" ]; then
  warn "bundle" ".storekit file(s) in the repo; with Xcode synchronized folders they can ship in the IPA. Rerun with --ipa to verify"
  printf '%s\n' "$STOREKIT" | head -3 | while read -r l; do info "$l"; done
else
  pass "bundle" "no .storekit files in the repo"
fi

# ---------------- 15. Rating prompt in onboarding ----------------
g "-lE" 'requestReview|SKStoreReviewController' "$TMP/src_app" | grep -iE 'onboard|welcome|intro|firstlaunch|first_launch' > "$TMP/rate" || true
if [ -s "$TMP/rate" ]; then
  warn "rating-prompt" "review prompt in onboarding/first-launch code; reported 5.6 rejections in 2026 (custom prompts are disallowed by 5.6.1)"
  sed "s|^$ROOT/||" "$TMP/rate" | head -3 | while read -r l; do info "$l"; done
fi

# ---------------- 16. App Store Connect (optional, read-only) ----------------
echo
if ! command -v asc >/dev/null 2>&1; then
  warn "asc" "asc CLI not installed; skipped App Store Connect checks"
elif [ -z "${APP_ID:-}" ] || [ -z "${VERSION_ID:-}" ]; then
  warn "asc" "set APP_ID and VERSION_ID to run asc validate and the Review Notes check"
else
  ASC_ARGS=(validate --app "$APP_ID" --version-id "$VERSION_ID" --output table)
  [ -n "$IPA" ] && [ -f "$IPA" ] && ASC_ARGS+=(--ipa "$IPA")
  if asc "${ASC_ARGS[@]}" > "$TMP/validate.txt" 2>&1; then
    pass "asc-validate" "asc validate reported no blockers (rerun with --deep --check-urls for agreements, App Privacy, URLs)"
  else
    fail "asc-validate" "asc validate reported blockers:"
    head -40 "$TMP/validate.txt" | sed 's/^/      /'
  fi
  # Default output redacts demo passwords; we print only lengths and booleans.
  if asc review details-for-version --version-id "$VERSION_ID" --output json > "$TMP/rd.json" 2>/dev/null; then
    read_field() { # FIELD -> value (jq, python3, or empty)
      if command -v jq >/dev/null 2>&1; then
        jq -r "[.. | objects | .$1? // empty] | first // empty" "$TMP/rd.json" 2>/dev/null
      elif command -v python3 >/dev/null 2>&1; then
        python3 -I - "$TMP/rd.json" "$1" <<'PY' 2>/dev/null
import json, sys
def walk(o, k):
    if isinstance(o, dict):
        if k in o and o[k] is not None: return o[k]
        for v in o.values():
            r = walk(v, k)
            if r is not None: return r
    elif isinstance(o, list):
        for v in o:
            r = walk(v, k)
            if r is not None: return r
    return None
r = walk(json.load(open(sys.argv[1])), sys.argv[2])
print("" if r is None else (str(r).lower() if isinstance(r, bool) else r), end="")
PY
      fi
    }
    NOTES=$(read_field notes)
    NBYTES=$(printf '%s' "$NOTES" | wc -c | tr -d ' ')
    if [ "$NBYTES" -eq 0 ]; then
      fail "review-notes" "Review Notes are empty (see references/review-notes-template.md)"
    elif [ "$NBYTES" -gt 4000 ]; then
      fail "review-notes" "Review Notes are $NBYTES bytes; limit is 4000"
    elif [ "$NBYTES" -lt 300 ]; then
      warn "review-notes" "Review Notes are only $NBYTES bytes; first submissions need purpose, flows, IAPs, AI providers, devices tested"
    else
      pass "review-notes" "Review Notes present ($NBYTES bytes)"
    fi
    DEMO_REQ=$(read_field demoAccountRequired)
    DEMO_NAME=$(read_field demoAccountName)
    if [ "$DEMO_REQ" = "true" ] && [ -z "$DEMO_NAME" ]; then
      fail "demo-account" "Sign-in required is set but no demo username is filled"
    elif [ "$DEMO_REQ" = "true" ]; then
      pass "demo-account" "demo account configured (credentials not shown); verify it signs in right now"
    else
      info "Sign-in required is off; notes must say why no account is needed"
    fi
  else
    warn "review-notes" "could not read review details for VERSION_ID (none created yet, or auth issue: run 'asc auth doctor')"
  fi
fi

# ---------------- Summary ----------------
echo
echo "Not checkable here: paywall layout and price prominence, AI consent screen, ATT timing,"
echo "IAPs attached to the submission, App Privacy answers, age rating, screenshots. See SKILL.md stages 4-8."
echo "Summary: ${G}${NPASS} PASS${N}  ${Y}${NWARN} WARN${N}  ${R}${NFAIL} FAIL${N}"
[ "$NFAIL" -eq 0 ]
