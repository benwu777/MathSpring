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
  const FavoritesPage({
    super.key,
    required this.services,
    this.initialQuestionsById,
  });

  final AppServices services;
  final Map<String, Question>? initialQuestionsById;

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
    // A deleted collection falls back to all favorites.
    final String selectedId = collections.any(
            (FavoriteQuestionCollection c) => c.id == _selectedCollectionId)
        ? _selectedCollectionId!
        : 'favorites_all_$learnerId';
    _selectedCollectionId = selectedId;
    final List<FavoriteQuestion> favorites =
        await widget.services.getFavoriteQuestionsInCollection(
      learnerId: learnerId,
      collectionId: selectedId,
    );
    final Map<String, Set<String>> collectionIdsByQuestion =
        <String, Set<String>>{
      for (final FavoriteQuestion favorite in favorites)
        favorite.questionId:
            await widget.services.getFavoriteQuestionCollectionIds(
          learnerId: learnerId,
          questionId: favorite.questionId,
        ),
    };
    final Map<String, Question> questionsById = <String, Question>{
      ...?widget.initialQuestionsById,
    };
    if (favorites.isNotEmpty && widget.initialQuestionsById == null) {
      final List<QuestionBank> packs =
          await bundled.BundledQuestionBankRepository().loadAllPacks();
      for (final QuestionBank pack in packs) {
        for (final Question question in pack.questions) {
          questionsById[question.id] = question;
        }
      }
    }
    return _FavoritesPageData(
      collections: collections,
      selectedCollectionId: selectedId,
      favorites: favorites,
      collectionIdsByQuestion: collectionIdsByQuestion,
      questionsById: questionsById,
    );
  }

  Future<void> _manageCollections() async {
    final String? learnerId = widget.services.currentLearnerId;
    if (learnerId == null) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _ManageCollectionsSheet(
        services: widget.services,
        learnerId: learnerId,
      ),
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
      await _manageCollections();
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
                          secondary: _CollectionColorDot(
                              colorKey: collection.colorKey),
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

  Future<void> _editFavoriteDetails(FavoriteQuestion favorite) async {
    final String? learnerId = widget.services.currentLearnerId;
    if (learnerId == null) return;
    final List<String> usedTags =
        await widget.services.getUsedFavoriteTags(learnerId);
    if (!mounted) return;
    final _FavoriteDetails? details =
        await showModalBottomSheet<_FavoriteDetails>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) =>
          _FavoriteDetailsSheet(favorite: favorite, usedTags: usedTags),
    );
    if (details == null) return;
    await widget.services.updateFavoriteDetails(
      learnerId: learnerId,
      questionId: favorite.questionId,
      note: details.note,
      tags: details.tags,
    );
    if (mounted) setState(_reload);
  }

  Future<void> _removeFavorite(FavoriteQuestion favorite) async {
    final String? learnerId = widget.services.currentLearnerId;
    if (learnerId == null) return;
    await widget.services.toggleFavoriteQuestion(
      learnerId: learnerId,
      questionId: favorite.questionId,
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
            key: const ValueKey<String>('manage_favorite_collections'),
            tooltip: strings.manageCollections,
            onPressed: _manageCollections,
            icon:
                const Icon(Icons.tune_rounded, color: AppVisualTokens.progress),
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
          final Map<String, FavoriteQuestionCollection> collectionsById =
              <String, FavoriteQuestionCollection>{
            for (final FavoriteQuestionCollection collection in collections)
              collection.id: collection,
          };
          return ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              if (collections.isNotEmpty)
                DropdownButtonFormField<String>(
                  key: const ValueKey<String>('favorite_collection_picker'),
                  initialValue: data.selectedCollectionId,
                  decoration:
                      InputDecoration(labelText: strings.favoritesTitle),
                  items: collections
                      .map((FavoriteQuestionCollection collection) =>
                          DropdownMenuItem<String>(
                            value: collection.id,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (!collection.isDefault) ...<Widget>[
                                  _CollectionColorDot(
                                      colorKey: collection.colorKey, size: 10),
                                  const SizedBox(width: 8),
                                ],
                                Text(collection.isDefault
                                    ? strings.allFavorites
                                    : collection.name),
                              ],
                            ),
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
                ...data.favorites.map((FavoriteQuestion favorite) {
                  final Question? question =
                      data.questionsById[favorite.questionId];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _FavoriteQuestionCard(
                      favorite: favorite,
                      question: question,
                      collections: <FavoriteQuestionCollection>[
                        for (final FavoriteQuestionCollection collection
                            in collections)
                          if (!collection.isDefault &&
                              (data.collectionIdsByQuestion[
                                          favorite.questionId] ??
                                      const <String>{})
                                  .contains(collection.id))
                            collectionsById[collection.id]!,
                      ],
                      onOrganize: () => _editFavoriteCollections(
                        favorite: favorite,
                        collections: collections,
                        strings: strings,
                      ),
                      onEditDetails: () => _editFavoriteDetails(favorite),
                      onRemove: () => _removeFavorite(favorite),
                      onOpen: question == null
                          ? null
                          : () => _openQuestion(question),
                    ),
                  );
                }),
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
    required this.selectedCollectionId,
    required this.favorites,
    required this.collectionIdsByQuestion,
    required this.questionsById,
  });

  const _FavoritesPageData.empty()
      : collections = const <FavoriteQuestionCollection>[],
        selectedCollectionId = null,
        favorites = const <FavoriteQuestion>[],
        collectionIdsByQuestion = const <String, Set<String>>{},
        questionsById = const <String, Question>{};

  final List<FavoriteQuestionCollection> collections;
  final String? selectedCollectionId;
  final List<FavoriteQuestion> favorites;
  final Map<String, Set<String>> collectionIdsByQuestion;
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
    required this.collections,
    required this.onOpen,
    required this.onOrganize,
    required this.onEditDetails,
    required this.onRemove,
  });

  final FavoriteQuestion favorite;
  final Question? question;
  final List<FavoriteQuestionCollection> collections;
  final VoidCallback? onOpen;
  final VoidCallback onOrganize;
  final VoidCallback onEditDetails;
  final VoidCallback onRemove;

  static Widget _pill({
    Key? key,
    required String label,
    required Color background,
    required Color foreground,
  }) =>
      Container(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: foreground),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: AppVisualTokens.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppVisualTokens.outline),
        boxShadow: const <BoxShadow>[
          BoxShadow(
              color: Color(0x0A17201D), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 4, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          question?.localizedPrompt(_localeCode(context)) ??
                              favorite.questionId,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyLarge?.copyWith(height: 1.5),
                        ),
                      ),
                    ),
                    PopupMenuButton<_FavoriteAction>(
                      key: ValueKey<String>(
                          'favorite_actions_${favorite.questionId}'),
                      tooltip: strings.organizeFavorite,
                      icon: const Icon(Icons.more_horiz_rounded),
                      onSelected: (_FavoriteAction action) => switch (action) {
                        _FavoriteAction.organize => onOrganize(),
                        _FavoriteAction.editDetails => onEditDetails(),
                        _FavoriteAction.remove => onRemove(),
                      },
                      itemBuilder: (_) => <PopupMenuEntry<_FavoriteAction>>[
                        PopupMenuItem<_FavoriteAction>(
                          value: _FavoriteAction.organize,
                          child: Text(strings.organizeFavorite),
                        ),
                        PopupMenuItem<_FavoriteAction>(
                          value: _FavoriteAction.editDetails,
                          child: Text(strings.editTagsAndNote),
                        ),
                        PopupMenuItem<_FavoriteAction>(
                          value: _FavoriteAction.remove,
                          child: Text(strings.removeFavorite),
                        ),
                      ],
                    ),
                  ],
                ),
                if (collections.isNotEmpty ||
                    favorite.tags.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: <Widget>[
                      for (final FavoriteQuestionCollection collection
                          in collections)
                        _pill(
                          key: ValueKey<String>(
                              'favorite_collection_chip_${favorite.questionId}_${collection.id}'),
                          label: collection.name,
                          background:
                              FavoriteCollectionPalette.of(collection.colorKey)
                                  .soft,
                          foreground:
                              FavoriteCollectionPalette.of(collection.colorKey)
                                  .strong,
                        ),
                      for (final String tag in favorite.tags)
                        _pill(
                          label: tag,
                          background: AppVisualTokens.surfaceMuted,
                          foreground: AppVisualTokens.inkMuted,
                        ),
                    ],
                  ),
                ],
                if (favorite.note.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      favorite.note,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall
                          ?.copyWith(color: AppVisualTokens.inkMuted),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CollectionColorDot extends StatelessWidget {
  const _CollectionColorDot({required this.colorKey, this.size = 12});

  final String? colorKey;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: FavoriteCollectionPalette.of(colorKey).strong,
          shape: BoxShape.circle,
        ),
      );
}

