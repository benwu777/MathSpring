import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/data/local/app_services.dart';
import 'package:mathspring/data/local/favorite_question_repository.dart';
import 'package:mathspring/data/local/mathspring_database.dart';
import 'package:mathspring/models/favorite_question.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  const String learnerId = 'learner_allen';
  late Database database;
  late FavoriteQuestionRepository repository;
  late AppServices services;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    database = await MathSpringDatabase.openInMemory();
    repository = FavoriteQuestionRepository(database);
    services = AppServices(
      database: database,
      favoriteQuestionRepository: repository,
    );
  });

  tearDown(() async {
    await database.close();
  });

  Future<void> favorite(String questionId, {String learner = learnerId}) =>
      services.toggleFavoriteQuestion(
          learnerId: learner, questionId: questionId);

  group('collection colors', () {
    test('the all-favorites collection has no color', () async {
      final List<FavoriteQuestionCollection> collections =
          await services.getFavoriteCollections(learnerId);

      expect(collections.single.isDefault, isTrue);
      expect(collections.single.colorKey, isNull);
    });

    test('new collections take the first unused palette color', () async {
      final FavoriteQuestionCollection first = (await services
          .createFavoriteCollection(learnerId: learnerId, name: '易錯'))!;
      final FavoriteQuestionCollection second = (await services
          .createFavoriteCollection(learnerId: learnerId, name: '考前複習'))!;

      expect(first.colorKey, FavoriteCollectionColors.keys[0]);
      expect(second.colorKey, FavoriteCollectionColors.keys[1]);
    });

    test('a freed palette color is reused before later ones', () async {
      final FavoriteQuestionCollection first = (await services
          .createFavoriteCollection(learnerId: learnerId, name: 'A'))!;
      await services.createFavoriteCollection(learnerId: learnerId, name: 'B');
      await services.deleteFavoriteCollection(first);

      final FavoriteQuestionCollection third = (await services
          .createFavoriteCollection(learnerId: learnerId, name: 'C'))!;

      expect(third.colorKey, FavoriteCollectionColors.keys[0]);
    });

    test('a collection can be created with a chosen color', () async {
      final FavoriteQuestionCollection collection =
          (await services.createFavoriteCollection(
        learnerId: learnerId,
        name: '易錯',
        colorKey: 'rose',
      ))!;

      expect(collection.colorKey, 'rose');
      expect(
        (await services.getFavoriteCollections(learnerId))
            .singleWhere((FavoriteQuestionCollection c) => !c.isDefault)
            .colorKey,
        'rose',
      );
    });

    test('the palette has eight distinct colors', () {
      expect(FavoriteCollectionColors.keys, hasLength(8));
      expect(FavoriteCollectionColors.keys.toSet(), hasLength(8));
    });
  });

  group('collection editing', () {
    test('a collection can be renamed and recolored', () async {
      final FavoriteQuestionCollection collection = (await services
          .createFavoriteCollection(learnerId: learnerId, name: '易錯'))!;

      await services.updateFavoriteCollection(
        collection: collection,
        name: '  容易粗心  ',
        colorKey: 'sky',
      );

      final FavoriteQuestionCollection updated =
          (await services.getFavoriteCollections(learnerId))
              .singleWhere((FavoriteQuestionCollection c) => !c.isDefault);
      expect(updated.name, '容易粗心');
      expect(updated.colorKey, 'sky');
    });

    test('blank names are rejected', () async {
      await expectLater(
        services.createFavoriteCollection(learnerId: learnerId, name: '   '),
        throwsA(isA<FavoriteCollectionNameInvalid>().having(
            (FavoriteCollectionNameInvalid e) => e.reason,
            'reason',
            FavoriteCollectionNameProblem.empty)),
      );
    });

    test('names longer than 20 characters are rejected', () async {
      await expectLater(
        services.createFavoriteCollection(
            learnerId: learnerId, name: '一二三四五六七八九十一二三四五六七八九十一'),
        throwsA(isA<FavoriteCollectionNameInvalid>().having(
            (FavoriteCollectionNameInvalid e) => e.reason,
            'reason',
            FavoriteCollectionNameProblem.tooLong)),
      );
    });

    test('duplicate names within a learner are rejected', () async {
      final FavoriteQuestionCollection review = (await services
          .createFavoriteCollection(learnerId: learnerId, name: '複習'))!;
      final FavoriteQuestionCollection other = (await services
          .createFavoriteCollection(learnerId: learnerId, name: '易錯'))!;

      await expectLater(
        services.createFavoriteCollection(learnerId: learnerId, name: ' 複習 '),
        throwsA(isA<FavoriteCollectionNameInvalid>().having(
            (FavoriteCollectionNameInvalid e) => e.reason,
            'reason',
            FavoriteCollectionNameProblem.duplicate)),
      );
      await expectLater(
        services.updateFavoriteCollection(
            collection: other, name: '複習', colorKey: other.colorKey!),
        throwsA(isA<FavoriteCollectionNameInvalid>()),
      );
      // Keeping a collection's own name is not a duplicate.
      await services.updateFavoriteCollection(
          collection: review, name: '複習', colorKey: 'sand');
    });

    test('the same name is allowed for another learner', () async {
      await services.createFavoriteCollection(learnerId: learnerId, name: '複習');

      expect(
        await services.createFavoriteCollection(
            learnerId: 'learner_bella', name: '複習'),
        isNotNull,
      );
    });

    test('a sixth custom collection is rejected', () async {
      for (int index = 0; index < 5; index += 1) {
        await services.createFavoriteCollection(
            learnerId: learnerId, name: '分類$index');
      }

      await expectLater(
        services.createFavoriteCollection(learnerId: learnerId, name: '分類5'),
        throwsA(isA<FavoriteCollectionLimitReached>()),
      );
      expect(FavoriteQuestionRepository.maxCustomCollections, 5);
    });

    test('deleting a collection keeps its questions favorited', () async {
      await favorite('number_grade3_foundation_001');
      final FavoriteQuestionCollection review = (await services
          .createFavoriteCollection(learnerId: learnerId, name: '複習'))!;
      await services.setFavoriteQuestionCollections(
        learnerId: learnerId,
        questionId: 'number_grade3_foundation_001',
        collectionIds: <String>[review.id],
      );

      await services.deleteFavoriteCollection(review);

      expect(await services.getFavoriteQuestions(learnerId), hasLength(1));
      expect(
        await services.getFavoriteQuestionCollectionIds(
            learnerId: learnerId, questionId: 'number_grade3_foundation_001'),
        isEmpty,
      );
      expect(await services.getFavoriteCollections(learnerId), hasLength(1));
    });

    test('collection question counts include all favorites', () async {
      await favorite('q1');
      await favorite('q2');
      final FavoriteQuestionCollection review = (await services
          .createFavoriteCollection(learnerId: learnerId, name: '複習'))!;
      await services.setFavoriteQuestionCollections(
          learnerId: learnerId, questionId: 'q1', collectionIds: [review.id]);

      final Map<String, int> counts =
          await services.getFavoriteCollectionCounts(learnerId);

      expect(counts['favorites_all_$learnerId'], 2);
      expect(counts[review.id], 1);
    });
  });

  group('tags and notes', () {
    test('tags are trimmed, deduplicated and capped', () {
      expect(
        normalizeFavoriteTags(<String>[
          ' 易錯 ',
          '',
          '易錯',
          '一二三四五六七八九十一二三',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
        ]),
        <String>['易錯', '一二三四五六七八九十一二', '1', '2', '3', '4', '5', '6'],
      );
    });

    test('notes are trimmed and capped at 200 characters', () {
      expect(normalizeFavoriteNote('  好題  '), '好題');
      expect(normalizeFavoriteNote('字' * 250), '字' * 200);
    });

    test('saving details stores normalized tags and note', () async {
      await favorite('q1');

      await services.updateFavoriteDetails(
        learnerId: learnerId,
        questionId: 'q1',
        note: '  問老師  ',
        tags: const <String>[' 易錯 ', '易錯', '幾何'],
      );

      final FavoriteQuestion saved =
          (await services.getFavoriteQuestions(learnerId)).single;
      expect(saved.note, '問老師');
      expect(saved.tags, <String>['易錯', '幾何']);
    });

    test('used tags are ordered by frequency and isolated per learner',
        () async {
      for (final String id in <String>['q1', 'q2', 'q3']) {
        await favorite(id);
      }
      await favorite('q9', learner: 'learner_bella');
      await services.updateFavoriteDetails(
          learnerId: learnerId, questionId: 'q1', note: '', tags: ['幾何']);
      await services.updateFavoriteDetails(
          learnerId: learnerId, questionId: 'q2', note: '', tags: ['易錯', '幾何']);
      await services.updateFavoriteDetails(
          learnerId: learnerId, questionId: 'q3', note: '', tags: ['易錯', '計算']);
      await services.updateFavoriteDetails(
          learnerId: 'learner_bella',
          questionId: 'q9',
          note: '',
          tags: ['別人的']);

      expect(await services.getUsedFavoriteTags(learnerId),
          <String>['易錯', '幾何', '計算']);
    });
  });

  test('upgrading from version 7 gives existing custom collections colors',
      () async {
    final Directory directory =
        await Directory.systemTemp.createTemp('mathspring_v7_');
    final String path = p.join(directory.path, 'mathspring.db');
    try {
      final Database legacy = await openDatabase(path, version: 7,
          onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE favorite_question_collections(
          id TEXT PRIMARY KEY, learner_id TEXT NOT NULL, name TEXT NOT NULL,
          sort_order INTEGER NOT NULL, is_default INTEGER NOT NULL,
          created_at TEXT NOT NULL)''');
        for (final List<Object> row in <List<Object>>[
          <Object>['favorites_all_$learnerId', 'All favorites', 0, 1],
          <Object>['c1', '討論', 1, 0],
          <Object>['c2', '複習', 2, 0],
        ]) {
          await db.insert('favorite_question_collections', <String, Object?>{
            'id': row[0],
            'learner_id': learnerId,
            'name': row[1],
            'sort_order': row[2],
            'is_default': row[3],
            'created_at': '2026-09-15T00:00:00Z',
          });
        }
      });
      await legacy.close();

      final Database upgraded = await MathSpringDatabase.openAtPath(path);
      final List<FavoriteQuestionCollection> collections =
          await FavoriteQuestionRepository(upgraded)
              .fetchCollections(learnerId);
      await upgraded.close();

      expect(collections.map((FavoriteQuestionCollection c) => c.name),
          <String>['All favorites', '討論', '複習']);
      expect(
          collections.map((FavoriteQuestionCollection c) => c.colorKey),
          <String?>[
            null,
            FavoriteCollectionColors.keys[0],
            FavoriteCollectionColors.keys[1],
          ]);
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
