#!/usr/bin/env bash
# shellcheck disable=SC2015 # 'cond && echo ok || {...}': echo cannot fail
# test-preflight.sh - self-check for preflight.sh using two throwaway fixtures in $TMPDIR.
# Usage: bash scripts/test-preflight.sh
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PF="$HERE/preflight.sh"
T="$(mktemp -d "${TMPDIR:-/tmp}/pftest.XXXXXX")"
trap 'rm -rf "$T"' EXIT
FAILS=0
expect() { # OUTPUT_FILE REGEX DESCRIPTION
  if grep -qE "$2" "$1"; then echo "ok   - $3"; else echo "FAIL - $3"; FAILS=$((FAILS+1)); fi
}
reject() {
  if grep -qE "$2" "$1"; then echo "FAIL - $3"; FAILS=$((FAILS+1)); else echo "ok   - $3"; fi
}

# --- Bad fixture: every check should trip ---
B="$T/bad"; mkdir -p "$B/App.xcodeproj" "$B/App" "$B/fastlane/metadata/en-US"
cat > "$B/App.xcodeproj/project.pbxproj" <<'EOF'
IPHONEOS_DEPLOYMENT_TARGET = 12.0;
INFOPLIST_KEY_NSCameraUsageDescription = "Needs camera access";
EOF
cat > "$B/App/ContentView.swift" <<'EOF'
import SwiftUI
import RevenueCat
import GoogleSignIn
let s = AVCaptureSession()
let key = "test_AbCdEfGhIjKlMnOpQrStUvWx"
let mic = AVAudioRecorder()
struct V: View { var body: some View { Text("Lorem ipsum dolor"); Button("Coming soon") {} } }
func buy() { Purchases.shared.purchase(package: p) }
func login() { GIDSignIn.sharedInstance.signIn() }
EOF
echo "Great app. Also on Android." > "$B/fastlane/metadata/en-US/description.txt"
echo "Free AI Photos" > "$B/fastlane/metadata/en-US/name.txt"
: > "$B/App/Configuration.storekit"
echo 'func done() { requestReview() }' > "$B/App/OnboardingView.swift"
bash "$PF" --no-color "$B" > "$T/bad.out" 2>&1; BAD_RC=$?
[ "$BAD_RC" -eq 1 ] && echo "ok   - bad fixture exits 1" || { echo "FAIL - bad fixture exit $BAD_RC"; FAILS=$((FAILS+1)); }
expect "$T/bad.out" 'FAIL \[deploy-target\]' "deployment target < 13"
expect "$T/bad.out" 'WARN \[purpose-string\] NSCameraUsageDescription looks vague' "vague camera string"
expect "$T/bad.out" 'FAIL \[purpose-string\] microphone' "missing mic string"
expect "$T/bad.out" 'FAIL \[privacy-manifest\]' "missing privacy manifest"
expect "$T/bad.out" 'WARN \[encryption\]' "missing encryption key"
expect "$T/bad.out" 'FAIL \[placeholder\]' "lorem ipsum"
expect "$T/bad.out" 'WARN \[placeholder\]' "coming soon"
expect "$T/bad.out" 'FAIL \[other-platform\]' "Android in metadata"
expect "$T/bad.out" 'FAIL \[eula-link\]' "missing EULA link"
expect "$T/bad.out" 'WARN \[price-words\]' "free in name"
expect "$T/bad.out" 'FAIL \[api-keys\]' "RevenueCat test key"
reject "$T/bad.out" 'AbCdEfGhIjKlMn' "secret value never printed"
expect "$T/bad.out" 'FAIL \[account-deletion\]' "no deletion with Google login"
expect "$T/bad.out" 'FAIL \[restore\]' "no restore"
expect "$T/bad.out" 'WARN \[siwa\]' "Google without SIWA"
expect "$T/bad.out" 'WARN \[rating-prompt\]' "review prompt in onboarding"
expect "$T/bad.out" 'WARN \[bundle\]' ".storekit in repo"

# --- Good fixture: no FAIL lines expected ---
G="$T/good"; mkdir -p "$G/App.xcodeproj" "$G/App" "$G/fastlane/metadata/en-US"
cat > "$G/App.xcodeproj/project.pbxproj" <<'EOF'
IPHONEOS_DEPLOYMENT_TARGET = 17.0;
INFOPLIST_KEY_NSCameraUsageDescription = "MyApp uses the camera so you can take a selfie for your avatar, for example a front-facing portrait.";
INFOPLIST_KEY_ITSAppUsesNonExemptEncryption = NO;
INFOPLIST_KEY_NSPhotoLibraryAddUsageDescription = "MyApp saves the videos you create to your photo library, for example after you tap Save.";
EOF
cat > "$G/App/PrivacyInfo.xcprivacy" <<'EOF'
<plist><dict><key>NSPrivacyTracking</key><false/><key>NSPrivacyAccessedAPIType</key><string>NSPrivacyAccessedAPICategoryUserDefaults</string></dict></plist>
EOF
cat > "$G/App/ContentView.swift" <<'EOF'
import SwiftUI
import RevenueCat
let s = AVCaptureSession()
let key = "appl_AbCdEfGhIjKlMnOpQrStUvWx"
let event = "test_purchaseStarted1"  // analytics name, must not trip the key check
let terms = URL(string: "https://example.com/terms")!
let privacy = URL(string: "https://example.com/privacy")!
struct V: View { var body: some View { Text("Create your look"); Button("Delete Account") {} } }
func buy() { Purchases.shared.purchase(package: p) }
func restore() { Purchases.shared.restorePurchases() }
func save() async { _ = await PHPhotoLibrary.requestAuthorization(for: .addOnly) }
EOF
printf 'Great app.\nTerms of Use: https://www.apple.com/legal/internet-services/itunes/dev/stdeula/\n' > "$G/fastlane/metadata/en-US/description.txt"
echo "MyApp AI Photos" > "$G/fastlane/metadata/en-US/name.txt"
bash "$PF" --no-color "$G" > "$T/good.out" 2>&1; GOOD_RC=$?
[ "$GOOD_RC" -eq 0 ] && echo "ok   - good fixture exits 0" || { echo "FAIL - good fixture exit $GOOD_RC"; FAILS=$((FAILS+1)); cat "$T/good.out"; }
reject "$T/good.out" '^FAIL' "good fixture has no FAIL lines"
expect "$T/good.out" 'PASS \[eula-link\]' "EULA link detected"
expect "$T/good.out" 'PASS \[restore\]' "restore detected"

# --- Empty directory: one FAIL, nothing else ---
mkdir -p "$T/empty"
bash "$PF" --no-color "$T/empty" > "$T/empty.out" 2>&1; EMPTY_RC=$?
[ "$EMPTY_RC" -eq 1 ] && [ "$(grep -c '^FAIL' "$T/empty.out")" -eq 1 ] && echo "ok   - empty dir: single FAIL, exit 1" || { echo "FAIL - empty dir"; FAILS=$((FAILS+1)); cat "$T/empty.out"; }

# --- Read-only: fixtures unchanged ---
[ -z "$(find "$B" "$G" -newer "$T/good.out" -type f)" ] && echo "ok   - no files modified" || { echo "FAIL - files modified"; FAILS=$((FAILS+1)); }

echo
[ "$FAILS" -eq 0 ] && echo "All preflight self-checks passed." || { echo "$FAILS self-check(s) failed. Bad output:"; cat "$T/bad.out"; }
[ "$FAILS" -eq 0 ]