class _ManageCollectionsSheet extends StatefulWidget {
  const _ManageCollectionsSheet({
    required this.services,
    required this.learnerId,
  });

  final AppServices services;
  final String learnerId;

  @override
  State<_ManageCollectionsSheet> createState() =>
      _ManageCollectionsSheetState();
}

class _ManageCollectionsSheetState extends State<_ManageCollectionsSheet> {
  late Future<
      (
        List<FavoriteQuestionCollection> collections,
        Map<String, int> counts
      )> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = _fetch();
  }

  Future<(List<FavoriteQuestionCollection>, Map<String, int>)> _fetch() async =>
      (
        await widget.services.getFavoriteCollections(widget.learnerId),
        await widget.services.getFavoriteCollectionCounts(widget.learnerId),
      );

  Future<void> _openEditor({
    required List<FavoriteQuestionCollection> collections,
    FavoriteQuestionCollection? collection,
  }) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (_) => _CollectionEditorDialog(
        collection: collection,
        initialColorKey:
            collection?.colorKey ?? nextFavoriteCollectionColor(collections),
        onSubmit: (String name, String colorKey) async {
          if (collection == null) {
            await widget.services.createFavoriteCollection(
              learnerId: widget.learnerId,
              name: name,
              colorKey: colorKey,
            );
          } else {
            await widget.services.updateFavoriteCollection(
              collection: collection,
              name: name,
              colorKey: colorKey,
            );
          }
        },
      ),
    );
    if (saved == true && mounted) setState(_reload);
  }

  Future<void> _delete(FavoriteQuestionCollection collection) async {
    final AppStrings strings = AppStrings.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(strings.deleteCollection),
        content: Text(strings.deleteCollectionConfirm(collection.name)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(strings.cancelLabel),
          ),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: AppVisualTokens.danger),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(strings.deleteLabel),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.services.deleteFavoriteCollection(collection);
    if (mounted) setState(_reload);
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child:
          FutureBuilder<(List<FavoriteQuestionCollection>, Map<String, int>)>(
        future: _future,
        builder: (BuildContext context,
            AsyncSnapshot<(List<FavoriteQuestionCollection>, Map<String, int>)>
                snapshot) {
          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final (
            List<FavoriteQuestionCollection> collections,
            Map<String, int> counts
          ) = snapshot.data!;
          final int customCount = collections
              .where((FavoriteQuestionCollection c) => !c.isDefault)
              .length;
          final bool isFull =
              customCount >= FavoriteQuestionRepository.maxCustomCollections;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(strings.manageCollections, style: textTheme.titleLarge),
                const SizedBox(height: 12),
                for (final FavoriteQuestionCollection collection in collections)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: collection.isDefault
                        ? const Icon(Icons.bookmark_border_rounded,
                            color: AppVisualTokens.inkMuted)
                        : _CollectionColorDot(colorKey: collection.colorKey),
                    minLeadingWidth: 24,
                    title: Text(collection.isDefault
                        ? strings.allFavorites
                        : collection.name),
                    subtitle: Text(strings
                        .favoriteQuestionCount(counts[collection.id] ?? 0)),
                    trailing: collection.isDefault
                        ? Text(strings.fixedCollection,
                            style: textTheme.labelMedium
                                ?.copyWith(color: AppVisualTokens.inkMuted))
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                key: ValueKey<String>(
                                    'edit_favorite_collection_${collection.id}'),
                                tooltip: strings.editCollection,
                                onPressed: () => _openEditor(
                                    collections: collections,
                                    collection: collection),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                key: ValueKey<String>(
                                    'delete_favorite_collection_${collection.id}'),
                                tooltip: strings.deleteCollection,
                                onPressed: () => _delete(collection),
                                icon: const Icon(Icons.delete_outline_rounded),
                              ),
                            ],
                          ),
                  ),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  key: const ValueKey<String>('add_favorite_collection'),
                  onPressed: isFull
                      ? null
                      : () => _openEditor(collections: collections),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(strings.addCollection),
                ),
                if (isFull) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    strings.collectionLimitReached(
                        FavoriteQuestionRepository.maxCustomCollections),
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall
                        ?.copyWith(color: AppVisualTokens.inkMuted),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Creates or edits a collection; [onSubmit] runs inside the dialog so name
