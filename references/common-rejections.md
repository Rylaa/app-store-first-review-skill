# Common First-Submission Rejections (2025-06 to 2026-10)

Each entry gives: the reviewer wording (as reposted by developers, so REPORTED unless marked), how reviewers catch it, the check, the fix, and sources with dates. Frequency counts are the number of independent reports found in the research lane, not Apple statistics.

## Contents

1. 3.1.2(c) Terms of Use (EULA) missing from metadata
2. 3.1.2(c) Required subscription info missing in the app
3. 3.1.2(c) Billed amount not the most prominent price
4. 3.1.2 Free-trial toggle
5. 5.6 / 3.1.2 Exit-intent discount on the paywall
6. 2.1(b) IAPs not submitted with the version (and the separate-draft trap)
7. 2.1(b) IAPs do not load or the buy button does nothing
8. 2.1 Information Needed: New App Submission
9. 2.1 Demo account missing, broken, or in the wrong state
10. 2.1(a) Crash or hang on the reviewer device
11. 4.0 iPad compatibility layout
12. 4.3(a)/(b) Spam
13. 5.6 Hidden features / fraud pattern
14. 5.1.2(i) Third-party AI data sharing without consent
15. 5.1.1 Vague purpose strings
16. 5.1.1(iv) Permission priming
17. 5.1.2(i) ATT not found / label mismatch
18. 4.8 / 4.0 Sign in with Apple missing or re-asking the name
19. 5.1.1(v) Forced login
20. 5.1.1(v) Account deletion
21. 3.1.1 Restore missing
22. 2.3.7 Prices or "free" in screenshots and metadata
23. 2.3.x Screenshots don't match the build
24. 2.3.10 Other-platform mentions
25. 4.1(a)/(c) Copycats and trademarks
26. 1.5 / 5.1.1(i) Broken URLs
27. IAP metadata duplicated across products
28. 4.2 Minimum functionality / empty first launch
29. 1.1 Objectionable-content potential (AI templates)
30. 1.2 / 4.7 UGC and chatbot safeguards
31. 2.3.6 Age rating mismatch
32. 5.1.2 Game Center / other consent gaps
33. 5.6.1 / 5.6.3 Rating prompt in onboarding

---

## 1. 3.1.2(c) Terms of Use (EULA) missing from metadata

