import 'package:mathspring/data/local/app_preferences_repository.dart';
import 'package:mathspring/data/local/favorite_question_repository.dart';
import 'package:mathspring/data/local/answer_session_repository.dart';
import 'package:mathspring/data/local/learner_profile_repository.dart';
import 'package:mathspring/data/local/mathspring_database.dart';
import 'package:mathspring/data/local/question_progress_repository.dart';
import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/avatar_configuration.dart';
import 'package:mathspring/models/favorite_question.dart';
import 'package:mathspring/models/learner_profile.dart';
import 'package:mathspring/models/question_progress.dart';
import 'package:mathspring/models/session_answer_record.dart';
import 'package:mathspring/services/learning_activity_summary.dart';
import 'package:mathspring/services/daily_mission.dart';
import 'package:mathspring/services/free_solution_allowance.dart';
import 'package:sqflite/sqflite.dart';

class AppServices {
  AppServices({
    this.database,
    this.learnerProfileRepository,
    this.questionProgressRepository,
    this.appPreferencesRepository,
    this.answerSessionRepository,
    this.favoriteQuestionRepository,
    this.onSaveQuestionProgress,
    this.onSaveAnswerSession,
    List<LearnerProfile>? learnerProfiles,
    List<QuestionProgress>? initialProgress,
    List<AnswerSession>? initialSessions,
    Map<String, List<SessionAnswerRecord>>? initialSessionRecords,
  })  : learnerProfiles = <LearnerProfile>[],
        _progressRecords =
            List<QuestionProgress>.from(initialProgress ?? const []),
        _answerSessions = List<AnswerSession>.from(initialSessions ?? const []),
        _sessionRecords = Map<String, List<SessionAnswerRecord>>.from(
          initialSessionRecords ?? const {},
        );

  final Database? database;
  final LearnerProfileRepository? learnerProfileRepository;
  final QuestionProgressRepository? questionProgressRepository;
  final AppPreferencesRepository? appPreferencesRepository;
  final AnswerSessionRepository? answerSessionRepository;
  final FavoriteQuestionRepository? favoriteQuestionRepository;
  final Future<void> Function(QuestionProgress progress)?
      onSaveQuestionProgress;
  final Future<void> Function(
    AnswerSession session,
    List<SessionAnswerRecord> records,
  )? onSaveAnswerSession;
  final List<LearnerProfile> learnerProfiles;
  final List<QuestionProgress> _progressRecords;
  final List<AnswerSession> _answerSessions;
  final Map<String, List<SessionAnswerRecord>> _sessionRecords;
  final List<FavoriteQuestion> _inMemoryFavorites = <FavoriteQuestion>[];
  final List<FavoriteQuestionCollection> _inMemoryFavoriteCollections =
      <FavoriteQuestionCollection>[];
  final Map<String, Set<String>> _inMemoryFavoriteCollectionMemberships =
      <String, Set<String>>{};
  String? currentLearnerId;
  String? _inMemoryFreeSolutions;

  static const String _freeSolutionsKey = 'free_solution_unlocks';

  factory AppServices.forTesting({
    required List<LearnerProfile> learnerProfiles,
    required String currentLearnerId,
    Future<void> Function(QuestionProgress progress)? onSaveQuestionProgress,
    Future<void> Function(
      AnswerSession session,
      List<SessionAnswerRecord> records,
    )? onSaveAnswerSession,
    List<QuestionProgress>? initialProgress,
    List<AnswerSession>? initialSessions,
    Map<String, List<SessionAnswerRecord>>? initialSessionRecords,
  }) {
    final AppServices services = AppServices(
      learnerProfiles: learnerProfiles,
      onSaveQuestionProgress: onSaveQuestionProgress,
      onSaveAnswerSession: onSaveAnswerSession,
      initialProgress: initialProgress,
      initialSessions: initialSessions,
      initialSessionRecords: initialSessionRecords,
    );
    services.learnerProfiles
      ..clear()
      ..addAll(learnerProfiles);
    services.currentLearnerId = currentLearnerId;
    return services;
  }

