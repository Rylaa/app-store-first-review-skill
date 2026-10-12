# Metadata and Screenshots

Name, subtitle, keywords, description, promotional text, What's New, screenshots, previews, IAP display names, App Review Information fields. Evidence cutoff 2026-10-12.

## 1. Required fields (block submission if empty)

OFFICIAL (https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information and guidelines "Before You Submit", Jun 8, 2026; accessed 2026-10-12):

- Screenshots, description (max 4000 characters), keywords (max 100 bytes), Support URL, Copyright.
- App Review contact phone in international format with `+` and country code: "Numbers-only entries are rejected."
- Review Notes: up to 4000 bytes.
- Privacy Policy URL (App Information).
- Age rating answered, including the Social Media questions required since September 2026 (OFFICIAL, https://developer.apple.com/news/?id=tlur8uvi, Jul 9, 2026).

Check with `asc validate --app APP_ID --version-id VERSION_ID --check-urls` (read-only).

## 2. What may not appear where

| Rule | Applies to | Label + source |
|---|---|---|
| No prices or terms "not specific to the metadata type" | name, subtitle, screenshots, previews | OFFICIAL, 2.3.7, Jun 8, 2026 |
| "references to free or discounted services are considered a price reference" | screenshots (and likely name/subtitle) | REPORTED reviewer text, https://www.reddit.com/r/iOSProgramming/comments/1vtbupn/, 2026-08-20 |
| No trademarked terms or popular app names | any metadata field incl. keywords | OFFICIAL, https://developer.apple.com/help/app-review/guideline-reference/4-1-prevent-copycat-rejection |
| No other developer's icon, brand or product name | icon, name | OFFICIAL, 4.1(c), https://developer.apple.com/news/?id=ey6d8onl, Nov 13, 2025 |
| Keywords: "don't use other apps' or companies' names" | keywords | OFFICIAL, platform-version-information page |
| No names, icons or imagery of other mobile platforms (incl. status bars) | app and metadata | OFFICIAL, 2.3.10 |
| Say whether featured items need additional purchase | description, screenshots | OFFICIAL, 2.3.2 |
| Icons, screenshots, previews must suit a 4+ audience even if rated higher | icon, screenshots, previews | OFFICIAL, 2.3.8 |
| "For Kids" / "For Children" reserved for the Kids Category | all metadata | OFFICIAL, 2.3.8 |
| No hidden or undocumented features; "Generic descriptions will be rejected" | description, notes | OFFICIAL, 2.3.1(a) |
| Promoting a false price, in or outside the App Store, is grounds for removal | everywhere incl. ads | OFFICIAL, 2.3.1(a) |

Whether naming the AI model you use in the description ("powered by X") violates 4.1: NOT FOUND. The 4.1 help page bans trademarked terms in any metadata field, so treat it as risky.

## 3. Grep list before submitting

Run over name, subtitle, keywords, description, promo text, What's New, screenshot captions (OCR), preview frames, and `Localizable.xcstrings`:

```
free | trial | \$ | € | £ | % off | discount | sale | price | no ads | cheapest
Android | Google Play | Play Store | also on | iPhone-only claims for iPad builds
ChatGPT | OpenAI | GPT | Gemini | Midjourney | Sora | Veo | Kling | Runway | Instagram | TikTok | YouTube | CapCut
lorem | TODO | coming soon | beta | test | placeholder
```

`scripts/preflight.sh` covers the repo side (fastlane/metadata dirs and strings). For ASC-hosted metadata, use `asc metadata pull` (see `asc-metadata-sync`) into a temp directory and point the script at it with `--metadata-dir`.

## 4. Screenshots

OFFICIAL (https://developer.apple.com/help/app-review/guideline-reference/2-3-3-screenshots and https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications, accessed 2026-10-12; new guidance published Oct 5, 2026, https://developer.apple.com/news/?id=ljpl7kyn):

- App Review "will approve only those submissions where more than half of screenshots show the app in use".
- Don't use only login or splash screens, misleading UI, or overlays that crowd out the app.
- Required: at least one iPhone screenshot at the "iPhone with Dynamic Island (medium display)" size; plus iPad 13-inch if the app runs on iPad as a native iPad app. 1-10 per size.
- iPhone Duo screenshots required from April 2027 for apps on the iOS 27.1 SDK.

REPORTED patterns:

- A screenshot of the paywall with prices, or a free-vs-premium comparison, was rejected under 2.3.7 (https://www.reddit.com/r/AppBusiness/comments/1wcdvzm/, 2026-09-10; 1vtbupn). Community heuristic: "Premium/Pro vs Standard" is fine, "Paid vs Free" is not.
- Features shown that are only available with premium must be labelled in the screenshot or description (1s2e3lj comments, 2026-03).
- Screenshots of a flow that changed in the build, so the reviewer could not reproduce it (same thread).

Checklist:

- [ ] More than 50% of frames are real app UI captures; captions are small.
- [ ] Every frame maps to a screen reachable in this build (keep a frame → screen list).
- [ ] Sample AI outputs are things the app really produces, neutral (no suggestive faces/bodies, no celebrities or brands).
- [ ] No prices, "free", trial, discount, or other platforms.
- [ ] Pro-only features labelled "Pro".
- [ ] iPad set exists if the build supports iPad natively (`asc validate --ipa ./App.ipa` detects this).

## 5. In-app purchase metadata

- Each product: unique display name and description stating quantity or period; review screenshot; localized (REPORTED duplicate-name rejection, https://www.reddit.com/r/appledevelopers/comments/1w6wvsy/, 2026-09-04).
- Promoted IAP images unique per product (REPORTED, https://www.reddit.com/r/vibecoding/comments/1tawhbd/, 2026-05-12).
- Don't put brand names of AI vendors in IAP names either (ASSUMED, same 4.1 logic).

## 6. Description structure for a subscription gen-AI app

1. What the app does, in concrete outcomes (no superlatives about competitors).
2. Feature list matching the screenshots.
3. "Generating content requires credits or an active subscription." (2.3.2)
4. Subscription details block with Terms of Use (EULA) and Privacy Policy URLs (template in `subscriptions-and-iap.md` § 8), in every localization.

## 7. App Review Information attachments

- Rights documentation (signed contract, email permission) for third-party trademarks, creator content or likeness: attach in App Review Information and describe in Notes (OFFICIAL, https://developer.apple.com/help/app-review/before-submitting-for-review/complete-review).
- Partnership/authorization documents for regulated categories go in the Attachment section (OFFICIAL, https://developer.apple.com/distribute/app-review/).
- A screen recording can be attached or linked (REPORTED practice, see `review-notes-template.md`).
