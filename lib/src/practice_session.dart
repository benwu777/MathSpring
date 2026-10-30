part of '../main.dart';

class PracticeSessionPage extends StatefulWidget {
  const PracticeSessionPage({
    super.key,
    required this.services,
    required this.pack,
    this.initialQuestions,
    this.learner,
  });

  final AppServices services;
  final bundled.BundledQuestionPackInfo pack;
  final List<Question>? initialQuestions;
  final LearnerProfile? learner;

  @override
  State<PracticeSessionPage> createState() => _PracticeSessionPageState();
}

class _PracticeSessionPageState extends State<PracticeSessionPage> {
  late final Future<QuestionBank> _packFuture;
  final DateTime _startedAt = DateTime.now();
  final List<PracticeAnswerRecord> _records = <PracticeAnswerRecord>[];
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _reviewCardKey = GlobalKey();
  int _currentIndex = 0;
  bool _isReviewing = false;
  bool _isCurrentQuestionFavorite = false;
  PracticeAnswerRecord? _latestRecord;

  @override
  void initState() {
    super.initState();
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
    _loadFavoriteForCurrentQuestion();
  }

  Future<void> _loadFavoriteForCurrentQuestion() async {
    final QuestionBank bank = await _packFuture;
    final Question question =
        bank.questions[_currentIndex % bank.questions.length];
    final bool value = await widget.services.isFavoriteQuestion(
      learnerId: widget.services.currentLearnerId ?? 'unknown',
      questionId: question.id,
    );
    if (mounted) setState(() => _isCurrentQuestionFavorite = value);
  }