  static Future<AppServices> openDefault() async {
    final Database database = await MathSpringDatabase.openDefault();
    final AppServices services = AppServices(
      database: database,
      learnerProfileRepository: LearnerProfileRepository(database),
      questionProgressRepository: QuestionProgressRepository(database),
      appPreferencesRepository: AppPreferencesRepository(database),
      answerSessionRepository: AnswerSessionRepository(database),
      favoriteQuestionRepository: FavoriteQuestionRepository(database),
    );
    await services.seedDefaultDataIfNeeded();
    return services;
  }

  Future<void> seedDefaultDataIfNeeded() async {
    final LearnerProfileRepository learnerRepository =
        learnerProfileRepository!;
    final AppPreferencesRepository preferencesRepository =
        appPreferencesRepository!;
    final List<LearnerProfile> existingProfiles =
        await learnerRepository.fetchAll();
    if (existingProfiles.isEmpty) {
      await learnerRepository.save(
        const LearnerProfile(
          id: 'learner_allen',
          displayName: 'Allen',
          levelStage: 'grade4',
          minLevelStage: 'grade3',
          maxLevelStage: 'grade4',
          challengeTier: 'advanced',
          createdAtIso: '2026-07-16T00:00:00Z',
        ),
      );
      await learnerRepository.save(
        const LearnerProfile(
          id: 'learner_mia',
          displayName: 'Mia',
          levelStage: 'grade2',
          minLevelStage: 'grade1',
          maxLevelStage: 'grade2',
          challengeTier: 'foundation',
          createdAtIso: '2026-07-16T00:01:00Z',
        ),
      );
    }

    final String? currentLearnerId =
        await preferencesRepository.getValue('current_learner_id');
    if (currentLearnerId == null) {
      await preferencesRepository.setValue(
        'current_learner_id',
        'learner_allen',
      );
    }

    learnerProfiles
      ..clear()
      ..addAll(await learnerRepository.fetchAll());
    this.currentLearnerId =
        await preferencesRepository.getValue('current_learner_id');
  }

  Future<void> saveQuestionProgress(QuestionProgress progress) async {
    _upsertProgressRecord(progress);

    if (onSaveQuestionProgress != null) {
      await onSaveQuestionProgress!(progress);
      return;
    }

    if (questionProgressRepository == null) {
      return;
    }
    await questionProgressRepository!.upsert(progress);
  }

  Future<bool> toggleFavoriteQuestion({
    required String learnerId,
    required String questionId,
  }) async {
    final FavoriteQuestionRepository? repository = favoriteQuestionRepository;
    if (repository == null) {
      final int existingIndex = _inMemoryFavorites.indexWhere(
          (FavoriteQuestion item) =>
              item.learnerId == learnerId && item.questionId == questionId);
      if (existingIndex >= 0) {
        _inMemoryFavorites.removeAt(existingIndex);
        for (final Set<String> questionIds
            in _inMemoryFavoriteCollectionMemberships.values) {
          questionIds.remove(questionId);
        }
        return false;
      }
      final String now = DateTime.now().toUtc().toIso8601String();
      _inMemoryFavorites.add(FavoriteQuestion(
        learnerId: learnerId,
        questionId: questionId,
        note: '',
        tags: const <String>[],
        createdAtIso: now,
        updatedAtIso: now,
      ));
      return true;
    }
    final FavoriteQuestion? existing = await repository.fetchFavorite(
      learnerId: learnerId,
      questionId: questionId,
    );
    if (existing != null) {
      await repository.deleteFavorite(
        learnerId: learnerId,
        questionId: questionId,
      );
      return false;
    }
    final String now = DateTime.now().toUtc().toIso8601String();
    await repository.saveFavorite(FavoriteQuestion(
      learnerId: learnerId,
      questionId: questionId,
      note: '',
      tags: const <String>[],
      createdAtIso: now,
      updatedAtIso: now,
    ));
    return true;
  }

