import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/models/avatar_configuration.dart';
import 'package:mathspring/services/avatar_asset_catalog.dart';
import 'package:mathspring/widgets/avatar_editor.dart';

void main() {
  testWidgets(
      'avatar editor starts with presentation and advances through options',
      (tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: Scaffold(body: AvatarEditor())));
    expect(find.text('Choose avatar'), findsAtLeastNWidgets(1));
    await tester
        .tap(find.byKey(const ValueKey<String>('avatar_presentation_boy')));
    await tester.tap(find.byKey(const ValueKey<String>('avatar_next_button')));
    await tester.pump();
    expect(find.text('Skin tone'), findsAtLeastNWidgets(1));
    await tester.tap(find.byKey(const ValueKey<String>('avatar_next_button')));
    await tester.pump();
    expect(find.text('Face shape'), findsAtLeastNWidgets(1));
  });

  testWidgets('lets learners jump straight to a localized avatar section',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('zh', 'TW'),
        supportedLocales: <Locale>[Locale('zh', 'TW')],
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(body: AvatarEditor()),
      ),
    );

    expect(find.byKey(const ValueKey<String>('avatar_section_selector')),
        findsOneWidget);
    expect(find.text('膚色'), findsOneWidget);

    for (int step = 0; step < 3; step++) {
      await tester
          .tap(find.byKey(const ValueKey<String>('avatar_next_button')));
      await tester.pump();
    }

    expect(find.text('髮型'), findsAtLeastNWidgets(1));
    expect(find.byKey(const ValueKey<String>('avatar_option_girl_hair_01')),
        findsOneWidget);
  });

  testWidgets('can show stable asset IDs on preview option tiles',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AvatarEditor(showOptionIds: true)),
      ),
    );

    for (int step = 0; step < 3; step++) {
      await tester
          .tap(find.byKey(const ValueKey<String>('avatar_next_button')));
      await tester.pump();
    }

    expect(find.text('girl_hair_01'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('girl_hair_10'),
      120,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('girl_hair_10'), findsOneWidget);
  });

  testWidgets('keeps direct section controls and navigation inside iPhone view',
      (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AvatarEditor())),
    );

    for (final Finder control in <Finder>[
      find.byKey(const ValueKey<String>('avatar_section_selector')),
      find.byKey(const ValueKey<String>('avatar_back_button')),
      find.byKey(const ValueKey<String>('avatar_next_button')),
    ]) {
      final Rect rect = tester.getRect(control);
      expect(rect.top, greaterThanOrEqualTo(0));
      expect(rect.bottom, lessThanOrEqualTo(844));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows girl hairstyle options as tappable asset thumbnails',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AvatarEditor())),
    );

    for (int step = 0; step < 3; step++) {
      await tester
          .tap(find.byKey(const ValueKey<String>('avatar_next_button')));
      await tester.pump();
    }

    expect(find.text('Hairstyle'), findsAtLeastNWidgets(1));
    expect(find.byKey(const ValueKey<String>('avatar_option_girl_hair_01')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('avatar_option_girl_hair_03')),
        findsOneWidget);
  });

  testWidgets('keeps hairstyle navigation visible with ten options',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AvatarEditor())),
    );

    for (int step = 0; step < 3; step++) {
      await tester
          .tap(find.byKey(const ValueKey<String>('avatar_next_button')));
      await tester.pump();
    }

    expect(
      tester
          .getCenter(find.byKey(const ValueKey<String>('avatar_next_button')))
          .dy,
      lessThan(600),
    );
  });

  testWidgets('uses a denser grid for smaller facial parts', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AvatarEditor())),
    );

    Future<void> advanceTo(int step) async {
      for (int current = 0; current < step; current++) {
        await tester
            .tap(find.byKey(const ValueKey<String>('avatar_next_button')));
        await tester.pump();
      }
    }

    int columnCount() {
      final GridView grid = tester.widget<GridView>(find.byType(GridView));
      return (grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
          .crossAxisCount;
    }

    // 步驟：3 髮型 → 4 眼型（包含眼鏡）→ 5 鼻 → 6 嘴
    await advanceTo(3);
    expect(columnCount(), 3, reason: '髮型');

    await tester.tap(find.byKey(const ValueKey<String>('avatar_next_button')));
    await tester.pump();
    expect(columnCount(), 4, reason: '眼型');

    await tester.tap(find.byKey(const ValueKey<String>('avatar_next_button')));
    await tester.pump();
    expect(columnCount(), 5, reason: '鼻');

    await tester.tap(find.byKey(const ValueKey<String>('avatar_next_button')));
    await tester.pump();
    expect(columnCount(), 5, reason: '嘴');

    expect(find.text('Glasses'), findsNothing);
  });

  testWidgets('does not offer eye colour as an avatar editor step',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AvatarEditor())),
    );

    for (int step = 0; step < 4; step++) {
      await tester
          .tap(find.byKey(const ValueKey<String>('avatar_next_button')));
      await tester.pump();
    }
    expect(find.text('Eyes'), findsAtLeastNWidgets(1));

    await tester.tap(find.byKey(const ValueKey<String>('avatar_next_button')));
    await tester.pump();
    expect(find.text('Nose'), findsAtLeastNWidgets(1));
    expect(find.text('Eye colour'), findsNothing);
  });

  testWidgets('zooms mouth art inside its compact option tile', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AvatarEditor())),
    );

    for (int step = 0; step < 6; step++) {
      await tester
          .tap(find.byKey(const ValueKey<String>('avatar_next_button')));
      await tester.pump();
    }

    final Transform mouthArt = tester.widget<Transform>(
      find.byKey(const ValueKey<String>('avatar_option_image_girl_mouth_01')),
    );
    expect(mouthArt.transform.storage[0], 3);
  });

  testWidgets(
      'shows the third boy hairstyle as its own untransformed thumbnail',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AvatarEditor())),
    );

    await tester
        .tap(find.byKey(const ValueKey<String>('avatar_presentation_boy')));
    for (int step = 0; step < 3; step++) {
      await tester
          .tap(find.byKey(const ValueKey<String>('avatar_next_button')));
      await tester.pump();
    }

    expect(find.text('Hairstyle'), findsAtLeastNWidgets(1));
    expect(find.byKey(const ValueKey<String>('avatar_option_boy_hair_03')),
        findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('avatar_option_treatment_boy_hair_03')),
      findsNothing,
    );
  });

  testWidgets('gives every treated option a matching thumbnail treatment',
      (tester) async {
    for (final AvatarPresentation presentation in AvatarPresentation.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AvatarEditor(
                key: ValueKey<AvatarPresentation>(presentation),
                initialConfiguration:
                    AvatarConfiguration.defaultFor(presentation),
              ),
            ),
          ),
        ),
      );

      // 順序必須與 AvatarEditor 的步驟一致；眼鏡是眼睛圖稿的一部分。
      const List<String> categories = <String>[
        'skin',
        'face',
        'hair',
        'eyes',
        'nose',
        'mouth',
      ];
      for (final String category in categories) {
        await tester
            .tap(find.byKey(const ValueKey<String>('avatar_next_button')));
        await tester.pump();

        // A scrollable hairstyle grid intentionally builds only its visible
        // tiles.  This widget test checks one visible treated thumbnail;
        // non-visible treatments are asserted by their catalog tests.
        final Iterable<String> ids = category == 'hair'
            ? AvatarConfiguration.optionsFor(presentation, category).where(
                (String id) => !AvatarAssetCatalog.treatmentFor(id).isNeutral,
              ).take(1)
            : AvatarConfiguration.optionsFor(presentation, category);
        for (final String id in ids) {
          expect(
              find.byKey(ValueKey<String>('avatar_option_$id')), findsOneWidget,
              reason: '$id is missing from the $category step');
          expect(
            find.byKey(ValueKey<String>('avatar_option_treatment_$id')),
            AvatarAssetCatalog.treatmentFor(id).isNeutral
                ? findsNothing
                : findsOneWidget,
            reason: '$id thumbnail does not match its preview treatment',
          );
        }
      }
    }
  });
}
