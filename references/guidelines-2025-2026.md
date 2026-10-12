# App Review Rule Changes, 2025-2026 (dated, with sources)

Evidence cutoff: 2026-10-12. Guidelines page: https://developer.apple.com/app-store/review/guidelines/ ("Last Updated: June 8, 2026", OFFICIAL, read 2026-10-12).

Labels: OFFICIAL / REPORTED / ASSUMED / NOT FOUND (see SKILL.md). Items dated before 2025-06 are marked "possibly stale" but listed when Apple still shows them as in force.

## Timeline

| Date | Change | What it means for a first submission | Label + source |
|---|---|---|---|
| 2024-05-01 | Apps that don't describe required-reason API use in a privacy manifest are not accepted by App Store Connect | Upload is rejected automatically. Still in force (possibly stale date, current rule) | OFFICIAL, https://developer.apple.com/news/upcoming-requirements/ (May 1, 2024 entry) |
| 2025-02-17 | Apps without EU DSA trader status are removed from the EU App Store | Declare trader status at account level before submitting, even if you don't target the EU | OFFICIAL (possibly stale date, still listed), https://developer.apple.com/news/upcoming-requirements/ ; https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-european-union-digital-services-act-trader-requirements |
| 2025-06-09 | Guideline update; 3.2.2(x) created ("must not force users to rate the app, review the app ... to access functionality") | No "rate us for credits" | OFFICIAL, https://developer.apple.com/news/?id=r9dcmrvs (Jun 9, 2025) |
| 2025-07-24 | New age rating system (13+, 16+, 18+ added) and new questions; "consider how all app features, including AI assistants and chatbot functionality, impact the frequency of sensitive content" | Answer the questionnaire with AI output in scope | OFFICIAL, https://developer.apple.com/news/?id=ks775ehf (Jul 24, 2025) |
| 2025-11-13 | 5.1.2(i): "You must clearly disclose where personal data will be shared with third parties, including with third-party AI, and obtain explicit permission before doing so." | Consent screen naming AI providers before first upload | OFFICIAL, https://developer.apple.com/news/?id=ey6d8onl (Nov 13, 2025) |
| 2025-11-13 | 4.1(c): no other developer's icon, brand or product name in your icon or name without approval | No AI vendor / social network brands in name or icon | OFFICIAL, https://developer.apple.com/news/?id=ey6d8onl |
| 2025-11-13 | 4.7 clarified to cover HTML5/JavaScript mini apps and mini games (the current 4.7 heading also names chatbots and 4.7.1 requires filter/report/block, but this announcement does not say when chatbots were added: NOT FOUND); 1.2.1(a) and 4.7.5 creator/out-of-binary content above the rating needs an age restriction based on verified or declared age | Chat personas and creator templates need filters and age gating | OFFICIAL, https://developer.apple.com/news/?id=ey6d8onl |
| 2025-12-23 | Court injunction suspends Texas SB2420; Apple pauses its Texas age-assurance plans; Declared Age Range API, PermissionKit Significant Change API, StoreKit age rating property and server notifications stay available (sandbox) for Utah and Louisiana laws | Legal exposure; plan adoption | OFFICIAL, https://developer.apple.com/news/?id=8jzbigf4 (Dec 23, 2025) |
| 2026-01 (mid) | Apple begins rejecting free-trial toggle paywalls (unannounced) | Replace toggles with plan cards | REPORTED, https://www.revenuecat.com/blog/growth/r-i-p-toggle-paywall-we-hardly-knew-ye/ (Feb 9, 2026, upd. Apr 23, 2026) |
| 2026-01-31 | Deadline to answer the updated age rating questions | Submission blocked until answered | OFFICIAL, https://developer.apple.com/news/upcoming-requirements/ (Jan 31, 2026 entry) |
| 2026-02-06 | Random or anonymous chat apps are subject to 1.2 | Any anonymous chat needs UGC safeguards | OFFICIAL, https://developer.apple.com/news/?id=d75yllv4 (Feb 6, 2026) |
| 2026-02-24 | Apple blocks 18+ app downloads in Brazil, Australia, Singapore for unconfirmed adults; loot boxes make a Brazil rating 18+ | An 18+ rating shrinks reach in those storefronts | OFFICIAL, https://developer.apple.com/news/?id=f5zj08ey (Feb 24, 2026) |
| 2026-04-28 | Uploads must use Xcode 26+ and the iOS/iPadOS 26 SDK or later | CI runners must be upgraded | OFFICIAL, https://developer.apple.com/news/upcoming-requirements/ ; https://developer.apple.com/news/?id=ueeok6yw (Feb 3, 2026) |
| 2026-05-06 / 06-04 / 07-01 | Utah (May 6) and Louisiana (Jul 1): age categories shared via Declared Age Range API for new Apple Accounts; Texas (Jun 4): Declared Age Range API, PermissionKit Significant Change API, `AppStore.ageRatingCode`, and a server notification when a parent withdraws consent. Apple Q&A: "No, there are no changes to the App Review process." | Legal exposure, not a rejection reason per Apple | OFFICIAL, https://developer.apple.com/news/?id=f5zj08ey (Feb 24, 2026, Utah/Louisiana); https://developer.apple.com/news/?id=sg176nne (Jun 3, 2026, Texas); https://developer.apple.com/support/age-assurance (Q&A, undated) |
| 2026-06-08 | Guidelines update: 1.2 new paragraph ("It is your responsibility to remove content that violates this guideline..."; removal and compliance plan on egregious/repeated issues); 4.3(a)/(b) clarified with examples; Introduction adds "Make sure kids are getting age-appropriate experiences inside your app." | Moderation is your duty even after approval; similar-app spam scrutiny up | OFFICIAL, https://developer.apple.com/news/?id=a233fmpw (Jun 8, 2026) |
| 2026-06-08 | HIG Generative AI page updated ("Let people share feedback on outputs"; never trick people into thinking AI content is human) | Report/feedback affordance on outputs; AI labels | OFFICIAL, https://developer.apple.com/design/human-interface-guidelines/generative-ai (change log June 8, 2026) |
| 2026-07-09 | Social media capability questions added to the age rating questionnaire; responses required to submit new apps or updates from September 2026 | Answer them; any feed of others' outputs likely means Yes | OFFICIAL, https://developer.apple.com/news/?id=tlur8uvi (Jul 9, 2026) |
| 2026-07-17 | SF City Attorney demand to remove "nudify" apps; Apple says it rejects and terminates such developers | Undress-adjacent features are account-level risk | REPORTED, https://www.macrumors.com/2026/07/17/demand-to-pull-nudify-apps/ |
| 2026-08-02 | EU AI Act Art. 50 transparency duties apply (deepfake labelling); 50(2) machine-readable marking extended to Dec 2, 2026 only for systems already on the market | Label AI outputs for EU users (law, not App Review) | REPORTED (law-firm summary), https://www.goodwinlaw.com/en/insights/publications/2026/08/alerts-technology-dpc-eu-ai-act-transparency-obligations-now-in-force |
| 2026-08-24 | Sign in with Apple private relay emails move to `private.icloud.com` (old: `privaterelay.appleid.com`); accept both | Email allowlists/regexes must accept the new domain | OFFICIAL, https://developer.apple.com/news/?id=1ptvdtcm (Aug 24, 2026) |
| 2026-08 to 2026-10 | Spike of 4.3(a)/(b) spam rejections for AI-built apps, often instant; account warnings after repeated resubmission | Highest portfolio risk | REPORTED, e.g. https://www.reddit.com/r/iOSProgramming/comments/1w07lj9/ (2026-08-27), https://www.reddit.com/r/iOSProgramming/comments/1wj2j1d/ (2026-09-17) |
| 2026-09-09 | iOS/iPadOS uploads must target iOS 13 or later | Check IPHONEOS_DEPLOYMENT_TARGET | OFFICIAL, https://developer.apple.com/news/upcoming-requirements/ (Sep 9, 2026 entry) |
| 2026-09-16 | Alternative EU ATT prompt available from iOS 27.2; the only option in DE, FR, IT, PL, RO; when to ask is unchanged | Re-check ATT copy and flow for those storefronts | OFFICIAL, https://developer.apple.com/news/?id=idsft9ai (Sep 16, 2026) |
| 2026-10-05 | New screenshot guidance published (2.3.3) | Re-check that more than half of screenshots show the app in use | OFFICIAL, https://developer.apple.com/news/?id=ljpl7kyn (Oct 5, 2026); https://developer.apple.com/help/app-review/guideline-reference/2-3-3-screenshots |
| 2026-10 | First reviews often wait 5-14+ days in "Waiting for Review"; replies to 2.1 requests sit unanswered | Budget 1-3 weeks for v1.0 | REPORTED, https://developer.apple.com/forums/tags/app-review (fetched 2026-10-12); https://developer.apple.com/forums/thread/850197 |
| 2027-04 (upcoming) | iOS/iPadOS 27 SDK required; iPhone Duo screenshots required for apps on the iOS 27.1 SDK | Plan the next Xcode upgrade | OFFICIAL, https://developer.apple.com/news/?id=k1mtkt1k (Sep 9, 2026; not yet on the upcoming-requirements page as of 2026-10-12); https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications |

