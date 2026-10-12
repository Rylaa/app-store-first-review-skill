# App Store First Review (iOS) — Claude Code Skill

> A Claude Code skill that gets a new iOS app through App Review on the first try.
> Built from Apple's App Review Guidelines (Last Updated June 8, 2026), Apple Developer News through October 2026, and about 100 developer rejection reports from June 2025 to October 2026. Tuned for subscription and credit-based generative-AI apps (SwiftUI, RevenueCat, Meta/Adjust SDKs, `asc` CLI).

[![Claude Skill](https://img.shields.io/badge/Claude-Skill-blueviolet)](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
[![App Review Guidelines](https://img.shields.io/badge/Guidelines-Jun%208%2C%202026-blue)](https://developer.apple.com/app-store/review/guidelines/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## What This Skill Solves

Most first-submission rejections are not policy fights. They are small, avoidable misses:

- No Terms of Use (EULA) link in the App Store description, in one of the locales.
- The first subscriptions were not attached to the version submission.
- The paywall showed no prices on the reviewer's iPad in the sandbox.
- "$0.96/week" was bigger than the "$49.99/year" actually billed.
- A selfie was sent to an AI provider before any consent screen named that provider.
- The demo account was already Pro, so the reviewer never saw the paywall.
- A `.storekit` file from an Xcode synchronized folder shipped inside the IPA.
- The app looked like a template of your other app (4.3).

Apple's own figure: "over 40% of unresolved issues are related to guideline 2.1: App Completeness" ([App Review](https://developer.apple.com/distribute/app-review/), accessed 2026-10-12).

## What Makes This Different

- **Every rule carries a label, a URL and a date**: OFFICIAL (Apple text), REPORTED (developer reports, with the reviewer's wording), ASSUMED (inference), or NOT FOUND. No invented guideline numbers.
- **2026-current**: third-party AI consent (5.1.2(i), Nov 2025), 4.3 spam spike (Aug–Oct 2026), the "Information Needed – New App Submission" screen-recording request, trial-toggle rejections, age-rating Social Media questions (required since Sep 2026), Xcode 26 SDK minimum, SIWA relay domain change.
- **Ordered procedure**: binary → backend → App Store Connect → paywall/IAP → privacy → content/AI → Review Notes → submit.
- **Review Notes templates** for no-login/device-account apps, login apps, subscription/credit apps, AI apps and hardware/region-dependent apps.
- **A read-only preflight script** that never mutates anything and never prints secret values.

## Quick Start

### Install (per user)

```bash
git clone https://github.com/Rylaa/app-store-first-review-skill \
  ~/.claude/skills/app-store-first-review
```

### Install (per project)

```bash
git clone https://github.com/Rylaa/app-store-first-review-skill \
  .claude/skills/app-store-first-review
```

Restart Claude Code. Trigger it with, for example:

```
We're submitting our AI photo app 1.0 tomorrow. RevenueCat weekly + yearly,
credit packs, no login. What will Apple reject?
```

```
Rejected under 3.1.2(c) and 2.1(b). Here's the message: ...
```

## Preflight Script

```bash
bash ~/.claude/skills/app-store-first-review/scripts/preflight.sh path/to/ios-project
bash .../preflight.sh --ipa build/MyApp.ipa --metadata-dir /tmp/meta path/to/ios-project
APP_ID=123456789 VERSION_ID=abc-def bash .../preflight.sh path/to/ios-project   # adds asc validate + Review Notes
bash .../preflight.sh --help
```

| # | Check | Result on failure |
|---|---|---|
| 1 | Deployment target ≥ iOS 13 | FAIL |
| 2 | Purpose strings for every protected API used; vague strings | FAIL / WARN |
| 3 | `PrivacyInfo.xcprivacy` present; UserDefaults reason; tracking flag | FAIL / WARN |
| 4 | `ITSAppUsesNonExemptEncryption` set | WARN |
| 5 | lorem / coming soon / TODO / beta / test in UI strings | FAIL / WARN |
| 6 | Android / Google Play in metadata or strings | FAIL / WARN |
| 7 | Terms of Use link in every description; price words in name/subtitle | FAIL / WARN |
| 8 | RevenueCat `test_` keys, `sk_` secret keys (file:line only) | FAIL |
| 9 | In-app account deletion; SIWA revoke | FAIL / WARN |
| 10 | Restore Purchases | FAIL |
| 11 | Terms + Privacy URLs in app | WARN |
| 12 | Sign in with Apple (or equivalent, 4.8) when Google/Facebook login exists | WARN |
| 13 | SIWA relay domain allowlist (`private.icloud.com`) | WARN |
| 14 | `.storekit` / `.xcconfig` / `.env` in the IPA | FAIL / WARN |
| 15 | Review prompt (`requestReview`) in onboarding/first-launch code | WARN |
| 16 | `asc validate`, Review Notes non-empty and ≤ 4000 bytes, demo username | FAIL / WARN |

Exit code is 1 if any check FAILs. It is a grep heuristic: a PASS means "nothing obvious", not "approved". Self-test: `bash scripts/test-preflight.sh`.

CI (non-blocking):

```yaml
- name: App Store preflight
  run: bash .claude/skills/app-store-first-review/scripts/preflight.sh apps/ios
  continue-on-error: true
```

## What's Inside

```
app-store-first-review/
├── SKILL.md                              Entry point: Top 26, procedure, Review Notes rules
├── README.md                             (this file)
├── CHANGELOG.md
├── LICENSE
├── references/
│   ├── guidelines-2025-2026.md           Dated rule changes + NOT FOUND list
│   ├── common-rejections.md              33 patterns with reviewer wording
│   ├── subscriptions-and-iap.md          Paywall, IAP attachment, credits, Restore
│   ├── generative-ai-apps.md             AI consent, templates, UGC, likeness, age
│   ├── privacy-and-tracking.md           Labels, manifests, ATT, deletion, login
│   ├── metadata-and-screenshots.md       What may appear where
│   ├── review-notes-template.md          Fill-in templates + recording script
│   └── resubmission-and-appeals.md       Reply, resubmit, appeal, expedite
└── scripts/
    ├── preflight.sh                      Read-only preflight (16 checks)
    └── test-preflight.sh                 Fixture self-check
```

## What This Skill Does NOT Do

- Submit, upload or edit anything in App Store Connect (use `asc-release-flow`, `asc-metadata-sync`, `asc-submission-health`).
- Implement paywalls or purchases (use the RevenueCat skills).
- ATT/attribution plumbing (use `marketing-att-pipeline`).
- ASO strategy, Google Play review, macOS/tvOS/visionOS specifics.
- Legal advice on age-assurance laws, the EU AI Act or the TAKE IT DOWN Act. It flags them; counsel decides.

## Keeping It Current

App Review changes often. When updating:

1. Re-read the guidelines page "Last Updated" date and Apple Developer News.
2. Add the change to `references/guidelines-2025-2026.md` with label, URL and date.
3. Move anything older than ~12 months without fresh reports to "possibly stale".
4. Bump `metadata.version` and `metadata.updated` in `SKILL.md` and add a CHANGELOG entry.

## Disclaimer

Not affiliated with Apple. App Review decisions are made by Apple and are not always consistent; reported cases describe what happened to specific developers at specific times.
