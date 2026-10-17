part of '../main.dart';

class _ResultStatusBadge extends StatelessWidget {
  const _ResultStatusBadge({
    required this.label,
    required this.isCorrect,
  });

  final String label;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        isCorrect ? const Color(0xFF166534) : const Color(0xFFB91C1C);
    final Color backgroundColor =
        isCorrect ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

Future<String?> _showTopicPicker({
  required BuildContext context,
  required AppStrings strings,
}) async {
  return showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(strings.chooseTopic),
        contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        content: SizedBox(
          width: 320,
          child: _TopicActionGrid(
            strings: strings,
            onTopicSelected: (topicCode) async {
              Navigator.of(dialogContext).pop(topicCode);
            },
          ),
        ),
      );
    },
  );
}

Future<FormalExamPreset?> _showFormalExamPresetPicker(
  BuildContext context,
) {
  final AppStrings strings = AppStrings.of(context);
  return showModalBottomSheet<FormalExamPreset>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.chooseFormalExam,
              style: Theme.of(sheetContext).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(strings.chooseFormalExamBody),
            const SizedBox(height: 16),
            for (final FormalExamPreset preset in FormalExamPreset.standard)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OutlinedButton(
                  key: ValueKey<String>(
                    'formal_exam_${preset.questionCount}_${preset.timeLimit.inMinutes}',
                  ),
                  onPressed: () => Navigator.of(sheetContext).pop(preset),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(
                    strings.formalExamPresetLabel(
                        preset.questionCount, preset.timeLimit.inMinutes),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _openFirstEligiblePack({
  required BuildContext context,
  required AppServices services,
  required LearnerProfile? learner,
  required _SessionLaunchMode mode,
  String? topicCode,
  int? questionLimit,
  FormalExamPreset? formalExamPreset,
}) async {
  final bundled.BundledQuestionBankRepository repository =
      bundled.BundledQuestionBankRepository();
  final bundled.BundledQuestionManifest manifest =
      await repository.loadManifest();
  final List<bundled.BundledQuestionPackInfo> selectedPacks =
      SessionLaunchPlanBuilder.pickEligiblePacks(
    manifest.packs,
    learner,
    topicCode: topicCode,
  );
  if (!context.mounted || selectedPacks.isEmpty) {
    return;
  }

  final List<Question> mergedQuestions = <Question>[];
  for (final bundled.BundledQuestionPackInfo pack in selectedPacks) {
    final QuestionBank questionBank = await repository.loadPack(pack.path);
    mergedQuestions.addAll(questionBank.questions);
  }
  final List<Question> approvedQuestions =
      SessionLaunchPlanBuilder.filterApprovedQuestionsForLaunch(
          mergedQuestions);
  if (!context.mounted || approvedQuestions.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppStrings.of(context).noApprovedQuestionsInRange)),
      );
    }
    return;
  }
  final String? learnerId = learner?.id ?? services.currentLearnerId;
  final Set<String> answeredQuestionIds = learnerId == null
      ? const <String>{}
      : await services.getLearnerAnsweredQuestionIds(learnerId);
  if (!context.mounted) {
    return;
  }
  final List<Question> prioritizedQuestions =
      SessionLaunchPlanBuilder.preferUnansweredQuestionsForLaunch(
    approvedQuestions,
    answeredQuestionIds: answeredQuestionIds,
  );
  final List<Question> randomizedQuestions =
      SessionLaunchPlanBuilder.randomizeQuestionOrderForSession(
    prioritizedQuestions,
  );
  final List<Question> sessionQuestions = questionLimit == null
      ? randomizedQuestions
      : randomizedQuestions.take(questionLimit).toList(growable: false);

  final bundled.BundledQuestionPackInfo launchPack =
      SessionLaunchPlanBuilder.buildLaunchPack(
    selectedPacks: selectedPacks,
    learner: learner,
    mergedQuestionCount: approvedQuestions.length,
    topicCode: topicCode,
  );

  final Widget page = switch (mode) {
    _SessionLaunchMode.practice => PracticeSessionPage(
        services: services,
        pack: launchPack,
        initialQuestions: sessionQuestions,
        learner: learner,
      ),
    _SessionLaunchMode.quiz => QuizSessionPage(
        services: services,
        pack: launchPack,
        initialQuestions: sessionQuestions,
        formalExamPreset: formalExamPreset,
        learner: learner,
      ),
  };

  await Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => page),
  );
}

