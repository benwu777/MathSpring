import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/data/local/app_services.dart';
import 'package:mathspring/main.dart';
import 'package:mathspring/models/favorite_question.dart';
import 'package:mathspring/models/question.dart';
import 'package:mathspring/ui/favorite_collection_palette.dart';

void main() {
  const String learnerId = 'learner_allen';

  AppServices createServices() => AppServices()..currentLearnerId = learnerId;

  Future<void> pumpFavorites(WidgetTester tester, AppServices services) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'TW'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const <LocalizationsDelegate<Object>>[
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: FavoritesPage(
          services: services,
          initialQuestionsById: const <String, Question>{},
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<List<FavoriteQuestionCollection>> customCollections(
          AppServices services) async =>
      (await services.getFavoriteCollections(learnerId))
          .where((FavoriteQuestionCollection c) => !c.isDefault)
          .toList();

  Future<void> openManageSheet(WidgetTester tester) async {
    await tester
        .tap(find.byKey(const ValueKey<String>('manage_favorite_collections')));
    await tester.pumpAndSettle();
  }

  group('manage collections', () {
    testWidgets('a new collection is created with the chosen color',
        (WidgetTester tester) async {
      final AppServices services = createServices();
      await pumpFavorites(tester, services);

      await openManageSheet(tester);
      await tester
          .tap(find.byKey(const ValueKey<String>('add_favorite_collection')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const ValueKey<String>('favorite_collection_name')), '易錯');
      await tester
          .tap(find.byKey(const ValueKey<String>('collection_color_rose')));
      await tester.pump();
      await tester.tap(find.text('儲存'));
      await tester.pumpAndSettle();

      final List<FavoriteQuestionCollection> collections =
          await customCollections(services);
      expect(collections.single.name, '易錯');
      expect(collections.single.colorKey, 'rose');
      expect(find.text('易錯'), findsOneWidget);
    });

    testWidgets('the add dialog preselects the next unused color',
        (WidgetTester tester) async {
      final AppServices services = createServices();
      await services.createFavoriteCollection(learnerId: learnerId, name: '複習');
      await pumpFavorites(tester, services);

      await openManageSheet(tester);
      await tester
          .tap(find.byKey(const ValueKey<String>('add_favorite_collection')));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(ValueKey<String>(
              'collection_color_${FavoriteCollectionColors.keys[1]}')),
          matching: find.byIcon(Icons.check_rounded),
        ),
        findsOneWidget,
      );
    });

    testWidgets('a blank name shows an error and keeps the dialog open',
        (WidgetTester tester) async {
      final AppServices services = createServices();
      await pumpFavorites(tester, services);

      await openManageSheet(tester);
      await tester
          .tap(find.byKey(const ValueKey<String>('add_favorite_collection')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('儲存'));
      await tester.pumpAndSettle();

      expect(find.text('請輸入分類名稱'), findsOneWidget);
      expect(await customCollections(services), isEmpty);
    });

    testWidgets('a collection can be renamed and recolored',
        (WidgetTester tester) async {
      final AppServices services = createServices();
      final FavoriteQuestionCollection collection = (await services
          .createFavoriteCollection(learnerId: learnerId, name: '易錯'))!;
      await pumpFavorites(tester, services);

      await openManageSheet(tester);
      await tester.tap(find.byKey(
          ValueKey<String>('edit_favorite_collection_${collection.id}')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const ValueKey<String>('favorite_collection_name')),
          '容易粗心');
      await tester
          .tap(find.byKey(const ValueKey<String>('collection_color_sky')));
      await tester.pump();
      await tester.tap(find.text('儲存'));
      await tester.pumpAndSettle();

      final FavoriteQuestionCollection updated =
          (await customCollections(services)).single;
      expect(updated.name, '容易粗心');
      expect(updated.colorKey, 'sky');
      expect(find.text('容易粗心'), findsOneWidget);
    });

    testWidgets('deleting the viewed collection returns to all favorites',
        (WidgetTester tester) async {
      final AppServices services = createServices();
      final FavoriteQuestionCollection collection = (await services
          .createFavoriteCollection(learnerId: learnerId, name: '易錯'))!;
      await services.toggleFavoriteQuestion(
          learnerId: learnerId, questionId: 'q1');
      await services.setFavoriteQuestionCollections(
          learnerId: learnerId,
          questionId: 'q1',
          collectionIds: [collection.id]);
      await pumpFavorites(tester, services);
      await tester.tap(
          find.byKey(const ValueKey<String>('favorite_collection_picker')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('易錯').last);
      await tester.pumpAndSettle();

      await openManageSheet(tester);
      await tester.tap(find.byKey(
          ValueKey<String>('delete_favorite_collection_${collection.id}')));
      await tester.pumpAndSettle();
      expect(find.textContaining('題目仍會保留在全部收藏'), findsOneWidget);
      await tester.tap(find.text('刪除'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      expect(await customCollections(services), isEmpty);
      expect(await services.getFavoriteQuestions(learnerId), hasLength(1));
      expect(find.text('全部收藏'), findsOneWidget);
      expect(find.text('q1'), findsOneWidget);
    });

    testWidgets('adding is disabled once five custom collections exist',
        (WidgetTester tester) async {
      final AppServices services = createServices();
      for (int index = 0; index < 5; index += 1) {
        await services.createFavoriteCollection(
            learnerId: learnerId, name: '分類$index');
      }
      await pumpFavorites(tester, services);

      await openManageSheet(tester);

      final ButtonStyleButton addButton = tester.widget<ButtonStyleButton>(
          find.byKey(const ValueKey<String>('add_favorite_collection')));
      expect(addButton.onPressed, isNull);
      expect(find.text('最多 5 個自訂分類'), findsOneWidget);
    });
  });

  group('favorite card', () {
    testWidgets('shows custom collection chips in their palette color',
        (WidgetTester tester) async {
      final AppServices services = createServices();
      final FavoriteQuestionCollection collection =
          (await services.createFavoriteCollection(
              learnerId: learnerId, name: '易錯', colorKey: 'rose'))!;
      await services.toggleFavoriteQuestion(
          learnerId: learnerId, questionId: 'q1');
      await services.setFavoriteQuestionCollections(
          learnerId: learnerId,
          questionId: 'q1',
          collectionIds: [collection.id]);
      await pumpFavorites(tester, services);

      final Container chip = tester.widget<Container>(find.byKey(
          ValueKey<String>('favorite_collection_chip_q1_${collection.id}')));
      expect((chip.decoration! as BoxDecoration).color,
          FavoriteCollectionPalette.of('rose').soft);
    });

    testWidgets('shows both tags and note', (WidgetTester tester) async {
      final AppServices services = createServices();
      await services.toggleFavoriteQuestion(
          learnerId: learnerId, questionId: 'q1');
      await services.updateFavoriteDetails(
          learnerId: learnerId,
          questionId: 'q1',
          note: '問老師',
          tags: const <String>['幾何']);
      await pumpFavorites(tester, services);

      expect(find.text('幾何'), findsOneWidget);
      expect(find.text('問老師'), findsOneWidget);
    });
  });

  group('edit tags and note', () {
    Future<void> openEditor(WidgetTester tester, String questionId) async {
      await tester
          .tap(find.byKey(ValueKey<String>('favorite_actions_$questionId')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('編輯標籤與筆記'));
      await tester.pumpAndSettle();
    }

    Future<AppServices> servicesWithTwoFavorites() async {
      final AppServices services = createServices();
      await services.toggleFavoriteQuestion(
          learnerId: learnerId, questionId: 'q1');
      await services.toggleFavoriteQuestion(
          learnerId: learnerId, questionId: 'q2');
      await services.updateFavoriteDetails(
          learnerId: learnerId,
          questionId: 'q2',
          note: '',
          tags: const <String>['幾何', '易錯']);
      return services;
    }

    testWidgets('saves typed tags, picked used tags and a note',
        (WidgetTester tester) async {
      final AppServices services = await servicesWithTwoFavorites();
      await pumpFavorites(tester, services);

      await openEditor(tester, 'q1');
      await tester.enterText(
          find.byKey(const ValueKey<String>('favorite_note_field')), '問老師');
      await tester.enterText(
          find.byKey(const ValueKey<String>('favorite_tag_field')), '考前');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const ValueKey<String>('used_favorite_tag_幾何')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('儲存'));
      await tester.pumpAndSettle();

      final FavoriteQuestion saved =
          (await services.getFavoriteQuestions(learnerId))
              .singleWhere((FavoriteQuestion f) => f.questionId == 'q1');
      expect(saved.note, '問老師');
      expect(saved.tags, <String>['考前', '幾何']);
      expect(find.text('問老師'), findsOneWidget);
    });

    testWidgets('a tag can be removed before saving',
        (WidgetTester tester) async {
      final AppServices services = await servicesWithTwoFavorites();
      await pumpFavorites(tester, services);

      await openEditor(tester, 'q2');
      await tester
          .tap(find.byKey(const ValueKey<String>('remove_favorite_tag_幾何')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('儲存'));
      await tester.pumpAndSettle();

      final FavoriteQuestion saved =
          (await services.getFavoriteQuestions(learnerId))
              .singleWhere((FavoriteQuestion f) => f.questionId == 'q2');
      expect(saved.tags, <String>['易錯']);
    });

    testWidgets('used tags exclude tags already on the question',
        (WidgetTester tester) async {
      final AppServices services = await servicesWithTwoFavorites();
      await pumpFavorites(tester, services);

      await openEditor(tester, 'q2');

      expect(find.byKey(const ValueKey<String>('used_favorite_tag_幾何')),
          findsNothing);
    });

    testWidgets('cancel leaves the favorite unchanged',
        (WidgetTester tester) async {
      final AppServices services = await servicesWithTwoFavorites();
      await pumpFavorites(tester, services);

      await openEditor(tester, 'q1');
      await tester.enterText(
          find.byKey(const ValueKey<String>('favorite_note_field')), '不要存');
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();

      final FavoriteQuestion saved =
          (await services.getFavoriteQuestions(learnerId))
              .singleWhere((FavoriteQuestion f) => f.questionId == 'q1');
      expect(saved.note, isEmpty);
      expect(find.text('不要存'), findsNothing);
    });
  });
}
