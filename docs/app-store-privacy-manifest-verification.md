# Release Privacy Manifest Verification

Verified on 2026-10-24 from the unsigned iOS release artifact produced by:

```sh
flutter build ios --release --no-codesign
```

The inspected bundle was `build/ios/iphoneos/Runner.app`. This is release-build evidence for the current source tree; repeat the inspection after changing Flutter, an iOS plugin, or any privacy-relevant code.

| Bundle | Manifest | Collected data | Tracking | Required Reason APIs |
| --- | --- | --- | --- | --- |
| App target (`Runner.app`) | No app-owned manifest | No app-owned declaration | No app-owned declaration | None found in app source review; recheck if native code is added. |
| `Flutter.framework` | Present | None | No | File timestamp: `0A2A.1`, `C617.1`; system boot time: `35F9.1`. |
| `in_app_purchase_storekit` | Present | None | No | None. |
| `sqflite_darwin` | Present | None | No | None. |
| `url_launcher_ios` | Present | None | No | None. |

## App Store Connect declaration

The inspected release uses local SQLite for learner settings, answer history, and progress. The source review found no account, analytics, advertising, tracking, cloud synchronization, or developer-server data transfer. Subject to confirming the final signed archive and all eventual SDKs, select **“No, we do not collect data from this app”** in App Privacy.

Apple handles StoreKit payment processing. Do not declare payment-card data as developer-collected data unless future code or services receive it.

## Required before submission

- Build and inspect the signed release archive selected for App Review.
- Review Xcode Organizer / App Store Connect upload warnings and the final Privacy Report.
- Re-run this check after dependency changes.
- Add `ios/Runner/PrivacyInfo.xcprivacy` only if app-owned iOS code uses a Required Reason API or collects data that needs a declaration. Use an Apple-approved reason that matches the actual feature.