- **Wording (REPORTED):** "The app's metadata is missing the following required information: * A functional link to the Terms of Use (EULA). If you are using the standard Apple Terms of Use (EULA), include a link to the Terms of Use in the App Description. If you are using a custom EULA, add it in App Store Connect." (https://developer.apple.com/forums/thread/809505, Dec 2025)
- **Frequency:** 12+ reports, the single most frequent "silly" subscription rejection. In one case the developer suspected (unconfirmed) that the link was in the French description but not the English one (https://developer.apple.com/forums/thread/786790, Jun 2025, possibly stale). Another was rejected twice before fixing (https://www.reddit.com/r/iosdev/comments/1rrmx18/, 2026-03-12).
- **Official basis:** "your app and App Store metadata must include links to your Terms of Use and Privacy Policy" (OFFICIAL, https://developer.apple.com/app-store/subscriptions/, accessed 2026-10-12).
- **Caught by:** metadata read. The Privacy Policy URL field alone does not satisfy it; in-app links alone do not satisfy it.
- **Check:** every localization's description contains a working Terms of Use URL (Apple standard EULA `https://www.apple.com/legal/internet-services/itunes/dev/stdeula/` or your own) and a Privacy Policy URL, or a custom EULA is set in ASC.
- **Fix:** append a "Subscription details" block to every locale (template in `subscriptions-and-iap.md`).
- **Sources:** forum threads 809505 (Dec 2025), 786790 (Jun 2025), 813493 (Jan 2026), 809635 (Dec 2025); https://www.reddit.com/r/iOSProgramming/comments/1s2e3lj/ (2026-03-24, 3 of 5 apps); https://www.reddit.com/r/AppBusiness/comments/1wcdvzm/ (2026-09-10); https://www.reddit.com/r/appledevelopers/comments/1ug880a/ (2026-06-26). All REPORTED.

## 2. 3.1.2(c) Required subscription info missing in the app

- **Wording (REPORTED):** "The following information needs to be included within the app: A functional link to the Terms of Use (EULA) / A functional link to the Privacy Policy" (https://developer.apple.com/forums/thread/813493, Jan 2026). For a SubscriptionStoreView paywall: "The app offers a free trial or introductory period but does not make it clear that a payment will be automatically initiated for the next subscription period" (https://www.reddit.com/r/iosdev/comments/1rmrnup/, 2026-03-06).
- **Official basis:** DPLA Schedule 2 §3.8(b): title, length, price (and price per unit if appropriate), Privacy Policy and Terms of Use links "accessible within Your Licensed Application" (OFFICIAL, https://developer.apple.com/support/terms/apple-developer-program-license-agreement/, fetched 2026-10-12).
- **Caught by:** reviewer opens the paywall during the purchase test. "Having them in Settings isn't enough. Apple wants them visible ON the purchase screen" (REPORTED, 1s2e3lj, 2026-03-24).
- **Check / fix:** see `subscriptions-and-iap.md` § Paywall disclosure checklist. Check every RevenueCat paywall variant, not only the default offering.

## 3. 3.1.2(c) Billed amount not the most prominent price

- **Official:** "the amount that will be billed must be the most prominent pricing element in the layout" (OFFICIAL, https://developer.apple.com/app-store/subscriptions/, accessed 2026-10-12).
- **Wording (REPORTED):** "The auto-renewable subscription promotes the free trial, introductory pricing, or introductory period for the subscription more clearly and conspicuously than the billed amount." (https://developer.apple.com/forums/thread/841626, Aug 2026). "The actual billed amount needs to be the most prominent price." ($0.96/week at 42pt over a small $49.99; https://www.reddit.com/r/indiehackersindia/comments/1w1ho7v/, 2026-08-29).
- **Pattern:** a dev rejected twice with "$0" and then "Start 3-day free trial" as the hero; passed with CTA "Continue for $4.99 / month" and the trial as a caption (https://www.reddit.com/r/buildinpublic/comments/1uo5pki/, 2026-07-05). Also "The app doesn't clearly describe what the user receives for the price" (https://www.reddit.com/r/appledevelopers/comments/1v1a9eh/, 2026-07-20).
- **Check:** the billed amount is the largest price text on each card; per-week/day breakdowns are visibly smaller; "FREE"/"$0" never dominates; benefits are listed.
- **Fix:** billed price is the hero; trial and breakdowns are captions; list concrete benefits ("200 credits/month, HD export").

## 4. 3.1.2 Free-trial toggle

- **Wording (REPORTED via vendor):** "The purchase screen includes a toggle to add or remove a free trial from the subscription purchase" ... "Remove the toggle for adding or removing a free trial from the subscription purchase screen." (https://www.revenuecat.com/blog/growth/r-i-p-toggle-paywall-we-hardly-knew-ye/, Feb 9, 2026, updated Apr 23, 2026; https://adapty.io/blog/your-toggle-paywall-is-about-to-get-rejected/, 2026). Also https://www.reddit.com/r/AppStoreOptimization/comments/1qeavxq/ (2026-01-16).
- **Fix:** separate plan cards ("Weekly", "Yearly with 3-day free trial"), each showing its own billed price.

## 5. 5.6 / 3.1.2 Exit-intent discount on the paywall

- **Wording (REPORTED):** "The app attempts to manipulate customers into making unwanted in-app purchases. Specifically, your app still displayed an additional discount offer when we attempted to exit the subscription page." (https://www.reddit.com/r/iOSProgramming/comments/1pa71k5/, 2025-11-30). A commenter copied a top-chart app's exact UX and was still rejected; the reviewer said they can't comment on other apps.
- **Check:** tap X on every paywall; it dismisses immediately.
- **Fix:** put all offers on the single paywall; use Apple win-back offers or later sessions for re-engagement.

## 6. 2.1(b) IAPs not submitted with the version (and the separate-draft trap)

- **Wording (REPORTED):** "We are unable to complete the review of the app because one or more of the in-app purchase products have not been submitted for review. Specifically, the app includes references to subscriptions but the associated in-app purchase products have not been submitted for review... Note you must provide an App Review screenshot in App Store Connect in order to submit in-app purchases for review." (https://developer.apple.com/forums/thread/816376, Feb 2026)
- **Official:** "The first consumable, non-consumable, auto-renewable subscription, and non-renewing subscription In-App Purchase of each type must be submitted with a new app version." ... "The app version, subscription group, and every subscription or In-App Purchase you want reviewed together must all be added to the same draft submission before you click Submit for Review." (OFFICIAL, https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-in-app-purchase, accessed 2026-10-12)
- **Trap (REPORTED):** when v1.0 sits in a rejected submission, "Add for Review" on IAPs creates a separate draft that fails with "Unable to Submit for Review: To submit your items for review, add an app version for the selected platform." Working fix reported by two developers in https://developer.apple.com/forums/thread/850187 (~2026-10-09): remove the version from the rejected submission, add every subscription individually (not just the group), then "Add for Review" on the version into the same draft. https://developer.apple.com/forums/thread/840483 (Aug 2026) shows the same lock with no fix; an App Store Commerce Engineer replied that an issue affected some IAP submissions in a recent update. The subscription group also needs an App Store localization first (https://www.reddit.com/r/AppBusiness/comments/1wcdvzm/, 2026-09-10).
- **Check:** `asc validate subscriptions --app APP_ID`, `asc validate iap --app APP_ID`, `asc review items list --submission SUBMISSION_ID`; every product referenced by RevenueCat offerings is in the submission.

## 7. 2.1(b) IAPs do not load or the buy button does nothing

- **Wording (REPORTED):** "The In-App Purchase products exhibited one or more bugs which create a poor user experience. Specifically, tapping on go premium has no functionality." (https://www.reddit.com/r/appledevelopers/comments/1uj4z9x/, 2026-06-29). "the app displayed no pricing on the Subscription page, while the Continue button produced no purchase flow" (https://www.reddit.com/r/iOSProgramming/comments/1opbclo/, 2025-11-05).
- **Official:** review runs in the sandbox; paid IAPs "won't function in review until" the Paid Apps Agreement is active; "In-App Purchases do not need prior approval from App Review to function in review." (OFFICIAL, https://developer.apple.com/help/app-review/before-submitting-for-review/configure-in-app-purchases, accessed 2026-10-12)
- **Reported causes:** products not attached (#6); Paid Apps Agreement inactive (https://www.reddit.com/r/applestore/comments/1svldy4/, 2026-04-25); fresh-account code path differs from the dev's own; an error modal over a fullscreen paywall left an invisible tap-swallowing layer (1w1ho7v, 2026-08-29); paywall failed to load → blank screen (https://www.reddit.com/r/iosdev/comments/1ushcmq/, 2026-07-10); region-restricted products (https://www.reddit.com/r/iOSProgramming/comments/1q085ch/, 2025-12-31); testing only with a .storekit file (https://www.reddit.com/r/iOSProgramming/comments/1p1bx7y/, 2025-11-19); StoreKit returned no products on the reviewer device, so the RevenueCat offering was empty (https://developer.apple.com/forums/thread/844471, Sep 2026); RevenueCat `offerings_fetch_failed` (https://origin-devforums.apple.com/forums/thread/818349, Mar 2026).
- **Check:** fresh sandbox Apple ID, fresh install, TestFlight build without .storekit, on iPad, under bad network. Prices render, failures show an error with Retry, cancel leaves the UI tappable.

## 8. 2.1 Information Needed: New App Submission

- **Wording (REPORTED, 2026 template):** "Guideline 2.1 - Information Needed - New App Submission ... 1. A screen recording captured on a physical device, running the latest operating system, demonstrating the app's functionality. The recording must begin with launching the app and show the typical user flow through its core features. If the app has any of the following, include them in the recording: - Account registration, login, and account deletion flows - Accessing paid content or features within the app, including any purchase or subscription flows - User-generated content, including content reporting and blocking mechanisms - Any prompts requesting access to sensitive data or device capabilities (for example, location, contacts, camera, or App Tracking Transparency) 2. A list of the device models and operating systems the app was tested on ... 3. A description of the app's purpose and target audience ... 4. Instructions for setting up and accessing the app's main features..." (https://www.reddit.com/r/iosdev/comments/1u70od4/, 2026-06-16). An AI video generator got it (https://www.reddit.com/r/appledevelopers/comments/1v7p8ql/, 2026-07-27).
- **Automated variant (REPORTED):** "An automated analysis of the submission indicates the app may include a login but was submitted without a demo account. Demo accounts are required for apps with account-based features." Triggered even for SIWA/Google-only apps (https://www.reddit.com/r/iOSProgramming/comments/1sm15zd/, 2026-04-15).
- **Official basis:** Review Notes for a new app should cover concept, business model, audience, devices/OS tested, external services "for example ... payment processors, or AI services", regional differences (OFFICIAL, https://developer.apple.com/help/app-review/before-submitting-for-review/complete-review, accessed 2026-10-12).
- **Fix:** answer all four items up front in the notes and link the recording. One dev reports first-try approvals with "review notes as a full test script" (https://www.reddit.com/r/appledevelopers/comments/1tisu0l/, 2026-05-20).

## 9. 2.1 Demo account missing, broken, or in the wrong state

- **Official:** apps with auto-renewable subscriptions should provide "a demo account with an expired subscription to enable review of the entire purchase flow"; if login needs a 2FA/OTP code, put it in Notes, otherwise a call may be required; "Calls are typically completed within three to five business days" (OFFICIAL, https://developer.apple.com/help/app-review/before-submitting-for-review/complete-review, accessed 2026-10-12). The demo account "must not expire" (OFFICIAL, https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information).
- **Reported failures:** reviewer account already Pro hid the paywall and Restore, "4 rounds of back-and-forth" (https://www.reddit.com/r/vibecoding/comments/1tawhbd/, 2026-05-12); generous free credits so the reviewer never hit the paywall (https://www.reddit.com/r/SideProject/comments/1w10cu1/, 2026-08-28); a sandbox tester Apple ID entered as app credentials that didn't exist in the app's DB (https://www.reddit.com/r/AppBusiness/comments/1wbfu32/, 2026-09-09); the reviewer actually deleted the demo account during the deletion test (1rrmx18, 2026-03-12).
- **Fix:** seed a dedicated reviewer account per submission (scripted); reset entitlements in RevenueCat; provide two accounts if deletion exists.

## 10. 2.1(a) Crash or hang on the reviewer device

- **Wording (REPORTED, automated):** "This is an automated message. The review of this submission cannot proceed... The app crashed after the initial launch. Apps that crash negatively impact users." (https://www.reddit.com/r/iOSProgramming/comments/1t1999m/, 2026-05-01)
- **Reported causes:** crash only on Apple's iPads (https://www.reddit.com/r/SideProject/comments/1w4wiqh/, 2026-09-02); unresponsive after login under poor network (https://www.reddit.com/r/iOSProgramming/comments/1pqlcss/, 2025-12-19); camera features blocked in iPad compat mode (https://www.reddit.com/r/iOSProgramming/comments/1phizap/, 2025-12-08); backend deploy during review (1tawhbd, 2026-05-12).
- **Official:** "Don't submit for review without testing your app's behavior in compatibility modes." (OFFICIAL, https://developer.apple.com/help/app-review/before-submitting-for-review/test-compatible-devices, accessed 2026-10-12)
- **Note:** that reviewers deliberately test on degraded networks is community belief (ASSUMED).

## 11. 4.0 iPad compatibility layout

- **Wording (REPORTED):** "Parts of the app's user interface were crowded, laid out, or displayed in a way that made it difficult to use the app when reviewed on iPad Air 11-inch (M3) running iPadOS 26.6. Specifically, layout in iPad were not optimized" (https://www.reddit.com/r/iOSProgramming/comments/1vmeqyq/, 2026-08-12). Also https://www.reddit.com/r/iOSProgramming/comments/1reaor0/ (2026-02-25), 1s0nb97 (2026-03-22).
- **Official:** "Adding or removing iPad as a supported destination in Xcode won't change that app's availability on iPad." (OFFICIAL, test-compatible-devices page above)
- **Fix:** keep `TARGETED_DEVICE_FAMILY = 1` unless you designed for iPad (adding iPad also requires 13-inch iPad screenshots); wrap fixed-height screens in ScrollView; test iPad mini and 11-inch.

## 12. 4.3(a)/(b) Spam

- **Official:** 4.3(a) "Don't create multiple Bundle IDs of the same app"; 4.3(b) "Don't submit apps that are indistinguishable from what's already widely available. Opportunistically creating variants of existing app categories or popular apps degrades App Store discovery" (OFFICIAL, guidelines Jun 8, 2026; clarified with examples https://developer.apple.com/news/?id=a233fmpw). "Submitting several apps that are essentially the same ties up the App Review process" (OFFICIAL, https://developer.apple.com/distribute/app-review/).
- **Wording (REPORTED), factors list:** "Submitting an app with the same source code or assets as other apps already submitted to the App Store - Creating and submitting multiple similar apps using a repackaged app template - Purchasing an app template with problematic code from a third party - Submitting several similar apps across multiple accounts" (https://www.reddit.com/r/iOSProgramming/comments/1q4rljp/, 2026-01-05).
- **Pattern (REPORTED):** Aug-Oct 2026 spike, often instant; 4 first-time apps rejected in parallel (1w07lj9, 2026-08-27); a veteran approved after a long originality reply (https://www.reddit.com/r/appledevelopers/comments/1wjgb26/, 2026-09-18); dating rejected as "similar to existing dating apps" under 4.3(b) (https://www.reddit.com/r/appledevelopers/comments/1wnap6j/, 2026-09-22; https://developer.apple.com/forums/thread/850439, Oct 2026) (4.3(b) itself names dating and fortune telling as saturated, OFFICIAL); repeated resubmission brought an "account removal for repeated noncompliance" warning (1wj2j1d, 2026-09-17; https://developer.apple.com/forums/thread/847013); an update rejected under 4.3(a) after adding RevenueCat + Meta SDK + ATT was overturned by the App Review Board (https://www.reddit.com/r/iOSProgramming/comments/1w9ojf7/, 2026-09-07).
- **How caught:** devs infer automated binary/metadata similarity from instant rejections with zero backend sessions (ASSUMED).
- **Fix:** see `resubmission-and-appeals.md` § 4.3. Before submitting: one app per concept, distinct UI/screenshots/copy, don't submit several similar apps at once.

## 13. 5.6 Hidden features / fraud pattern

- **Wording (REPORTED, paraphrased):** "a pattern of unusual behavior commonly associated with fraudulent activity"; "features that appear to have been intentionally hidden during the review process" (https://www.reddit.com/r/iOSProgramming/comments/1wydut7/, 2026-10-05; https://developer.apple.com/forums/thread/841506, Aug 2026).
- **Case:** an Xcode synchronized folder shipped `Configuration.storekit` (listing more products than submitted) inside the Release IPA; after excluding it the next review was ordinary (1wydut7). Projects using `PBXFileSystemSynchronizedRootGroup` add every file in the folder to the target unless excepted.
- **Official basis:** 2.3.1(a) no hidden, dormant or undocumented features; 2.5.2 no downloaded code that changes features (OFFICIAL, guidelines Jun 8, 2026).
- **Check:** `unzip -l App.ipa | grep -Ei 'storekit|xcconfig|\.env|secrets'` is empty; remote config doesn't unlock unreviewed features; debug menus compiled out.
- **Fix:** add membership exceptions for .storekit/.xcconfig in synchronized groups; a build phase that fails if they reach the bundle; disclose remote-configured content in notes.

## 14. 5.1.2(i) Third-party AI data sharing without consent

- **Wording (REPORTED):** "The app appears to share the user's personal data with a third-party AI service but the app does not clearly explain what data is sent, identify who the data is sent to, and ask the user's permission before sharing the data... the app's privacy policy must also identify what data the app collects, how it collects that data, and all uses of that data, including if it is shared with a third-party AI service." (https://developer.apple.com/forums/thread/816140, Feb 2026). "only including this information in the app's Terms of Service or Privacy Policy is not sufficient" (https://developer.apple.com/forums/thread/822961, Apr 2026). Repeat rejection: "We were not presented with the consent prompt on launch or anywhere else in the app." (https://developer.apple.com/forums/thread/820209, Mar 2026)
- **Details and fix:** `generative-ai-apps.md` § Third-party AI consent.

## 15. 5.1.1 Vague purpose strings

- **Wording (REPORTED):** "One or more purpose strings in the app do not sufficiently explain the use of protected resources. Purpose strings must clearly and completely describe the app's use of data and, in most cases, provide an example of how the data will be used." (https://developer.apple.com/forums/thread/790111, Jun 2025)
- **Rejected examples:** "In order to take a picture or video, this app requires permission to access the camera" (790111); "Location is needed for app to function" (1rrmx18).
- **Official:** purpose strings name the feature, give an example, one sentence, active voice, localized for every supported localization (OFFICIAL, https://developer.apple.com/help/app-review/guideline-reference/5-1-1-purpose-strings, accessed 2026-10-12).
- **Fix:** see `privacy-and-tracking.md` § Purpose strings. Prefer PhotosPicker (no photo permission needed).

## 16. 5.1.1(iv) Permission priming

- **Reports (REPORTED):** custom screen button "Enable Microphone" rejected, "Continue" passed (https://www.reddit.com/r/iOSProgramming/comments/1t57gda/, 2026-05-06); HealthKit pre-screen with "Maybe later" rejected as priming, neutral screen with plain Continue passed (https://www.reddit.com/r/appledevelopers/comments/1w44704/, 2026-09-01); "Connect Apple Health" + "Maybe later" rejected (1w1ho7v, 1w2annj).
- **Official basis:** don't manipulate or force consent (5.1.1(iv)); a transparent pre-prompt explanation is allowed for ATT (OFFICIAL, https://developer.apple.com/app-store/user-privacy-and-data-use/).
- **Fix:** neutral explanation + single "Continue" that always triggers the system prompt; no skip, no incentive.

## 17. 5.1.2(i) ATT not found / label mismatch

- **Wording (REPORTED):** "The app uses the AppTrackingTransparency framework, but we are unable to locate the App Tracking Transparency permission request when reviewed on iOS 26.6.1 and iPadOS 26.6.1." (https://www.reddit.com/r/appledevelopers/comments/1w6wvsy/, 2026-09-04). "The app privacy information provided in App Store Connect indicates the app collects data in order to track the user, including Device ID. However, the app does not use App Tracking Transparency to request the user's permission before tracking their activity." (https://www.reddit.com/r/iosdev/comments/1s3c009/, 2026-03-25)
- **Catch-22 (REPORTED):** after removing tracking, ASC refused to uncheck tracking: "Your app contains NSUserTrackingUsageDescription, indicating that it may request permission to track users..." because the live version contains the key (https://www.reddit.com/r/iosdev/comments/1s6ucnq/, 2026-03-29; https://developer.apple.com/forums/thread/840650, Aug 2026).
- **Details:** `privacy-and-tracking.md` § ATT.

## 18. 4.8 / 4.0 Sign in with Apple missing or re-asking the name

- **Official 4.8:** a third-party/social primary login requires an equivalent login that limits data to name and email, allows a private email, and doesn't track without consent (OFFICIAL, guidelines Jun 8, 2026).
- **Reported:** 4.8 missing in 5 reports (1w1ho7v, 1svldy4, 1tawhbd); "my onboarding asked for a name that the Authentication Services framework had already handed over. Guideline 4 violation" (1wbfu32, 2026-09-09); older wording "requires users to provide their name after signing in" (https://developer.apple.com/forums/thread/751115, 2024, possibly stale).
- **Fix:** SIWA with equal prominence; store `fullName` on the first callback; name/email fields optional and prefilled.

## 19. 5.1.1(v) Forced login

- **Wording (REPORTED):** "The app requires users to register or log in to access features that are not account based." and "We noticed that the app requires users to register with personal information to purchase In-App Purchase products that are not account based." (AI comic journaling app, https://www.reddit.com/r/reactnative/comments/1t58gjm/, 2026-05-06). Also https://developer.apple.com/forums/thread/818946 (Mar 2026): "it is not appropriate to force user registration to meet this requirement".
- **Reported pass:** Firebase anonymous auth (UID, no personal info) for credit packs (https://www.reddit.com/r/iOSProgramming/comments/1vby2km/, 2026-07-31). A hard paywall with no free tier was approved when login was not forced (https://www.reddit.com/r/AppBusiness/comments/1wfd836/, 2026-09-13).
- **Fix:** anonymous/device identity for purchases; optional account linking later.

## 20. 5.1.1(v) Account deletion

- **Official:** in-app, easy to find; deactivation is insufficient; no phone/email/support flow for non-regulated apps; revoke SIWA tokens; warn that subscription billing continues through Apple; guest accounts deletable too (OFFICIAL, https://developer.apple.com/help/app-review/guideline-reference/5-1-1-account-deletion and https://developer.apple.com/support/offering-account-deletion-in-your-app/, accessed 2026-10-12).
- **Reported:** delete button opening a pre-filled support email rejected (1rrmx18, 2026-03-12); "Contact support won't pass" (1tawhbd); deletion without SIWA revoke rejected (1s2e3lj, 2026-03-24).
- **Details:** `privacy-and-tracking.md` § Account deletion.

## 21. 3.1.1 Restore missing

- **Official:** the sign-up screen needs "A way for current subscribers to sign in or restore purchases" (OFFICIAL, https://developer.apple.com/app-store/subscriptions/); 3.1.1 restore mechanism for restorable purchases.
- **Evidence strength:** no verbatim 2025-2026 rejection found; only checklists (REPORTED: 1s0kw1w 2026-03-22, 1tawhbd, 1rmrnup). Older wording "does not include a Restore Purchases feature" (https://developer.apple.com/forums/thread/112115, pre-2025, possibly stale). Low frequency, but trivially cheap to satisfy.
- **Fix:** Restore on the paywall and in Settings, wired to `Purchases.shared.restorePurchases()` on user tap, with success/none-found feedback.

## 22. 2.3.7 Prices or "free" in screenshots and metadata

- **Wording (REPORTED):** "The app screenshots include references to the price of the app or the service it provides, which is not considered an appropriate part of these metadata items. Note that references to free or discounted services are considered a price reference and are not appropriate for app metadata." (https://www.reddit.com/r/iOSProgramming/comments/1vtbupn/, 2026-08-20)
- **Triggers seen:** free-vs-premium comparison screenshot; caption "Split in any currency, free" (https://www.reddit.com/r/buildinpublic/comments/1wx5stl/, 2026-10-04); paywall screenshot with prices (1wcdvzm); "Start with three days free" (1wbfu32).
- **Official:** 2.3.7 names, subtitles, screenshots and previews "should not include prices" (OFFICIAL, guidelines Jun 8, 2026). Pricing in the description is expected.
- **Details:** `metadata-and-screenshots.md`.

## 23. 2.3.x Screenshots don't match the build

- **Reported:** rejected "because the screenshots were showing things accessible only when we've got a premium access"; a screenshot showed a flow that had changed and the reviewer could not reproduce it (1s2e3lj comments, 2026-03); "screenshots looked too promotional" (1ushcmq, 2026-07-10). Weak evidence (2 reports).
- **Official:** more than half of screenshots must show the app in use (OFFICIAL, https://developer.apple.com/help/app-review/guideline-reference/2-3-3-screenshots); 2.3.2 must indicate if featured items require additional purchase.

## 24. 2.3.10 Other-platform mentions

- **Reported:** What's New "alignment of design with android" rejected; removing "android" passed (https://www.reddit.com/r/iOSProgramming/comments/1w0fk2c/, 2026-08-28). Older: "Android and Web questions coming soon" (1uvcdz9, 2023 incident, possibly stale).
- **Check:** description, What's New, promo text, keywords, screenshots, and Localizable strings for Android, Google Play, Play Store.

## 25. 4.1(a)/(c) Copycats and trademarks

- **Wording (REPORTED):** "Guideline 4.1(a) - Design - Copycats ... The app's metadata still contains third-party content similar to a popular app or game ... Specifically, the app's name and subtitle includes references to Plex, Emby and Stremio... If you have the necessary rights ... attach documentary evidence in the App Review Information section" (https://www.reddit.com/r/iosdev/comments/1sjcqc8/, 2026-04-12). Persisted even though Plex's own trademark rules allow "Works with Plex".
- **Official:** 4.1(c) (Nov 13, 2025); help page bans "references to popular app names or trademarked terms in any metadata field" (OFFICIAL, https://developer.apple.com/help/app-review/guideline-reference/4-1-prevent-copycat-rejection).

## 26. 1.5 / 5.1.1(i) Broken URLs

- **Reported:** support URL 404 → "Guideline 1.5 (Support URL not reachable)" (1svldy4, 2026-04-25); "Reviewers actually check it" (1rrmx18).
- **Official:** "All links in your app must be functional. A link to user support with up-to-date contact information and a link to your privacy policy is required for all apps." (OFFICIAL, https://developer.apple.com/distribute/app-review/, accessed 2026-10-12). Support URL "must lead to real contact information".
- **Check:** `curl -sIL` every ASC URL and in-app legal link, logged out: 200, no auth wall.

## 27. IAP metadata duplicated across products

- **Wording (REPORTED):** "We noticed that the display names and descriptions for your promoted In-App Purchase products and/or win back offers, Huge golden beans pack, Medium Golden Beans Pack, ... are the same, which makes it hard for users to identify what they are purchasing from the App Store." (1w6wvsy, 2026-09-04). Reused image across IAPs rejected (1tawhbd).
- **Fix:** unique names/descriptions stating quantity or period ("100 credits"); unique promo images.

## 28. 4.2 Minimum functionality / empty first launch

- **Wording (REPORTED):** "Guideline 4.2.2 - Design - Minimum Functionality. We noticed that your app only includes links, images, or content aggregated from the Internet with limited or no native functionality." (https://www.reddit.com/r/iOSProgramming/comments/1ppwejy/, 2025-12-18)
- **Reported:** empty library on first launch read as "doesn't do enough"; fixed with seeded samples (https://www.reddit.com/r/iOSProgramming/comments/1ukh8d3/, 2026-07-01); on-device AI app whose Background Assets were only downloadable after approval was rejected for weeks (https://www.reddit.com/r/iosdev/comments/1wuwc15/, 2026-10-01).
- **Fix:** seeded example gallery; core generation works in review without later downloads.

## 29. 1.1 Objectionable-content potential (AI templates)

- **Wording (REPORTED):** "The app includes templates for generating content showing people making intimate contact with each other, such as hugging, kissing, or other intimate templates. While these templates alone may not be objectionable, they could be used to create objectionable content." (https://developer.apple.com/forums/thread/809787, rejections May and Oct 2025). Virtual try-on rejected: "Specifically, simulating outfit try-ons and styling" despite own-photo-only warnings (https://developer.apple.com/forums/thread/826606, May 2026). Apple on competitors: "another app being out of compliance is not a reason for your app to be."
- **Details:** `generative-ai-apps.md`.

## 30. 1.2 / 4.7 UGC and chatbot safeguards

- **Official:** filter objectionable material, report mechanism with timely response, block abusive users, published contact info (1.2; 4.7.1 for chatbots) (OFFICIAL, guidelines Jun 8, 2026).
- **Reported:** report alone insufficient, block required (1rrmx18, 2026-03-12).

## 31. 2.3.6 Age rating mismatch

- **Reported:** "Age Assurance" answered Yes incorrectly → 2.3.6 (1s0nb97, 2026-03-22).
- **Official:** answer honestly; a mis-rating "could trigger an inquiry from government regulators" (2.3.6, guidelines Jun 8, 2026). AI output counts (https://developer.apple.com/news/?id=ks775ehf, Jul 24, 2025).

## 32. 5.1.2 Game Center / other consent gaps

- **Wording (REPORTED):** "The app does not obtain the user's consent prior to uploading users' scores to a global leaderboard." (https://www.reddit.com/r/iOSProgramming/comments/1w02jic/, 2026-08-27). Generalization: anything that publishes user data needs consent first (ASSUMED).

## 33. 5.6.1 / 5.6.3 Rating prompt in onboarding

- **Official:** "Use the provided API to prompt users to review your app ... and we will disallow custom review prompts." (5.6.1); "Manipulating any element of the App Store customer experience such as charts, search, reviews, or referrals to your app ... is not permitted." (5.6.3); no rewards or gating for ratings (3.2.2(x)) (OFFICIAL, guidelines Jun 8, 2026).
- **Reported:** Apple "has started rejecting" apps that ask for a rating during onboarding, cited as 5.6.3; no Apple wording quoted (REPORTED, vendor blog, https://www.revenuecat.com/blog/engineering/dont-prompt-ratings-during-onboarding, Jun 18, 2026). A developer with repeated unexplained 5.6 rejections was told by another developer that early rating requests are a common trigger (REPORTED, community claim, https://developer.apple.com/forums/thread/848158, ~Sep 2026).
- **Why it matters here:** paywall-first onboarding templates for subscription apps often include a "Rate us" step before the paywall.
- **Check:** no `requestReview` / `SKStoreReviewController` call and no custom star or "Enjoying the app?" screen in onboarding or first launch (`scripts/preflight.sh` warns on onboarding files).
- **Fix:** call `requestReview` only after a success moment (for example after the user saves a finished generation), never gate it on a satisfaction answer, and never reward it.

---

## Low-confidence or not found in 2025-2026 reports

IPv6-only network rejections (only 2016-2018 threads, stale); keyword stuffing (no 2025-2026 report); crash when a backend flag is off (no direct report); "coming soon" placeholder (one report, 2023 incident). Still check them; don't prioritize them.