/// problems are shown in place instead of closing it.
class _CollectionEditorDialog extends StatefulWidget {
  const _CollectionEditorDialog({
    required this.collection,
    required this.initialColorKey,
    required this.onSubmit,
  });

  final FavoriteQuestionCollection? collection;
  final String initialColorKey;
  final Future<void> Function(String name, String colorKey) onSubmit;

  @override
  State<_CollectionEditorDialog> createState() =>
      _CollectionEditorDialogState();
}

class _CollectionEditorDialogState extends State<_CollectionEditorDialog> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.collection?.name ?? '');
  late String _colorKey = widget.initialColorKey;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppStrings strings) async {
    try {
      await widget.onSubmit(_nameController.text, _colorKey);
    } on FavoriteCollectionNameInvalid catch (error) {
      setState(() => _error = strings.collectionNameError(error.reason));
      return;
    } on FavoriteCollectionLimitReached {
      setState(() => _error = strings.collectionLimitReached(
          FavoriteQuestionRepository.maxCustomCollections));
      return;
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return AlertDialog(
      title: Text(widget.collection == null
          ? strings.addCollection
          : strings.editCollection),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            key: const ValueKey<String>('favorite_collection_name'),
            controller: _nameController,
            autofocus: widget.collection == null,
            maxLength: maxFavoriteCollectionNameLength,
            decoration: InputDecoration(
              labelText: strings.collectionName,
              errorText: _error,
            ),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            onSubmitted: (_) => _submit(strings),
          ),
          const SizedBox(height: 8),
          Text(strings.collectionColor,
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              for (final String key in FavoriteCollectionColors.keys)
                Semantics(
                  label: strings.collectionColorName(key),
                  selected: key == _colorKey,
                  button: true,
                  child: InkWell(
                    key: ValueKey<String>('collection_color_$key'),
                    customBorder: const CircleBorder(),
                    onTap: () => setState(() => _colorKey = key),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: FavoriteCollectionPalette.of(key).strong,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: key == _colorKey
                              ? AppVisualTokens.ink
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: key == _colorKey
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 20)
                          : null,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(strings.cancelLabel),
        ),
        FilledButton(
          onPressed: () => _submit(strings),
          child: Text(strings.saveLabel),
        ),
      ],
    );
  }
}

