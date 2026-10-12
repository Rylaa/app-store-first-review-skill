# Review Notes Templates

Fill-in templates for App Store Connect > version > App Review Information > Notes. Evidence cutoff 2026-10-12.

## Why the notes matter

- Apple asks a new app's notes to cover the concept and business model, purpose and audience, devices and OS versions tested, external services used for core functionality ("for example ... payment processors, or AI services"), and regional differences. "Generic descriptions will be rejected." (OFFICIAL, https://developer.apple.com/help/app-review/before-submitting-for-review/complete-review, accessed 2026-10-12; 2.3.1(a), guidelines Jun 8, 2026)
- Apple's checklist: "detailed explanations of non-obvious features and in-app purchases in the App Review notes" (OFFICIAL, guidelines "Before You Submit", Jun 8, 2026).
- "If features require an environment that is hard to replicate or require specific hardware, be prepared to provide a demo video or the hardware." (OFFICIAL, https://developer.apple.com/distribute/app-review/, accessed 2026-10-12)
- In 2026 many first submissions receive "2.1 Information Needed - New App Submission" asking for a physical-device screen recording, devices/OS tested, purpose and audience, and setup instructions (REPORTED, https://www.reddit.com/r/iosdev/comments/1u70od4/, 2026-06-16). Answering those four items up front avoids a round trip that can cost days. A developer reports first-try approvals with notes written as a test script (REPORTED, https://www.reddit.com/r/appledevelopers/comments/1tisu0l/, 2026-05-20).

## Limits and field rules

- Notes: up to 4000 bytes (OFFICIAL, https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information). Non-ASCII characters cost more than one byte. Check with `printf '%s' "$NOTES" | wc -c`.
- "Sign-in required" only when the app requires login. The demo account "must not expire" (OFFICIAL, same page).
- Contact phone with `+` and country code.
- Set notes with `asc review details-update --id DETAIL_ID --notes "..."` (writes to ASC; run deliberately, not from preflight).

## The screen recording

Record on a physical device on the latest iOS, starting from app launch (REPORTED request wording, 1u70od4). Include, in order, whatever applies:

1. Launch and onboarding, including every permission prompt (ATT, camera, photos, notifications) and the AI consent screen.
2. Account registration/login (or show that none is needed).
3. Core flow: upload/prompt → generation → result → Report button.
4. Paywall → sandbox purchase → credits/entitlement applied → Restore.
5. Sharing/feed with Report and Block, if any.
6. Settings → Delete account/data.

Host it as an unlisted link that needs no login, or attach it in App Review Information. Keep it under ~3 minutes (ASSUMED reviewer-friendly length).

## Template A: no-login / device-account app (anonymous ID)

```
PURPOSE AND AUDIENCE
<App> lets adults create <images/videos> of themselves from a selfie and a text prompt.
Audience: <creators / general consumers, 18+ / 13+>.

ACCOUNTS
No account or sign-in. Identity is an anonymous device ID; "Sign-in required" is unchecked.
All features, the paywall and purchases are available without registration.
Settings > Delete My Data erases the device profile, uploads and generations on our server.

HOW TO TEST (about 3 minutes)
1. Launch > onboarding (3 screens) > ATT prompt appears on screen 2.
2. AI consent screen appears before the first upload (Create tab). Tap Agree.
3. Create tab > pick a photo > choose "<template>" > Generate. Typical time: <N> s.
4. Result screen: ••• > Report.
5. A fresh install has <N> free credits; after that the paywall opens. Or tap the crown icon (top right) to open it directly.
6. Paywall > Restore Purchases at the bottom. Settings also has Restore.

TESTED ON
iPhone <model> (iOS <x>), iPad <model> (iPadOS <x>, compatibility mode).

EXTERNAL SERVICES
RevenueCat (purchases), <AI Provider A>, <AI Provider B> (generation), <analytics/attribution SDKs>, <crash reporter>.
No regional differences.
```

## Template B: app with login

```
DEMO ACCOUNT
Username: <reviewer@domain>   Password: <in the credential fields>
The account has no active subscription and <N> credits so you can reach the paywall.
No 2FA/OTP is required for this account. A second account is provided because the
deletion test removes the first: <reviewer2@domain>.
Sign in with Apple also works with any Apple ID.
Account deletion: Settings > Account > Delete Account (revokes Sign in with Apple, warns about active subscriptions).
```

If login is only Sign in with Apple, OTP or magic link: say which path the reviewer can use (static code for the reviewer address, or "use any Apple ID"). An automated pre-check flags apps that seem to have a login but no demo account (REPORTED, https://www.reddit.com/r/iOSProgramming/comments/1sm15zd/, 2026-04-15).

## Template C: subscription and credits block (add to A or B)

```
IN-APP PURCHASES (all attached to this version)
- <app>.weekly: auto-renewing, 1 week, <N> credits per week.
- <app>.yearly: auto-renewing, 1 year, <N> credits per month, <3-day free trial for eligible users>.
- <app>.credits.100 / .500: consumable credit packs; purchased credits never expire.
One generation costs <N> credits (video <M>). Subscription allowance resets each period;
purchased credits do not.
Paywall: <path>. Restore: paywall footer and Settings > Restore Purchases.
This version contains our first subscriptions and consumables; please review them together.
```

## Template D: AI block (add when user data goes to an AI model)

```
AI PROCESSING AND SAFETY
Photos and prompts are sent to <Provider A> and <Provider B> only after the user agrees on
the consent screen, which names these providers. Users can decline and revoke in Settings > Privacy.
Moderation: prompt filter + input-image and output classifiers block nudity, minors and sexualized edits.
Every result has a Report button. Outputs are private to the user; there is no feed or sharing between users.
  (or) Shared posts appear in the Discover feed; each post has Report and Block; reports are reviewed within 24 hours; contact: <email>.
Face data: <one-sentence summary of the privacy policy face-data section; no ad use; retention>.
Templates are original or used with written permission (attached in App Review Information).
```

## Template E: hardware-, region- or server-dependent features

```
SPECIAL CONDITIONS
- <Feature> needs <camera / LiDAR / a location>; on devices without it the app shows <fallback>. Demo video: <link>.
- Generation runs on our servers; the backend is live and quotas are raised for the review period.
- Server-configured content: template catalog and prices come from our backend/RevenueCat. No feature is
  hidden or enabled after review; the reviewer sees the full feature set.
- Regional differences: <none / feature X unavailable in Y because Z>.
```

## Template F: differentiation (when you own similar apps or the category is saturated)

```
WHAT IS DIFFERENT
<App> is not a variant of our other apps. Unique features: <1>, <2>, <3>.
Code, UI, templates and assets are original to this app.
```

Rationale: 4.3(a)/(b) is the highest-volume rejection for AI apps in Aug-Oct 2026 (REPORTED, see `common-rejections.md` #12). Stating originality up front cannot be verified to help (ASSUMED), but replies with specifics have cleared 4.3 (REPORTED, https://www.reddit.com/r/appledevelopers/comments/1wjgb26/, 2026-09-18).

## Final check

- [ ] Every rule in SKILL.md "Review Notes Decision Rules" that applies is covered.
- [ ] Every claim in the notes is true in this exact build (reviewers compare).
- [ ] Byte count ≤ 4000.
- [ ] Demo credentials tested within the last hour against production.
- [ ] Recording link opens logged out.
