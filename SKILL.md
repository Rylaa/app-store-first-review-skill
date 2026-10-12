---
name: app-store-first-review
description: >-
  Use before the FIRST App Store submission of an iOS app, and before any
  resubmission after an App Review rejection, to find and fix what Apple
  actually rejects in 2025-2026. Built for subscription and credit-based
  generative-AI apps (SwiftUI, RevenueCat, Meta/Adjust, asc CLI). Covers 2.1
  completeness (crashes, demo account, IAPs attached to the version, empty
  paywalls), 3.1.2 paywall rules (EULA link, billed-price prominence, trial
  toggles, Restore), 4.3 spam, 5.1.2(i) third-party AI consent, account
  deletion, forced login, ATT, privacy labels and manifests, purpose strings,
  screenshots, age rating, Review Notes and appeals. Activate on: App Review,
  rejected, Guideline 2.1/3.1.2/4.3/5.1.1/5.1.2, Resolution Center, review
  notes, demo account, "submit for review", "ready to ship", "Information
  Needed", paywall compliance, EULA, privacy label, appeal. Use proactively
  whenever an iOS app is about to be submitted, even if the user only says
  "let's ship 1.0".
license: MIT
metadata:
  author: Rylaa
  version: "1.0.1"
  created: "2026-10-12"
  updated: "2026-10-12"
  domain: app-store-review
  evidence_cutoff: "2026-10-12"
---

# App Store First Review (iOS)

Pre-submission and post-rejection playbook for getting a new iOS app through App Review on the first try. Built from Apple's guidelines (Last Updated June 8, 2026), Apple Developer News through October 2026, and ~100 developer rejection reports from June 2025 to October 2026.

Apple's own number explains the focus: "On average, over 40% of unresolved issues are related to guideline 2.1: App Completeness" (OFFICIAL, https://developer.apple.com/distribute/app-review/, accessed 2026-10-12). Most first-submission rejections are not policy disputes. They are a missing link, a product not attached, a paywall that renders empty for the reviewer, or a feature the reviewer could not find.

## When To Use This Skill

1. A new app is about to be submitted for the first time (v1.0, or the first version with IAP).
2. An app was rejected and the user wants to understand, fix, reply or appeal.
3. The user asks "are we ready to submit?", "what will Apple reject?", or wants a pre-submission audit.
4. A paywall, onboarding, AI consent, account deletion or ATT flow is being built and must pass review.
5. Review Notes or the demo account need to be written.

Out of scope: ASO keyword strategy (use `aso`), App Store metadata syncing mechanics (use `asc-metadata-sync`), release execution (use `asc-release-flow`), stuck-submission repair (use `asc-submission-health`), paywall implementation (use `revenuecat:*`), attribution plumbing (use `marketing-att-pipeline`). This skill decides *what must be true*; those skills *do* it.

## Evidence Labels

Every non-obvious rule in `references/` carries a label, a URL and a date:

- **OFFICIAL**: Apple guideline, Apple help/doc page, Apple Developer News, or Apple agreement text.
- **REPORTED**: a developer's account of a rejection (forums, Reddit, vendor blogs). Reviewer wording is quoted as reposted, not from Apple.
- **ASSUMED**: an inference. Treat it as a risk, not a rule.
- **NOT FOUND**: searched for and not found in official text. Do not invent a guideline number to fill the gap.

Anything dated before 2025-06 is flagged "possibly stale". When you tell the user a rule, say which label it has. When the user's situation hits a NOT FOUND, say so and choose the conservative option.

## How To Use

1. **Intake** (ask or infer from the repo): login model (none / device-account / SIWA / email / social), subscriptions and/or consumable credits, AI providers that receive user data, any sharing/feed/public profile, iPad support, storefronts, other apps on the same developer account, Meta/Adjust or other tracking SDKs.
2. **Run** `scripts/preflight.sh <project-root>` (read-only; `--help` for options, `--ipa App.ipa` to inspect the bundle, `--metadata-dir` for pulled metadata). With `APP_ID` and `VERSION_ID` set and `asc` installed it also runs `asc validate` and checks Review Notes. It is a grep heuristic: treat PASS as "nothing obvious", never as approval. `scripts/test-preflight.sh` self-checks it.
3. **Walk the procedure** below in order. Each stage gates the next: no point polishing Review Notes for a build that crashes on iPad.
4. **Write the Review Notes** from `references/review-notes-template.md` using the decision rules below.
5. **Report** as PASS / WARN / FAIL per stage, with the guideline, the evidence label, the file:line or ASC field, and the fix.

