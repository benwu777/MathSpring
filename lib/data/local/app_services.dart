import 'package:mathspring/data/local/app_preferences_repository.dart';
import 'package:mathspring/data/local/answer_session_repository.dart';
import 'package:mathspring/data/local/learner_profile_repository.dart';
import 'package:mathspring/data/local/mathspring_database.dart';
import 'package:mathspring/data/local/question_progress_repository.dart';
import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/learner_profile.dart';
import 'package:mathspring/models/question_progress.dart';
import 'package:mathspring/models/session_answer_record.dart';
import 'package:mathspring/services/learning_activity_summary.dart';
import 'package:mathspring/services/daily_mission.dart';
import 'package:sqflite/sqflite.dart';

class AppServices {
  AppServices({
    this.database,
    this.learnerProfileRepository,
    this.questionProgressRepository,
    this.appPreferencesRepository,
    this.answerSessionRepository,
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
  String? currentLearnerId;

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
  }) async {
    final LearnerProfile profile = LearnerProfile(
      id: 'learner_${DateTime.now().toUtc().microsecondsSinceEpoch}',
      displayName: displayName,
      levelStage: maxLevelStage,
      minLevelStage: minLevelStage,
      maxLevelStage: maxLevelStage,
      challengeTier: challengeTier,
      createdAtIso: DateTime.now().toUtc().toIso8601String(),
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
        questionProgressRepository != null
            ? await questionProgressRepository!.fetchByLearnerId(learnerId)
            : _progressRecords
                .where((progress) => progress.learnerId == learnerId)
                .toList();
    final int solvedCount = progressRecords.length;
    final int correctCount = progressRecords
        .where((progress) => progress.status == 'correct')
        .length;
    return LearnerProgressSummary(
      solvedCount: solvedCount,
      correctCount: correctCount,
    );
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
      sessions.map((AnswerSession session) => getSessionAnswerRecords(session.id)),
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
