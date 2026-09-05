import 'package:flutter/material.dart';
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
    expect(find.text('Choose avatar'), findsOneWidget);
    await tester
        .tap(find.byKey(const ValueKey<String>('avatar_presentation_boy')));
    await tester.tap(find.byKey(const ValueKey<String>('avatar_next_button')));
    await tester.pump();
    expect(find.text('Skin tone'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('avatar_next_button')));
    await tester.pump();
    expect(find.text('Face shape'), findsOneWidget);
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

    expect(find.text('Hairstyle'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('avatar_option_girl_hair_01')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('avatar_option_girl_hair_03')),
        findsOneWidget);
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

    await advanceTo(3);
    expect(columnCount(), 3);

    await tester.tap(find.byKey(const ValueKey<String>('avatar_next_button')));
    await tester.pump();
    expect(columnCount(), 4);

    await tester.tap(find.byKey(const ValueKey<String>('avatar_next_button')));
    await tester.pump();
    expect(columnCount(), 5);

    await tester.tap(find.byKey(const ValueKey<String>('avatar_next_button')));
    await tester.pump();
    expect(columnCount(), 5);
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

  testWidgets('shows the third boy hairstyle as a mirrored thumbnail',
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

    expect(find.text('Hairstyle'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('avatar_option_treatment_boy_hair_03')),
      findsOneWidget,
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

        for (final String id
            in AvatarConfiguration.optionsFor(presentation, category)) {
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