enum _FavoriteAction { organize, editDetails, remove }

class _FavoriteDetails {
  const _FavoriteDetails({required this.note, required this.tags});

  final String note;
  final List<String> tags;
}

/// Edits a favorite's note and tags; nothing is saved until the learner taps
/// save, which returns the edited [_FavoriteDetails].
class _FavoriteDetailsSheet extends StatefulWidget {
  const _FavoriteDetailsSheet({required this.favorite, required this.usedTags});

  final FavoriteQuestion favorite;
  final List<String> usedTags;

  @override
  State<_FavoriteDetailsSheet> createState() => _FavoriteDetailsSheetState();
}

class _FavoriteDetailsSheetState extends State<_FavoriteDetailsSheet> {
  static const int _maxUsedTagsShown = 15;

  late final TextEditingController _noteController =
      TextEditingController(text: widget.favorite.note);
  final TextEditingController _tagController = TextEditingController();
  final FocusNode _tagFocus = FocusNode();
  late final List<String> _tags = List<String>.from(widget.favorite.tags);

  bool get _isFull => _tags.length >= maxFavoriteTags;

  @override
  void dispose() {
    _noteController.dispose();
    _tagController.dispose();
    _tagFocus.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final List<String> next = normalizeFavoriteTags(<String>[..._tags, tag]);
    setState(() {
      _tags
        ..clear()
        ..addAll(next);
      _tagController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<String> suggestions = widget.usedTags
        .where((String tag) => !_tags.contains(tag))
        .take(_maxUsedTagsShown)
        .toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(strings.editTagsAndNote, style: textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                key: const ValueKey<String>('favorite_note_field'),
                controller: _noteController,
                minLines: 2,
                maxLines: 4,
                maxLength: maxFavoriteNoteLength,
                decoration: InputDecoration(labelText: strings.favoriteNote),
              ),
              const SizedBox(height: 8),
              Text(strings.favoriteTags, style: textTheme.labelLarge),
              const SizedBox(height: 8),
              if (_tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: <Widget>[
                    for (final String tag in _tags)
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: AppVisualTokens.surfaceMuted,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(tag,
                                style: const TextStyle(
                                    color: AppVisualTokens.ink,
                                    fontWeight: FontWeight.w600)),
                            IconButton(
                              key: ValueKey<String>('remove_favorite_tag_$tag'),
                              visualDensity: VisualDensity.compact,
                              iconSize: 16,
                              tooltip: strings.deleteLabel,
                              onPressed: () =>
                                  setState(() => _tags.remove(tag)),
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      key: const ValueKey<String>('favorite_tag_field'),
                      controller: _tagController,
                      focusNode: _tagFocus,
                      enabled: !_isFull,
                      maxLength: maxFavoriteTagLength,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: _isFull
                            ? strings.favoriteTagLimit(maxFavoriteTags)
                            : strings.addFavoriteTagHint,
                        counterText: '',
                      ),
                      onSubmitted: (String value) {
                        _addTag(value);
                        _tagFocus.requestFocus();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed:
                        _isFull ? null : () => _addTag(_tagController.text),
                    child: Text(strings.addFavoriteTag),
                  ),
                ],
              ),
              if (suggestions.isNotEmpty && !_isFull) ...<Widget>[
                const SizedBox(height: 12),
                Text(strings.usedFavoriteTags,
                    style: textTheme.labelMedium
                        ?.copyWith(color: AppVisualTokens.inkMuted)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: <Widget>[
                    for (final String tag in suggestions)
                      ActionChip(
                        key: ValueKey<String>('used_favorite_tag_$tag'),
                        label: Text(tag),
                        avatar: const Icon(Icons.add_rounded, size: 16),
                        onPressed: () => _addTag(tag),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(strings.cancelLabel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => Navigator.pop(
                      context,
                      _FavoriteDetails(
                          note: _noteController.text, tags: List.of(_tags)),
                    ),
                    child: Text(strings.saveLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
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