  Future<bool> isFavoriteQuestion({
    required String learnerId,
    required String questionId,
  }) async {
    final FavoriteQuestionRepository? repository = favoriteQuestionRepository;
    if (repository == null) {
      return _inMemoryFavorites.any((FavoriteQuestion item) =>
          item.learnerId == learnerId && item.questionId == questionId);
    }
    return (await repository.fetchFavorite(
          learnerId: learnerId,
          questionId: questionId,
        )) !=
        null;
  }

  Future<List<FavoriteQuestionCollection>> getFavoriteCollections(
      String learnerId) async {
    final FavoriteQuestionRepository? repository = favoriteQuestionRepository;
    if (repository == null) {
      if (_inMemoryFavoriteCollections
          .where(
              (FavoriteQuestionCollection item) => item.learnerId == learnerId)
          .isEmpty) {
        _inMemoryFavoriteCollections.add(FavoriteQuestionCollection(
          id: 'favorites_all_$learnerId',
          learnerId: learnerId,
          name: 'All favorites',
          sortOrder: 0,
          isDefault: true,
          createdAtIso: DateTime.now().toUtc().toIso8601String(),
        ));
      }
      return _inMemoryFavoriteCollections
          .where(
              (FavoriteQuestionCollection item) => item.learnerId == learnerId)
          .toList();
    }
    return repository.ensureDefaultCollections(learnerId);
  }

  Future<List<FavoriteQuestion>> getFavoriteQuestions(String learnerId) async {
    final FavoriteQuestionRepository? repository = favoriteQuestionRepository;
    if (repository == null) {
      return _inMemoryFavorites
          .where((FavoriteQuestion item) => item.learnerId == learnerId)
          .toList();
    }
    return repository.fetchFavorites(learnerId);
  }

  Future<List<FavoriteQuestion>> getFavoriteQuestionsInCollection({
    required String learnerId,
    required String collectionId,
  }) async {
    final FavoriteQuestionRepository? repository = favoriteQuestionRepository;
    if (collectionId == 'favorites_all_$learnerId') {
      return getFavoriteQuestions(learnerId);
    }
    if (repository == null) {
      final Set<String> questionIds =
          _inMemoryFavoriteCollectionMemberships[collectionId] ??
              const <String>{};
      return (await getFavoriteQuestions(learnerId))
          .where((FavoriteQuestion favorite) =>
              questionIds.contains(favorite.questionId))
          .toList();
    }
    return repository.fetchFavoritesInCollection(
      learnerId: learnerId,
      collectionId: collectionId,
    );
  }

  Future<Set<String>> getFavoriteQuestionCollectionIds({
    required String learnerId,
    required String questionId,
  }) async {
    final FavoriteQuestionRepository? repository = favoriteQuestionRepository;
    if (repository != null) {
      return repository.fetchCollectionIdsForFavorite(
        learnerId: learnerId,
        questionId: questionId,
      );
    }
    return Set<String>.from(
      _inMemoryFavoriteCollectionMemberships.entries
          .where((MapEntry<String, Set<String>> entry) =>
              entry.value.contains(questionId))
          .map((MapEntry<String, Set<String>> entry) => entry.key),
    );
  }

  Future<void> setFavoriteQuestionCollections({
    required String learnerId,
    required String questionId,
    required Iterable<String> collectionIds,
  }) async {
    final String allFavoritesId = 'favorites_all_$learnerId';
    final Set<String> selectedIds =
        collectionIds.where((String id) => id != allFavoritesId).toSet();
    final Set<String> existingIds = await getFavoriteQuestionCollectionIds(
      learnerId: learnerId,
      questionId: questionId,
    );
    final FavoriteQuestionRepository? repository = favoriteQuestionRepository;
    for (final String collectionId in existingIds.difference(selectedIds)) {
      if (repository != null) {
        await repository.removeFromCollection(
          learnerId: learnerId,
          questionId: questionId,
          collectionId: collectionId,
        );
      } else {
        _inMemoryFavoriteCollectionMemberships[collectionId]
            ?.remove(questionId);
      }
    }
    for (final String collectionId in selectedIds.difference(existingIds)) {
      if (repository != null) {
        await repository.addToCollection(
          learnerId: learnerId,
          questionId: questionId,
          collectionId: collectionId,
        );
      } else {
        _inMemoryFavoriteCollectionMemberships
            .putIfAbsent(collectionId, () => <String>{})
            .add(questionId);
      }
    }
  }