For a rejection, go straight to `references/resubmission-and-appeals.md`, then the reference for the cited guideline.

## Routing

| User situation | Read |
|---|---|
| Paywall, subscriptions, credit packs, Restore, EULA, IAP not loading, IAP not attached | `references/subscriptions-and-iap.md` |
| App sends photos/prompts/voice to an AI model, face swap, templates, chatbot, UGC, age gating | `references/generative-ai-apps.md` |
| Privacy label, privacy manifest, ATT, Meta/Adjust, purpose strings, permission priming, account deletion, login | `references/privacy-and-tracking.md` |
| Name, subtitle, keywords, description, screenshots, previews, IAP display names, trademarks | `references/metadata-and-screenshots.md` |
| A specific rejection message, or "what usually gets rejected" | `references/common-rejections.md` |
| "What changed recently?", dates of rule changes, SDK/Xcode minimums | `references/guidelines-2025-2026.md` |
| Writing Review Notes, demo account, screen recording | `references/review-notes-template.md` |
| Rejected: reply, fix, resubmit, appeal, expedite | `references/resubmission-and-appeals.md` |

## Top 26 First-Submission Rejection Causes

Ranked by report frequency and impact for subscription/credit gen-AI apps. Full wording, checks and sources are in `references/common-rejections.md`.

| # | Guideline | What the reviewer sees / does | How to check | Fix |
|---|---|---|---|---|
| 1 | 3.1.2(c) | No Terms of Use (EULA) link in the App Description (any localization) | Read every localized description in ASC | Add a "Subscription details" block with Terms + Privacy URLs to every locale, or set a custom EULA |
| 2 | 2.1(b) | Paywall references subscriptions but the IAPs were not submitted with the version | ASC draft submission lists the version AND every group/subscription/consumable | Attach all products to the same draft before Submit; each needs a review screenshot |
| 3 | 2.1(b) | Paywall empty, prices missing, buy button dead in sandbox (often on iPad) | Fresh sandbox Apple ID, TestFlight build, no .storekit, bad network | Paid Apps Agreement active; loading/error+Retry states; never bind buttons to nil products |
| 4 | 4.3(a)/(b) | App looks like a template, a reskin of your other app, or a saturated category | Compare with your other apps and top apps in the category | Differentiate visibly; one app per concept; reply once with specifics, don't resubmit blindly |
| 5 | 3.1.2(c) | Paywall lacks title, period, billed price, auto-renew text, Terms/Privacy links, Restore | Screenshot every paywall variant incl. RevenueCat remote ones | Add the disclosure footer + links + Restore under the CTA |
| 6 | 3.1.2(c) | "$0.96/week" or "FREE" is bigger than the billed "$49.99/year" | Compare font sizes on each plan card and the CTA | Billed amount is the hero price; breakdowns and trial are captions |
| 7 | 2.1 | "Information Needed - New App Submission": screen recording + questionnaire request | Review Notes already answer purpose, audience, devices, flows, services | Preempt with full notes + a physical-device recording link |
| 8 | 5.1.2(i) | Photo/prompt goes to a third-party AI with no consent naming the provider | Fresh install; watch network before tapping Agree | Blocking consent screen naming providers, data, purpose; Decline path; policy update |
| 9 | 2.1(a) | Crash at launch or mid-flow on the reviewer's iPad / latest iOS | Release build on iPad (compat mode), latest iOS, Network Link Conditioner | Fix crashes, add timeouts/retry, freeze backend deploys while In Review |
| 10 | 2.1 | Demo account missing, broken, needs OTP, or already subscribed so the paywall is hidden | Sign in with it now; check RevenueCat entitlements | Permanent reviewer account, no entitlement, no OTP, low credits, path to paywall in notes |
| 11 | 5.1.1(v) | No in-app account deletion (or only "email us"), incl. guest/device accounts | Settings > Delete Account works end to end | Deletion endpoint + UI, SIWA token revoke, subscription warning |
| 12 | 5.1.1(v) | Registration required before non-account features or before buying credits | Fresh install: reach paywall and buy with no email | Anonymous/device identity; optional account later |
| 13 | 3.1.2 | Toggle that adds/removes a free trial on the purchase screen | Look for any switch on the paywall | Separate plan cards instead of a toggle |
| 14 | 5.6 / 3.1.2 | Extra discount offer appears when the reviewer closes the paywall | Tap X on every paywall | X dismisses immediately; no exit-intent offer |
| 15 | 5.1.2(i) | ATT prompt not found, or label says "tracking" but no ATT prompt | Fresh install: ATT appears early; compare App Privacy answers | Prompt early in onboarding; init Meta/Adjust after ATT; say where in notes |
| 16 | 5.1.1 | Purpose string vague ("needs camera access") | Read every NS*UsageDescription in all locales | "<App> uses <resource> to <feature>. For example, <example>." |
| 17 | 5.1.1(iv) | Pre-permission screen says "Enable"/"Allow" or offers "Maybe later" | Walk onboarding | Neutral copy, single "Continue" that always shows the system prompt |
| 18 | 4.8 / 4.0 | Google/Facebook login with no equivalent privacy-preserving option (4.8, OFFICIAL); or asks for name after SIWA (cited as 4.0, REPORTED) | Login screen; post-SIWA onboarding | Add SIWA (the usual 4.8 option) with equal prominence; prefill name, make optional |
| 19 | 1.1 / 1.2 / 4.7 | Templates that "could be used to create objectionable content"; no Report/Block | Audit template catalog; look for Report on outputs | Drop intimate/try-on templates for v1; filters + Report + Block + contact |
| 20 | 2.3.7 | "Free", "trial", "$", "% off" in screenshots, name or subtitle | OCR screenshots, read name/subtitle/promo text | Feature-outcome captions; pricing only in the description |
| 21 | 2.3.3 / 2.3.1 | Screenshots are marketing frames, show unreachable/premium-only features | >50% show real app UI; each maps to a reachable screen | Replace with in-app captures; label Pro features |
| 22 | 4.1(a)/(c) | Third-party brand (ChatGPT, Instagram, TikTok, Veo...) in name, subtitle or icon | Read name/subtitle/keywords/icon | Remove, or attach written permission in App Review Information |
| 23 | 1.5 / 5.1.1(i) | Support, Privacy or Terms URL 404s or is a login wall | `curl -sIL` every URL logged out | Host on a stable domain with real contact info |
| 24 | 4.0 | iPhone-only app is crowded/clipped on the reviewer's iPad | iPad mini + 11-inch simulator in compat mode | ScrollView-wrap fixed screens; keep iPhone-only unless iPad UI exists |
| 25 | 2.3.1(a) / 5.6 | "Hidden features" (rule: 2.3.1(a); rejections reported under 5.6): `.storekit`/`.xcconfig` shipped in the IPA, remote kill switches | `unzip -l App.ipa` for storekit/env files | Exclude from target (synchronized folders!); disclose any remote config |
| 26 | 5.6.1 / 5.6.3 | "Rate us" step or `requestReview` during onboarding, or a custom star/"Enjoying the app?" screen | Walk onboarding on a fresh install; preflight `rating-prompt` | Ask with `requestReview` only after a success moment; no custom prompt, gating or reward |