  Future<void> _toggleFavorite(Question question) async {
    final bool value = await widget.services.toggleFavoriteQuestion(
      learnerId: widget.services.currentLearnerId ?? 'unknown',
      questionId: question.id,
    );
    if (!mounted) return;
    setState(() => _isCurrentQuestionFavorite = value);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value
          ? AppStrings.of(context).favoriteAdded
          : AppStrings.of(context).favoriteRemoved),
      duration: const Duration(seconds: 1),
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    final AppStrings strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const ValueKey<String>('close_practice_session'),
          onPressed: () async {
            await _openSummary();
          },
          icon: const Icon(Icons.close),
        ),
        title: Text(strings.practiceMode),
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
          final Question question = questions[_currentIndex % questions.length];
          return ContentScrollView(
            controller: _scrollController,
            fill: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  key: const ValueKey<String>('practice_question_header'),
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
                          '${strings.questionLabel} ${_records.length + 1}',
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
                        onPressed: () => _toggleFavorite(question),
                        icon: Icon(_isCurrentQuestionFavorite
                            ? Icons.bookmark
                            : Icons.bookmark_border),
                      ),
                      Container(
                        key: const ValueKey<String>('question_meta_badge'),
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
                const SizedBox(height: 16),
                // 撐滿剩餘高度：換題時卡片的位置與大小固定，
                // 不會因為每題文字長短而上下跳。
                Expanded(
                  child: _SectionCard(
                    cardKey: const ValueKey<String>('study_surface_card'),
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
                        _PracticeAnswerSection(
                          question: question,
                          localeCode: _localeCode(context),
                          strings: strings,
                          isLocked: _isReviewing,
                          onSubmitted: (answer) {
                            _handleSubmittedAnswer(
                              question: question,
                              submittedAnswer: answer,
                            );
                          },
                        ),
                        if (_latestRecord != null && _isReviewing) ...[
                          const SizedBox(height: 20),
                          _PracticeReviewCard(
                            key: _reviewCardKey,
                            services: widget.services,
                            record: _latestRecord!,
                            localeCode: _localeCode(context),
                            nextLabel: strings.nextQuestion,
                            onNext: _goToNextQuestion,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleSubmittedAnswer({
    required Question question,
    required String submittedAnswer,
  }) async {
    if (_isReviewing) {
      return;
    }

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

    final PracticeAnswerRecord record = PracticeAnswerRecord(
      question: question,
      submittedAnswer: submittedAnswer,
      isCorrect: isCorrect,
      answeredAt: DateTime.now(),
    );

    setState(() {
      _records.add(record);
      _latestRecord = record;
      _isReviewing = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToReviewCard();
    });
  }

  void _goToNextQuestion() {
    if (!_isReviewing) {
      return;
    }
    setState(() {
      _currentIndex++;
      _isReviewing = false;
      _latestRecord = null;
      _isCurrentQuestionFavorite = false;
    });
    _loadFavoriteForCurrentQuestion();
  }

  Future<void> _scrollToReviewCard() async {
    if (!mounted || !_scrollController.hasClients) {
      return;
    }
    final double targetOffset = _scrollController.position.maxScrollExtent;

    await _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _openSummary() async {
    final PracticeSessionResult result = PracticeSessionResult(
      records: List<PracticeAnswerRecord>.unmodifiable(_records),
      startedAt: _startedAt,
      endedAt: DateTime.now(),
    );
    final String sessionId =
        'practice_${widget.services.currentLearnerId ?? 'unknown'}_${result.endedAt.microsecondsSinceEpoch}';
    await widget.services.saveAnswerSession(
      session: AnswerSession(
        id: sessionId,
        learnerId: widget.services.currentLearnerId ?? 'unknown',
        mode: 'practice',
        topicCode: widget.pack.topicCode,
        levelStage: widget.pack.levelStage,
        challengeTier: widget.pack.challengeTier,
        startedAtIso: result.startedAt.toUtc().toIso8601String(),
        endedAtIso: result.endedAt.toUtc().toIso8601String(),
        elapsedSeconds: result.elapsed.inSeconds,
        totalQuestions: result.totalQuestions,
        correctCount: result.correctCount,
      ),
      records: [
        for (int index = 0; index < result.records.length; index++)
          SessionAnswerRecord(
            sessionId: sessionId,
            questionId: result.records[index].question.id,
            sequence: index + 1,
            submittedAnswer: result.records[index].submittedAnswer,
            isCorrect: result.records[index].isCorrect,
            answeredAtIso:
                result.records[index].answeredAt.toUtc().toIso8601String(),
          ),
      ],
    );

    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => PracticeSummaryPage(
          result: result,
        ),
      ),
    );
  }
}

class _PracticeAnswerSection extends StatefulWidget {
  const _PracticeAnswerSection({
    required this.question,
    required this.localeCode,
    required this.strings,
    required this.isLocked,
    required this.onSubmitted,
  });

  final Question question;
  final String localeCode;
  final AppStrings strings;
  final bool isLocked;
  final ValueChanged<String> onSubmitted;

  @override
  State<_PracticeAnswerSection> createState() => _PracticeAnswerSectionState();
}

class _PracticeAnswerSectionState extends State<_PracticeAnswerSection> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = _createControllers();
  }

  @override
  void didUpdateWidget(covariant _PracticeAnswerSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      for (final TextEditingController controller in _controllers) {
        controller.dispose();
      }
      _controllers = _createControllers();
    }
  }

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<TextEditingController> _createControllers() => <TextEditingController>[
        for (final String _ in widget.question.correctAnswer.orderedValues)
          TextEditingController(),
      ];

  @override
  Widget build(BuildContext context) {
    switch (widget.question.answerMode) {
      case AnswerMode.multipleChoice:
        final List<String> keys = (widget.question.options?.keys.toList() ?? [])
          ..sort();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final String key in keys)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OutlinedButton(
                  key: ValueKey<String>(
                      'practice_option_${widget.question.id}_$key'),
                  onPressed:
                      widget.isLocked ? null : () => widget.onSubmitted(key),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _QuestionOptionText(
                    key: ValueKey<String>(
                      'question_option_text_${widget.question.id}_$key',
                    ),
                    text: widget.question
                        .optionDisplayLabel(key, widget.localeCode),
                    localeCode: widget.localeCode,
                  ),
                ),
              ),
          ],
        );
      case AnswerMode.integerInput:
        final List<String> labels = widget.question.correctAnswer
            .localizedInputLabels(widget.localeCode);
        final bool hasMultipleAnswers = _controllers.length > 1;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int index = 0; index < _controllers.length; index++) ...[
              if (hasMultipleAnswers) ...[
                Text(
                  index < labels.length
                      ? labels[index]
                      : widget.strings.answerFieldLabel(index + 1),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
              ],
              TextField(
                key: ValueKey<String>(
                  hasMultipleAnswers
                      ? 'practice_integer_input_${widget.question.id}_$index'
                      : 'practice_integer_input_${widget.question.id}',
                ),
                controller: _controllers[index],
                enabled: !widget.isLocked,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: widget.strings.integerHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              if (index < _controllers.length - 1) const SizedBox(height: 12),
            ],
            const SizedBox(height: 12),
            FilledButton(
              key: ValueKey<String>('submit_answer_${widget.question.id}'),
              onPressed: widget.isLocked
                  ? null
                  : () {
                      final List<String> values = <String>[
                        for (final TextEditingController controller
                            in _controllers)
                          controller.text.trim(),
                      ];
                      if (values.any((String value) => value.isEmpty)) {
                        return;
                      }
                      widget.onSubmitted(_encodeIntegerAnswers(values));
                    },
              style: FilledButton.styleFrom(),
              child: Text(widget.strings.submitAnswer),
            ),
          ],
        );
      case AnswerMode.selfCheck:
        return Text(widget.strings.selfCheckLabel);
    }
  }
}