  Future<FavoriteQuestionCollection?> createFavoriteCollection({
    required String learnerId,
    required String name,
  }) async {
    if (name.trim().isEmpty) return null;
    final FavoriteQuestionRepository? repository = favoriteQuestionRepository;
    if (repository != null) {
      return repository.createCollection(learnerId: learnerId, name: name);
    }
    final List<FavoriteQuestionCollection> collections =
        await getFavoriteCollections(learnerId);
    if (collections.length >= FavoriteQuestionRepository.maxCollections) {
      throw FavoriteCollectionLimitReached(
          FavoriteQuestionRepository.maxCollections);
    }
    final FavoriteQuestionCollection collection = FavoriteQuestionCollection(
      id: 'favorite_collection_${DateTime.now().toUtc().microsecondsSinceEpoch}',
      learnerId: learnerId,
      name: name.trim(),
      sortOrder: collections.length,
      isDefault: false,
      createdAtIso: DateTime.now().toUtc().toIso8601String(),
    );
    _inMemoryFavoriteCollections.add(collection);
    return collection;
  }

  Future<FreeSolutionAllowance> getFreeSolutionAllowance(
      {DateTime? now}) async {
    final String? raw = appPreferencesRepository == null
        ? _inMemoryFreeSolutions
        : await appPreferencesRepository!.getValue(_freeSolutionsKey);
    return FreeSolutionAllowance.decode(raw, now: now ?? DateTime.now());
  }

  /// 用掉一次今天的免費詳解；額度用完時回傳 false，不寫入。
  Future<bool> unlockFreeSolution(String questionId, {DateTime? now}) async {
    final FreeSolutionAllowance? next =
        (await getFreeSolutionAllowance(now: now)).unlock(questionId);
    if (next == null) {
      return false;
    }
    if (appPreferencesRepository == null) {
      _inMemoryFreeSolutions = next.encode();
    } else {
      await appPreferencesRepository!
          .setValue(_freeSolutionsKey, next.encode());
    }
    return true;
  }

  Future<void> setCurrentLearner(String learnerId) async {
    currentLearnerId = learnerId;
    if (appPreferencesRepository != null) {
      await appPreferencesRepository!.setValue('current_learner_id', learnerId);
    }
  }

  Future<void> saveAnswerSession({
    required AnswerSession session,
    required List<SessionAnswerRecord> records,
  }) async {
    _upsertAnswerSession(session, records);

    if (onSaveAnswerSession != null) {
      await onSaveAnswerSession!(session, records);
      return;
    }

    if (answerSessionRepository == null) {
      return;
    }
    await answerSessionRepository!.saveSession(
      session: session,
      records: records,
    );
  }

  Future<LearnerProfile> createLearner({
    required String displayName,
    required String minLevelStage,
    required String maxLevelStage,
    required String challengeTier,
    AvatarConfiguration? avatar,
    int maxLearnerProfiles = 1,
  }) async {
    if (learnerProfiles.length >= maxLearnerProfiles) {
      throw LearnerProfileLimitReached(maxLearnerProfiles);
    }
    final LearnerProfile profile = LearnerProfile(
      id: 'learner_${DateTime.now().toUtc().microsecondsSinceEpoch}',
      displayName: displayName,
      levelStage: maxLevelStage,
      minLevelStage: minLevelStage,
      maxLevelStage: maxLevelStage,
      challengeTier: challengeTier,
      createdAtIso: DateTime.now().toUtc().toIso8601String(),
      avatar: avatar,
    );

    learnerProfiles.add(profile);
    if (learnerProfileRepository != null) {
      await learnerProfileRepository!.save(profile);
    }
    if (currentLearnerId == null) {
      await setCurrentLearner(profile.id);
    }
    return profile;
  }

