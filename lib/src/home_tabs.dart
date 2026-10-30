part of '../main.dart';

class MathSpringHomePage extends StatefulWidget {
  const MathSpringHomePage({
    super.key,
    required this.onLocaleChanged,
    required this.services,
    required this.monetization,
  });

  final ValueChanged<Locale> onLocaleChanged;
  final AppServices services;
  final MonetizationService monetization;

  @override
  State<MathSpringHomePage> createState() => _MathSpringHomePageState();
}

enum _HomeTab { practice, quiz, review, settings }

class _MathSpringHomePageState extends State<MathSpringHomePage> {
  int _progressVersion = 0;
  _HomeTab _currentTab = _HomeTab.practice;

  void _handleLearnerChanged() {
    setState(() {
      _progressVersion++;
    });
  }

  LearnerProfile? get _currentLearner {
    final String? learnerId = widget.services.currentLearnerId;
    if (learnerId == null) {
      return widget.services.learnerProfiles.isEmpty
          ? null
          : widget.services.learnerProfiles.first;
    }
    for (final LearnerProfile profile in widget.services.learnerProfiles) {
      if (profile.id == learnerId) {
        return profile;
      }
    }
    return widget.services.learnerProfiles.isEmpty
        ? null
        : widget.services.learnerProfiles.first;
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Scaffold(
      body: SafeArea(
        child: _HomeShellFrame(
          learner: _currentLearner,
          child: switch (_currentTab) {
            _HomeTab.practice => _PracticeTab(
                services: widget.services,
                learner: _currentLearner,
              ),
            _HomeTab.quiz => _QuizTab(
                services: widget.services,
                learner: _currentLearner,
              ),
            _HomeTab.review => _ReviewTab(
                services: widget.services,
              ),
            _HomeTab.settings => _SettingsTab(
                key: ValueKey<int>(_progressVersion),
                services: widget.services,
                onChanged: _handleLearnerChanged,
                currentLocale: Localizations.localeOf(context),
                onLocaleChanged: widget.onLocaleChanged,
                monetization: widget.monetization,
              ),
          },
        ),
      ),
      // 導覽列跟內容欄同寬：滿版導覽列配上 760pt 的內容，
      // 在 iPad 上兩者寬度差太多，視覺節奏會斷掉。
      //
      // 用左右 padding 而不是包一層 Center + ConstrainedBox：後者會改變
      // Scaffold 對底部列的量測，實測會讓其他頁面的點擊命中失效。
      bottomNavigationBar: Builder(
        builder: (BuildContext context) {
          final double maxWidth = LayoutSpec.of(context).contentMaxWidth;
          final double screen = MediaQuery.sizeOf(context).width;
          final double side =
              screen > maxWidth ? (screen - maxWidth) / 2 : 16.0;
          return Padding(
            padding: EdgeInsets.fromLTRB(side, 0, side, 8),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1217201D),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: NavigationBar(
                  selectedIndex: _currentTab.index,
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentTab = _HomeTab.values[index];
                    });
                  },
                  destinations: [
                    NavigationDestination(
                      icon: const Icon(Icons.play_circle_outline),
                      selectedIcon: const Icon(Icons.play_circle_rounded),
                      label: strings.navPractice,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.fact_check_outlined),
                      selectedIcon: const Icon(Icons.fact_check_rounded),
                      label: strings.navQuiz,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.history_edu_outlined),
                      selectedIcon: const Icon(Icons.history_edu_rounded),
                      label: strings.navReview,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.settings_outlined),
                      selectedIcon: const Icon(Icons.settings_rounded),
                      label: strings.navSettings,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HomeShellFrame extends StatelessWidget {
  const _HomeShellFrame({
    required this.learner,
    required this.child,
  });

  final LearnerProfile? learner;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('home_shell_frame'),
      color: AppVisualTokens.canvas,
      child: ContentScrollView(
        fill: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopBar(
              title: 'MathSpring',
              learner: learner,
            ),
            const SizedBox(height: 12),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _PracticeTab extends StatefulWidget {
  const _PracticeTab({
    required this.services,
    required this.learner,
  });

  final AppServices services;
  final LearnerProfile? learner;

  @override
  State<_PracticeTab> createState() => _PracticeTabState();
}

class _PracticeTabState extends State<_PracticeTab> {
  String? _selectedTopicCode;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return _DailyMissionGate(
      services: widget.services,
      learner: widget.learner,
      normalContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroCard(strings: strings),
          const SizedBox(height: 18),
          _SectionCard(
            title: strings.practiceEntryTitle,
            subtitle: strings.practiceEntrySubtitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LearnerSummaryBanner(
                  learner: widget.learner,
                  primaryLabel: strings.currentLearnerLabel,
                  secondaryLabel: strings.gradeRangeLabel,
                ),
                const SizedBox(height: 18),
                OutlinedButton(
                  key: const ValueKey<String>('open_topic_practice'),
                  onPressed: () async {
                    final String? topicCode = await _showTopicPicker(
                      context: context,
                      strings: strings,
                    );
                    if (!mounted || topicCode == null) {
                      return;
                    }
                    setState(() {
                      _selectedTopicCode = topicCode;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(strings.chooseTopic),
                ),
                if (_selectedTopicCode != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.selectedTopicLabel,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _displayTopicCode(_selectedTopicCode!, strings),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  key: const ValueKey<String>('open_start_practice'),
                  onPressed: () => _openFirstEligiblePack(
                    context: context,
                    services: widget.services,
                    learner: widget.learner,
                    topicCode: _selectedTopicCode,
                    mode: _SessionLaunchMode.practice,
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(
                    _selectedTopicCode == null
                        ? strings.startPractice
                        : strings.startSelectedTopicPractice,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyMissionGate extends StatefulWidget {
  const _DailyMissionGate({
    required this.services,
    required this.learner,
    required this.normalContent,
  });

  final AppServices services;
  final LearnerProfile? learner;
  final Widget normalContent;

  @override
  State<_DailyMissionGate> createState() => _DailyMissionGateState();
}

class _DailyMissionGateState extends State<_DailyMissionGate> {
  bool _showNormalPractice = false;
  int _version = 0;

  @override
  Widget build(BuildContext context) {
    final String? learnerId = widget.services.currentLearnerId;
    if (learnerId == null) {
      return widget.normalContent;
    }
    return FutureBuilder<DailyMissionProgress>(
      key: ValueKey<int>(_version),
      future: widget.services.getLearnerDailyMissionProgress(learnerId),
      builder:
          (BuildContext context, AsyncSnapshot<DailyMissionProgress> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.isComplete || _showNormalPractice) {
          return widget.normalContent;
        }
        return _DailyMissionLanding(
          progress: snapshot.data!,
          learner: widget.learner,
          onStart: () async {
            await _openFirstEligiblePack(
              context: context,
              services: widget.services,
              learner: widget.learner,
              mode: _SessionLaunchMode.practice,
              questionLimit: DailyMission.targetCount,
              reviewMistakeCount: 1,
            );
            if (mounted) {
              setState(() => _version += 1);
            }
          },
          onOpenPractice: () => setState(() => _showNormalPractice = true),
        );
      },
    );
  }
}

class _DailyMissionLanding extends StatelessWidget {
  const _DailyMissionLanding({
    required this.progress,
    required this.learner,
    required this.onStart,
    required this.onOpenPractice,
  });

  final DailyMissionProgress progress;
  final LearnerProfile? learner;
  final VoidCallback onStart;
  final VoidCallback onOpenPractice;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final String learnerId = learner?.id ?? 'learner';
    return Column(
      key: const ValueKey<String>('daily_mission_landing'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompactHeroBanner(
          title: strings.dailyMissionTitle,
          subtitle: strings
              .dailyMissionEncouragements[DailyMission.encouragementIndexFor(
            learnerId: learnerId,
            date: progress.date,
            optionCount: strings.dailyMissionEncouragements.length,
          )],
          icon: Icons.wb_sunny_outlined,
        ),
        const SizedBox(height: 18),
        // 撐滿剩餘高度，首頁在 iPad 上不會只佔上方一小塊
        Expanded(
          child: _SectionCard(
            title: strings.dailyMissionTaskTitle,
            subtitle: strings.dailyMissionTaskSubtitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${progress.answeredCount} / ${progress.targetCount}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 18),
                FilledButton(
                  key: const ValueKey<String>('start_daily_mission'),
                  onPressed: onStart,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(strings.dailyMissionStart),
                ),
                const SizedBox(height: 10),
                TextButton(
                  key: const ValueKey<String>('open_regular_practice'),
                  onPressed: onOpenPractice,
                  child: Text(strings.dailyMissionOpenRegular),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuizTab extends StatelessWidget {
  const _QuizTab({
    required this.services,
    required this.learner,
  });

  final AppServices services;
  final LearnerProfile? learner;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompactHeroBanner(
          title: strings.quizEntryTitle,
          subtitle: strings.quizEntrySubtitle,
          icon: Icons.fact_check_rounded,
        ),
        const SizedBox(height: 18),
        // 撐滿剩餘高度：外殼的 fill 只把分頁內容包成 Expanded，
        // 分頁內部要自己指定哪一塊撐開，否則空間會空在裡面。
        Expanded(
          child: _SectionCard(
            title: strings.quizEntryTitle,
            subtitle: strings.quizEntrySubtitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LearnerSummaryBanner(
                  learner: learner,
                  primaryLabel: strings.currentLearnerLabel,
                  secondaryLabel: strings.gradeRangeLabel,
                ),
                const SizedBox(height: 18),
                Text(
                  strings.quizStartHint,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  key: const ValueKey<String>('open_start_quiz'),
                  onPressed: () async {
                    final FormalExamPreset? preset =
                        await _showFormalExamPresetPicker(context);
                    if (!context.mounted || preset == null) {
                      return;
                    }
                    await _openFirstEligiblePack(
                      context: context,
                      services: services,
                      learner: learner,
                      mode: _SessionLaunchMode.quiz,
                      questionLimit: preset.questionCount,
                      formalExamPreset: preset,
                    );
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(strings.startQuiz),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
