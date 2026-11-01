part of '../main.dart';

/// 冷啟動時的進入畫面：目前學習者的頭像、問候語，以及開始或接續的按鈕。
///
/// 2026-11-01 使用者希望打開 app 時有一個「進入遊戲」的畫面；同時 app 被系統
/// 回收後，做到一半的練習或正式測驗可以從這裡接回去。
class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
    required this.services,
    required this.onEnter,
  });

  final AppServices services;

  /// 進入首頁；[resume] 不為 null 時，進首頁後接著打開那一回練習或測驗。
  final void Function(InProgressSession? resume) onEnter;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _loaded = false;
  bool _enteredBefore = false;
  InProgressSession? _resume;

  @override
  void initState() {
    super.initState();
    _load();
  }

  LearnerProfile? get _learner {
    final String? id = widget.services.currentLearnerId;
    for (final LearnerProfile profile in widget.services.learnerProfiles) {
      if (profile.id == id) {
        return profile;
      }
    }
    return widget.services.learnerProfiles.firstOrNull;
  }

  Future<void> _load() async {
    final bool entered = await widget.services.hasEnteredBefore();
    final String? learnerId = _learner?.id;
    final InProgressSession? resume = learnerId == null
        ? null
        : await widget.services.loadInProgressSession(learnerId);
    if (!mounted) {
      return;
    }
    setState(() {
      _enteredBefore = entered;
      _resume = resume;
      _loaded = true;
    });
  }

  Future<void> _enter({InProgressSession? resume}) async {
    await widget.services.markEntered();
    widget.onEnter(resume);
  }

  Future<void> _switchLearner() async {
    final AppStrings strings = AppStrings.of(context);
    final String? picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(strings.switchLearner,
                  style: Theme.of(sheetContext).textTheme.titleLarge),
            ),
            for (final LearnerProfile profile in widget.services.learnerProfiles)
              ListTile(
                key: ValueKey<String>('welcome_learner_${profile.id}'),
                leading: AvatarPreview(configuration: profile.avatar, size: 40),
                title: Text(profile.displayName),
                trailing: profile.id == _learner?.id
                    ? const Icon(Icons.check_rounded,
                        color: AppVisualTokens.primary)
                    : null,
                onTap: () => Navigator.of(sheetContext).pop(profile.id),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (picked == null || picked == _learner?.id) {
      return;
    }
    await widget.services.setCurrentLearner(picked);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final LearnerProfile? learner = _learner;
    final InProgressSession? resume = _resume;
    return Scaffold(
      key: const ValueKey<String>('welcome_page'),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: !_loaded
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (learner != null)
                          AvatarPreview(
                              configuration: learner.avatar, size: 140),
                        const SizedBox(height: 20),
                        Text(
                          strings.heroTitle,
                          style: textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _enteredBefore && learner != null
                              ? strings.welcomeBack(learner.displayName)
                              : strings.welcomeFirstTime,
                          textAlign: TextAlign.center,
                          style: textTheme.titleLarge
                              ?.copyWith(color: AppVisualTokens.inkMuted),
                        ),
                        const SizedBox(height: 36),
                        if (resume != null) ...[
                          FilledButton(
                            key: const ValueKey<String>('welcome_resume'),
                            onPressed: () => _enter(resume: resume),
                            child: Text(
                              resume.kind == InProgressSessionKind.quiz
                                  ? strings.resumeQuiz(resume.currentIndex + 1,
                                      resume.questionIds.length)
                                  : strings.resumePractice(
                                      resume.currentIndex %
                                              resume.questionIds.length +
                                          1,
                                      resume.questionIds.length),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            key: const ValueKey<String>('welcome_start'),
                            onPressed: () => _enter(),
                            child: Text(strings.startNewPractice),
                          ),
                        ] else
                          FilledButton(
                            key: const ValueKey<String>('welcome_start'),
                            onPressed: () => _enter(),
                            child: Text(strings.startPractice),
                          ),
                        if (widget.services.learnerProfiles.length > 1) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            key: const ValueKey<String>('welcome_switch'),
                            onPressed: _switchLearner,
                            child: Text(strings.switchLearner),
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 打開從進入畫面接回的練習或測驗。題目只靠題號找回：練習可能來自好幾個題包。
Future<void> _openResumedSession(
  BuildContext context,
  AppServices services,
  InProgressSession session,
) async {
  final List<Question> questions = await bundled.BundledQuestionBankRepository()
      .loadQuestionsByIds(session.questionIds);
  if (!context.mounted || questions.length != session.questionIds.length) {
    // 題庫改版後題目不齊，就不硬接，回到首頁重新開始。
    final String? learnerId = services.currentLearnerId;
    if (learnerId != null) {
      await services.clearInProgressSession(learnerId);
    }
    return;
  }
  final bundled.BundledQuestionPackInfo pack = session.packJson.isEmpty
      ? bundled.BundledQuestionPackInfo(
          path: '',
          topic: 'mixed',
          topicCode: 'mixed',
          levelStage: questions.first.levelStage,
          challengeTier: 'foundation',
          questionCount: questions.length,
        )
      : bundled.BundledQuestionPackInfo.fromJson(session.packJson);
  final LearnerProfile? learner = services.learnerProfiles
      .where((LearnerProfile p) => p.id == services.currentLearnerId)
      .firstOrNull;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => session.kind == InProgressSessionKind.quiz
          ? QuizSessionPage(
              services: services,
              pack: pack,
              initialQuestions: questions,
              learner: learner,
              formalExamPreset: session.isFormalExam
                  ? FormalExamPreset(
                      questionCount:
                          session.examQuestionCount ?? questions.length,
                      timeLimit:
                          Duration(seconds: session.examTimeLimitSeconds!),
                    )
                  : null,
              resume: session,
            )
          : PracticeSessionPage(
              services: services,
              pack: pack,
              initialQuestions: questions,
              learner: learner,
              resume: session,
            ),
    ),
  );
}