String _learnerGradeRangeLabel(LearnerProfile learner, AppStrings strings) {
  return strings.gradeRangeDisplay(
    levelStageNumber(learner.effectiveMinLevelStage),
    levelStageNumber(learner.effectiveMaxLevelStage),
  );
}

String _answerModeSubtitle(AppStrings strings, AnswerMode answerMode) {
  switch (answerMode) {
    case AnswerMode.multipleChoice:
      return strings.chooseOneAnswer;
    case AnswerMode.integerInput:
      return strings.enterIntegerAnswer;
    case AnswerMode.selfCheck:
      return strings.selfCheckLabel;
  }
}

String _localeCode(BuildContext context) {
  final Locale locale = Localizations.localeOf(context);
  return locale.countryCode == null || locale.countryCode!.isEmpty
      ? locale.languageCode
      : '${locale.languageCode}-${locale.countryCode}';
}

bool _isDenseScriptLocale(String localeCode) {
  final String normalized = localeCode.toLowerCase();
  return normalized.startsWith('zh') || normalized.startsWith('ja');
}

String _displayLevelStage(String levelStage, AppStrings strings) {
  return strings.levelStageDisplay(levelStage);
}

String _displayTier(String tier, AppStrings strings) {
  return strings.tierDisplay(tier);
}

String _englishMonthName(int month) {
  const List<String> months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return months[month - 1];
}

String _displayTopicCode(String topicCode, AppStrings strings) =>
    displayTopicCode(topicCode, strings);

String displayTopicCode(String topicCode, AppStrings strings) {
  switch (topicCode) {
    case 'mixed':
      return strings.topicMixed;
    case 'geometry':
      return strings.topicGeometry;
    case 'arithmetic':
      return strings.topicArithmetic;
    case 'logic':
      return strings.topicLogic;
    case 'algebra':
      return strings.topicAlgebra;
    case 'combinatorics':
      return strings.topicCombinatorics;
    case 'number_theory':
      return strings.topicNumberTheory;
    default:
      return topicCode;
  }
}

bool _isCorrect(Question question, String submittedAnswer) {
  switch (question.answerMode) {
    case AnswerMode.multipleChoice:
    case AnswerMode.selfCheck:
      return submittedAnswer == question.correctAnswer.value;
    case AnswerMode.integerInput:
      final List<String> expected = question.correctAnswer.orderedValues;
      final List<String> submitted = _decodeIntegerAnswers(submittedAnswer);
      return expected.length == submitted.length &&
          List<bool>.generate(
            expected.length,
            (int index) => expected[index] == submitted[index],
          ).every((bool matches) => matches);
  }
}

const String _integerAnswerSeparator = '\u001F';

String _encodeIntegerAnswers(Iterable<String> values) =>
    values.join(_integerAnswerSeparator);

List<String> _decodeIntegerAnswers(String encoded) =>
    encoded.split(_integerAnswerSeparator);

String _answerModeToken(AnswerMode mode) {
  switch (mode) {
    case AnswerMode.multipleChoice:
      return 'multiple_choice';
    case AnswerMode.integerInput:
      return 'integer_input';
    case AnswerMode.selfCheck:
      return 'self_check';
  }
}

String _formatElapsed(Duration duration) {
  final int minutes = duration.inMinutes;
  final int seconds = duration.inSeconds.remainder(60);
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

String _formatSessionEndedAt(String endedAtIso) {
  final DateTime endedAt = DateTime.parse(endedAtIso).toLocal();
  final String month = endedAt.month.toString().padLeft(2, '0');
  final String day = endedAt.day.toString().padLeft(2, '0');
  final String hour = endedAt.hour.toString().padLeft(2, '0');
  final String minute = endedAt.minute.toString().padLeft(2, '0');
  return '${endedAt.year}/$month/$day $hour:$minute';
}

String _displaySubmittedAnswer(
  Question? question,
  String submittedAnswer,
  String localeCode,
) {
  if (submittedAnswer.isEmpty) {
    return '-';
  }
  if (question == null) {
    return submittedAnswer;
  }

  switch (question.answerMode) {
    case AnswerMode.multipleChoice:
      return question.optionDisplayLabel(submittedAnswer, localeCode);
    case AnswerMode.integerInput:
      final List<String> values = _decodeIntegerAnswers(submittedAnswer);
      return values.join('、');
    case AnswerMode.selfCheck:
      return submittedAnswer;
  }
}
