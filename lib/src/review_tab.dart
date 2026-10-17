part of '../main.dart';

class _ReviewTab extends StatelessWidget {
  const _ReviewTab({required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    return _LearningReviewSection(services: services);
  }
}

class _LearningReviewSection extends StatefulWidget {
  const _LearningReviewSection({required this.services});

  final AppServices services;

  @override
  State<_LearningReviewSection> createState() => _LearningReviewSectionState();
}

class _LearningReviewSectionState extends State<_LearningReviewSection> {
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final String? learnerId = widget.services.currentLearnerId;
    return FutureBuilder<LearningActivitySummary>(
      future: learnerId == null
          ? Future<LearningActivitySummary>.value(
              LearningActivitySummary.fromSessions(
                sessions: const <AnswerSession>[],
                recordsBySessionId: const <String, List<SessionAnswerRecord>>{},
              ),
            )
          : widget.services.getLearnerLearningActivitySummary(learnerId),
      builder: (BuildContext context,
          AsyncSnapshot<LearningActivitySummary> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final LearningActivitySummary summary = snapshot.data!;
        final List<DateTime> practicedDays = summary.days.keys.toList()..sort();
        final DateTime displayedDay = _selectedDay ??
            (practicedDays.isEmpty ? DateTime.now() : practicedDays.last);
        final LearningDaySummary daySummary = summary.dayFor(displayedDay);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton.outlined(
                key: const ValueKey<String>('open_favorites'),
                tooltip: strings.favoritesTitle,
                icon: const Icon(Icons.bookmark_outline_rounded),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => FavoritesPage(services: widget.services),
                  ));
                },
              ),
            ),
            _CompactHeroBanner(
              title: strings.reviewTitle,
              subtitle: strings.reviewSubtitle,
              icon: Icons.history_edu_rounded,
            ),
            const SizedBox(height: 18),
            _MistakeReviewSection(services: widget.services),
            const SizedBox(height: 18),
            _WeakConceptSection(services: widget.services),
            const SizedBox(height: 18),
            _SectionCard(
              title: strings.achievementsTitle,
              subtitle: strings.achievementsSubtitle,
              child: _AchievementOverview(summary: summary, strings: strings),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              title: strings.calendarTitle,
              subtitle: strings.calendarSubtitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MonthlyLearningCalendar(
                    month: displayedDay,
                    summary: summary,
                    strings: strings,
                    selectedDay: displayedDay,
                    onDaySelected: (DateTime day) {
                      setState(() => _selectedDay = day);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    strings.dayActivityLabel(displayedDay),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    daySummary.questionCount == 0
                        ? strings.calendarNoPractice
                        : strings.dayActivitySummary(
                            daySummary.questionCount,
                            daySummary.accuracyRate,
                          ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => AnswerHistoryPage(
                              services: widget.services,
                            ),
                          ),
                        );
                      },
                      child: Text(strings.viewHistory),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 錯題再練：最近一次作答答錯、還沒訂正的題目。
class _MistakeReviewSection extends StatefulWidget {
  const _MistakeReviewSection({required this.services});

  final AppServices services;

  @override
  State<_MistakeReviewSection> createState() => _MistakeReviewSectionState();
}

class _MistakeReviewSectionState extends State<_MistakeReviewSection> {
  late Future<List<String>> _mistakeIds = _loadMistakeIds();

  AppServices get services => widget.services;

  Future<List<String>> _loadMistakeIds() {
    final String? learnerId = services.currentLearnerId;
    return learnerId == null
        ? Future<List<String>>.value(const <String>[])
        : services.getLearnerMistakeQuestionIds(learnerId);
  }

  Future<void> _practiceMistakes(List<String> mistakeIds) async {
    await _openMistakePractice(
      context: context,
      services: services,
      mistakeQuestionIds: mistakeIds,
    );
    if (mounted) {
      // 練完回來，答對的題目要從清單消失
      setState(() => _mistakeIds = _loadMistakeIds());
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return FutureBuilder<List<String>>(
      future: _mistakeIds,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        final List<String> mistakeIds = snapshot.data ?? const <String>[];
        return _SectionCard(
          title: strings.mistakePracticeTitle,
          subtitle: strings.mistakePracticeSubtitle,
          child: mistakeIds.isEmpty
              ? Text(strings.noMistakesToFix)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.mistakesToFix(mistakeIds.length),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        key: const ValueKey<String>('start_mistake_practice'),
                        onPressed: () => _practiceMistakes(mistakeIds),
                        child: Text(strings.startMistakePractice),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

/// 需要加強的概念：依作答紀錄找出答對率偏低的 `c:` 概念。
class _WeakConceptSection extends StatefulWidget {
  const _WeakConceptSection({required this.services});

  final AppServices services;

  @override
  State<_WeakConceptSection> createState() => _WeakConceptSectionState();
}

class _WeakConceptSectionState extends State<_WeakConceptSection> {
  static const int _shownCount = 3;

  // 只在進入複習頁時讀一次，切換日曆日期不重讀題庫
  late final Future<ConceptMastery> _mastery = _loadMastery();

  AppServices get services => widget.services;

  Future<ConceptMastery> _loadMastery() async {
    final String? learnerId = services.currentLearnerId;
    if (learnerId == null) {
      return ConceptMastery.fromRecords(
        const <SessionAnswerRecord>[],
        conceptTagsByQuestionId: const <String, List<String>>{},
      );
    }
    final List<SessionAnswerRecord> records =
        await services.getLearnerAnswerRecords(learnerId);
    final List<Question> questions =
        await bundled.BundledQuestionBankRepository().loadQuestionsByIds(records
            .map((SessionAnswerRecord record) => record.questionId)
            .toSet()
            .toList());
    return ConceptMastery.fromRecords(
      records,
      conceptTagsByQuestionId: <String, List<String>>{
        for (final Question question in questions)
          question.id: question.conceptTags,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final Locale locale = Localizations.localeOf(context);
    return FutureBuilder<ConceptMastery>(
      future: _mastery,
      builder: (BuildContext context, AsyncSnapshot<ConceptMastery> snapshot) {
        final ConceptMastery? mastery = snapshot.data;
        final List<String> weak =
            mastery?.weakConcepts.take(_shownCount).toList() ??
                const <String>[];
        return _SectionCard(
          title: strings.weakConceptsTitle,
          subtitle: strings.weakConceptsSubtitle,
          child: weak.isEmpty
              ? Text(strings.noWeakConcepts)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final String concept in weak)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          strings.conceptAccuracy(
                            conceptLabel(concept, locale),
                            mastery!.statsFor(concept)!.correct,
                            mastery.statsFor(concept)!.attempts,
                          ),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class _AchievementOverview extends StatelessWidget {
  const _AchievementOverview({required this.summary, required this.strings});

  final LearningActivitySummary summary;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final List<Widget> badges = <Widget>[
      _AchievementBadge(
        label: strings.streakAchievement(
            summary.currentStreak, summary.longestStreak),
        icon: Icons.local_fire_department_outlined,
      ),
      _AchievementBadge(
        label: strings.recoveryAchievement(summary.recoveredWrongAnswerCount),
        icon: Icons.restart_alt_rounded,
      ),
      ...summary.topicQuestionCounts.entries
          .expand((MapEntry<String, int> entry) {
        return summary.reachedTopicMilestones(entry.key).map(
              (int milestone) => _AchievementBadge(
                label: strings.topicAchievement(
                  _displayTopicCode(entry.key, strings),
                  milestone,
                ),
                icon: Icons.workspace_premium_outlined,
              ),
            );
      }),
    ];
    if (badges.isEmpty) {
      return Text(strings.achievementsEmpty);
    }
    return Wrap(spacing: 10, runSpacing: 10, children: badges);
  }
}

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppVisualTokens.brand),
          const SizedBox(width: 6),
          // 成就文字必須可壓縮：外層是 Wrap，寬度受限於一行的可用空間，
          // 英文的成就描述比中文長，在 390pt 上會把徽章自己的 Row 撐爆 34px。
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyLearningCalendar extends StatelessWidget {
  const _MonthlyLearningCalendar({
    required this.month,
    required this.summary,
    required this.strings,
    required this.selectedDay,
    required this.onDaySelected,
  });

  final DateTime month;
  final LearningActivitySummary summary;
  final AppStrings strings;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final DateTime firstDay = DateTime(month.year, month.month);
    final int dayCount = DateTime(month.year, month.month + 1, 0).day;
    final int leadingEmptyCells = firstDay.weekday % 7;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(strings.monthLabel(month),
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        // 星期標題列：欄位寬度與下方日期格完全一致，靠同一個 Row 結構保證對齊
        Row(
          children: <Widget>[
            for (int i = 0; i < 7; i++) ...<Widget>[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: Center(
                  child: Text(
                    AppStrings.of(context).weekdayHeaders[i],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
                        ),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        // 用 Column + Row 而不是 GridView：一個月最多 6×7 = 42 格，
        // 不需要延遲建構；而 GridView 是 viewport，無法回報 intrinsic 高度，
        // 會讓外層的滿版模式（IntrinsicHeight）整個炸掉。
        ..._buildCalendarRows(
          leadingEmptyCells: leadingEmptyCells,
          dayCount: dayCount,
          month: month,
          summary: summary,
          selectedDay: selectedDay,
          onDaySelected: onDaySelected,
        ),
      ],
    );
  }
}

/// 月曆的日期格，一列七天。
///
/// 刻意不用 `GridView`：一個月最多 42 格，延遲建構沒有意義，
/// 而 viewport 無法回報 intrinsic 高度，會擋住外層的滿版模式。
List<Widget> _buildCalendarRows({
  required int leadingEmptyCells,
  required int dayCount,
  required DateTime month,
  required LearningActivitySummary summary,
  required DateTime selectedDay,
  required ValueChanged<DateTime> onDaySelected,
}) {
  const double spacing = 6;
  final int cellCount = leadingEmptyCells + dayCount;
  final int rowCount = (cellCount / 7).ceil();
  final List<Widget> rows = <Widget>[];
  for (int row = 0; row < rowCount; row++) {
    final List<Widget> cells = <Widget>[];
    for (int col = 0; col < 7; col++) {
      final int index = row * 7 + col;
      if (col > 0) {
        cells.add(const SizedBox(width: spacing));
      }
      if (index < leadingEmptyCells || index >= cellCount) {
        cells.add(const Expanded(child: SizedBox.shrink()));
        continue;
      }
      final DateTime day =
          DateTime(month.year, month.month, index - leadingEmptyCells + 1);
      final LearningDaySummary daySummary = summary.dayFor(day);
      final bool practiced = daySummary.questionCount > 0;
      final bool selected =
          day == DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      cells.add(
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Material(
              color: selected
                  ? AppVisualTokens.brand
                  : (practiced ? const Color(0xFFE7EEF9) : Colors.transparent),
              borderRadius: BorderRadius.circular(9),
              child: InkWell(
                key: ValueKey<String>(
                    'calendar_day_${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}'),
                borderRadius: BorderRadius.circular(9),
                onTap: () => onDaySelected(day),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      fontWeight: practiced ? FontWeight.w700 : FontWeight.w400,
                      color: selected ? Colors.white : const Color(0xFF334155),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (row > 0) {
      rows.add(const SizedBox(height: spacing));
    }
    rows.add(
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: cells));
  }
  return rows;
}
