# Changelog

All notable changes to the `app-store-first-review` skill are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] — 2026-10-12

Adversarial source re-check (all OFFICIAL claims, 18 REPORTED claims re-fetched).

### Fixed
- Citations: iOS 13 deployment-target rule is on upcoming-requirements (Sep 9, 2026); news `k1mtkt1k` is the April 2027 iOS 27 SDK rule. Dec 23, 2025 news is the Texas SB2420 pause; Utah/Louisiana dates come from the Feb 24, 2026 news.
- Guideline numbers: hidden features are 2.3.1(a) (rejections reported as 5.6); 4.8 requires an equivalent privacy-preserving login, not SIWA by name; 3.1.1(a) and 5.1.1(ii)/(iii)/(iv) labelled precisely; date chatbots entered 4.7 marked NOT FOUND.
- Quotes: demo account "must not expire"; calls "typically completed within three to five business days"; export compliance wording; Apple rejection text in a forum post relabelled REPORTED.
- Over-stated reports: French-locale EULA cause marked unconfirmed; forum 840483 has no fix; 850439 is a dating 4.3(b) case.
- `preflight.sh`: stops after one FAIL on a non-project directory; SIWA check is WARN; RevenueCat key patterns need 20+ chars; shellcheck clean.

### Added
- Rejection #33 / Top 26 row: rating prompt in onboarding (5.6.1 / 5.6.3) and a `rating-prompt` preflight check.

## [1.0.0] — 2026-10-12

First release. Evidence cutoff: 2026-10-12 (App Review Guidelines "Last Updated
June 8, 2026", Apple Developer News through Oct 5, 2026, developer rejection
reports from June 2025 to October 2026).

### Added
- **`SKILL.md`** — when to use, evidence labels (OFFICIAL / REPORTED / ASSUMED /
  NOT FOUND), routing table, Top 25 first-submission rejection causes, the
  8-stage pre-submission procedure (binary → backend → App Store Connect →
  paywall/IAP → privacy → content/AI → Review Notes → submit), and Review Notes
  decision rules.
- **`references/guidelines-2025-2026.md`** — dated timeline of rule changes
  (5.1.2(i) third-party AI, 4.1(c), 4.7, 1.2 updates, 4.3 clarification, age
  rating system and Social Media questions, Xcode 26 SDK and iOS 13 minimums,
  SIWA relay domain, EU ATT prompt, screenshot guidance) plus a NOT FOUND list.
- **`references/common-rejections.md`** — 32 rejection patterns with reposted
  reviewer wording, checks, fixes and dated sources.
- **`references/subscriptions-and-iap.md`** — agreements, attaching first-time
  IAPs (and the rejected-submission draft trap), paywall disclosure checklist,
  price hierarchy, trial toggles, exit offers, credits vs allowances, Restore
  with anonymous IDs, reviewer sandbox test matrix, description block template.
- **`references/generative-ai-apps.md`** — third-party AI consent, 1.1 template
  risk, UGC/chatbot safeguards, likeness and IP, face data, age rating and
  minors, 4.3 for AI portfolios, social-data rules, EU AI Act / TAKE IT DOWN.
- **`references/privacy-and-tracking.md`** — privacy policy, App Privacy label,
  privacy manifests and signed SDKs, ATT with Meta/Adjust, purpose strings,
  permission primers, login rules, account deletion, export compliance,
  consistency table.
- **`references/metadata-and-screenshots.md`** — required fields, what may not
  appear where, grep list, screenshot rules, IAP metadata.
- **`references/review-notes-template.md`** — templates for no-login/device
  accounts, login apps, subscriptions/credits, AI apps, hardware/region/server
  dependencies, differentiation; screen-recording script.
- **`references/resubmission-and-appeals.md`** — reading a rejection, replying
  in App Store Connect, resubmitting, App Review Board appeals, 4.3 and 5.6
  handling, expedited review, bug-fix submissions, timing.
- **`scripts/preflight.sh`** — read-only preflight with 15 checks and optional
  `asc validate` + Review Notes check. Never prints secret values.
- **`scripts/test-preflight.sh`** — fixture-based self-check for the preflight.

### Known gaps
- No per-guideline rejection statistics (Apple's transparency report CSV not opened).
- X/Twitter and Hacker News reports not covered.
- `asc` branch of the preflight not exercised against a live account in tests.
