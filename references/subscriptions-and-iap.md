# Subscriptions, Credits and IAP for a First Submission

Evidence cutoff 2026-10-12. Labels: OFFICIAL / REPORTED / ASSUMED / NOT FOUND.

## Contents

1. Before you build: agreements and catalog
2. Attaching first-time IAPs to the version
3. Paywall disclosure checklist (3.1.2(c) + Schedule 2)
4. Price hierarchy, trials, toggles, exit offers
5. Credits (3.1.1) and subscription allowances
6. Restore and anonymous IDs
7. Making the paywall work for the reviewer (2.1(b))
8. App Store description "Subscription details" block
9. External purchase links (3.1.1(a)/3.1.3)
10. Verification commands

## 1. Before you build: agreements and catalog

- Paid Apps Agreement must be Active, with tax and banking complete. Paid IAPs "won't function in review until" the Account Holder accepts it (OFFICIAL, https://developer.apple.com/help/app-review/before-submitting-for-review/configure-in-app-purchases, accessed 2026-10-12). A reported rejection was traced to an inactive agreement (REPORTED, https://www.reddit.com/r/applestore/comments/1svldy4/, 2026-04-25).
- Put all subscriptions in one group (REPORTED advice, https://www.reddit.com/r/iOSProgramming/comments/1s0kw1w/, 2026-03-22). The group needs an App Store localization before submission (REPORTED, https://www.reddit.com/r/AppBusiness/comments/1wcdvzm/, 2026-09-10).
- Each product needs: reference name, price, availability, localized display name and description, and an App Review screenshot (REPORTED: Apple rejection text quoted at https://developer.apple.com/forums/thread/816376, Feb 2026; also https://www.revenuecat.com/docs/test-and-launch/submitting-ios-subscription-app, vendor doc, undated).
- Display names and descriptions must differ per product and state quantity or period ("100 credits", "Yearly"). Identical names across credit packs were rejected (REPORTED, https://www.reddit.com/r/appledevelopers/comments/1w6wvsy/, 2026-09-04).
- Subscription period at least 7 days (3.1.2(a), OFFICIAL, guidelines Jun 8, 2026). A weekly plan is the shortest allowed.
- Products available in every territory the app is sold in; region-restricted products failed with "The product is not available for purchase" (REPORTED, https://www.reddit.com/r/iOSProgramming/comments/1q085ch/, 2025-12-31). If restrictions are intentional, explain them in Notes (OFFICIAL, configure-in-app-purchases page).

## 2. Attaching first-time IAPs to the version

OFFICIAL (https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-in-app-purchase, accessed 2026-10-12):

> "The first consumable, non-consumable, auto-renewable subscription, and non-renewing subscription In-App Purchase of each type must be submitted with a new app version."
> "If you're submitting a new subscription it must be submitted together with its subscription group. Each new subscription group must be submitted with at least one of its subscriptions. The app version, subscription group, and every subscription or In-App Purchase you want reviewed together must all be added to the same draft submission before you click Submit for Review."

Procedure:

1. Create the draft submission from the version (ASC "Add for Review" on the version, or `asc review submissions-create` + `asc review items add`).
2. Add every subscription group, every subscription individually, and every consumable credit pack.
3. List items before submitting: `asc review items list --submission SUBMISSION_ID`. Compare with the product IDs in RevenueCat offerings; any product the binary can show must be in the list.
4. Add a review note: "This version includes first-time subscriptions X, Y and consumables Z; please review them together."

Rejected-submission trap (REPORTED, https://developer.apple.com/forums/thread/850187, ~2026-10-09, fix confirmed by a second developer; same lock without a fix in https://developer.apple.com/forums/thread/840483, Aug 2026): if v1.0 sits in a rejected submission, "Add for Review" on IAPs creates a separate draft that cannot be submitted ("To submit your items for review, add an app version for the selected platform"). Remove the version from the rejected submission, add each subscription individually, then add the version into that same draft. If it still fails, contact App Store Connect support.

## 3. Paywall disclosure checklist (3.1.2(c) + Schedule 2)

Sources: DPLA Schedule 2 §3.8(b) (OFFICIAL, https://developer.apple.com/support/terms/apple-developer-program-license-agreement/, fetched 2026-10-12); https://developer.apple.com/app-store/subscriptions/ (OFFICIAL, accessed 2026-10-12); guideline 3.1.2(c) (OFFICIAL, Jun 8, 2026).

On every purchase surface (onboarding paywall, in-app paywall, RevenueCat remote paywall variants, SubscriptionStoreView), visible before the buy button:

- [ ] Subscription name and duration, and what is provided during the period (features, credits per period).
- [ ] Full renewal price, localized, from StoreKit/RevenueCat (`localizedPriceString`), never hardcoded.
- [ ] Auto-renew statement, e.g. "Auto-renews at $49.99/year until cancelled."
- [ ] For a trial or intro offer: how long it lasts and the price billed after ("3-day free trial, then $4.99/week"). A SubscriptionStoreView paywall was rejected for not making automatic payment after the trial clear (REPORTED, https://www.reddit.com/r/iosdev/comments/1rmrnup/, 2026-03-06).
- [ ] Tappable Terms of Use (EULA) and Privacy Policy links on the paywall itself. "Having them in Settings isn't enough" (REPORTED, https://www.reddit.com/r/iOSProgramming/comments/1s2e3lj/, 2026-03-24).
- [ ] Restore Purchases (and "sign in" if accounts exist).
- [ ] Trial copy only shown to trial-eligible users (RevenueCat intro eligibility). ASSUMED best practice, consistent with 3.1.2(a) bait-and-switch ban.

Footer template:

```
<Plan> · <billed price>/<period>. Auto-renews unless cancelled at least 24 hours
before the end of the period. <N-day free trial, then <price>/<period>.>
Manage or cancel in Settings > Apple Account > Subscriptions.
[Restore Purchases]   [Terms of Use]   [Privacy Policy]
```

The "24 hours before" wording is common industry copy (ASSUMED), not quoted from Apple.

## 4. Price hierarchy, trials, toggles, exit offers

- Billed amount most prominent: "In the purchase flow, the amount that will be billed must be the most prominent pricing element in the layout... these additional elements should be displayed in a subordinate position and size to the annual price." (OFFICIAL, https://developer.apple.com/app-store/subscriptions/)
- Reported rejection text: "promotes the free trial, introductory pricing, or introductory period for the subscription more clearly and conspicuously than the billed amount" (REPORTED, https://developer.apple.com/forums/thread/841626, Aug 2026). Main CTA was "Try for Free".
- Passing pattern: CTA "Continue for $4.99 / month", trial as a small caption (REPORTED, https://www.reddit.com/r/buildinpublic/comments/1uo5pki/, 2026-07-05).
- No trial toggle (REPORTED, RevenueCat blog Feb 9, 2026, see `common-rejections.md` #4).
- No exit-intent discount (REPORTED, https://www.reddit.com/r/iOSProgramming/comments/1pa71k5/, 2025-11-30).
- Close button: no Apple rule found requiring an immediately visible close (NOT FOUND). Hard paywalls are not prohibited in the text reviewed, and a hard-paywall app was approved (REPORTED, https://www.reddit.com/r/AppBusiness/comments/1wfd836/, 2026-09-13). Conservative choice for v1.0: visible X with a 44pt target, no delay (ASSUMED).
- Don't present a second modal over a fullscreen paywall on purchase failure; an invisible layer swallowed taps and caused a 2.1(b) (REPORTED, https://www.reddit.com/r/indiehackersindia/comments/1w1ho7v/, 2026-08-29). Show errors inline.
- No rewards for ratings (3.2.2(x), OFFICIAL, https://developer.apple.com/news/?id=r9dcmrvs, Jun 9, 2025); paid tier must not require social posting (3.1.2(a), OFFICIAL).

## 5. Credits (3.1.1) and subscription allowances

- "Any credits or in-game currencies purchased via in-app purchase may not expire, and you should make sure you have a restore mechanism for any restorable in-app purchases." (OFFICIAL, 3.1.1, Jun 8, 2026)
- "Subscriptions may include consumable credits, gems, in-game currencies, etc." (OFFICIAL, 3.1.2(a))
- Whether a per-period subscription allowance that resets at renewal counts as "expiring" is NOT FOUND. Treating it as fine when disclosed as "N credits per month, resets each period" is ASSUMED.
- Backend rule: keep two ledgers, purchased credits (never expire, never decay) and subscription allowance (resets per period). Say so on the paywall, in Terms, and in Review Notes.
- Grep Terms, FAQ and paywall copy for "expire". A reviewer reading "credits expire" is a 3.1.1 rejection (ASSUMED from the rule text).
- Items bought with credits that persist forever look like disguised non-consumables (REPORTED, https://developer.apple.com/forums/thread/800637, date not verified, possibly stale).

## 6. Restore and anonymous IDs

- Sign-up screen must offer "A way for current subscribers to sign in or restore purchases" (OFFICIAL, https://developer.apple.com/app-store/subscriptions/).
- RevenueCat: "Consumables and non-renewing subscriptions can only be restored by using an account system with custom App User IDs"; `restorePurchases` "should not be triggered programmatically" (vendor doc, https://www.revenuecat.com/docs/getting-started/restoring-purchases, fetched 2026-10-12).
- With anonymous/device IDs: subscriptions restore; consumable credit balances live in your ledger keyed to the device ID, so they will not follow a new device unless you add an optional account. Disclose that (ASSUMED inference).
- RevenueCat transfer behavior "transfer to new App User ID" lets a restored subscription follow the new device token (vendor context, https://community.revenuecat.com/sdks-51/handling-apple-app-review-rejection-with-revenuecat-s-keep-with-original-app-user-id-setting-6041, Mar 2025, possibly stale).
- Put Restore on the paywall and in Settings. Show success / "nothing to restore" feedback.

## 7. Making the paywall work for the reviewer (2.1(b))

2.1(b): "If you offer in-app purchases in your app, make sure they are complete, up-to-date, visible to the reviewer and functional. If any configured in-app purchase items cannot be found or reviewed in your app, explain the reason in your review notes." (OFFICIAL, Jun 8, 2026)

Test matrix (each must render prices and complete a purchase or show a clear error with Retry):

| Condition | Why |
|---|---|
| Fresh sandbox Apple ID, fresh install | Reviewer's account path differs from yours (REPORTED, 1uj4z9x, 2026-06-29) |
| TestFlight build, no .storekit config | .storekit hides missing-product bugs (REPORTED, 1p1bx7y, 2025-11-19) |
| iPad in iPhone compatibility mode | Review device named as iPad Air 11-inch (M3) (REPORTED, https://developer.apple.com/forums/thread/844471, Sep 2026) |
| Network Link Conditioner "Very Bad Network" | Offerings fetch timeouts produce blank paywalls (REPORTED, 1ushcmq, 2026-07-10) |
| Purchase cancelled / failed | UI must stay tappable (REPORTED, 1w1ho7v) |
| Demo account with no entitlement | Paywall and Restore must be reachable (REPORTED, 1tawhbd) |

Paywall state machine: `loading → loaded(products) | error(retry)`. Never bind a buy button to a nil product. Log offerings errors to your crash reporter. If sandbox flakiness is suspected, RevenueCat docs note some developers had to resubmit the same build (vendor, https://www.revenuecat.com/docs/test-and-launch/app-store-rejections.md, undated).

## 8. App Store description "Subscription details" block

Put this at the end of the description in every localization (localized text, same URLs). Pricing in the description is expected; prices in name/subtitle/screenshots are not (2.3.7).

```
Subscription details
- <App> Weekly: <price> per week, includes <N> credits per week.
- <App> Yearly: <price> per year, includes <N> credits per month. <Trial terms if any.>
- Credit packs: one-time purchases; purchased credits never expire.
Payment is charged to your Apple Account at confirmation. Subscriptions renew
automatically unless cancelled at least 24 hours before the end of the current
period. Manage or cancel in your Apple Account settings.
Generating content requires credits or an active subscription.
Terms of Use (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
Privacy Policy: https://<your-domain>/privacy
```

Why: missing EULA link in the description is the most reported subscription rejection (REPORTED, see `common-rejections.md` #1); 2.3.2 requires saying when features need additional purchase (OFFICIAL). Check each locale; one rejection came from a locale missing the link (REPORTED, forum 786790, Jun 2025).

## 9. External purchase links (3.1.1(a)/3.1.3)

"In all other storefronts, except for the United States storefront, where this prohibition does not apply, apps and their metadata may not include buttons, external links, or other calls to action that direct customers to purchasing mechanisms other than in-app purchase." (OFFICIAL, 3.1.1(a), guidelines Jun 8, 2026)

For v1.0: omit web checkout, or gate it on `Storefront.current?.countryCode == "USA"` and keep IAP alongside it.

## 10. Verification commands

```bash
asc validate subscriptions --app "$APP_ID"
asc validate iap --app "$APP_ID"
asc validate --app "$APP_ID" --version-id "$VERSION_ID" --deep   # deep: agreements + first-of-type attachment
asc review items list --submission "$SUBMISSION_ID"
```

All are read-only. `--deep` needs a cached Apple web session and never starts an interactive login (per `asc validate --help`, asc 5.13.0).