Also blocking but caught before human review: Xcode 26 / iOS 26 SDK minimum, privacy manifests for listed SDKs, missing export compliance, unanswered age-rating questions (incl. the Social Media questions required since September 2026), DSA trader status. See `references/guidelines-2025-2026.md`.

## Pre-Submission Procedure (in order)

### Stage 1: Binary

- Built with Xcode 26+ and the iOS 26 SDK or later; deployment target ≥ iOS 13 (OFFICIAL, upcoming-requirements, Apr 28 2026 and Sep 9 2026).
- `PrivacyInfo.xcprivacy` present with required-reason API entries; Xcode Archive > Generate Privacy Report has no SDK gaps.
- `ITSAppUsesNonExemptEncryption` set (usually `NO` for OS HTTPS only).
- Every protected resource the code uses has a specific, localized purpose string.
- No `.storekit`, `.xcconfig`, `.env`, `GoogleService-Info` duplicates, debug menus or test API keys (RevenueCat `test_` keys) in the Release IPA.
- No user-facing "lorem", "TODO", "coming soon", "beta", "test" strings.
- Release build tested on a physical iPhone on the latest iOS, on an iPad in compatibility mode, and with "Very Bad Network" / "100% Loss".
- Run `scripts/preflight.sh`. Fix every FAIL; justify every WARN.

### Stage 2: Backend and live services