  Future<void> updateLearner(LearnerProfile profile) async {
    final int index =
        learnerProfiles.indexWhere((item) => item.id == profile.id);
    if (index == -1) {
      return;
    }

    learnerProfiles[index] = profile;
    if (learnerProfileRepository != null) {
      await learnerProfileRepository!.save(profile);
    }
  }

  Future<void> deleteLearner(String learnerId) async {
    if (learnerProfiles.length <= 1) {
      return;
    }

    final int index = learnerProfiles.indexWhere(
      (profile) => profile.id == learnerId,
    );
    if (index == -1) {
      return;
    }

    learnerProfiles.removeAt(index);
    if (learnerProfileRepository != null) {
      await learnerProfileRepository!.deleteById(learnerId);
    }
    if (questionProgressRepository != null) {
      await questionProgressRepository!.deleteByLearnerId(learnerId);
    }
    if (answerSessionRepository != null) {
      await answerSessionRepository!.deleteAnswerRecordsByLearnerId(learnerId);
      await answerSessionRepository!.deleteSessionsByLearnerId(learnerId);
    }
    _progressRecords.removeWhere((progress) => progress.learnerId == learnerId);
    final List<String> sessionIds = _answerSessions
        .where((session) => session.learnerId == learnerId)
        .map((session) => session.id)
        .toList();
    _answerSessions.removeWhere((session) => session.learnerId == learnerId);
    for (final String sessionId in sessionIds) {
      _sessionRecords.remove(sessionId);
    }

    if (currentLearnerId == learnerId) {
      final int nextIndex = index == 0 ? 0 : index - 1;
      await setCurrentLearner(learnerProfiles[nextIndex].id);
    }
  }

  Future<LearnerProgressSummary> getLearnerProgressSummary(
    String learnerId,
  ) async {
    final List<QuestionProgress> progressRecords =
        await _getLearnerQuestionProgress(learnerId);
    final int solvedCount = progressRecords.length;
    final int correctCount = progressRecords
        .where((progress) => progress.status == 'correct')
        .length;
    return LearnerProgressSummary(
      solvedCount: solvedCount,
      correctCount: correctCount,
    );
  }

  Future<Set<String>> getLearnerAnsweredQuestionIds(String learnerId) async =>
      (await _getLearnerQuestionProgress(learnerId))
          .map((QuestionProgress progress) => progress.questionId)
          .toSet();

  /// 最近一次作答是答錯的題目（還沒訂正），最近答錯的排前面。
  Future<List<String>> getLearnerMistakeQuestionIds(String learnerId) async {
    final List<QuestionProgress> mistakes = (await _getLearnerQuestionProgress(
            learnerId))
        .where((QuestionProgress progress) => progress.status == 'incorrect')
        .toList()
      ..sort((QuestionProgress left, QuestionProgress right) =>
          right.updatedAtIso.compareTo(left.updatedAtIso));
    return mistakes
        .map((QuestionProgress progress) => progress.questionId)
        .toList(growable: false);
  }

  Future<List<AnswerSession>> getLearnerAnswerSessions(String learnerId) async {
    if (answerSessionRepository != null) {
      return answerSessionRepository!.fetchByLearnerId(learnerId);
    }

    final List<AnswerSession> sessions = _answerSessions
        .where((session) => session.learnerId == learnerId)
        .toList()
      ..sort((left, right) => right.endedAtIso.compareTo(left.endedAtIso));
    return sessions;
  }

  Future<List<SessionAnswerRecord>> getSessionAnswerRecords(
      String sessionId) async {
    if (answerSessionRepository != null) {
      return answerSessionRepository!.fetchAnswerRecords(sessionId);
    }
    return List<SessionAnswerRecord>.from(
        _sessionRecords[sessionId] ?? const []);
  }

