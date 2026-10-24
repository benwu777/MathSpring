part of '../main.dart';

class QuestionLibraryPage extends StatefulWidget {
  const QuestionLibraryPage({
    super.key,
    required this.services,
  });

  final AppServices services;

  @override
  State<QuestionLibraryPage> createState() => _QuestionLibraryPageState();
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key, required this.services});

  final AppServices services;

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<_FavoritesPageData> _pageFuture;
  String? _selectedCollectionId;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    final String? learnerId = widget.services.currentLearnerId;
    _pageFuture = learnerId == null
        ? Future<_FavoritesPageData>.value(const _FavoritesPageData.empty())
        : _load(learnerId);
  }

  Future<_FavoritesPageData> _load(String learnerId) async {
    final List<FavoriteQuestionCollection> collections =
        await widget.services.getFavoriteCollections(learnerId);
    final List<FavoriteQuestion> favorites =
        await widget.services.getFavoriteQuestionsInCollection(
      learnerId: learnerId,
      collectionId: _selectedCollectionId ?? 'favorites_all_$learnerId',
    );
    if (favorites.isEmpty) {
      return _FavoritesPageData(
        collections: collections,
        favorites: favorites,
        questionsById: const <String, Question>{},
      );
    }
    final List<QuestionBank> packs =
        await bundled.BundledQuestionBankRepository().loadAllPacks();
    return _FavoritesPageData(
      collections: collections,
      favorites: favorites,
      questionsById: <String, Question>{
        for (final QuestionBank pack in packs)
          for (final Question question in pack.questions) question.id: question,
      },
    );
  }

  Future<void> _addCollection(AppStrings strings) async {
    final TextEditingController controller = TextEditingController();
    final String? name = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(strings.addCollection),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: strings.collectionName),
          onSubmitted: (String value) => Navigator.pop(dialogContext, value),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(strings.cancelLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: Text(strings.saveLabel),
          ),
        ],
      ),
    );
    final String? learnerId = widget.services.currentLearnerId;
    if (name == null || learnerId == null) return;
    await widget.services.createFavoriteCollection(
      learnerId: learnerId,
      name: name,
    );
    if (mounted) setState(_reload);
  }

  Future<void> _editFavoriteCollections({
    required FavoriteQuestion favorite,
    required List<FavoriteQuestionCollection> collections,
    required AppStrings strings,
  }) async {
    final String? learnerId = widget.services.currentLearnerId;
    if (learnerId == null) return;
    final List<FavoriteQuestionCollection> customCollections = collections
        .where((FavoriteQuestionCollection collection) => !collection.isDefault)
        .toList();
    if (customCollections.isEmpty) {
      await _addCollection(strings);
      return;
    }
    final Set<String> initialIds =
        await widget.services.getFavoriteQuestionCollectionIds(
      learnerId: learnerId,
      questionId: favorite.questionId,
    );
    if (!mounted) return;
    final Set<String>? selectedIds = await showDialog<Set<String>>(
      context: context,
      builder: (BuildContext dialogContext) {
        final Set<String> selected = Set<String>.from(initialIds);
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) =>
              AlertDialog(
            title: Text(strings.organizeFavorite),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: customCollections
                    .map((FavoriteQuestionCollection collection) =>
                        CheckboxListTile(
                          value: selected.contains(collection.id),
                          title: Text(collection.name),
                          contentPadding: EdgeInsets.zero,
                          onChanged: (bool? value) => setDialogState(() {
                            if (value ?? false) {
                              selected.add(collection.id);
                            } else {
                              selected.remove(collection.id);
                            }
                          }),
                        ))
                    .toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(strings.cancelLabel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, selected),
                child: Text(strings.saveLabel),
              ),
            ],
          ),
        );
      },
    );
    if (selectedIds == null) return;
    await widget.services.setFavoriteQuestionCollections(
      learnerId: learnerId,
      questionId: favorite.questionId,
      collectionIds: selectedIds,
    );
    if (mounted) setState(_reload);
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.favoritesTitle),
        actions: <Widget>[
          IconButton(
            key: const ValueKey<String>('add_favorite_collection'),
            tooltip: strings.addCollection,
            onPressed: () => _addCollection(strings),
            icon: const Icon(Icons.create_new_folder_outlined),
          ),
        ],
      ),
      body: FutureBuilder<_FavoritesPageData>(
        future: _pageFuture,
        builder:
            (BuildContext context, AsyncSnapshot<_FavoritesPageData> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final _FavoritesPageData data = snapshot.data!;
          final List<FavoriteQuestionCollection> collections = data.collections;
          final String? selectedId = _selectedCollectionId ??
              (collections.isEmpty ? null : collections.first.id);
          return ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              if (collections.isNotEmpty)
                DropdownButtonFormField<String>(
                  key: const ValueKey<String>('favorite_collection_picker'),
                  initialValue: selectedId,
                  decoration:
                      InputDecoration(labelText: strings.favoritesTitle),
                  items: collections
                      .map((FavoriteQuestionCollection collection) =>
                          DropdownMenuItem<String>(
                            value: collection.id,
                            child: Text(collection.isDefault
                                ? strings.allFavorites
                                : collection.name),
                          ))
                      .toList(),
                  onChanged: (String? value) => setState(() {
                    _selectedCollectionId = value;
                    _reload();
                  }),
                ),
              const SizedBox(height: 24),
              if (data.favorites.isEmpty)
                _FavoriteEmptyState(message: strings.favoritesEmpty)
              else
                ...data.favorites.map((FavoriteQuestion favorite) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _FavoriteQuestionCard(
                        favorite: favorite,
                        question: data.questionsById[favorite.questionId],
                        onOrganize: () => _editFavoriteCollections(
                          favorite: favorite,
                          collections: collections,
                          strings: strings,
                        ),
                        onOpen: data.questionsById[favorite.questionId] == null
                            ? null
                            : () => _openQuestion(
                                data.questionsById[favorite.questionId]!),
                      ),
                    )),
            ],
          );
        },
      ),
    );
  }

  void _openQuestion(Question question) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => PracticeSessionPage(
        services: widget.services,
        pack: bundled.BundledQuestionPackInfo(
          path: '',
          topic: question.topic,
          topicCode: question.topic,
          levelStage: question.levelStage,
          challengeTier: question.challengeTier,
          questionCount: 1,
        ),
        initialQuestions: <Question>[question],
      ),
    ));
  }
}

