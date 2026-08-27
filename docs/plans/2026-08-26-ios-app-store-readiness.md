# iOS App Store Readiness Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Prepare MathSpring for an iPhone/iPad App Store launch by improving code health, adding public support/privacy pages and in-app entry points, documenting QA, and producing bilingual Simulator-based store assets.

**Architecture:** Keep the app offline-first and use static GitHub Pages content for support/privacy information. Add a small in-app legal/support route that opens public URLs once configured. Keep signing identifiers configurable placeholders until the developer account exists.

**Tech Stack:** Flutter/Dart, iOS Xcode project, GitHub Pages static HTML, Flutter integration/widget tests, iOS Simulator.

### Task 1: Record release configuration and QA acceptance criteria

**Files:**
- Create: `docs/ios-release-qa.md`
- Modify: `docs/app-store-release-checklist.md`

**Step 1:** Document supported iPhone/iPad OS/device matrix, core flows, offline assertions, localization checks, accessibility text-size checks, release commands, and deferred signing fields.

**Step 2:** Add explicit acceptance criteria for each QA flow and a release-blocker list.

**Step 3:** Verify Markdown links and `git diff --check`.

### Task 2: Add static GitHub Pages support and privacy content

**Files:**
- Create: `docs/site/index.html`
- Create: `docs/site/support/index.html`
- Create: `docs/site/privacy/index.html`
- Create: `docs/site/assets/site.css`

**Step 1:** Write page-content tests/checks that assert support contact, version section, privacy data-handling statement, retention/deletion policy, and links between pages.

**Step 2:** Implement responsive, accessible static pages in Traditional Chinese and English sections; use an obvious placeholder support email and deployment URL variable that must be replaced before release.

**Step 3:** Run static link/content validation and visually inspect rendered pages locally.

### Task 3: Add in-app Support and Privacy entry points

**Files:**
- Modify: `pubspec.yaml`
- Modify: `lib/main.dart`
- Modify: `test/widget_test.dart`

**Step 1:** Add a failing widget test for visible Support and Privacy entry points and locale-aware labels.

**Step 2:** Add `url_launcher` and a configurable static-site URL constant. Present support/privacy links in the existing app settings or an information surface without blocking offline learning.

**Step 3:** Implement handling for unavailable URLs with user-visible feedback.

**Step 4:** Run focused widget tests, then all Flutter tests.

### Task 4: Eliminate current static-analysis findings

**Files:**
- Modify: `lib/main.dart`
- Modify: `lib/services/question_bank_duplicate_audit.dart`
- Modify: `test/geometry_scene_test.dart`
- Modify: `test/widget_test.dart`

**Step 1:** Add or adjust tests around asynchronous navigation paths before changing mounted checks.

**Step 2:** Remove unused widgets/helpers/imports, make safe constants const, replace unnecessary containers, and repair public APIs exposing private state types.

**Step 3:** Resolve all `flutter analyze` findings without suppressing rules.

**Step 4:** Run `flutter analyze` and `flutter test`.

### Task 5: Prepare iOS release configuration without developer credentials

**Files:**
- Modify: `ios/Runner/Info.plist`
- Modify: `ios/Runner.xcodeproj/project.pbxproj`
- Create: `docs/ios-signing-handoff.md`

**Step 1:** Add build-time placeholders for the future production Bundle ID and product name; do not invent a real identifier.

**Step 2:** Document exact Xcode values to fill after joining Apple Developer Program, including Team, bundle ID, automatic signing, and build-number increment procedure.

**Step 3:** Run `flutter build ios --no-codesign` to validate release compilation.

### Task 6: Generate bilingual App Store copy and Simulator screenshot checklist

**Files:**
- Create: `docs/app-store-metadata-zh-Hant.md`
- Create: `docs/app-store-metadata-en.md`
- Create: `docs/app-store-screenshot-plan.md`

**Step 1:** Draft localized name, subtitle, description, keywords, category, age-rating guidance, Review Notes, and release notes without unsupported claims.

**Step 2:** Define five Simulator screenshot states per locale: home, learner/level choice, topic selection, active question, result/history.

**Step 3:** Launch the iOS Simulator, capture the specified screens, and save them under a non-source release-assets directory. Verify screens use real app content and required dimensions.

### Task 7: Final release-readiness verification

**Files:**
- Modify: `docs/app-store-release-checklist.md`

**Step 1:** Run `flutter analyze`, `flutter test`, `flutter build ios --no-codesign`, and `git diff --check`.

**Step 2:** Verify support/privacy content, in-app links, metadata drafts, QA document, and screenshot artifacts against the checklist.

**Step 3:** Commit with a Chinese message and present merge options.
