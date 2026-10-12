# Generative-AI Apps: What App Review Checks

For apps that send photos, faces, prompts, voice or chat text to an AI model (your own backend or a vendor such as OpenAI, Google, fal, Replicate, Kling), image/video generators, face swap, avatars, templates, chatbots and AI persona profiles. Evidence cutoff 2026-10-12.

## Contents

1. Third-party AI consent (5.1.2(i))
2. Objectionable-content potential (1.1)
3. UGC, chatbots and reporting (1.2, 4.7)
4. Real people, likeness, brands and IP (1.1.1, 1.2, 4.1, 5.2)
5. Face data (5.1.2(vi), 2.1 info requests)
6. Age rating and minors (2.3.6, 1.2.1(a), 4.7.5, age assurance)
7. Spam and thin wrappers (4.2, 4.3)
8. Social media data and creator content (5.2.2, 5.2.3, 5.1.1(viii))
9. Laws outside App Review (EU AI Act, TAKE IT DOWN Act)
10. Review Notes lines for AI apps

## 1. Third-party AI consent (5.1.2(i))

**Rule (OFFICIAL, guidelines Jun 8, 2026; added Nov 13, 2025, https://developer.apple.com/news/?id=ey6d8onl):**
> "You must clearly disclose where personal data will be shared with third parties, including with third-party AI, and obtain explicit permission before doing so."

**Rejection text (REPORTED, https://developer.apple.com/forums/thread/816140, Feb 2026; https://developer.apple.com/forums/thread/822961, Apr 2026):** the app must clearly explain what data is sent, identify who it is sent to, and ask permission before sharing; "only including this information in the app's Terms of Service or Privacy Policy is not sufficient." A generic consent screen plus a policy update did not clear it for one developer; a kids app naming Gemini only in its privacy policy was still rejected (REPORTED, https://developer.apple.com/forums/thread/815715, Feb 2026).

**Applies even when the call goes through your own server** (ASSUMED: the rule is about where data ends up, and the rejection text says "third-party AI service").

**Consent screen requirements:**

- [ ] Shown before the first photo, prompt, voice clip or chat text leaves the device. Verify with a proxy on a fresh install: nothing hits the AI endpoint before Agree.
- [ ] Names each AI provider by company (e.g. "OpenAI", "Google", "fal.ai"), or a category plus a link to a list that names them. Naming is what the rejection text asks for ("identify who the data is sent to").
- [ ] Lists the data types (photos, face images, text prompts, voice) and the purpose (generate your images/videos).
- [ ] States retention (e.g. "providers delete inputs within N days") if you know it.
- [ ] Explicit Agree button; not a pre-checked box; a Decline path that leaves the rest of the app usable.
- [ ] Stored locally and revocable in Settings; Revoke stops uploads.
- [ ] Privacy policy names the same providers and data types; the App Privacy label matches.
- [ ] Implemented as a root-level condition (`if !hasConsented { ConsentView() }`), not a dismissable sheet behind secondary flags.

**The reviewer must actually see it.** A developer was rejected repeatedly with "We were not presented with the consent prompt on launch or anywhere else in the app." (REPORTED, https://developer.apple.com/forums/thread/820209, Mar 2026). Causes: launch-state flags and consent stored server-side or shared across installs. Device-account apps whose Keychain token survives reinstall are exposed to exactly this. Test: delete app, reset Keychain token (or a new simulator), launch. Put the consent screen's location in Review Notes and include it in the screen recording.

Exact required UI wording: NOT FOUND in official docs.

## 2. Objectionable-content potential (1.1)

- Reported rejection text: "The app includes templates for generating content showing people making intimate contact with each other, such as hugging, kissing, or other intimate templates. While these templates alone may not be objectionable, they could be used to create objectionable content." (REPORTED, https://developer.apple.com/forums/thread/809787, rejections May and Oct 2025). Same templates were approved in summer 2025 and rejected in Oct 2025: enforcement is inconsistent.
- AI virtual try-on from the user's own face/body rejected under 1.1 ("Specifically, simulating outfit try-ons and styling") despite own-photo-only warnings, front-camera-only capture and ToS disclosures (REPORTED, https://developer.apple.com/forums/thread/826606, May 2026).
- Apple to developers citing competitors: "another app being out of compliance is not a reason for your app to be." (REPORTED, same threads)
- Climate: Apple removed "nudify" apps after the SF City Attorney's demand and said it terminates those developers (REPORTED, https://www.macrumors.com/2026/07/17/demand-to-pull-nudify-apps/, Jul 17, 2026). Apple pressed xAI for a moderation plan for Grok (REPORTED, https://www.macrumors.com/2026/04/15/apple-threatened-pull-grok-from-app-store, Apr 15, 2026).
- 1.2 (Jun 8, 2026, OFFICIAL, https://developer.apple.com/news/?id=a233fmpw): "If we find such content, we will ask you to remove it, and provide a plan to improve your compliance... Egregious or repeated behavior is grounds for immediate removal of your app from the App Store, and from the Apple Developer Program."

**Template audit for v1.0:** remove or hold back two-person intimacy (hug, kiss, couple, romantic), swimwear/lingerie, undress-adjacent effects, body reshaping, outfit swaps on real-person photos, and "swap any face" framing. Add them later, if at all, with strong moderation. Warnings alone did not prevent rejection.

**Moderation stack (describe it in Review Notes):** input-image classifier (nudity, minors), prompt filter, output classifier, logging and takedown. Write a one-page moderation plan you can send if Apple asks (ASSUMED good practice, consistent with 1.2's "plan to improve your compliance"). Never advertise undress / "see through" / "any face" capability anywhere, including ads.

## 3. UGC, chatbots and reporting (1.2, 4.7)

- 1.2 requires: "A method for filtering objectionable material... A mechanism to report offensive content and timely responses to concerns... The ability to block abusive users... Published contact information" (OFFICIAL, Jun 8, 2026).
- 4.7 names chatbots; 4.7.1 requires filtering, reporting with timely responses, and blocking (OFFICIAL, guidelines Jun 8, 2026; when chatbots entered 4.7 is NOT FOUND, the Nov 13, 2025 change only clarified mini apps/games).
- Random or anonymous chat is subject to 1.2 (OFFICIAL, https://developer.apple.com/news/?id=d75yllv4, Feb 6, 2026).
- HIG Generative AI: "Let people share feedback on outputs... report concerns when outputs don't match their expectations." (OFFICIAL, https://developer.apple.com/design/human-interface-guidelines/generative-ai, change log June 8, 2026)
- Report alone was insufficient; block was required (REPORTED, https://www.reddit.com/r/iosdev/comments/1rrmx18/, 2026-03-12).
- Whether private, unshared AI output counts as UGC: NOT FOUND. Vendor blogs claim reviewers treat AI output as UGC (ASSUMED).

**Decision:**

| App behavior | Minimum for v1.0 |
|---|---|
| Outputs private to the user | Report/feedback on every output (HIG); filters; contact in-app; notes say "no sharing between users" |
| Share to system share sheet only | Same as private (ASSUMED: sharing outside the app is not an in-app social surface) |
| In-app feed, gallery, public profile, AI persona pages | Report on every item, Block user, filters, published contact, timely-response process; answer the Social Media age-rating question Yes |
| Chatbot / companion persona | 4.7.1 filter + report + block; age rating covers worst-case chat output |

## 4. Real people, likeness, brands and IP (1.1.1, 1.2, 4.1, 5.2)

- No explicit "likeness consent" guideline: NOT FOUND.
- Applicable text (OFFICIAL, Jun 8, 2026): 1.1.1 bans content "likely to humiliate, intimidate, or harm a targeted individual"; 1.2 bans services used primarily for "objectification of real people"; 5.2.1 bans unauthorized trademarks, copyrighted works and "misleading... representations, names, or metadata"; 4.1(c) bans another developer's icon, brand or name.
- HIG: "Never trick someone into thinking they're interacting with or viewing content authored by a human if they're actually interacting with AI." (OFFICIAL, HIG Generative AI, June 8, 2026)
- Inference that celebrity/public-figure templates attract 1.1 or 5.2.1 rejection: ASSUMED from the reported 1.1 cases.
- 5.2.2: if the app "uses, accesses, monetizes access to, or displays content from a third-party service", you must be permitted, and "Authorization must be provided upon request." Rights documentation (signed contract, email permission) goes in App Review Information (OFFICIAL, https://developer.apple.com/help/app-review/before-submitting-for-review/complete-review).

**Checks:** no named celebrities, influencers, politicians, film characters or brands in templates, presets, prompt suggestions, screenshots or metadata; templates built from other creators' content have written permission attached in ASC; a "this is me / I have permission" attestation before face upload; AI-generated labels on exports where outputs could pass as real.

## 5. Face data (5.1.2(vi), 2.1 info requests)

- 5.1.2(vi): data from "depth and/or facial mapping tools (e.g. ARKit, Camera APIs, or Photo APIs) may not be used for marketing, advertising or use-based data mining, including by third parties." (OFFICIAL, Jun 8, 2026)
- A 2.1 information request in Aug 2026 asked (paraphrased): what face data is collected; how it is used, stored, retained, deleted and shared; whether it goes to third parties; where the privacy policy explains it; and the exact policy text (REPORTED, https://developer.apple.com/forums/thread/841786, Aug 2026).
- **Fix:** a "Face data and photos of people" section in the privacy policy (what is processed, which AI vendors receive it, retention, no biometric template extraction, no ad use, how to delete). Paste it into Review Notes to avoid the round trip. Keep face photos out of Meta/Adjust event payloads.

## 6. Age rating and minors (2.3.6, 1.2.1(a), 4.7.5, age assurance)

- "you must consider how all app features, including AI assistants and chatbot functionality, impact the frequency of sensitive content appearing within your app" (OFFICIAL, https://developer.apple.com/news/?id=ks775ehf, Jul 24, 2025). Answer for worst-case output frequency, not only curated templates.
- Social media capability = "the ability to redistribute, amplify, or interact with user-generated content through a social feed or similar discovery method"; responses required from September 2026 (OFFICIAL, https://developer.apple.com/news/?id=tlur8uvi, Jul 9, 2026; https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions/).
- Unrestricted web access makes the app 16+ (OFFICIAL, same ASC page).
- If your Terms say 18+, set the rating to 18+ so they match (ASSUMED consistency rule); note 18+ apps are blocked for unconfirmed adults in AU/BR/SG since Feb 24, 2026 (OFFICIAL, https://developer.apple.com/news/?id=f5zj08ey).
- 1.2.1(a) creator content and 4.7.5 software not embedded in the binary: content exceeding the app's rating needs "an age restriction mechanism based on verified or declared age" (OFFICIAL, Nov 13, 2025).
- Texas/Utah/Louisiana age assurance (Declared Age Range API, PermissionKit Significant Change API, consent-withdrawal server notification): legal exposure (OFFICIAL, https://developer.apple.com/news/?id=sg176nne, Jun 3, 2026; https://developer.apple.com/news/?id=f5zj08ey, Feb 24, 2026). Apple's Q&A: "No, there are no changes to the App Review process" (OFFICIAL, https://developer.apple.com/support/age-assurance, undated). Decide with counsel whether to gate minors from face/person generation and companion chat.
- An AI-imagery-specific age-rating question: NOT FOUND.

## 7. Spam and thin wrappers (4.2, 4.3)

- 4.2: more than a repackaged website (OFFICIAL). 4.3(b) saturated categories and opportunistic variants (OFFICIAL, Jun 8, 2026 clarification).
- AI photo/avatar/video, fortune telling, dating, calorie AI and habit trackers were named as saturated in 2026 reports (REPORTED, see `common-rejections.md` #12). No Apple text names AI generators as spam (NOT FOUND).
- Portfolio rule for owners who ship several similar AI apps from one backend: one concept per app, distinct UI/onboarding/paywall/screenshots/copy, do not submit several at once, and state the differentiators in Review Notes. A shared paywall template and shared onboarding across apps are the kind of "same source code or assets" factor in the reported 4.3(a) text (REPORTED, https://www.reddit.com/r/iOSProgramming/comments/1q4rljp/, 2026-01-05).
- First launch must show value: seeded sample outputs, not an empty library (REPORTED, https://www.reddit.com/r/iOSProgramming/comments/1ukh8d3/, 2026-07-01).

## 8. Social media data and creator content (5.2.2, 5.2.3, 5.1.1(viii))

- 5.2.3: no "ability to save, convert, or download media from third-party sources... without explicit authorization" (OFFICIAL).
- 5.1.1(viii): no compiling personal information "from any source that is not directly from the user or without the user's explicit consent, even public databases" (OFFICIAL).
- 5.1.1(v): social tokens stay on device; in-app revoke/disconnect; don't use them off-device while the app isn't in use (OFFICIAL).
- Instagram Terms prohibit automated collection without permission and collecting usernames/passwords/access tokens (OFFICIAL Meta terms, https://www.facebook.com/help/instagram/581066165581870, undated, fetched 2026-10-12).
- Use official OAuth APIs scoped to the user's own account, or a user-uploaded data export. No scraping, no other people's profiles by username, no reel downloading. No 2025-2026 report of a 5.2.2 rejection for such apps was found (NOT FOUND), so the risk is inferred from the text.

## 9. Laws outside App Review

- EU AI Act Art. 50: transparency duties (AI interaction disclosure, deepfake labelling) apply from Aug 2, 2026; machine-readable marking extended to Dec 2, 2026 only for systems already on the market (REPORTED law-firm summary, https://www.goodwinlaw.com/en/insights/publications/2026/08/alerts-technology-dpc-eu-ai-act-transparency-obligations-now-in-force).
- US TAKE IT DOWN Act: covered platforms (primarily hosting UGC) need an NCII notice process and 48-hour removal since May 19, 2026 (REPORTED, https://wilmerhale.com/en/insights/client-alerts/20260615-the-take-it-down-act-goes-live, Jun 15, 2026). Whether a private-output generator is a "covered platform" is unclear (ASSUMED).
- Not App Review checks, but they become evidence when Apple acts on complaints.

## 10. Review Notes lines for AI apps

```
AI processing: Photos and prompts you submit are sent to <Provider A> and <Provider B>
to generate images/videos. A consent screen naming these providers appears before the
first upload (Create tab > first photo). Users can decline and revoke in Settings > Privacy.
Moderation: prompt filter, input-image and output classifiers block nudity, minors and
sexualized edits. Every result has a Report button (••• menu). <Sharing: none / feed with Block>.
Generation time: typically <N> seconds; the backend is live and quotas are raised for review.
Templates: all templates are original or used with written permission (attached).
```