class _PracticeReviewCard extends StatelessWidget {
  const _PracticeReviewCard({
    super.key,
    required this.services,
    required this.record,
    required this.localeCode,
    required this.nextLabel,
    required this.onNext,
  });

  final AppServices services;
  final PracticeAnswerRecord record;
  final String localeCode;
  final String nextLabel;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: record.isCorrect
            ? AppVisualTokens.celebrationSoft
            : AppVisualTokens.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppVisualTokens.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ResultStatusBadge(
                  label: record.isCorrect
                      ? strings.correctLabel
                      : strings.incorrectLabel,
                  isCorrect: record.isCorrect,
                ),
              ),
              OtterCompanion(
                pose: record.isCorrect
                    ? OtterPose.celebrating
                    : OtterPose.thinking,
                size: 64,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (record.question.figure.kind != 'none') ...[
            _QuestionFigureView(question: record.question),
            const SizedBox(height: 16),
          ],
          _QuestionBodyText(
            text: record.question.localizedAnswer(localeCode),
            localeCode: localeCode,
          ),
          const SizedBox(height: 10),
          _SolutionStepsGate(
            services: services,
            questionId: record.question.id,
            steps: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final String step
                    in record.question.localizedSolutionSteps(localeCode))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _QuestionBodyText(
                      text: step,
                      localeCode: localeCode,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(),
              child: Text(nextLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class PracticeSummaryPage extends StatelessWidget {
  const PracticeSummaryPage({
    super.key,
    required this.result,
  });

  final PracticeSessionResult result;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.practiceSummary),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: ContentScrollView(
        fill: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 撐滿剩餘高度，畫面不會依內容長短留下大片空白
            Expanded(
              child: _SectionCard(
                title: strings.practiceSummary,
                subtitle:
                    '${result.correctCount} / ${result.totalQuestions} ${strings.correctSuffix}',
                child: Column(
                  children: [
                    _StatRow(
                      leftValue: '${result.totalQuestions}',
                      leftLabel: strings.solvedLabel,
                      rightValue: '${result.accuracyRate.round()}%',
                      rightLabel: strings.accuracyLabel,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PracticeSessionResult {
  const PracticeSessionResult({
    required this.records,
    required this.startedAt,
    required this.endedAt,
  });

  final List<PracticeAnswerRecord> records;
  final DateTime startedAt;
  final DateTime endedAt;

  int get totalQuestions => records.length;

  int get correctCount => records.where((record) => record.isCorrect).length;

  double get accuracyRate =>
      totalQuestions == 0 ? 0 : (correctCount / totalQuestions) * 100;

  Duration get elapsed => endedAt.difference(startedAt);
}

class PracticeAnswerRecord {
  const PracticeAnswerRecord({
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
