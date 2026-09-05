import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/data/local/app_services.dart';
import 'package:mathspring/data/local/app_preferences_repository.dart';
import 'package:mathspring/data/local/answer_session_repository.dart';
import 'package:mathspring/data/local/learner_profile_repository.dart';
import 'package:mathspring/data/local/mathspring_database.dart';
import 'package:mathspring/data/local/question_progress_repository.dart';
import 'package:mathspring/models/learner_profile.dart';
import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/avatar_configuration.dart';
import 'package:mathspring/models/question_progress.dart';
import 'package:mathspring/models/session_answer_record.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database database;
  late LearnerProfileRepository learnerProfileRepository;
  late QuestionProgressRepository questionProgressRepository;
  late AppPreferencesRepository appPreferencesRepository;
  late AnswerSessionRepository answerSessionRepository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    database = await MathSpringDatabase.openInMemory();
    learnerProfileRepository = LearnerProfileRepository(database);
    questionProgressRepository = QuestionProgressRepository(database);
    appPreferencesRepository = AppPreferencesRepository(database);
    answerSessionRepository = AnswerSessionRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('creates the expected local tables', () async {
    final List<Map<String, Object?>> tables = await database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table'",
    );
    final Set<String> tableNames =
        tables.map((row) => row['name']! as String).toSet();

    expect(tableNames, contains('learner_profiles'));
    expect(tableNames, contains('answer_sessions'));
    expect(tableNames, contains('session_answer_records'));
    expect(tableNames, contains('question_progress'));
    expect(tableNames, contains('app_preferences'));
  });

  test('stores and reads answer sessions with linked answer records', () async {
    const AnswerSession session = AnswerSession(
      id: 'session_quiz_001',
      learnerId: 'learner_allen',
      mode: 'quiz',
      topicCode: 'geometry',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      startedAtIso: '2026-07-17T09:00:00Z',
      endedAtIso: '2026-07-17T09:03:00Z',
      elapsedSeconds: 180,
      totalQuestions: 2,
      correctCount: 1,
      timeLimitSeconds: 600,
      maxScore: 100,
      earnedScore: 60,
    );
    const List<SessionAnswerRecord> records = [
      SessionAnswerRecord(
        sessionId: 'session_quiz_001',
        questionId: 'q1',
        sequence: 1,
        submittedAnswer: 'B',
        isCorrect: true,
        answeredAtIso: '2026-07-17T09:01:00Z',
        maxScore: 60,
        earnedScore: 60,
      ),
      SessionAnswerRecord(
        sessionId: 'session_quiz_001',
        questionId: 'q2',
        sequence: 2,
        submittedAnswer: '',
        isCorrect: false,
        answeredAtIso: '2026-07-17T09:03:00Z',
        maxScore: 40,
        earnedScore: 0,
      ),
    ];

    await answerSessionRepository.saveSession(
      session: session,
      records: records,
    );

    final List<AnswerSession> sessions =
        await answerSessionRepository.fetchByLearnerId('learner_allen');
    final List<SessionAnswerRecord> loadedRecords =
        await answerSessionRepository.fetchAnswerRecords('session_quiz_001');

    expect(sessions, hasLength(1));
    expect(sessions.first.mode, 'quiz');
    expect(sessions.first.correctCount, 1);
    expect(sessions.first.timeLimitSeconds, 600);
    expect(sessions.first.maxScore, 100);
    expect(sessions.first.earnedScore, 60);
    expect(loadedRecords, hasLength(2));
    expect(loadedRecords.first.questionId, 'q1');
    expect(loadedRecords.last.isCorrect, isFalse);
    expect(loadedRecords.first.maxScore, 60);
    expect(loadedRecords.first.earnedScore, 60);
  });

  test('stores and reads learner profiles', () async {
    const LearnerProfile profile = LearnerProfile(
      id: 'learner_001',
      displayName: 'Allen',
      levelStage: 'grade4',
      challengeTier: 'advanced',
      createdAtIso: '2026-07-16T09:00:00Z',
    );

    await learnerProfileRepository.save(profile);
    final List<LearnerProfile> profiles =
        await learnerProfileRepository.fetchAll();

    expect(profiles, hasLength(1));
    expect(profiles.first.displayName, 'Allen');
    expect(profiles.first.levelStage, 'grade4');
  });

  test('stores and reads learner avatar selections', () async {
    const LearnerProfile profile = LearnerProfile(
      id: 'learner_avatar_001',
      displayName: 'Noah',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      createdAtIso: '2026-09-02T08:00:00Z',
      avatar: AvatarConfiguration(
        presentation: AvatarPresentation.boy,
        skinId: 'boy_skin_01',
        faceId: 'boy_face_01',
        hairId: 'boy_hair_02',
        eyesId: 'boy_eyes_01',
        noseId: 'boy_nose_02',
        mouthId: 'boy_mouth_01',
      ),
    );

    await learnerProfileRepository.save(profile);
    final LearnerProfile loaded =
        (await learnerProfileRepository.fetchAll()).single;

    expect(loaded.avatar.presentation, AvatarPresentation.boy);
    expect(loaded.avatar.hairId, 'boy_hair_02');
    expect(loaded.avatar.noseId, 'boy_nose_02');
  });

  test('legacy learner profile maps receive a default avatar', () {
    final LearnerProfile profile = LearnerProfile.fromMap(
      const <String, Object?>{
        'id': 'legacy',
        'display_name': 'Legacy',
        'level_stage': 'grade2',
        'challenge_tier': 'foundation',
        'created_at': '2026-09-02T08:00:00Z',
      },
    );

    expect(profile.avatar.presentation, AvatarPresentation.girl);
    expect(profile.avatar.hairId, 'girl_hair_01');
  });

  test('deletes learner profiles by id', () async {
    const LearnerProfile allen = LearnerProfile(
      id: 'learner_001',
      displayName: 'Allen',
      levelStage: 'grade4',
      challengeTier: 'advanced',
      createdAtIso: '2026-07-16T09:00:00Z',
    );
    const LearnerProfile mia = LearnerProfile(
      id: 'learner_002',
      displayName: 'Mia',
      levelStage: 'grade2',
      challengeTier: 'foundation',
      createdAtIso: '2026-07-16T09:01:00Z',
    );

    await learnerProfileRepository.save(allen);
    await learnerProfileRepository.save(mia);
    await learnerProfileRepository.deleteById('learner_001');

    final List<LearnerProfile> profiles =
        await learnerProfileRepository.fetchAll();
    expect(profiles, hasLength(1));
    expect(profiles.first.id, 'learner_002');
  });

  test('upserts question progress by learner and question', () async {
    const QuestionProgress progress = QuestionProgress(
      learnerId: 'learner_001',
      questionId: 'geometry_grade4_foundation_001',
      status: 'correct',
      lastResult: 'multiple_choice:B',
      updatedAtIso: '2026-07-16T09:30:00Z',
    );

    await questionProgressRepository.upsert(progress);
    await questionProgressRepository.upsert(
      progress.copyWith(lastResult: 'multiple_choice:C'),
    );

    final QuestionProgress? loaded = await questionProgressRepository.fetchOne(
      learnerId: 'learner_001',
      questionId: 'geometry_grade4_foundation_001',
    );

    expect(loaded, isNotNull);
    expect(loaded!.status, 'correct');
    expect(loaded.lastResult, 'multiple_choice:C');
  });

  test('stores and reads app preferences', () async {
    await appPreferencesRepository.setValue(
        'current_learner_id', 'learner_001');
    final String? value =
        await appPreferencesRepository.getValue('current_learner_id');

    expect(value, 'learner_001');
  });

  test('deleting the current learner switches to another learner', () async {
    final AppServices services = AppServices(
      database: database,
      learnerProfileRepository: learnerProfileRepository,
      questionProgressRepository: questionProgressRepository,
      appPreferencesRepository: appPreferencesRepository,
    );

    await services.seedDefaultDataIfNeeded();
    expect(services.currentLearnerId, 'learner_allen');

    await services.deleteLearner('learner_allen');

    expect(services.currentLearnerId, 'learner_mia');
    final List<LearnerProfile> profiles =
        await learnerProfileRepository.fetchAll();
    expect(profiles.map((profile) => profile.id), ['learner_mia']);
    expect(
      await appPreferencesRepository.getValue('current_learner_id'),
      'learner_mia',
    );
  });

  test('calculates learner progress summary from saved answers', () async {
    final AppServices services = AppServices(
      database: database,
      learnerProfileRepository: learnerProfileRepository,
      questionProgressRepository: questionProgressRepository,
      appPreferencesRepository: appPreferencesRepository,
    );

    await questionProgressRepository.upsert(
      const QuestionProgress(
        learnerId: 'learner_allen',
        questionId: 'q1',
        status: 'correct',
        lastResult: 'multiple_choice:A',
        updatedAtIso: '2026-07-16T09:00:00Z',
      ),
    );
    await questionProgressRepository.upsert(
      const QuestionProgress(
        learnerId: 'learner_allen',
        questionId: 'q2',
        status: 'incorrect',
        lastResult: 'multiple_choice:B',
        updatedAtIso: '2026-07-16T09:05:00Z',
      ),
    );
    await questionProgressRepository.upsert(
      const QuestionProgress(
        learnerId: 'learner_mia',
        questionId: 'q3',
        status: 'correct',
        lastResult: 'multiple_choice:C',
        updatedAtIso: '2026-07-16T09:10:00Z',
      ),
    );

    final LearnerProgressSummary summary =
        await services.getLearnerProgressSummary('learner_allen');

    expect(summary.solvedCount, 2);
    expect(summary.correctCount, 1);
    expect(summary.accuracyRate, 0.5);
  });

  test('reads only the current learner question IDs for launch selection',
      () async {
    final AppServices services = AppServices(
      database: database,
      learnerProfileRepository: learnerProfileRepository,
      questionProgressRepository: questionProgressRepository,
      appPreferencesRepository: appPreferencesRepository,
    );
    await questionProgressRepository.upsert(
      const QuestionProgress(
        learnerId: 'learner_allen',
        questionId: 'answered_1',
        status: 'correct',
        lastResult: 'integer_input:1',
        updatedAtIso: '2026-09-06T09:00:00Z',
      ),
    );
    await questionProgressRepository.upsert(
      const QuestionProgress(
        learnerId: 'learner_mia',
        questionId: 'other_learner',
        status: 'correct',
        lastResult: 'integer_input:1',
        updatedAtIso: '2026-09-06T09:01:00Z',
      ),
    );

    expect(
      await services.getLearnerAnsweredQuestionIds('learner_allen'),
      <String>{'answered_1'},
    );
  });

  test('app services persists practice session summaries', () async {
    final AppServices services = AppServices(
      database: database,
      learnerProfileRepository: learnerProfileRepository,
      questionProgressRepository: questionProgressRepository,
      appPreferencesRepository: appPreferencesRepository,
      answerSessionRepository: answerSessionRepository,
    );

    await services.saveAnswerSession(
      session: const AnswerSession(
        id: 'session_practice_001',
        learnerId: 'learner_allen',
        mode: 'practice',
        topicCode: 'geometry',
        levelStage: 'grade4',
        challengeTier: 'foundation',
        startedAtIso: '2026-07-17T10:00:00Z',
        endedAtIso: '2026-07-17T10:02:30Z',
        elapsedSeconds: 150,
        totalQuestions: 2,
        correctCount: 1,
      ),
      records: const [
        SessionAnswerRecord(
          sessionId: 'session_practice_001',
          questionId: 'q1',
          sequence: 1,
          submittedAnswer: 'A',
          isCorrect: false,
          answeredAtIso: '2026-07-17T10:01:00Z',
        ),
        SessionAnswerRecord(
          sessionId: 'session_practice_001',
          questionId: 'q2',
          sequence: 2,
          submittedAnswer: '45',
          isCorrect: true,
          answeredAtIso: '2026-07-17T10:02:00Z',
        ),
      ],
    );

    final List<AnswerSession> sessions =
        await answerSessionRepository.fetchByLearnerId('learner_allen');
    expect(sessions, hasLength(1));
    expect(sessions.first.mode, 'practice');
    expect(sessions.first.totalQuestions, 2);
  });

  test(
      'app services reads learner answer session history in latest-first order',
      () async {
    final AppServices services = AppServices(
      database: database,
      learnerProfileRepository: learnerProfileRepository,
      questionProgressRepository: questionProgressRepository,
      appPreferencesRepository: appPreferencesRepository,
      answerSessionRepository: answerSessionRepository,
    );

    await answerSessionRepository.saveSession(
      session: const AnswerSession(
        id: 'session_old',
        learnerId: 'learner_allen',
        mode: 'practice',
        topicCode: 'arithmetic',
        levelStage: 'grade3',
        challengeTier: 'foundation',
        startedAtIso: '2026-07-17T08:00:00Z',
        endedAtIso: '2026-07-17T08:02:00Z',
        elapsedSeconds: 120,
        totalQuestions: 2,
        correctCount: 1,
      ),
      records: const [],
    );
    await answerSessionRepository.saveSession(
      session: const AnswerSession(
        id: 'session_new',
        learnerId: 'learner_allen',
        mode: 'quiz',
        topicCode: 'geometry',
        levelStage: 'grade4',
        challengeTier: 'foundation',
        startedAtIso: '2026-07-17T09:00:00Z',
        endedAtIso: '2026-07-17T09:05:00Z',
        elapsedSeconds: 300,
        totalQuestions: 10,
        correctCount: 8,
      ),
      records: const [],
    );

    final List<AnswerSession> sessions =
        await services.getLearnerAnswerSessions('learner_allen');

    expect(sessions, hasLength(2));
    expect(sessions.first.id, 'session_new');
    expect(sessions.last.id, 'session_old');
  });

  test('app services derives learner activity from persisted answer records',
      () async {
    final AppServices services = AppServices(
      database: database,
      learnerProfileRepository: learnerProfileRepository,
      questionProgressRepository: questionProgressRepository,
      appPreferencesRepository: appPreferencesRepository,
      answerSessionRepository: answerSessionRepository,
    );
    const AnswerSession session = AnswerSession(
      id: 'session_activity',
      learnerId: 'learner_allen',
      mode: 'practice',
      topicCode: 'geometry',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      startedAtIso: '2026-08-20T09:00:00Z',
      endedAtIso: '2026-08-20T09:02:00Z',
      elapsedSeconds: 120,
      totalQuestions: 2,
      correctCount: 1,
    );

    await services.saveAnswerSession(
      session: session,
      records: const [
        SessionAnswerRecord(
          sessionId: 'session_activity',
          questionId: 'q1',
          sequence: 1,
          submittedAnswer: 'A',
          isCorrect: false,
          answeredAtIso: '2026-08-20T09:01:00Z',
        ),
        SessionAnswerRecord(
          sessionId: 'session_activity',
          questionId: 'q2',
          sequence: 2,
          submittedAnswer: 'B',
          isCorrect: true,
          answeredAtIso: '2026-08-20T09:02:00Z',
        ),
      ],
    );

    final dynamic summary =
        await services.getLearnerLearningActivitySummary('learner_allen');

    expect(summary.dayFor(DateTime(2026, 8, 20)).questionCount, 2);
    expect(summary.topicQuestionCounts, {'geometry': 2});
  });
}
