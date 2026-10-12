# Privacy, Tracking, Manifests, Login and Account Deletion

Evidence cutoff 2026-10-12. Labels: OFFICIAL / REPORTED / ASSUMED / NOT FOUND.

## Contents

1. Privacy policy and support URL (5.1.1(i))
2. App Privacy details (the label)
3. Privacy manifest, required-reason APIs, signed SDKs
4. ATT with Meta and Adjust (5.1.2)
5. Purpose strings (5.1.1)
6. Permission primers (5.1.1(iv))
7. Login: forced login, Sign in with Apple, social tokens
8. Account deletion (5.1.1(v))
9. Export compliance
10. Consistency check: one table for policy, label, manifest, prompts

## 1. Privacy policy and support URL (5.1.1(i))

- A privacy policy link is required in the ASC metadata field and "within the app in an easily accessible manner" (OFFICIAL, guidelines 5.1.1(i), Jun 8, 2026).
- Content: "Identifies the data the app collects, how it collects that data, and all uses of that data. Confirms that any third party with whom the app shares user data provides the same or equal protection... Explains your data retention and deletion policies and describes how a user can revoke consent and/or request deletion of their data." (OFFICIAL, https://developer.apple.com/distribute/app-review/, accessed 2026-10-12)
- "A link to user support with up-to-date contact information and a link to your privacy policy is required for all apps." (OFFICIAL, same page)
- Name in the policy: every SDK that receives data (RevenueCat, Meta, Adjust, Firebase, crash reporter), every AI provider, and your backend/storage. Include a face-data section if photos of people are processed (see `generative-ai-apps.md` § 5).
- Check: `curl -sIL <url>` returns 200 with no login wall; links reachable from Settings and from the paywall.

## 2. App Privacy details (the label)

- Required for distribution and must include the practices of "third-party partners whose code you integrate" (OFFICIAL, https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy and https://developer.apple.com/app-store/app-privacy-details/, accessed 2026-10-12).
- "Collect" means sent off device and retained longer than needed to service the request in real time (OFFICIAL, app-privacy-details page).
- Whether data sent to AI providers must be declared depends on provider retention; treating it as "collected" is the conservative reading (ASSUMED).
- Typical inventory for this stack: RevenueCat (purchase history, user ID); Meta and Adjust (device ID, product interaction, advertising data; "Used to track you" if ATT-authorized tracking); Firebase (app/device identifiers if Analytics or Messaging); crash reporter (diagnostics); photos/prompts (user content, if retained).
- Label changes take effect when published. If the LIVE version contains `NSUserTrackingUsageDescription`, ASC refuses to remove "tracking" (REPORTED, https://www.reddit.com/r/iosdev/comments/1s6ucnq/, 2026-03-29; https://developer.apple.com/forums/thread/840650, Aug 2026, DTS: check whether an SDK still links AdSupport/AppTrackingTransparency). For a first submission, decide the tracking stance before v1.0 ships.

## 3. Privacy manifest, required-reason APIs, signed SDKs

- Since May 1, 2024: "apps that don't describe their use of required reason API in their privacy manifest file aren't accepted by App Store Connect" (OFFICIAL, https://developer.apple.com/news/upcoming-requirements/, possibly stale date, rule current).
- Categories: FileTimestamp, SystemBootTime, DiskSpace, ActiveKeyboards, UserDefaults (OFFICIAL, https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api, accessed 2026-10-12). Most SwiftUI apps need at least UserDefaults (`CA92.1` for app-only access).
- Each SDK bundle carries its own manifest. Listed SDKs (including FBSDKCoreKit, FBSDKLoginKit, FBAEMKit, FirebaseCore, FirebaseAuth, FirebaseFirestore, FirebaseMessaging, FirebaseRemoteConfig, GoogleSignIn, GoogleUtilities, Alamofire) need a manifest when a new app includes them, plus a signature when used as binary dependencies (OFFICIAL, https://developer.apple.com/support/third-party-SDK-requirements/, accessed 2026-10-12).
- Adjust, RevenueCat and Sentry are NOT on Apple's list as of 2026-10-12, but must still ship manifests if they use required-reason APIs or collect data (OFFICIAL list; obligation per privacy-manifest docs).
- Check: Xcode Product > Archive > Generate Privacy Report; every SDK appears with its manifest. Use current SPM/CocoaPods versions of FBSDK and Firebase that ship signed xcframeworks.
- Missing-reason uploads produce an App Store Connect email; the code ITMS-91053 is from memory (ASSUMED).

## 4. ATT with Meta and Adjust (5.1.2)

Rules (OFFICIAL, https://developer.apple.com/app-store/user-privacy-and-data-use/ and guidelines 5.1.2(i), accessed 2026-10-12):

- ATT permission is required before tracking or accessing IDFA, including "Placing a third-party SDK in your app that combines user data from your app with user data from other developers' apps to target advertising or measure advertising efficiency".
- "Your app may not require users to enable system functionalities (e.g. push notifications, location services, tracking) in order to access functionality, content, use the app, or receive monetary or other compensation". No credits for allowing tracking.
- No fingerprinting; if the user declines, no hashed email/phone tracking.
- From iOS 27.2 an alternative EU ATT prompt is available and is the only option in DE, FR, IT, PL, RO; when to ask is unchanged (OFFICIAL, https://developer.apple.com/news/?id=idsft9ai, Sep 16, 2026).

Reported failures:

- "we are unable to locate the App Tracking Transparency permission request" when the prompt only appeared after a later rewarded-ad action (REPORTED, https://www.reddit.com/r/appledevelopers/comments/1w6wvsy/, 2026-09-04).
- Label says tracking, no ATT prompt → 5.1.2(i) (REPORTED, https://www.reddit.com/r/iosdev/comments/1s3c009/, 2026-03-25).

Checks:

- [ ] `NSUserTrackingUsageDescription` is specific ("We use your device's advertising identifier to measure which ads brought you to <App>").
- [ ] `ATTrackingManager.requestTrackingAuthorization` runs early and reliably on first launch (after the app is active, typically in onboarding), before Meta/Adjust collect IDFA.
- [ ] Meta and Adjust initialize after the ATT result (or with their wait/delay APIs); see the `marketing-att-pipeline` skill.
- [ ] The prompt appears in the review build on iPhone and iPad; Review Notes say where.
- [ ] App Privacy "Used to track you" matches what the SDKs do. That the declaration and the prompt must match is REPORTED as a common rejection, not quoted from Apple.
- [ ] `otool -L` on the binary: AdSupport/AppTrackingTransparency linkage matches the label.

## 5. Purpose strings (5.1.1)

- Must name the specific feature, give an example, be one sentence in active voice, and be localized for every supported localization (OFFICIAL, https://developer.apple.com/help/app-review/guideline-reference/5-1-1-purpose-strings, accessed 2026-10-12).
- Reported rejection text: "Update the camera and photo library purpose string to explain how the app will use the requested information and provide a specific example of how the data will be used." (REPORTED, https://developer.apple.com/forums/thread/790111, Jun 2025)
- Template: `<App> uses <resource> to <feature>. For example, <concrete example>.`
  - Camera: "MyApp uses the camera so you can take a selfie for your AI avatar, for example a front-facing photo for a new look."
  - Photos (only if you need library access): "MyApp uses the photos you choose to create AI images, for example turning a portrait into a styled photo shoot."
  - Microphone: "MyApp uses the microphone while you hold the record button to capture your voice for a video narration."
- Prefer `PhotosPicker` / `PHPickerViewController` (out of process, no photo permission). "Where possible, use the out-of-process picker or a share sheet rather than requesting full access to protected resources like Photos or Contacts." (OFFICIAL, 5.1.1(iii)).
- Check strings injected by SDKs too. Request permission when the feature is used, not at launch.
- Degrade gracefully when a permission is denied: "Where possible, provide alternative solutions for users who don't grant consent" (OFFICIAL, 5.1.1(iv)); "Paid functionality must not be dependent on or require a user to grant access to this data" (OFFICIAL, 5.1.1(ii)); never require push, location or tracking to use the app (OFFICIAL, 5.1.2(i)).

## 6. Permission primers (5.1.1(iv))

- Allowed: a transparent explanation before the system prompt (OFFICIAL for ATT, user-privacy-and-data-use page).
- Reported rejections: button copy "Enable Microphone" (passed with "Continue"); "Maybe later" or skip options before the system prompt treated as priming (REPORTED, https://www.reddit.com/r/iOSProgramming/comments/1t57gda/, 2026-05-06; https://www.reddit.com/r/appledevelopers/comments/1w44704/, 2026-09-01).
- Rules for a `PermissionPrimer` component: neutral explanation matching the Info.plist string; one button labelled "Continue" or "Next" that always triggers the system prompt; no Allow/Enable wording; no skip; no incentive.

## 7. Login: forced login, Sign in with Apple, social tokens

- "If your app doesn't include significant account-based features, let people use it without a login." (OFFICIAL, 5.1.1(v)). Registration before buying non-account IAP was rejected (REPORTED, https://www.reddit.com/r/reactnative/comments/1t58gjm/, 2026-05-06; https://developer.apple.com/forums/thread/818946, Mar 2026).
- Anonymous device identity (Keychain device token, RevenueCat anonymous App User ID, Firebase anonymous auth) is consistent with this (REPORTED pass, https://www.reddit.com/r/iOSProgramming/comments/1vby2km/, 2026-07-31).
- Don't require name, age or gender in onboarding unless needed: apps "may not require users to enter personal information to function, except when directly relevant to the core functionality" (OFFICIAL, 5.1.1).
- 4.8: if Google/Facebook/X login is the primary account, also offer an equivalent privacy-preserving login (in practice Sign in with Apple) with equal prominence (OFFICIAL). Exceptions include apps that exclusively use their own account system and clients for a specific third-party service.
- After SIWA: don't ask for the name again; prefill from the credential (only returned on the first authorization) and keep it optional (REPORTED, https://www.reddit.com/r/AppBusiness/comments/1wbfu32/, 2026-09-09).
- Relay email: accept `privaterelay.appleid.com` and `private.icloud.com` (OFFICIAL, https://developer.apple.com/news/?id=1ptvdtcm, Aug 24, 2026).
- Social network credentials: keep tokens on device, offer in-app revoke, don't use them off-device (OFFICIAL, 5.1.1(v)).

## 8. Account deletion (5.1.1(v))

OFFICIAL (https://developer.apple.com/help/app-review/guideline-reference/5-1-1-account-deletion and https://developer.apple.com/support/offering-account-deletion-in-your-app/, accessed 2026-10-12):

- If the app supports account creation, offer in-app deletion that is easy to find, typically in account settings.
- "Only offering to temporarily deactivate or disable an account is insufficient." Deletion includes user content.
- Non-regulated apps must not require a phone call, email or support chat.
- Apps with Sign in with Apple "should use the Sign in with Apple REST API to revoke user tokens".
- "If a person has an auto-renewable subscription, notify them that billing will continue through Apple and ask them to cancel their subscription before continuing."
- "People should have the option to delete automatically generated accounts (sometimes called "guest" accounts) and the data associated with those accounts." Device-token accounts with server records count.

Checklist:

- [ ] Settings > Delete Account (or "Delete my data") with a confirmation.
- [ ] Server deletes the profile, generations, uploaded photos and stored media; keeps only legally required records (e.g. transaction ledger entries), and the policy says so.
- [ ] SIWA token revoked; Keychain token cleared; app returns to a fresh state.
- [ ] Confirmation mentions an active subscription and links to manage subscriptions (`showManageSubscriptions` / `manageSubscriptionsSheet`).
- [ ] Works for the demo account; give reviewers a second account because they may delete one (REPORTED, https://www.reddit.com/r/iosdev/comments/1rrmx18/, 2026-03-12).

## 9. Export compliance

- Set `ITSAppUsesNonExemptEncryption` in Info.plist "so that you don't need to answer encryption questions with each app submission" (OFFICIAL, https://developer.apple.com/help/app-store-connect/manage-app-information/overview-of-export-compliance, accessed 2026-10-12).
- Set `NO` if the app (including linked libraries) uses no encryption or only exempt encryption; "Typically, the use of encryption that's built into the operating system—for example ... HTTPS ... is exempt" (OFFICIAL, https://developer.apple.com/documentation/bundleresources/information-property-list/itsappusesnonexemptencryption).
- Set `YES` plus `ITSEncryptionExportComplianceCode` for non-exempt encryption. France has separate controls.

## 10. Consistency check

Reviewers compare these; mismatches are what get cited (REPORTED pattern across 5.1.1/5.1.2 rejections):

| Data / behavior | Privacy policy | App Privacy label | PrivacyInfo.xcprivacy | In-app prompt/consent |
|---|---|---|---|---|
| Photos/prompts to AI providers | names providers | User Content (if retained) | NSPrivacyCollectedDataTypes | AI consent screen |
| IDFA via Meta/Adjust | names SDKs, tracking | Used to track you | NSPrivacyTracking + domains | ATT prompt |
| Purchases via RevenueCat | names RevenueCat | Purchase history | per SDK manifest | n/a |
| Crash reports | names vendor | Diagnostics | per SDK manifest | n/a |
| Account / device ID | retention + deletion | Identifiers | n/a | Delete account |

Fill this table for the app before submitting; every row should be consistent across columns.