  /// 學習者所有練習與測驗的逐題作答紀錄。
  Future<List<SessionAnswerRecord>> getLearnerAnswerRecords(
    String learnerId,
  ) async {
    final List<AnswerSession> sessions =
        await getLearnerAnswerSessions(learnerId);
    final List<List<SessionAnswerRecord>> records = await Future.wait(
      sessions.map(
        (AnswerSession session) => getSessionAnswerRecords(session.id),
      ),
    );
    return <SessionAnswerRecord>[
      for (final List<SessionAnswerRecord> sessionRecords in records)
        ...sessionRecords,
    ];
  }

  Future<LearningActivitySummary> getLearnerLearningActivitySummary(
    String learnerId,
  ) async {
    final List<AnswerSession> sessions =
        await getLearnerAnswerSessions(learnerId);
    final List<List<SessionAnswerRecord>> records = await Future.wait(
      sessions.map(
        (AnswerSession session) => getSessionAnswerRecords(session.id),
      ),
    );
    final Map<String, List<SessionAnswerRecord>> recordsBySessionId =
        <String, List<SessionAnswerRecord>>{};
    for (int index = 0; index < sessions.length; index += 1) {
      recordsBySessionId[sessions[index].id] = records[index];
    }
    return LearningActivitySummary.fromSessions(
      sessions: sessions,
      recordsBySessionId: recordsBySessionId,
    );
  }

  Future<DailyMissionProgress> getLearnerDailyMissionProgress(
    String learnerId, {
    DateTime? date,
  }) async {
    final List<AnswerSession> sessions =
        await getLearnerAnswerSessions(learnerId);
    final List<List<SessionAnswerRecord>> records = await Future.wait(
      sessions
          .map((AnswerSession session) => getSessionAnswerRecords(session.id)),
    );
    return DailyMission.calculate(
      learnerId: learnerId,
      date: date ?? DateTime.now(),
      sessions: sessions,
      recordsBySessionId: <String, List<SessionAnswerRecord>>{
        for (int index = 0; index < sessions.length; index += 1)
          sessions[index].id: records[index],
      },
    );
  }

  void _upsertProgressRecord(QuestionProgress progress) {
    final int existingIndex = _progressRecords.indexWhere(
      (item) =>
          item.learnerId == progress.learnerId &&
          item.questionId == progress.questionId,
    );
    if (existingIndex == -1) {
      _progressRecords.add(progress);
      return;
    }
    _progressRecords[existingIndex] = progress;
  }

  Future<List<QuestionProgress>> _getLearnerQuestionProgress(
    String learnerId,
  ) async =>
      questionProgressRepository != null
          ? questionProgressRepository!.fetchByLearnerId(learnerId)
          : _progressRecords
              .where((QuestionProgress progress) =>
                  progress.learnerId == learnerId)
              .toList();

  void _upsertAnswerSession(
    AnswerSession session,
    List<SessionAnswerRecord> records,
  ) {
    final int existingIndex = _answerSessions.indexWhere(
      (item) => item.id == session.id,
    );
    if (existingIndex == -1) {
      _answerSessions.add(session);
    } else {
      _answerSessions[existingIndex] = session;
    }
    _sessionRecords[session.id] = List<SessionAnswerRecord>.from(records);
  }
}

class LearnerProfileLimitReached implements Exception {
  const LearnerProfileLimitReached(this.maxLearnerProfiles);

  final int maxLearnerProfiles;

  @override
  String toString() =>
      'LearnerProfileLimitReached(maxLearnerProfiles: $maxLearnerProfiles)';
}

class LearnerProgressSummary {
  const LearnerProgressSummary({
    required this.solvedCount,
    required this.correctCount,
  });

  final int solvedCount;
  final int correctCount;

  double get accuracyRate {
    if (solvedCount == 0) {
      return 0;
    }
    return correctCount / solvedCount;
  }
}