## Standing rules that drive most rejections

These predate 2025-06 but are the current text (Last Updated June 8, 2026):

- 2.1(a) final build, demo account, backend on. 2.1(b) IAPs "complete, up-to-date, visible to the reviewer and functional".
- 3.1.1 credits bought via IAP "may not expire"; restore mechanism for restorable purchases.
- 3.1.2(c) subscription info before purchase; DPLA Schedule 2 §3.8(b) disclosures (OFFICIAL, https://developer.apple.com/support/terms/apple-developer-program-license-agreement/, fetched 2026-10-12, no revision date on page).
- 5.1.1(v) account deletion and no forced login for non-account features.
- 4.8 an equivalent privacy-preserving login (in practice Sign in with Apple) when a third-party/social login is the primary account.

## Review timing (official)

"Typically reviewing at least 50% of submissions in less than 24 hours and 90% in less than 48 hours." (OFFICIAL, https://developer.apple.com/distribute/app-review/, accessed 2026-10-12). October 2026 reports describe much longer first-review waits (REPORTED, above). Both can be true for different submission types; plan for the slow case.

## Transparency report numbers (context)

2025: 9,100,620 submissions, 2,093,244 rejected; the Performance section (contains 2.1) appears in 1,354,418 rejections; 387,087 submissions approved after resubmission. Section-level only; the per-guideline CSV was not opened (OFFICIAL, https://images.apple.com/legal/app-store/transparency/2025/, accessed 2026-10-12).

## NOT FOUND in official text (as of 2026-10-12)

- An age-rating question specific to AI-generated imagery.
- A deepfake / real-person likeness consent rule (closest: 1.1.1, 1.2 "objectification of real people", 5.2.1).
- Whether private, unshared AI generation counts as UGC under 1.2.
- The exact consent UI wording Apple expects for 5.1.2(i).
- Whether naming the underlying model (e.g. "powered by X") in the description violates 4.1 (4.1(c) covers name and icon; the 4.1 help page warns against trademarked terms in any metadata field).
- A rule requiring an immediately visible paywall close button.
- A rule naming the word "free" (2.3.7 bans prices in name/subtitle/screenshots; reviewers treat "free" as a price reference, REPORTED).
- Whether resetting subscription credit allowances per period counts as "expiring" credits.
