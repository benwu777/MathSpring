part of '../main.dart';

class QuizSessionPage extends StatefulWidget {
  const QuizSessionPage({
    super.key,
    required this.services,
    required this.pack,
    this.initialQuestions,
    this.formalExamPreset,
    this.learner,
  });

  final AppServices services;
  final bundled.BundledQuestionPackInfo pack;
  final List<Question>? initialQuestions;
  final FormalExamPreset? formalExamPreset;
  final LearnerProfile? learner;

  @override
  State<QuizSessionPage> createState() => _QuizSessionPageState();
}

class _QuizSessionPageState extends State<QuizSessionPage> {
  late final Future<QuestionBank> _packFuture;
  final Map<String, String> _answers = <String, String>{};
  final DateTime _startedAt = DateTime.now();
  int _currentIndex = 0;
  Timer? _countdownTimer;
  DateTime? _deadline;
  List<Question>? _activeQuestions;
  bool _hasAutoSubmitted = false;
  final Set<String> _favoriteQuestionIds = <String>{};

  @override
  void initState() {
    super.initState();
    if (widget.formalExamPreset != null) {
      _deadline = _startedAt.add(widget.formalExamPreset!.timeLimit);
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        final List<Question>? questions = _activeQuestions;
        if (questions == null || !mounted) {
          return;
        }
        if (_remainingExamTime.inSeconds <= 0 && !_hasAutoSubmitted) {
          _hasAutoSubmitted = true;
          _countdownTimer?.cancel();
          _finishQuiz(context, questions: questions);
          return;
        }
        setState(() {});
      });
    }
    _packFuture = widget.initialQuestions == null
        ? bundled.BundledQuestionBankRepository().loadPack(
            widget.pack.path,
          )
        : Future<QuestionBank>.value(
            QuestionBank(
              version: 1,
              languages: const ['en', 'zh-Hant'],
              questions: widget.initialQuestions!,
            ),
          );
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final QuestionBank bank = await _packFuture;
    final String learnerId = widget.services.currentLearnerId ?? 'unknown';
    for (final Question question in bank.questions) {
      if (await widget.services
          .isFavoriteQuestion(learnerId: learnerId, questionId: question.id)) {
        _favoriteQuestionIds.add(question.id);
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> _toggleQuizFavorite(Question question) async {
    final bool value = await widget.services.toggleFavoriteQuestion(
        learnerId: widget.services.currentLearnerId ?? 'unknown',
        questionId: question.id);
    if (!mounted) return;
    setState(() => value
        ? _favoriteQuestionIds.add(question.id)
        : _favoriteQuestionIds.remove(question.id));
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Duration get _remainingExamTime {
    final DateTime? deadline = _deadline;
    if (deadline == null) {
      return Duration.zero;
    }
    final Duration remaining = deadline.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    final AppStrings strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.quizMode),
        actions: [
          if (widget.learner != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 124,
                child: _CurrentLearnerIdentity(learner: widget.learner!),
              ),
            ),
        ],
        surfaceTintColor: Colors.transparent,
      ),
      body: FutureBuilder<QuestionBank>(
        future: _packFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<Question> questions = snapshot.data!.questions;
          _activeQuestions = questions;
          final List<FormalExamQuestionScore> scores =
              FormalExamScoring.allocate(questions);
          final Question question = questions[_currentIndex];
          final String? selectedAnswer = _answers[question.id];
          return ContentScrollView(
            fill: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppVisualTokens.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppVisualTokens.outline),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.formalExamPreset == null
                              ? strings.questionCounter(
                                  _currentIndex + 1,
                                  questions.length,
                                )
                              : strings.formalExamQuestionCounter(
                                  _currentIndex + 1,
                                  questions.length,
                                  scores[_currentIndex].maxScore,
                                ),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: layoutSpec.titleText),
                        ),
                      ),
                      IconButton(
                        key: ValueKey<String>(
                            'bookmark_question_${question.id}'),
                        tooltip: strings.bookmarkQuestion,
                        onPressed: () => _toggleQuizFavorite(question),
                        icon: Icon(_favoriteQuestionIds.contains(question.id)
                            ? Icons.bookmark
                            : Icons.bookmark_border),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppVisualTokens.primarySoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _displayLevelStage(question.levelStage, strings),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppVisualTokens.primary,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.formalExamPreset == null
                      ? '${strings.elapsedLabel} ${_formatElapsed(Duration(seconds: DateTime.now().difference(_startedAt).inSeconds))}'
                      : strings.formalExamRemaining(
                          _formatElapsed(_remainingExamTime)),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppVisualTokens.inkMuted,
                      ),
                ),
                const SizedBox(height: 16),
                // 撐滿剩餘高度：換題時卡片的位置與大小固定，
                // 不會因為每題文字長短而上下跳。
                Expanded(
                  child: _SectionCard(
                    title: _displayLevelStage(question.levelStage, strings),
                    subtitle: '',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _QuestionPromptText(
                          key: ValueKey<String>(
                              'question_prompt_${question.id}'),
                          text: question.localizedPrompt(_localeCode(context)),
                          localeCode: _localeCode(context),
                        ),
                        if (question.source?.displayLabel != null) ...[
                          const SizedBox(height: 8),
                          _QuestionSourceText(
                              text: question.source!.displayLabel!),
                        ],
                        if (question.figure.kind != 'none') ...[
                          const SizedBox(height: 20),
                          _QuestionFigureView(question: question),
                        ],
                        const SizedBox(height: 20),
                        _QuizAnswerSection(
                          question: question,
                          localeCode: _localeCode(context),
                          selectedAnswer: selectedAnswer,
                          onAnswerChanged: (answer) {
                            setState(() {
                              _answers[question.id] = answer;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (widget.formalExamPreset != null) ...[
                  OutlinedButton.icon(
                    key: const ValueKey<String>('open_exam_navigator'),
                    onPressed: () => _openQuestionNavigator(
                      context,
                      questions: questions,
                      scores: scores,
                    ),
                    icon: const Icon(Icons.grid_view_rounded),
                    label: Text(strings.questionOverview),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        key: const ValueKey<String>('submit_quiz_early'),
                        onPressed: () async {
                          await _finishQuiz(
                            context,
                            questions: questions,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                        child: Text(strings.submitQuiz),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: selectedAnswer == null
                            ? null
                            : () => _submitCurrentAnswer(
                                  context,
                                  questions: questions,
                                  question: question,
                                  submittedAnswer: selectedAnswer,
                                ),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                        child: Text(
                          _currentIndex == questions.length - 1
                              ? strings.submitQuiz
                              : strings.nextQuestion,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _openQuestionNavigator(
    BuildContext context, {
    required List<Question> questions,
    required List<FormalExamQuestionScore> scores,
  }) async {
    final AppStrings strings = AppStrings.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.questionOverview,
                  style: Theme.of(sheetContext).textTheme.titleLarge),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (int index = 0; index < questions.length; index += 1)
                    OutlinedButton(
                      onPressed: () {
                        setState(() => _currentIndex = index);
                        Navigator.of(sheetContext).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            _answers.containsKey(questions[index].id)
                                ? AppVisualTokens.primarySoft
                                : AppVisualTokens.surface,
                      ),
                      child: Text(strings.questionOverviewItem(
                          index + 1, scores[index].maxScore)),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(strings.questionOverviewLegend),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitCurrentAnswer(
    BuildContext context, {
    required List<Question> questions,
    required Question question,
    required String submittedAnswer,
  }) async {
    final bool isCorrect = _isCorrect(question, submittedAnswer);
    final String learnerId = widget.services.currentLearnerId ?? 'unknown';
    await widget.services.saveQuestionProgress(
      QuestionProgress(
        learnerId: learnerId,
        questionId: question.id,
        status: isCorrect ? 'correct' : 'incorrect',
        lastResult: '${_answerModeToken(question.answerMode)}:$submittedAnswer',
        updatedAtIso: DateTime.now().toUtc().toIso8601String(),
      ),
    );

    if (!context.mounted) {
      return;
    }
    if (_currentIndex == questions.length - 1) {
      await _finishQuiz(
        context,
        questions: questions,
        overrideAnswers: <String, String>{
          ..._answers,
          question.id: submittedAnswer,
        },
      );
      return;
    }

    setState(() {
      _currentIndex++;
    });
  }

  Future<void> _finishQuiz(
    BuildContext context, {
    required List<Question> questions,
    Map<String, String>? overrideAnswers,
  }) async {
    final Map<String, String> finalAnswers = overrideAnswers ?? _answers;
    _countdownTimer?.cancel();
    final DateTime submittedAt = DateTime.now();
    final List<QuizAnswerRecord> records = <QuizAnswerRecord>[
      for (final Question item in questions)
        QuizAnswerRecord(
          question: item,
          submittedAnswer: finalAnswers[item.id] ?? '',
          isCorrect: _isCorrect(item, finalAnswers[item.id] ?? ''),
          answeredAt: submittedAt,
        ),
    ];
    final QuizSessionResult result = QuizSessionResult(
      records: records,
      startedAt: _startedAt,
      submittedAt: submittedAt,
    );
    final List<FormalExamQuestionScore> questionScores =
        FormalExamScoring.allocate(questions);
    final String sessionId =
        'quiz_${widget.services.currentLearnerId ?? 'unknown'}_${submittedAt.microsecondsSinceEpoch}';
    await widget.services.saveAnswerSession(
      session: AnswerSession(
        id: sessionId,
        learnerId: widget.services.currentLearnerId ?? 'unknown',
        mode: 'quiz',
        topicCode: widget.pack.topicCode,
        levelStage: widget.pack.levelStage,
        challengeTier: widget.pack.challengeTier,
        startedAtIso: result.startedAt.toUtc().toIso8601String(),
        endedAtIso: result.submittedAt.toUtc().toIso8601String(),
        elapsedSeconds: result.elapsed.inSeconds,
        totalQuestions: result.totalQuestions,
        correctCount: result.correctCount,
        timeLimitSeconds: widget.formalExamPreset?.timeLimit.inSeconds,
        maxScore: widget.formalExamPreset == null ? null : 100,
        earnedScore: widget.formalExamPreset == null
            ? null
            : _earnedFormalExamScore(records),
      ),
      records: [
        for (int index = 0; index < records.length; index++)
          SessionAnswerRecord(
            sessionId: sessionId,
            questionId: records[index].question.id,
            sequence: index + 1,
            submittedAnswer: records[index].submittedAnswer,
            isCorrect: records[index].isCorrect,
            answeredAtIso: records[index].answeredAt.toUtc().toIso8601String(),
            maxScore: widget.formalExamPreset == null
                ? null
                : questionScores[index].maxScore,
            earnedScore: widget.formalExamPreset == null
                ? null
                : (records[index].isCorrect
                    ? questionScores[index].maxScore
                    : 0),
          ),
      ],
    );

    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => QuizResultPage(
          services: widget.services,
          result: result,
          maxScore: widget.formalExamPreset == null ? null : 100,
          earnedScore: widget.formalExamPreset == null
              ? null
              : _earnedFormalExamScore(records),
        ),
      ),
    );
  }

  int _earnedFormalExamScore(List<QuizAnswerRecord> records) {
    final List<FormalExamQuestionScore> scores = FormalExamScoring.allocate(
      records.map((QuizAnswerRecord record) => record.question).toList(),
    );
    int earned = 0;
    for (int index = 0; index < records.length; index += 1) {
      if (records[index].isCorrect) {
        earned += scores[index].maxScore;
      }
    }
    return earned;
  }
}

class _QuizAnswerSection extends StatelessWidget {
  const _QuizAnswerSection({
    required this.question,
    required this.localeCode,
    required this.selectedAnswer,
    required this.onAnswerChanged,
  });

  final Question question;
  final String localeCode;
  final String? selectedAnswer;
  final ValueChanged<String> onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    switch (question.answerMode) {
      case AnswerMode.multipleChoice:
        final List<String> keys = (question.options?.keys.toList() ?? [])
          ..sort();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final String key in keys)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OutlinedButton(
                  key: ValueKey<String>('quiz_option_${question.id}_$key'),
                  onPressed: () => onAnswerChanged(key),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    alignment: Alignment.centerLeft,
                    backgroundColor: selectedAnswer == key
                        ? AppVisualTokens.primarySoft
                        : AppVisualTokens.surface,
                    side: BorderSide(
                      color: selectedAnswer == key
                          ? AppVisualTokens.primary
                          : AppVisualTokens.outline,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _QuestionOptionText(
                    key: ValueKey<String>(
                        'question_option_text_${question.id}_$key'),
                    text: question.optionDisplayLabel(key, localeCode),
                    localeCode: localeCode,
                  ),
                ),
              ),
          ],
        );
      case AnswerMode.integerInput:
        return _QuizIntegerAnswerFields(
          key: ValueKey<String>('quiz_integer_inputs_${question.id}'),
          question: question,
          localeCode: localeCode,
          selectedAnswer: selectedAnswer,
          onAnswerChanged: onAnswerChanged,
        );
      case AnswerMode.selfCheck:
        return Text(
          AppStrings.of(context).selfCheckLabel,
        );
    }
  }
}

class _QuizIntegerAnswerFields extends StatefulWidget {
  const _QuizIntegerAnswerFields({
    super.key,
    required this.question,
    required this.localeCode,
    required this.selectedAnswer,
    required this.onAnswerChanged,
  });

  final Question question;
  final String localeCode;
  final String? selectedAnswer;
  final ValueChanged<String> onAnswerChanged;

  @override
  State<_QuizIntegerAnswerFields> createState() =>
      _QuizIntegerAnswerFieldsState();
}

class _QuizIntegerAnswerFieldsState extends State<_QuizIntegerAnswerFields> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = _createControllers(widget.selectedAnswer);
  }

  @override
  void didUpdateWidget(covariant _QuizIntegerAnswerFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      for (final TextEditingController controller in _controllers) {
        controller.dispose();
      }
      _controllers = _createControllers(widget.selectedAnswer);
    }
  }

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<TextEditingController> _createControllers(String? selectedAnswer) {
    final List<String> currentValues = selectedAnswer == null
        ? const <String>[]
        : _decodeIntegerAnswers(selectedAnswer);
    return <TextEditingController>[
      for (int index = 0;
          index < widget.question.correctAnswer.orderedValues.length;
          index++)
        TextEditingController(
          text: index < currentValues.length ? currentValues[index] : '',
        ),
    ];
  }

  void _notifyChanged() {
    widget.onAnswerChanged(_encodeIntegerAnswers(
      <String>[
        for (final TextEditingController controller in _controllers)
          controller.text.trim(),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> labels =
        widget.question.correctAnswer.localizedInputLabels(widget.localeCode);
    final bool hasMultipleAnswers = _controllers.length > 1;
    final AppStrings strings = AppStrings.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int index = 0; index < _controllers.length; index++) ...[
          if (hasMultipleAnswers) ...[
            Text(
              index < labels.length
                  ? labels[index]
                  : strings.answerFieldLabel(index + 1),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 6),
          ],
          TextField(
            key: ValueKey<String>(
              hasMultipleAnswers
                  ? 'quiz_integer_input_${widget.question.id}_$index'
                  : 'quiz_integer_input_${widget.question.id}',
            ),
            controller: _controllers[index],
            decoration: const InputDecoration(border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            onChanged: (_) => _notifyChanged(),
          ),
          if (index < _controllers.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class QuizResultPage extends StatelessWidget {
  const QuizResultPage({
    super.key,
    required this.services,
    required this.result,
    this.maxScore,
    this.earnedScore,
  });

  final AppServices services;
  final QuizSessionResult result;
  final int? maxScore;
  final int? earnedScore;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.quizResult),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: ContentScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              title: strings.quizResult,
              subtitle: maxScore == null
                  ? '${result.correctCount} / ${result.totalQuestions} ${strings.correctSuffix}'
                  : strings.formalExamScore(earnedScore ?? 0, maxScore!),
              child: Builder(
                builder: (BuildContext context) {
                  final LayoutSpec layoutSpec = LayoutSpec.of(context);
                  final String resultValue = maxScore == null
                      ? '${result.correctCount}'
                      : '$earnedScore';
                  final String resultLabel = maxScore == null
                      ? strings.correctLabel
                      : strings.totalScore;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resultValue,
                        style: TextStyle(
                          fontSize: layoutSpec.scaleText(28),
                          fontWeight: FontWeight.w700,
                          color: AppVisualTokens.primary,
                        ),
                      ),
                      Text(
                        resultLabel,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${strings.elapsedLabel}: ${_formatElapsed(result.elapsed)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppVisualTokens.inkMuted,
                            ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            for (final QuizAnswerRecord record in result.records)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAlias,
                    child: ExpansionTile(
                      key: ValueKey<String>(
                        'quiz_result_${record.question.id}',
                      ),
                      title: _QuestionPromptText(
                        text: record.question
                            .localizedPrompt(_localeCode(context)),
                        localeCode: _localeCode(context),
                      ),
                      subtitle: _ResultStatusBadge(
                        label: record.isCorrect
                            ? strings.correctLabel
                            : strings.incorrectLabel,
                        isCorrect: record.isCorrect,
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        if (record.question.source?.displayLabel != null) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _QuestionSourceText(
                              text: record.question.source!.displayLabel!,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (record.question.figure.kind != 'none') ...[
                          _QuestionFigureView(question: record.question),
                          const SizedBox(height: 14),
                        ],
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _QuestionBodyText(
                            text: record.question
                                .localizedAnswer(_localeCode(context)),
                            localeCode: _localeCode(context),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _SolutionStepsGate(
                          services: services,
                          questionId: record.question.id,
                          steps: Column(
                            children: [
                              for (final String step in record.question
                                  .localizedSolutionSteps(_localeCode(context)))
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: _QuestionBodyText(
                                      text: step,
                                      localeCode: _localeCode(context),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class QuizSessionResult {
  const QuizSessionResult({
    required this.records,
    required this.startedAt,
    required this.submittedAt,
  });

  final List<QuizAnswerRecord> records;
  final DateTime startedAt;
  final DateTime submittedAt;

  int get totalQuestions => records.length;

  int get correctCount => records.where((record) => record.isCorrect).length;

  Duration get elapsed => submittedAt.difference(startedAt);
}

class QuizAnswerRecord {
  const QuizAnswerRecord({
    required this.question,
    required this.submittedAnswer,
    required this.isCorrect,
    required this.answeredAt,
  });

  final Question question;
  final String submittedAnswer;
  final bool isCorrect;
  final DateTime answeredAt;
}
