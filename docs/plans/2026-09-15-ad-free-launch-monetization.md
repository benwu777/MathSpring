# Ad-Free Launch Monetization Design

MathSpring's first App Store release does not include advertising. The single non-consumable purchase unlocks full solution steps, the complete avatar catalog, and up to five learner profiles. The product does not promise ad removal because no advertising is present in the shipped app.

All user-visible purchase copy, App Store metadata, privacy policy, and App Review notes must describe the same offer. The release checklist keeps App Store Connect product creation, paid-app agreements, sandbox purchase verification, TestFlight, and device QA as external release gates; none are represented as finished in the app.

Verification is a file-content regression test that fails if the public release surfaces retain advertising-removal claims. Existing StoreKit unit tests remain responsible for product loading, purchase, restore, and transaction completion.
