# After a Rejection: Reply, Fix, Resubmit, Appeal, Expedite

Evidence cutoff 2026-10-12. Official text is from the guidelines "After You Submit" section (Last Updated June 8, 2026, https://developer.apple.com/app-store/review/guidelines/) and https://developer.apple.com/distribute/app-review/ (no page date, accessed 2026-10-12).

## 1. Read the rejection correctly

1. Copy the full message, including every guideline number and the "Next Steps".
2. Classify it:

| Type | Typical wording | Action |
|---|---|---|
| Information Needed (2.1) | "Information Needed", "Reply in App Store Connect with..." | Reply with the requested info; no new build needed |
| Binary/feature issue | "we found...", "Specifically, ..." | Fix, new build, resubmit, and reply explaining the fix |
| Metadata only | "metadata", "screenshots", "description" | Edit metadata, then resubmit (no new build needed) |
| IAP issue | "in-app purchase products have not been submitted", "unable to locate" | Attach products / fix loading; see `subscriptions-and-iap.md` |
| Misunderstanding | Reviewer describes a feature that doesn't exist, or missed one | Reply with steps and a recording; appeal if it persists |
| 4.3 spam / 5.6 conduct | "spam", "saturated", "fraudulent", "hidden" | Do not resubmit blindly; see § 5 |

3. Map each cited guideline to its reference file (SKILL.md routing table) and fix every cited item in one pass. "if your app is repeatedly rejected for the same guideline violation or you've attempted to manipulate the review process, review of your app will take longer to complete." (OFFICIAL, After You Submit)

## 2. Reply in App Store Connect

- "If your app has been rejected and you have questions or would like to provide additional information, please use App Store Connect to communicate directly with the App Review team." (OFFICIAL, After You Submit)
- "You can correspond with App Review to resolve the issues before resubmitting the build. Access the App Review section on the app's page in App Store Connect." (OFFICIAL, distribute/app-review). Developers still call this the Resolution Center.
- Reply template:

```
Thank you for the review. We addressed Guideline <x.y>:
- Issue: <reviewer's words>.
- Change: <what changed, where, build number>.
- How to verify: <exact taps>. Screen recording: <link>.
<Repeat per guideline.>
We also checked <related items> to avoid further issues.
```

- Community advice conflicts on reply-vs-resubmit speed: replying keeps the thread with the same reviewer for clarifications; resubmitting may be faster for clear fixes (REPORTED, https://www.reddit.com/r/iOSProgramming/comments/1s0nb97/, 2026-03-22). Default: reply for Information Needed and misunderstandings; for real fixes, resubmit and also reply with the change summary.
- October 2026: many replies to 2.1 requests sit unanswered for days (REPORTED, https://developer.apple.com/forums/tags/app-review, fetched 2026-10-12). Don't send repeated messages; one complete reply.

## 3. Resubmit

- New build only if the binary changed; bump the build number.
- Re-run Stages 1-8 from SKILL.md for the changed areas and `scripts/preflight.sh`.
- Confirm IAPs are still attached to the same draft as the version; a rejected v1.0 can strand IAPs in a separate draft (REPORTED, https://developer.apple.com/forums/thread/850187, ~2026-10-09; fix in `subscriptions-and-iap.md` § 2).
- Update Review Notes so they describe the fixed behavior.
- Freeze backend deploys while In Review.

## 4. Appeal to the App Review Board

- "If you disagree with the outcome of your review, please submit an appeal." Link: https://developer.apple.com/contact/app-store/?topic=appeal (OFFICIAL, After You Submit).
- "If your app didn't pass review and you feel we misunderstood your app's concept and functionality, or that you were treated unfairly by Apple in the course of our review, you may choose to submit an appeal to the App Review Board. If you file an appeal, make sure to: Provide specific reasons why you believe your app complies with the App Review Guidelines. Submit only one appeal per submission that didn't pass review. Respond to any requests for additional information before submitting an appeal." (OFFICIAL, distribute/app-review)
- Use it when the rejection is wrong, not when it is inconvenient. Successful 2026 cases: a 4.3(a) on an update after adding RevenueCat + Meta SDK + ATT was ruled invalid (REPORTED, https://www.reddit.com/r/iOSProgramming/comments/1w9ojf7/, 2026-09-07); a 4.3(b) cleared by appeal plus a metadata rewrite (REPORTED, 1s0nb97, 2026-03-22). A 4.3(b) dating-app appeal was upheld against the developer (REPORTED, https://developer.apple.com/forums/thread/812196, 2026).
- Appeal content: the guideline text, why the app complies point by point, what is unique, evidence (recording, screenshots, permission documents). No comparisons to other apps; Apple's stock answer is "another app being out of compliance is not a reason for your app to be" (REPORTED).
- You can also suggest guideline changes: https://developer.apple.com/contact/app-store/?topic=guideline (OFFICIAL).

## 5. Special cases

### 4.3 spam

- Don't resubmit the same binary repeatedly: repeated resubmission led to "account removal for repeated noncompliance" warnings (REPORTED, https://www.reddit.com/r/iOSProgramming/comments/1wj2j1d/, 2026-09-17; https://developer.apple.com/forums/thread/847013).
- Reply once with specifics: what is original (features, code, assets), who it is for, why it is not a variant of your other apps. A long originality reply got a veteran's three apps approved (REPORTED, https://www.reddit.com/r/appledevelopers/comments/1wjgb26/, 2026-09-18; https://developer.apple.com/forums/thread/845019, Sep 2026).
- If the app really is close to another of yours, merge it: 4.3(a) wants variations as one app with IAP (OFFICIAL).
- Then appeal if you believe the decision is wrong.

### 5.6 "hidden features" / fraud pattern

- Check the IPA for `.storekit`, `.xcconfig`, debug menus, and products in the binary that weren't submitted (REPORTED, https://www.reddit.com/r/iOSProgramming/comments/1wydut7/, 2026-10-05). Remove, rebuild, and explain in the reply what was shipped by mistake and how it is prevented now.

### 2.1 "Information Needed - New App Submission"

- Reply with all four items (recording on a physical device from launch, devices/OS tested, purpose and audience, setup instructions with credentials). Use `review-notes-template.md`; paste the same into Notes for the next version.

### 5.1.2(i) "consent prompt not presented"

- The reviewer did not see the AI consent screen. Fix gating so it shows on any fresh install, add its location and a recording to the reply (REPORTED, https://developer.apple.com/forums/thread/820209, Mar 2026).

## 6. Expedited review

- "If you have a critical timing issue, you can request an expedited review. Please respect your fellow developers by seeking expedited review only when you truly need it. If we find you're abusing this system, we may reject your requests going forward." Link: https://developer.apple.com/contact/app-store/?topic=expedite (OFFICIAL, After You Submit).
- Valid reasons: "fixing a critical bug in your app or releasing your app to coincide with an event you're directly associated with." For a bug fix, "include the steps to reproduce the bug on the current version of your app". For an event, include "the event, date of the event, and your app's association with the event." (OFFICIAL, distribute/app-review)
- A first v1.0 launch date you chose yourself is not listed as a reason (ASSUMED from the wording). Plan 1-3 weeks instead and use manual release.

## 7. Bug-fix submissions (for apps already live; not v1.0)

- "For apps that are already on the App Store or alternative distribution, bug fixes will not be delayed over guideline violations except for those related to legal or safety issues." Reply in App Store Connect saying you want to use this process and will fix the issue in the next submission (OFFICIAL, After You Submit).
- This does not apply to a first submission, which by definition is not on the App Store yet.

## 8. Timing expectations

- Official: "Typically reviewing at least 50% of submissions in less than 24 hours and 90% in less than 48 hours." (OFFICIAL, distribute/app-review)
- October 2026 reports: first submissions with subscriptions "stuck in Waiting for Review since September 28" and 5-14+ day waits (REPORTED, https://developer.apple.com/forums/thread/850197). Approved-after-resubmission count in 2025: 387,087 (OFFICIAL, https://images.apple.com/legal/app-store/transparency/2025/).
- Strategy reported by developers: submit an early, minimal-but-complete v1.0 (paywall, IAPs, legal, deletion all present) with manual release so products get approved early (REPORTED, https://www.reddit.com/r/iOSProgramming/comments/1wuy8ok/, 2026-10-01).