- Review build points at production; AI provider keys, quotas and rate limits are raised for the review window.
- Deploy freeze while the build is "In Review" (a deploy mid-review caused a crash rejection, REPORTED).
- Reviewer account seeded in production: no active entitlement, low or zero credits, no OTP/2FA.
- If Sign in with Apple is used: backend accepts both `privaterelay.appleid.com` and `private.icloud.com` relay addresses (OFFICIAL, Aug 24 2026).

### Stage 3: App Store Connect fields and agreements

- Business: Paid Apps Agreement Active, tax and banking complete; DSA trader status declared.
- App Information: category, content rights, age rating fully answered (AI output in scope; Social Media question answered honestly), Privacy Policy URL.
- Version: description, keywords, Support URL, Copyright, screenshots per required size, App Review contact phone in `+<country>` format.
- App Privacy: answers match SDK behavior, the privacy manifest and the privacy policy.

### Stage 4: Paywall and IAP

- All products and groups are attached to the same draft submission as the version; each has a review screenshot, unique localized name and description, price and availability.
- Every paywall variant shows: plan name, period, billed price (most prominent), what's included (credits/features), auto-renew and trial-conversion text, Restore, Terms and Privacy links. No trial toggle, no exit offer.
- Description of every locale contains the Terms of Use (EULA) link.
- Purchased credits never expire; subscription allowance resets are disclosed.
- Details: `references/subscriptions-and-iap.md`.

### Stage 5: Privacy

- Third-party AI consent before the first upload; ATT before tracking SDKs; deletion in-app; no forced login; neutral permission primers.
- Details: `references/privacy-and-tracking.md`.

### Stage 6: Content and AI

- Template audit (no intimate, undress-adjacent, celebrity or brand templates in v1), prompt + output filters, Report on every output, Block + contact if anything is shared, age gating if content can exceed the rating.
- Details: `references/generative-ai-apps.md`.

### Stage 7: Review Notes and attachments

- Fill `references/review-notes-template.md` (max 4000 bytes). Attach or link a physical-device screen recording of the core flow.

### Stage 8: Submit

- `asc validate --app APP_ID --version-id VERSION_ID --deep --check-urls` (read-only) and `asc review doctor --app APP_ID`.
- Confirm the submission item list (version + every IAP/group). Prefer manual release for v1.0.
- Submit one app at a time from a developer account. Budget 1-3 weeks for a first review in October 2026 (REPORTED queue delays).

## Review Notes Decision Rules

Reviewers read the notes and compare them with what they see ("Generic descriptions will be rejected", OFFICIAL 2.3.1(a)). Apply every rule that matches:

| If the app... | The notes must... |
|---|---|
| has any account or login | give working credentials, or say exactly why none are needed (e.g. "No account: identity is an anonymous device ID; Sign-in required is unchecked") |
| uses only Sign in with Apple / OTP / magic link | provide a reviewer path with a static code or say "use any Apple ID" (automated checks flag login without demo account, REPORTED) |
| sells subscriptions or credits | list each product, what it grants, what one generation costs, and the exact taps to reach the paywall and Restore |
| gives free starter credits | say how to reach the paywall anyway (reviewers who never hit it reject under 2.1, REPORTED) |
| sends user data to external AI | name the providers and say where the consent screen appears |
| has outputs that can be shared, posted or seen by others | describe filters, the Report and Block locations, and the contact address |
| keeps outputs private | state "outputs are private to the device/account; no sharing between users" |
| uses ATT | say where and when the prompt appears |
| has features behind server flags or regional differences | list them and confirm the reviewer sees the full feature set |
| depends on hardware, a location, or slow generation | give expected latency, a demo video, or sample content |
| uses third-party content, likeness or trademarks | reference the permission documents attached in App Review Information |
| is similar to another app you own | state what is different and that code/assets are original |

## Output Pattern

1. One line: which stages were checked and how (repo grep, preflight, asc, manual).
2. A PASS / WARN / FAIL table per stage with guideline, evidence label and source link.
3. The concrete fixes, with file:line for code and the ASC field path for metadata.
4. Draft Review Notes if Stage 7 was in scope.
5. What was not verified (e.g. "App Privacy answers not readable without a web session").

## Related Skills

- `asc-submission-health`, `asc-release-flow`, `asc-metadata-sync`: execute the ASC side.
- `revenuecat:revenuecat-paywall`, `revenuecat:revenuecat-troubleshoot`: paywall implementation and empty offerings.
- `marketing-att-pipeline`: ATT timing and Meta/Adjust init order.
- `qa-playbook`: device matrix and StoreKit test runs.