class _FavoritesPageData {
  const _FavoritesPageData({
    required this.collections,
    required this.favorites,
    required this.questionsById,
  });

  const _FavoritesPageData.empty()
      : collections = const <FavoriteQuestionCollection>[],
        favorites = const <FavoriteQuestion>[],
        questionsById = const <String, Question>{};

  final List<FavoriteQuestionCollection> collections;
  final List<FavoriteQuestion> favorites;
  final Map<String, Question> questionsById;
}

class _FavoriteEmptyState extends StatelessWidget {
  const _FavoriteEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 28),
          child: Column(
            children: <Widget>[
              const Icon(Icons.bookmark_border_rounded,
                  size: 48, color: AppVisualTokens.primary),
              const SizedBox(height: 14),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
}

class _FavoriteQuestionCard extends StatelessWidget {
  const _FavoriteQuestionCard({
    required this.favorite,
    required this.question,
    required this.onOpen,
    required this.onOrganize,
  });

  final FavoriteQuestion favorite;
  final Question? question;
  final VoidCallback? onOpen;
  final VoidCallback onOrganize;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          onTap: onOpen,
          leading: const Icon(Icons.bookmark_rounded),
          title: Text(
            question?.localizedPrompt(_localeCode(context)) ??
                favorite.questionId,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(favorite.note.isEmpty
              ? favorite.tags.join(' · ')
              : favorite.note),
          trailing: IconButton(
            key: ValueKey<String>('organize_favorite_${favorite.questionId}'),
            tooltip: AppStrings.of(context).organizeFavorite,
            onPressed: onOrganize,
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ),
      );
}

class AnswerHistoryPage extends StatelessWidget {
  const AnswerHistoryPage({
    super.key,
    required this.services,
    this.initialQuestionsById,
  });

  final AppServices services;
  final Map<String, Question>? initialQuestionsById;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final String? learnerId = services.currentLearnerId;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.historyTitle),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<AnswerSession>>(
        future: learnerId == null
            ? Future<List<AnswerSession>>.value(const [])
            : services.getLearnerAnswerSessions(learnerId),
        builder: (context, snapshot) {
          final List<AnswerSession> sessions = snapshot.data ?? const [];
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (sessions.isEmpty) {
            return Center(
              child: Text(strings.historyEmpty),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: sessions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final AnswerSession session = sessions[index];
              return InkWell(
                key: ValueKey<String>('history_session_${session.id}'),
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SessionDetailPage(
                        services: services,
                        session: session,
                        initialQuestionsById: initialQuestionsById,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.mode == 'quiz'
                            ? strings.quizMode
                            : strings.practiceMode,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _displayTopicCode(session.topicCode, strings),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${session.correctCount} / ${session.totalQuestions} ${strings.correctSuffix}',
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${strings.elapsedLabel} ${_formatElapsed(Duration(seconds: session.elapsedSeconds))}',
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatSessionEndedAt(session.endedAtIso),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SessionDetailPage extends StatelessWidget {
  const SessionDetailPage({
    super.key,
    required this.services,
    required this.session,
    this.initialQuestionsById,
  });

  final AppServices services;
  final AnswerSession session;
  final Map<String, Question>? initialQuestionsById;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.sessionDetailTitle),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<SessionAnswerRecord>>(
        future: services.getSessionAnswerRecords(session.id),
        builder: (context, snapshot) {
          final List<SessionAnswerRecord> records = snapshot.data ?? const [];
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return FutureBuilder<List<Question?>>(
            future: _loadQuestions(records),
            builder: (context, questionSnapshot) {
              final List<Question?> questions = questionSnapshot.data ??
                  List<Question?>.filled(records.length, null);
              if (!questionSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: records.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final SessionAnswerRecord record = records[index];
                  final Question? question = questions[index];
                  return Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.questionLabelWithNumber(index + 1),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        _ResultStatusBadge(
                          label: record.isCorrect
                              ? strings.correctLabel
                              : strings.incorrectLabel,
                          isCorrect: record.isCorrect,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          strings.yourAnswerLabel(
                            _displaySubmittedAnswer(
                              question,
                              record.submittedAnswer,
                              _localeCode(context),
                            ),
                          ),
                        ),
                        if (question != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            question.localizedPrompt(_localeCode(context)),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          if (question.source?.displayLabel != null) ...[
                            const SizedBox(height: 8),
                            _QuestionSourceText(
                              text: question.source!.displayLabel!,
                            ),
                          ],
                          if (question.figure.kind != 'none') ...[
                            const SizedBox(height: 16),
                            _QuestionFigureView(question: question),
                          ],
                          const SizedBox(height: 8),
                          Text(question.localizedAnswer(_localeCode(context))),
                          const SizedBox(height: 10),
                          _SolutionStepsGate(
                            services: services,
                            questionId: question.id,
                            steps: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final String step
                                    in question.localizedSolutionSteps(
                                        _localeCode(context)))
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(step),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Question?>> _loadQuestions(
      List<SessionAnswerRecord> records) async {
    final bundled.BundledQuestionBankRepository repository =
        bundled.BundledQuestionBankRepository();
    final List<Question?> questions = <Question?>[];

    for (final SessionAnswerRecord record in records) {
      final Question? injectedQuestion =
          initialQuestionsById?[record.questionId];
      if (injectedQuestion != null) {
        questions.add(injectedQuestion);
        continue;
      }

      questions.add(
        await repository.loadQuestionForSession(
          topicCode: session.topicCode,
          levelStage: session.levelStage,
          challengeTier: session.challengeTier,
          questionId: record.questionId,
        ),
      );
    }

    return questions;
  }
}

class _QuestionLibraryPageState extends State<QuestionLibraryPage> {
  late final Future<bundled.BundledQuestionManifest> _manifestFuture;

  @override
  void initState() {
    super.initState();
    _manifestFuture = bundled.BundledQuestionBankRepository().loadManifest();
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.libraryTitle),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<bundled.BundledQuestionManifest>(
        future: _manifestFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<bundled.BundledQuestionPackInfo> packs =
              snapshot.data!.packs;
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: packs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final bundled.BundledQuestionPackInfo pack = packs[index];
              return _QuestionPackTile(
                pack: pack,
                strings: strings,
                onStartPractice: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => PracticeSessionPage(
                        services: widget.services,
                        pack: pack,
                      ),
                    ),
                  );
                },
                onStartQuiz: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QuizSessionPage(
                        services: widget.services,
                        pack: pack,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _QuestionPackTile extends StatelessWidget {
  const _QuestionPackTile({
    required this.pack,
    required this.strings,
    required this.onStartPractice,
    required this.onStartQuiz,
  });

  final bundled.BundledQuestionPackInfo pack;
  final AppStrings strings;
  final VoidCallback onStartPractice;
  final VoidCallback onStartQuiz;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayTopicCode(pack.topicCode, strings),
            style: TextStyle(
              fontSize: layoutSpec.titleText,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${_displayLevelStage(pack.levelStage, strings)} · ${_displayTier(pack.challengeTier, strings)}',
            style: TextStyle(
              fontSize: layoutSpec.scaleText(14),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoPill(
                label:
                    '${pack.questionCount} ${strings.questionCountLabel(pack.questionCount)}',
              ),
              const SizedBox(width: 10),
              _InfoPill(label: displayTopicCode(pack.topicCode, strings)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: ValueKey<String>('start_practice_${pack.topicCode}'),
                  onPressed: onStartPractice,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF111827),
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: Color(0xFFD1D5DB)),
                  ),
                  child: Text(strings.startPractice),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  key: ValueKey<String>('start_quiz_${pack.topicCode}'),
                  onPressed: onStartQuiz,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(strings.startQuiz),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
