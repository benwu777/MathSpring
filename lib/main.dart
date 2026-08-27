import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mathspring/competition_profiles.dart';
import 'package:mathspring/data/bundled/bundled_question_bank_repository.dart'
    as bundled;
import 'package:mathspring/data/local/app_services.dart';
import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/geometry_scene.dart';
import 'package:mathspring/models/question.dart';
import 'package:mathspring/models/question_bank.dart';
import 'package:mathspring/models/question_progress.dart';
import 'package:mathspring/models/learner_profile.dart';
import 'package:mathspring/models/session_answer_record.dart';
import 'package:mathspring/services/learning_activity_summary.dart';
import 'package:mathspring/services/math_text_formatter.dart';
import 'package:mathspring/services/session_launch_plan_builder.dart';

void main() {
  runApp(const MathSpringApp());
}

Question _buildTrigDemoQuestion() {
  return Question.fromJson({
    'id': 'geometry_demo_trig_plane_001',
    'topic': 'geometry',
    'difficulty': 'foundation',
    'levelStage': 'grade4',
    'challengeTier': 'foundation',
    'prompt': {
      'zh-Hant': '觀察圖形，在 0 到 2π 間，sin(x) 與 cos(x) 分別在何處達到最大值？',
      'zh-Hans': '观察图形，在 0 到 2π 间，sin(x) 与 cos(x) 分别在何处达到最大值？',
      'en':
          'Inspect the graph. On the interval from 0 to 2π, where do sin(x) and cos(x) each reach their maximum value?',
      'ja': 'グラフを見てください。0 から 2π の区間で、sin(x) と cos(x) はそれぞれどこで最大値をとりますか。',
    },
    'answer': {
      'zh-Hant': 'sin(x) 在 π/2 取得最大值 1，cos(x) 在 0 取得最大值 1。',
      'zh-Hans': 'sin(x) 在 π/2 取得最大值 1，cos(x) 在 0 取得最大值 1。',
      'en':
          'sin(x) reaches its maximum value 1 at π/2, and cos(x) reaches its maximum value 1 at 0.',
      'ja': 'sin(x) は π/2 で最大値 1 をとり、cos(x) は 0 で最大値 1 をとります。',
    },
    'solutionSteps': {
      'zh-Hant': [
        '觀察藍色的 sin(x) 曲線，最高點出現在 x = π/2。',
        '觀察紅色的 cos(x) 曲線，最高點出現在 x = 0。',
      ],
      'zh-Hans': [
        '观察蓝色的 sin(x) 曲线，最高点出现在 x = π/2。',
        '观察红色的 cos(x) 曲线，最高点出现在 x = 0。',
      ],
      'en': [
        'The blue sin(x) curve reaches its peak at x = π/2.',
        'The red cos(x) curve reaches its peak at x = 0.',
      ],
      'ja': [
        '青い sin(x) の曲線は x = π/2 で頂点に達します。',
        '赤い cos(x) の曲線は x = 0 で頂点に達します。',
      ],
    },
    'figure': {
      'type': 'custom',
      'kind': 'trig_plane',
      'params': {
        'showGrid': true,
        'showLegend': true,
        'highlightInterval': ['pi/2', 'pi'],
        'functions': ['sin', 'cos'],
      },
    },
    'answerMode': 'multiple_choice',
    'options': {
      'A': {
        'zh-Hant': 'sin(x) 在 0，cos(x) 在 π/2',
        'zh-Hans': 'sin(x) 在 0，cos(x) 在 π/2',
        'en': 'sin(x) at 0, cos(x) at π/2',
        'ja': 'sin(x) は 0、cos(x) は π/2',
      },
      'B': {
        'zh-Hant': 'sin(x) 在 π/2，cos(x) 在 0',
        'zh-Hans': 'sin(x) 在 π/2，cos(x) 在 0',
        'en': 'sin(x) at π/2, cos(x) at 0',
        'ja': 'sin(x) は π/2、cos(x) は 0',
      },
      'C': {
        'zh-Hant': '兩者都在 π',
        'zh-Hans': '两者都在 π',
        'en': 'Both at π',
        'ja': 'どちらも π',
      },
      'D': {
        'zh-Hant': '兩者都在 2π',
        'zh-Hans': '两者都在 2π',
        'en': 'Both at 2π',
        'ja': 'どちらも 2π',
      },
    },
    'correctAnswer': {
      'type': 'choice',
      'value': 'B',
    },
    'source': {
      'type': 'official_reference',
      'name': 'MathSpring Demo',
      'displayText': 'MathSpring graph demo',
    },
  });
}

class MathSpringApp extends StatefulWidget {
  const MathSpringApp({super.key, this.services});

  final AppServices? services;

  @override
  State<MathSpringApp> createState() => _MathSpringAppState();
}

class _MathSpringAppState extends State<MathSpringApp> {
  Locale? _localeOverride;
  late final Future<AppServices> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = widget.services == null
        ? AppServices.openDefault()
        : Future<AppServices>.value(widget.services!);
  }

  void _updateLocale(Locale locale) {
    setState(() {
      _localeOverride = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color seedColor = Color(0xFF163D7A);
    final Locale resolvedLocale = _localeOverride ??
        AppStrings.resolveLocale(
          WidgetsBinding.instance.platformDispatcher.locale,
          AppStrings.supportedLocales,
        );

    return MaterialApp(
      title: 'MathSpring',
      debugShowCheckedModeBanner: false,
      locale: resolvedLocale,
      supportedLocales: AppStrings.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.0,
            color: Color(0xFF0F172A),
          ),
          headlineSmall: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
          titleMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
          bodyLarge: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Color(0xFF334155),
          ),
          bodyMedium: TextStyle(
            fontSize: 13,
            height: 1.4,
            color: Color(0xFF475569),
          ),
          bodySmall: TextStyle(
            fontSize: 11,
            height: 1.35,
            color: Color(0xFF64748B),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7FB),
          foregroundColor: Color(0xFF0F172A),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF163D7A), width: 1.2),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            minimumSize: const Size(0, 44),
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xFFFDFDFE),
          indicatorColor: Color(0xFFE7EEF9),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          labelTextStyle: WidgetStatePropertyAll<TextStyle>(
            TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          color: Colors.white,
          shadowColor: const Color(0x140F172A),
          surfaceTintColor: Colors.transparent,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFFE7EBF2)),
          ),
        ),
      ),
      home: widget.services != null
          ? MathSpringHomePage(
              onLocaleChanged: _updateLocale,
              services: widget.services!,
            )
          : FutureBuilder<AppServices>(
              future: _servicesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return MathSpringHomePage(
                  onLocaleChanged: _updateLocale,
                  services: snapshot.data!,
                );
              },
            ),
    );
  }
}

class MathSpringHomePage extends StatefulWidget {
  const MathSpringHomePage({
    super.key,
    required this.onLocaleChanged,
    required this.services,
  });

  final ValueChanged<Locale> onLocaleChanged;
  final AppServices services;

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
              ),
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [
              BoxShadow(
                color: Color(0x120F172A),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: NavigationBar(
              backgroundColor: const Color(0xFFFDFDFE),
              indicatorColor: const Color(0xFFE7EEF9),
              selectedIndex: _currentTab.index,
              onDestinationSelected: (index) {
                setState(() {
                  _currentTab = _HomeTab.values[index];
                });
              },
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.play_circle_outline),
                  selectedIcon: const Icon(Icons.play_circle_fill),
                  label: strings.navPractice,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.fact_check_outlined),
                  selectedIcon: const Icon(Icons.fact_check),
                  label: strings.navQuiz,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.history_edu_outlined),
                  selectedIcon: const Icon(Icons.history_edu),
                  label: strings.navReview,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: strings.navSettings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeShellFrame extends StatelessWidget {
  const _HomeShellFrame({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('home_shell_frame'),
      color: const Color(0xFFF6F8FC),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -40,
            child: IgnorePointer(
              child: Container(
                key: const ValueKey<String>('home_background_glow'),
                width: 260,
                height: 260,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x55C9D9F6),
                      Color(0x00C9D9F6),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -70,
            child: IgnorePointer(
              child: Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x35E3ECFA),
                      Color(0x00E3ECFA),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _TopBar(
                      title: 'MathSpring',
                    ),
                    const SizedBox(height: 18),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroCard(
          strings: strings,
          onOpenDemo: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => TrigGraphDemoPage(services: widget.services),
              ),
            );
          },
        ),
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
                  foregroundColor: const Color(0xFF111827),
                  minimumSize: const Size.fromHeight(54),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
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
                  backgroundColor: const Color(0xFF111827),
                  minimumSize: const Size.fromHeight(54),
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
        _SectionCard(
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
                onPressed: () => _openFirstEligiblePack(
                  context: context,
                  services: services,
                  learner: learner,
                  mode: _SessionLaunchMode.quiz,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF111827),
                  minimumSize: const Size.fromHeight(54),
                ),
                child: Text(strings.startQuiz),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
            _CompactHeroBanner(
              title: strings.reviewTitle,
              subtitle: strings.reviewSubtitle,
              icon: Icons.history_edu_rounded,
            ),
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
          Icon(icon, size: 18, color: const Color(0xFF163D7A)),
          const SizedBox(width: 6),
          Text(label),
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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leadingEmptyCells + dayCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index < leadingEmptyCells) {
              return const SizedBox.shrink();
            }
            final DateTime day = DateTime(
                month.year, month.month, index - leadingEmptyCells + 1);
            final LearningDaySummary daySummary = summary.dayFor(day);
            final bool practiced = daySummary.questionCount > 0;
            final bool selected = day ==
                DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
            return Material(
              color: selected
                  ? const Color(0xFF163D7A)
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
            );
          },
        ),
      ],
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({
    super.key,
    required this.services,
    required this.onChanged,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  final AppServices services;
  final VoidCallback onChanged;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompactHeroBanner(
          title: strings.settingsTitle,
          subtitle: strings.settingsSubtitle,
          icon: Icons.tune_rounded,
        ),
        const SizedBox(height: 18),
        _LearnerProfilesSection(
          title: strings.settingsTitle,
          subtitle: strings.settingsSubtitle,
          services: services,
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
        _LocaleSettingsSection(
          currentLocale: currentLocale,
          onLocaleChanged: onLocaleChanged,
        ),
        const SizedBox(height: 16),
        _ProgressSection(
          title: strings.progressTitle,
          subtitle: strings.progressSubtitle,
          services: services,
        ),
        const SizedBox(height: 16),
        const _SupportAndPrivacySection(),
      ],
    );
  }
}

class _SupportAndPrivacySection extends StatelessWidget {
  const _SupportAndPrivacySection();

  static final Uri _supportUrl = Uri.parse(
    'https://YOUR_GITHUB_USERNAME.github.io/mathspring/support/',
  );
  static final Uri _privacyUrl = Uri.parse(
    'https://YOUR_GITHUB_USERNAME.github.io/mathspring/privacy/',
  );

  Future<void> _open(BuildContext context, Uri url) async {
    if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.of(context).linkOpenFailed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return _SectionCard(
      title: strings.helpAndPrivacyTitle,
      subtitle: strings.helpAndPrivacySubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            key: const ValueKey<String>('open_support_link'),
            onPressed: () => _open(context, _supportUrl),
            icon: const Icon(Icons.support_agent_outlined),
            label: Text(strings.supportLinkLabel),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            key: const ValueKey<String>('open_privacy_link'),
            onPressed: () => _open(context, _privacyUrl),
            icon: const Icon(Icons.privacy_tip_outlined),
            label: Text(strings.privacyLinkLabel),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          key: const ValueKey<String>('top_bar_brand_chip'),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFDFEFF),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFE6EBF2)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A0F172A),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            AppStrings.of(context).appSubtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      letterSpacing: -0.6,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                AppStrings.of(context).heroSubtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LocaleSettingsSection extends StatelessWidget {
  const _LocaleSettingsSection({
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final bool isChinese = currentLocale.languageCode == 'zh';

    return _SectionCard(
      title: strings.languageSettingsTitle,
      subtitle: strings.languageSettingsSubtitle,
      child: Row(
        children: [
          Expanded(
            child: _LanguageButton(
              buttonKey: const ValueKey<String>('locale_option_zh'),
              label: strings.languageTraditionalChinese,
              selected: isChinese,
              onPressed: () => onLocaleChanged(const Locale('zh', 'TW')),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _LanguageButton(
              buttonKey: const ValueKey<String>('locale_option_en'),
              label: strings.languageEnglish,
              selected: !isChinese,
              onPressed: () => onLocaleChanged(const Locale('en')),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    this.buttonKey,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final Key? buttonKey;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: buttonKey,
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:
            selected ? const Color(0xFF111827) : Colors.transparent,
        foregroundColor: selected ? Colors.white : const Color(0xFF4B5563),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label),
    );
  }
}

enum _SessionLaunchMode { practice, quiz }

class _LearnerSummaryBanner extends StatelessWidget {
  const _LearnerSummaryBanner({
    required this.learner,
    required this.primaryLabel,
    required this.secondaryLabel,
  });

  final LearnerProfile? learner;
  final String primaryLabel;
  final String secondaryLabel;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      key: const ValueKey<String>('learner_summary_banner'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            primaryLabel,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            learner?.displayName ?? strings.noLearnerSelected,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall?.copyWith(
              fontSize: 24,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            secondaryLabel,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            learner == null ? '-' : _learnerGradeRangeLabel(learner!, strings),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleLarge?.copyWith(
              fontSize: 19,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicActionGrid extends StatelessWidget {
  const _TopicActionGrid({
    required this.strings,
    required this.onTopicSelected,
  });

  final AppStrings strings;
  final Future<void> Function(String topicCode) onTopicSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _TopicActionButton(
          buttonKey: const ValueKey<String>('topic_action_geometry'),
          label: strings.topicGeometry,
          onPressed: () async => onTopicSelected('geometry'),
        ),
        _TopicActionButton(
          buttonKey: const ValueKey<String>('topic_action_arithmetic'),
          label: strings.topicArithmetic,
          onPressed: () async => onTopicSelected('arithmetic'),
        ),
        _TopicActionButton(
          buttonKey: const ValueKey<String>('topic_action_logic'),
          label: strings.topicLogic,
          onPressed: () async => onTopicSelected('logic'),
        ),
      ],
    );
  }
}

class _TopicActionButton extends StatelessWidget {
  const _TopicActionButton({
    required this.buttonKey,
    required this.label,
    required this.onPressed,
  });

  final Key buttonKey;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: OutlinedButton(
        key: buttonKey,
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF111827),
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.strings, required this.onOpenDemo});

  final AppStrings strings;
  final VoidCallback onOpenDemo;

  @override
  Widget build(BuildContext context) {
    final bool isWideLayout = MediaQuery.sizeOf(context).width >= 900;

    return Container(
      key: const ValueKey<String>('home_hero_surface'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFDFEFF),
            Color(0xFFF3F7FD),
            Color(0xFFEFF4FB),
          ],
        ),
        border: Border.all(color: const Color(0xFFE1E8F4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 32,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
        child: isWideLayout
            ? Row(
                children: [
                  Expanded(
                    child: _HeroCopy(
                      strings: strings,
                      onOpenDemo: onOpenDemo,
                    ),
                  ),
                  const SizedBox(width: 24),
                  const Expanded(child: _HeroPanel()),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroCopy(strings: strings, onOpenDemo: onOpenDemo),
                  const SizedBox(height: 24),
                  const _HeroPanel(),
                ],
              ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.strings, required this.onOpenDemo});

  final AppStrings strings;
  final VoidCallback onOpenDemo;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1FC),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            strings.heroBadge,
            style: const TextStyle(
              color: Color(0xFF163D7A),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          strings.heroTitle,
          style: textTheme.displaySmall?.copyWith(
            fontSize: 34,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          strings.heroSubtitle,
          style: textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF52637A),
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoPill(label: strings.pillAdaptive),
            _InfoPill(label: strings.pillProfiles),
            _InfoPill(label: strings.pillBilingual),
          ],
        ),
        const SizedBox(height: 18),
        FilledButton(
          key: const ValueKey<String>('hero_primary_cta'),
          onPressed: onOpenDemo,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF163D7A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(strings.openDemoCta),
        ),
      ],
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 220),
      decoration: BoxDecoration(
        color: const Color(0xFF163D7A),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1E163D7A),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.dashboardFocusTitle,
            style: const TextStyle(
              color: Color(0xB3FFFFFF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            strings.dashboardFocusBody,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0x1FFFFFFF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0x2FFFFFFF)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${strings.dashboardPathTitle}\n${strings.dashboardPathValue}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_outward, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactHeroBanner extends StatelessWidget {
  const _CompactHeroBanner({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFDFEFF),
            Color(0xFFF2F6FC),
          ],
        ),
        border: Border.all(color: const Color(0xFFE1E8F4)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF163D7A)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF64748B),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
    this.cardKey,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;
  final Key? cardKey;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: cardKey ?? ValueKey<String>('section_card_$title'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 18,
                          letterSpacing: -0.3,
                        ),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF64748B),
                    height: 1.45,
                  ),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

class _LearnerProfilesSection extends StatefulWidget {
  const _LearnerProfilesSection({
    required this.title,
    required this.subtitle,
    required this.services,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final AppServices services;
  final VoidCallback onChanged;

  @override
  State<_LearnerProfilesSection> createState() =>
      _LearnerProfilesSectionState();
}

class _LearnerProfilesSectionState extends State<_LearnerProfilesSection> {
  Future<void> _openCreateLearnerDialog(BuildContext context) async {
    final AppStrings strings = AppStrings.of(context);
    final _LearnerDraft? draft = await showDialog<_LearnerDraft>(
      context: context,
      builder: (_) => _CreateLearnerDialog(strings: strings),
    );
    if (draft == null) {
      return;
    }

    final LearnerProfile profile = await widget.services.createLearner(
      displayName: draft.displayName,
      minLevelStage: draft.minLevelStage,
      maxLevelStage: draft.maxLevelStage,
      challengeTier: 'foundation',
    );
    await widget.services.setCurrentLearner(profile.id);
    widget.onChanged();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openEditLearnerPage(
    BuildContext context,
    LearnerProfile learner,
  ) async {
    final bool? changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => LearnerEditPage(
          services: widget.services,
          learner: learner,
        ),
      ),
    );
    if (changed == true) {
      widget.onChanged();
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _deleteLearner(String learnerId) async {
    await widget.services.deleteLearner(learnerId);
    widget.onChanged();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final List<LearnerProfile> profiles = widget.services.learnerProfiles;
    return _SectionCard(
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: TextButton.icon(
        onPressed: () => _openCreateLearnerDialog(context),
        icon: const Icon(Icons.add, size: 18),
        label: Text(strings.addLearner),
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF111827),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LearnerSummaryBanner(
            learner: profiles.isEmpty
                ? null
                : profiles.firstWhere(
                    (profile) => profile.id == widget.services.currentLearnerId,
                    orElse: () => profiles.first,
                  ),
            primaryLabel: strings.currentLearnerLabel,
            secondaryLabel: strings.gradeRangeLabel,
          ),
          const SizedBox(height: 16),
          for (int index = 0; index < profiles.length; index++) ...[
            _ProfileTile(
              tileKey: ValueKey<String>('profile_tile_${profiles[index].id}'),
              onTap: () async {
                await widget.services.setCurrentLearner(profiles[index].id);
                widget.onChanged();
                if (mounted) {
                  setState(() {});
                }
              },
              name: profiles[index].displayName,
              level: _learnerGradeRangeLabel(profiles[index], strings),
              accent: index.isEven
                  ? const Color(0xFF163D7A)
                  : const Color(0xFF3B82F6),
              isCurrent: profiles[index].id == widget.services.currentLearnerId,
              currentLabel: strings.currentLearner,
              editTooltip: strings.editLearner,
              onEdit: () => _openEditLearnerPage(context, profiles[index]),
              editKey: ValueKey<String>('edit_learner_${profiles[index].id}'),
              deleteTooltip: strings.deleteLearner,
              onDelete: profiles.length <= 1
                  ? null
                  : () => _deleteLearner(profiles[index].id),
              deleteKey: ValueKey<String>(
                'delete_learner_${profiles[index].id}',
              ),
            ),
            if (index != profiles.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    this.tileKey,
    required this.onTap,
    required this.name,
    required this.level,
    required this.accent,
    required this.isCurrent,
    required this.currentLabel,
    required this.editTooltip,
    required this.deleteTooltip,
    this.editKey,
    this.onEdit,
    this.onDelete,
    this.deleteKey,
  });

  final Key? tileKey;
  final Future<void> Function() onTap;
  final String name;
  final String level;
  final Color accent;
  final bool isCurrent;
  final String currentLabel;
  final String editTooltip;
  final Key? editKey;
  final String deleteTooltip;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Key? deleteKey;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      key: tileKey,
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isCurrent ? const Color(0xFF163D7A) : const Color(0xFFE2E8F0),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A0F172A),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_outline, color: accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleLarge?.copyWith(
                            fontSize: 18,
                            letterSpacing: -0.2,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isCurrent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF2FF),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0xFFCFE0FF)),
                          ),
                          child: Text(
                            currentLabel,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF163D7A),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    level,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
            if (onEdit != null)
              IconButton(
                key: editKey,
                onPressed: onEdit,
                tooltip: editTooltip,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF94A3B8),
                ),
              ),
            if (onDelete != null)
              IconButton(
                key: deleteKey,
                onPressed: onDelete,
                tooltip: deleteTooltip,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFF94A3B8),
                ),
              ),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.title,
    required this.subtitle,
    required this.services,
  });

  final String title;
  final String subtitle;
  final AppServices services;

  @override
  Widget build(BuildContext context) {
    final String? learnerId = services.currentLearnerId;
    return FutureBuilder<LearnerProgressSummary>(
      future: learnerId == null
          ? Future<LearnerProgressSummary>.value(
              const LearnerProgressSummary(solvedCount: 0, correctCount: 0),
            )
          : services.getLearnerProgressSummary(learnerId),
      builder: (context, snapshot) {
        final LearnerProgressSummary summary = snapshot.data ??
            const LearnerProgressSummary(solvedCount: 0, correctCount: 0);
        return _SectionCard(
          title: title,
          subtitle: subtitle,
          child: _StatRow(
            leftValue: '${summary.solvedCount}',
            leftLabel: AppStrings.of(context).solvedLabel,
            rightValue: '${(summary.accuracyRate * 100).round()}%',
            rightLabel: AppStrings.of(context).accuracyLabel,
          ),
        );
      },
    );
  }
}

class _LearnerDraft {
  const _LearnerDraft({
    required this.displayName,
    required this.minLevelStage,
    required this.maxLevelStage,
  });

  final String displayName;
  final String minLevelStage;
  final String maxLevelStage;
}

class _CreateLearnerDialog extends StatefulWidget {
  const _CreateLearnerDialog({required this.strings});

  final AppStrings strings;

  @override
  State<_CreateLearnerDialog> createState() => _CreateLearnerDialogState();
}

class _CreateLearnerDialogState extends State<_CreateLearnerDialog> {
  final TextEditingController _nameController = TextEditingController();
  RangeValues _gradeRange = const RangeValues(1, 2);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(widget.strings.addLearner),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const ValueKey<String>('learner_name_field'),
              controller: _nameController,
              decoration: InputDecoration(
                labelText: widget.strings.learnerName,
              ),
            ),
            const SizedBox(height: 16),
            _LearnerGradeRangeSelector(
              strings: widget.strings,
              values: _gradeRange,
              onChanged: (value) {
                setState(() {
                  _gradeRange = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.strings.cancel),
        ),
        FilledButton(
          key: const ValueKey<String>('save_learner_button'),
          onPressed: () {
            final String name = _nameController.text.trim();
            if (name.isEmpty) {
              return;
            }
            Navigator.of(context).pop(
              _LearnerDraft(
                displayName: name,
                minLevelStage: levelStageFromNumber(_gradeRange.start.round()),
                maxLevelStage: levelStageFromNumber(_gradeRange.end.round()),
              ),
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF111827),
          ),
          child: Text(widget.strings.saveLearner),
        ),
      ],
    );
  }
}

class LearnerEditPage extends StatefulWidget {
  const LearnerEditPage({
    super.key,
    required this.services,
    required this.learner,
  });

  final AppServices services;
  final LearnerProfile learner;

  @override
  State<LearnerEditPage> createState() => _LearnerEditPageState();
}

class _LearnerEditPageState extends State<LearnerEditPage> {
  late final TextEditingController _nameController;
  late RangeValues _gradeRange;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.learner.displayName);
    _gradeRange = RangeValues(
      levelStageNumber(widget.learner.effectiveMinLevelStage).toDouble(),
      levelStageNumber(widget.learner.effectiveMaxLevelStage).toDouble(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }
    await widget.services.updateLearner(
      LearnerProfile(
        id: widget.learner.id,
        displayName: name,
        levelStage: levelStageFromNumber(_gradeRange.end.round()),
        minLevelStage: levelStageFromNumber(_gradeRange.start.round()),
        maxLevelStage: levelStageFromNumber(_gradeRange.end.round()),
        challengeTier: widget.learner.challengeTier,
        createdAtIso: widget.learner.createdAtIso,
      ),
    );
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.editLearner),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            key: const ValueKey<String>('edit_learner_name_field'),
            controller: _nameController,
            decoration: InputDecoration(
              labelText: strings.learnerName,
            ),
          ),
          const SizedBox(height: 20),
          _LearnerGradeRangeSelector(
            strings: strings,
            values: _gradeRange,
            onChanged: (value) {
              setState(() {
                _gradeRange = value;
              });
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const ValueKey<String>('save_learner_profile_button'),
            onPressed: _save,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF111827),
              minimumSize: const Size.fromHeight(52),
            ),
            child: Text(strings.saveLearner),
          ),
        ],
      ),
    );
  }
}

class _LearnerGradeRangeSelector extends StatelessWidget {
  const _LearnerGradeRangeSelector({
    required this.strings,
    required this.values,
    required this.onChanged,
  });

  final AppStrings strings;
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    final int startGrade = values.start.round();
    final int endGrade = values.end.round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.gradeRangeLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          strings.gradeRangeHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.gradeRangeDisplay(startGrade, endGrade),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              RangeSlider(
                key: const ValueKey<String>('learner_grade_range_slider'),
                min: 1,
                max: 12,
                divisions: 11,
                values: values,
                labels: RangeLabels('$startGrade', '$endGrade'),
                onChanged: onChanged,
              ),
              Row(
                children: [
                  Text('1', style: Theme.of(context).textTheme.bodySmall),
                  const Spacer(),
                  Text('12', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.leftValue,
    required this.leftLabel,
    required this.rightValue,
    required this.rightLabel,
  });

  final String leftValue;
  final String leftLabel;
  final String rightValue;
  final String rightLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(value: leftValue, label: leftLabel)),
        const SizedBox(width: 14),
        Expanded(child: _StatCard(value: rightValue, label: rightLabel)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF163D7A),
            ),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}

class QuestionLibraryPage extends StatefulWidget {
  const QuestionLibraryPage({
    super.key,
    required this.services,
  });

  final AppServices services;

  @override
  State<QuestionLibraryPage> createState() => _QuestionLibraryPageState();
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
                          for (final String step in question
                              .localizedSolutionSteps(_localeCode(context)))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(step),
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
            _displayTopicCode(pack.topicCode, strings),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${_displayLevelStage(pack.levelStage, strings)} · ${_displayTier(pack.challengeTier, strings)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
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
              _InfoPill(label: _displayTopicCode(pack.topicCode, strings)),
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

class PracticeSessionPage extends StatefulWidget {
  const PracticeSessionPage({
    super.key,
    required this.services,
    required this.pack,
    this.initialQuestions,
  });

  final AppServices services;
  final bundled.BundledQuestionPackInfo pack;
  final List<Question>? initialQuestions;

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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color(0xFFF5F7FB),
      ),
      body: FutureBuilder<QuestionBank>(
        future: _packFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<Question> questions = snapshot.data!.questions;
          final Question question = questions[_currentIndex % questions.length];
          return ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    key: const ValueKey<String>('practice_question_header'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE7EBF2)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${strings.questionLabel} ${_records.length + 1}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontSize: 18),
                          ),
                        ),
                        Container(
                          key: const ValueKey<String>('question_meta_badge'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF2FF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _displayLevelStage(question.levelStage, strings),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF163D7A),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    cardKey: const ValueKey<String>('study_surface_card'),
                    title: _displayTopicCode(widget.pack.topicCode, strings),
                    subtitle:
                        '${_displayLevelStage(question.levelStage, strings)} · ${_displayTier(question.challengeTier, strings)}',
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
                            record: _latestRecord!,
                            localeCode: _localeCode(context),
                            nextLabel: strings.nextQuestion,
                            onNext: _goToNextQuestion,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
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
    });
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
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant _PracticeAnswerSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                    foregroundColor: const Color(0xFF111827),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _QuestionOptionText(
                    key: ValueKey<String>(
                      'question_option_text_${widget.question.id}_$key',
                    ),
                    text:
                        '$key  ${widget.question.localizedOptionLabel(key, widget.localeCode)}',
                    localeCode: widget.localeCode,
                  ),
                ),
              ),
          ],
        );
      case AnswerMode.integerInput:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: ValueKey<String>(
                  'practice_integer_input_${widget.question.id}'),
              controller: _controller,
              enabled: !widget.isLocked,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: widget.strings.integerHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              key: ValueKey<String>('submit_answer_${widget.question.id}'),
              onPressed: widget.isLocked
                  ? null
                  : () {
                      final String value = _controller.text.trim();
                      if (value.isEmpty) {
                        return;
                      }
                      widget.onSubmitted(value);
                    },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF111827),
              ),
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
    required this.record,
    required this.localeCode,
    required this.nextLabel,
    required this.onNext,
  });

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
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ResultStatusBadge(
            label: record.isCorrect
                ? strings.correctLabel
                : strings.incorrectLabel,
            isCorrect: record.isCorrect,
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
          for (final String step
              in record.question.localizedSolutionSteps(localeCode))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _QuestionBodyText(
                text: step,
                localeCode: localeCode,
              ),
            ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF111827),
              ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
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

class QuizSessionPage extends StatefulWidget {
  const QuizSessionPage({
    super.key,
    required this.services,
    required this.pack,
    this.initialQuestions,
  });

  final AppServices services;
  final bundled.BundledQuestionPackInfo pack;
  final List<Question>? initialQuestions;

  @override
  State<QuizSessionPage> createState() => _QuizSessionPageState();
}

class _QuizSessionPageState extends State<QuizSessionPage> {
  late final Future<QuestionBank> _packFuture;
  final Map<String, String> _answers = <String, String>{};
  final DateTime _startedAt = DateTime.now();
  int _currentIndex = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.quizMode),
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color(0xFFF5F7FB),
      ),
      body: FutureBuilder<QuestionBank>(
        future: _packFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<Question> questions = snapshot.data!.questions;
          final Question question = questions[_currentIndex];
          final String? selectedAnswer = _answers[question.id];
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE7EBF2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          strings.questionCounter(
                            _currentIndex + 1,
                            questions.length,
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 18),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF2FF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _displayLevelStage(question.levelStage, strings),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF163D7A),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${strings.elapsedLabel} ${_formatElapsed(Duration(seconds: DateTime.now().difference(_startedAt).inSeconds))}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: _displayTopicCode(widget.pack.topicCode, strings),
                  subtitle:
                      '${_displayLevelStage(question.levelStage, strings)} · ${_displayTier(question.challengeTier, strings)}',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _QuestionPromptText(
                        key: ValueKey<String>('question_prompt_${question.id}'),
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
                const SizedBox(height: 20),
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
                          foregroundColor: const Color(0xFF111827),
                          minimumSize: const Size.fromHeight(52),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
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
                          backgroundColor: const Color(0xFF111827),
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
          ),
      ],
    );

    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => QuizResultPage(
          result: result,
        ),
      ),
    );
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
                    foregroundColor: const Color(0xFF111827),
                    backgroundColor: selectedAnswer == key
                        ? const Color(0xFFF3F4F6)
                        : Colors.white,
                    side: BorderSide(
                      color: selectedAnswer == key
                          ? const Color(0xFF111827)
                          : const Color(0xFFE5E7EB),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _QuestionOptionText(
                    key: ValueKey<String>(
                        'question_option_text_${question.id}_$key'),
                    text:
                        '$key  ${question.localizedOptionLabel(key, localeCode)}',
                    localeCode: localeCode,
                  ),
                ),
              ),
          ],
        );
      case AnswerMode.integerInput:
        return TextField(
          key: ValueKey<String>('quiz_integer_input_${question.id}'),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: onAnswerChanged,
        );
      case AnswerMode.selfCheck:
        return Text(
          AppStrings.of(context).selfCheckLabel,
        );
    }
  }
}

class QuizResultPage extends StatelessWidget {
  const QuizResultPage({
    super.key,
    required this.result,
  });

  final QuizSessionResult result;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.quizResult),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              title: strings.quizResult,
              subtitle:
                  '${result.correctCount} / ${result.totalQuestions} ${strings.correctSuffix}',
              child: _StatRow(
                leftValue: '${result.correctCount}',
                leftLabel: strings.correctLabel,
                rightValue: _formatElapsed(result.elapsed),
                rightLabel: strings.elapsedLabel,
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
                  child: ExpansionTile(
                    key: ValueKey<String>(
                      'quiz_result_${record.question.id}',
                    ),
                    title: _QuestionPromptText(
                      text:
                          record.question.localizedPrompt(_localeCode(context)),
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

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF4B5563),
          fontSize: 13,
        ),
      ),
    );
  }
}

class _QuestionPromptText extends StatelessWidget {
  const _QuestionPromptText({
    super.key,
    required this.text,
    required this.localeCode,
  });

  final String text;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    final bool denseScript = _isDenseScriptLocale(localeCode);
    final double width = MediaQuery.sizeOf(context).width;
    final double fontSize = width >= 900 ? 20 : 18;
    return Text(
      normalizeMathText(text),
      softWrap: true,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: fontSize,
            height: denseScript ? 1.65 : 1.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
    );
  }
}

class _QuestionBodyText extends StatelessWidget {
  const _QuestionBodyText({
    required this.text,
    required this.localeCode,
  });

  final String text;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    final bool denseScript = _isDenseScriptLocale(localeCode);
    return Text(
      normalizeMathText(text),
      softWrap: true,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            height: denseScript ? 1.7 : 1.55,
            color: const Color(0xFF374151),
          ),
    );
  }
}

class _QuestionSourceText extends StatelessWidget {
  const _QuestionSourceText({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Source: $text',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
            height: 1.5,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
    );
  }
}

class _QuestionOptionText extends StatelessWidget {
  const _QuestionOptionText({
    super.key,
    required this.text,
    required this.localeCode,
  });

  final String text;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    final bool denseScript = _isDenseScriptLocale(localeCode);
    return Text(
      normalizeMathText(text),
      softWrap: true,
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 15,
            height: denseScript ? 1.6 : 1.45,
            color: const Color(0xFF111827),
          ),
    );
  }
}

class AppStrings {
  AppStrings(this.locale);

  final Locale locale;

  static const List<Locale> supportedLocales = [
    Locale('zh', 'TW'),
    Locale('zh', 'CN'),
    Locale('en'),
    Locale('ja'),
  ];

  static Locale resolveLocale(
      Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale?.languageCode == 'zh') {
      if (locale?.countryCode == 'CN' || locale?.countryCode == 'SG') {
        return const Locale('zh', 'CN');
      }
      return const Locale('zh', 'TW');
    }
    if (locale?.languageCode == 'ja') {
      return const Locale('ja');
    }

    return const Locale('en');
  }

  static AppStrings of(BuildContext context) {
    return AppStrings(Localizations.localeOf(context));
  }

  bool get isTraditionalChinese =>
      locale.languageCode == 'zh' && locale.countryCode != 'CN';
  bool get isSimplifiedChinese =>
      locale.languageCode == 'zh' && locale.countryCode == 'CN';
  bool get isJapanese => locale.languageCode == 'ja';

  String _text({
    required String zhHant,
    String? zhHans,
    required String en,
    String? ja,
  }) {
    if (isTraditionalChinese) {
      return zhHant;
    }
    if (isSimplifiedChinese) {
      return zhHans ?? zhHant;
    }
    if (isJapanese) {
      return ja ?? en;
    }
    return en;
  }

  String get heroBadge => _text(
        zhHant: '為 iPhone 與 iPad 打造',
        zhHans: '为 iPhone 与 iPad 打造',
        en: 'Built for iPhone and iPad',
        ja: 'iPhone と iPad のために設計',
      );
  String get appSubtitle => _text(
        zhHant: '數學思維與進階練習',
        zhHans: '数学思维与进阶练习',
        en: 'Mathematical Thinking Practice',
        ja: '数学的思考と発展練習',
      );
  String get languageTraditionalChinese => '繁中';
  String get languageEnglish => 'EN';
  String get heroTitle => 'MathSpring';
  String get heroSubtitle => _text(
        zhHant: '用更清楚的方式練習數學思維',
        zhHans: '用更清楚的方式练习数学思维',
        en: 'Build mathematical thinking with clarity.',
        ja: '数学的思考を、より明快に鍛える。',
      );
  String get pillAdaptive => _text(
      zhHant: '自適應版面', zhHans: '自适应版面', en: 'Adaptive layout', ja: '適応レイアウト');
  String get pillProfiles => _text(
      zhHant: '多學習者切換', zhHans: '多学习者切换', en: 'Multi-profile', ja: '複数プロフィール');
  String get pillBilingual => _text(
      zhHant: '雙語題庫', zhHans: '双语题库', en: 'Bilingual content', ja: '多言語問題集');
  String get profilesTitle =>
      _text(zhHant: '學習者', zhHans: '学习者', en: 'Profiles', ja: '学習者');
  String get profilesSubtitle => _text(
        zhHant: '在同一台裝置上切換不同程度的孩子。',
        zhHans: '在同一台设备上切换不同程度的孩子。',
        en: 'Switch between learners with different levels on one device.',
        ja: '1 台の端末で、異なるレベルの学習者を切り替えられます。',
      );
  String get addLearner =>
      _text(zhHant: '新增學習者', zhHans: '新增学习者', en: 'Add learner', ja: '学習者を追加');
  String get deleteLearner => _text(
      zhHant: '刪除學習者', zhHans: '删除学习者', en: 'Delete learner', ja: '学習者を削除');
  String get currentLearner =>
      _text(zhHant: '目前使用', zhHans: '当前使用', en: 'Current', ja: '現在');
  String get currentLearnerLabel => _text(
        zhHant: '目前角色',
        zhHans: '当前角色',
        en: 'Current learner',
        ja: '現在の学習者',
      );
  String get gradeRangeLabel => _text(
        zhHant: '年級範圍',
        zhHans: '年级范围',
        en: 'Grade range',
        ja: '学年範囲',
      );
  String get editLearner =>
      _text(zhHant: '編輯角色', zhHans: '编辑角色', en: 'Edit learner', ja: '学習者を編集');
  String get gradeRangeHint => _text(
        zhHant: '拖曳左右兩端，設定這個角色可抽到的題目年級範圍。',
        zhHans: '拖动左右两端，设置这个角色可抽到的题目年级范围。',
        en: 'Drag both ends to choose the grades this learner can receive.',
        ja: '左右のつまみを動かして、この学習者に出題する学年範囲を設定します。',
      );
  String get learnerName =>
      _text(zhHant: '名稱', zhHans: '名称', en: 'Name', ja: '名前');
  String get levelStage =>
      _text(zhHant: '程度', zhHans: '程度', en: 'Level stage', ja: '学年目安');
  String get challengeTier =>
      _text(zhHant: '挑戰層級', zhHans: '挑战层级', en: 'Challenge tier', ja: '難度層');
  String get cancel =>
      _text(zhHant: '取消', zhHans: '取消', en: 'Cancel', ja: 'キャンセル');
  String get saveLearner =>
      _text(zhHant: '儲存', zhHans: '保存', en: 'Save', ja: '保存');
  String get progressTitle =>
      _text(zhHant: '今日進度', zhHans: '今日进度', en: 'Today', ja: '今日の進捗');
  String get progressSubtitle => _text(
        zhHant: '保留簡單、清楚、可以持續練習的節奏。',
        zhHans: '保持简单、清楚、可以持续练习的节奏。',
        en: 'Keep practice focused, calm, and easy to continue.',
        ja: '落ち着いて継続できる練習リズムを保つ。',
      );
  String get dashboardFocusTitle =>
      _text(zhHant: '今日重點', zhHans: '今日重点', en: 'Daily Focus', ja: '今日の重点');
  String get dashboardFocusBody => _text(
        zhHant: '2 題幾何推理\n1 題數列規律\n1 次作答回顧',
        zhHans: '2 题几何推理\n1 题数列规律\n1 次作答回顾',
        en: '2 geometry proofs\n1 number pattern\n1 review session',
        ja: '幾何 2 題\n数列 1 題\n復習 1 セッション',
      );
  String get dashboardPathTitle =>
      _text(zhHant: '目前路徑', zhHans: '当前路径', en: 'Level Path', ja: '現在のルート');
  String get dashboardPathValue => _text(
        zhHant: '年級範圍',
        zhHans: '年级范围',
        en: 'Grade range',
        ja: '学年範囲',
      );
  String get navPractice =>
      _text(zhHant: '練習', zhHans: '练习', en: 'Practice', ja: '練習');
  String get navQuiz =>
      _text(zhHant: '測驗', zhHans: '测验', en: 'Quiz', ja: 'テスト');
  String get navReview => _text(
        zhHant: '學習回顧',
        zhHans: '学习回顾',
        en: 'Review',
        ja: 'ふり返り',
      );
  String get navSettings =>
      _text(zhHant: '設定', zhHans: '设置', en: 'Settings', ja: '設定');
  String get practiceEntryTitle =>
      _text(zhHant: '開始練習', zhHans: '开始练习', en: 'Practice', ja: '練習開始');
  String get practiceEntrySubtitle => _text(
        zhHant: '直接開始目前年級範圍的練習，或指定主題。',
        zhHans: '直接开始当前年级范围的练习，或指定主题。',
        en: 'Start a session for the current grade range or choose a topic.',
        ja: '現在の学年範囲で練習を始めるか、分野を指定します。',
      );
  String get quizEntryTitle =>
      _text(zhHant: '開始測驗', zhHans: '开始测验', en: 'Quiz', ja: 'テスト開始');
  String get quizEntrySubtitle => _text(
        zhHant: '用目前年級範圍出一組測驗，完成後再看詳解。',
        zhHans: '按当前年级范围生成一组测验，完成后再看详解。',
        en: 'Generate a quiz for the current grade range and review solutions after submission.',
        ja: '現在の学年範囲に合わせて出題し、提出後に解説を確認します。',
      );
  String get reviewTitle =>
      _text(zhHant: '學習回顧', zhHans: '学习回顾', en: 'Review', ja: '学習ふり返り');
  String get reviewSubtitle => _text(
        zhHant: '回顧最近練習與測驗，重新檢查解題過程。',
        zhHans: '回顾最近练习与测验，重新检查解题过程。',
        en: 'Revisit recent practice and quiz sessions and inspect each solution again.',
        ja: '最近の練習とテストを見返し、解き方を再確認します。',
      );
  String get achievementsTitle => _text(
        zhHant: '學習成就',
        zhHans: '学习成就',
        en: 'Achievements',
        ja: '学習の達成',
      );
  String get achievementsSubtitle => _text(
        zhHant: '依累積練習、錯題重做與持續學習解鎖。',
        zhHans: '依累计练习、错题重做与持续学习解锁。',
        en: 'Unlocked through steady practice, review, and persistence.',
        ja: '練習の積み重ね、解き直し、継続によって達成します。',
      );
  String get achievementsEmpty => _text(
        zhHant: '完成第一輪練習後，這裡會出現你的成就。',
        zhHans: '完成第一轮练习后，这里会出现你的成就。',
        en: 'Your achievements will appear after your first practice session.',
        ja: '最初の練習を終えると、ここに達成が表示されます。',
      );
  String get calendarTitle => _text(
        zhHant: '答題行事曆',
        zhHans: '答题日历',
        en: 'Answer calendar',
        ja: '回答カレンダー',
      );
  String get calendarSubtitle => _text(
        zhHant: '選擇日期查看答題數與正確率。',
        zhHans: '选择日期查看答题数与正确率。',
        en: 'Choose a date to see question count and accuracy.',
        ja: '日付を選んで回答数と正答率を確認します。',
      );
  String get calendarNoPractice => _text(
        zhHant: '這一天沒有答題紀錄。',
        zhHans: '这一天没有答题记录。',
        en: 'No answers recorded on this day.',
        ja: 'この日の回答記録はありません。',
      );
  String dayActivityLabel(DateTime day) => _text(
        zhHant: '${day.month} 月 ${day.day} 日',
        zhHans: '${day.month} 月 ${day.day} 日',
        en: '${_englishMonthName(day.month)} ${day.day}',
        ja: '${day.month}月${day.day}日',
      );
  String dayActivitySummary(int count, double accuracyRate) => _text(
        zhHant: '$count 題 · 正確率 ${(accuracyRate * 100).round()}%',
        zhHans: '$count 题 · 正确率 ${(accuracyRate * 100).round()}%',
        en: '$count questions · ${(accuracyRate * 100).round()}% correct',
        ja: '$count 問 · 正答率 ${(accuracyRate * 100).round()}%',
      );
  String monthLabel(DateTime month) => _text(
        zhHant: '${month.year} 年 ${month.month} 月',
        zhHans: '${month.year} 年 ${month.month} 月',
        en: '${_englishMonthName(month.month)} ${month.year}',
        ja: '${month.year}年${month.month}月',
      );
  String streakAchievement(int current, int longest) => _text(
        zhHant: '目前連續 $current 天 · 最高 $longest 天',
        zhHans: '当前连续 $current 天 · 最高 $longest 天',
        en: 'Current streak: $current day${current == 1 ? '' : 's'}',
        ja: '現在 $current 日連続 · 最高 $longest 日',
      );
  String recoveryAchievement(int count) {
    final String label = count >= 100
        ? _text(zhHant: '百折不撓', zhHans: '百折不挠', en: 'Unbreakable', ja: '不屈')
        : count >= 50
            ? _text(
                zhHant: '重新上手', zhHans: '重新上手', en: 'Back on Track', ja: '再挑戦')
            : count >= 10
                ? _text(
                    zhHant: '重整旗鼓', zhHans: '重整旗鼓', en: 'Regroup', ja: '立て直し')
                : _text(
                    zhHant: '錯題重做 $count / 10',
                    zhHans: '错题重做 $count / 10',
                    en: 'Review recovery $count / 10',
                    ja: '解き直し $count / 10');
    return label;
  }

  String topicAchievement(String topic, int milestone) {
    final String level = switch (milestone) {
      100 => _text(zhHant: '達人', zhHans: '达人', en: 'Master', ja: '達人'),
      50 => _text(zhHant: '熟手', zhHans: '熟手', en: 'Familiar', ja: '経験者'),
      _ => _text(zhHant: '新手', zhHans: '新手', en: 'Beginner', ja: '入門者'),
    };
    return '$topic $level';
  }

  String get settingsTitle => _text(
        zhHant: '角色與設定',
        zhHans: '角色与设置',
        en: 'Profiles & Settings',
        ja: 'プロフィールと設定',
      );
  String get settingsSubtitle => _text(
        zhHant: '在這裡管理角色、出題年級範圍與目前使用者。',
        zhHans: '在这里管理角色、出题年级范围与当前使用者。',
        en: 'Manage learners, grade ranges, and the active profile here.',
        ja: 'ここで学習者、出題学年範囲、現在の利用者を管理します。',
      );
  String get topicPracticeTitle => _text(
        zhHant: '指定主題練習',
        zhHans: '指定主题练习',
        en: 'Practice by Topic',
        ja: '分野別練習',
      );
  String get topicPracticeSubtitle => _text(
        zhHant: '依目前年級範圍，選擇想加強的主題。',
        zhHans: '按当前年级范围，选择想加强的主题。',
        en: 'Choose a topic to practice within the current grade range.',
        ja: '現在の学年範囲に合わせて、強化したい分野を選びます。',
      );
  String get chooseTopic =>
      _text(zhHant: '指定主題', zhHans: '指定主题', en: 'Choose topic', ja: '分野を選ぶ');
  String get selectedTopicLabel => _text(
        zhHant: '已選主題',
        zhHans: '已选主题',
        en: 'Selected topic',
        ja: '選択中の分野',
      );
  String get noLearnerSelected => _text(
        zhHant: '尚未選擇角色',
        zhHans: '尚未选择角色',
        en: 'No learner selected',
        ja: '学習者が未選択です',
      );
  String get historyTitle =>
      _text(zhHant: '作答紀錄', zhHans: '作答记录', en: 'History', ja: '履歴');
  String get historySubtitle => _text(
        zhHant: '查看目前學習者最近的練習與測驗紀錄。',
        zhHans: '查看当前学习者最近的练习与测验记录。',
        en: 'Review the current learner\'s recent practice and quiz sessions.',
        ja: '現在の学習者の最近の練習とテスト履歴を確認します。',
      );
  String get historyPreviewTitle => _text(
        zhHant: '最近作答',
        zhHans: '最近作答',
        en: 'Recent sessions',
        ja: '最近のセッション',
      );
  String get historyPreviewBody => _text(
        zhHant: '保留每次練習與測驗的結果，之後可延伸成錯題本與主題分析。',
        zhHans: '保留每次练习与测验的结果，之后可扩展为错题本与主题分析。',
        en: 'Keep each practice and quiz result ready for future review and analysis.',
        ja: '各セッション結果を残し、今後は弱点集や分野分析へ発展できます。',
      );
  String get viewHistory =>
      _text(zhHant: '查看紀錄', zhHans: '查看记录', en: 'View history', ja: '履歴を見る');
  String get historyEmpty => _text(
        zhHant: '目前還沒有作答紀錄。',
        zhHans: '目前还没有作答记录。',
        en: 'No session history yet.',
        ja: 'まだ履歴がありません。',
      );
  String get sessionDetailTitle => _text(
        zhHant: '作答明細',
        zhHans: '作答明细',
        en: 'Session Detail',
        ja: 'セッション詳細',
      );
  String yourAnswerLabel(String answer) {
    return _text(
      zhHant: '你的答案：$answer',
      zhHans: '你的答案：$answer',
      en: 'Your answer: $answer',
      ja: 'あなたの答え: $answer',
    );
  }

  String get libraryTitle =>
      _text(zhHant: '題庫', zhHans: '题库', en: 'Question Library', ja: '問題集');
  String get librarySubtitle => _text(
        zhHant: '以固定格式持續擴充題目、答案與解題步驟。',
        zhHans: '以固定格式持续扩充题目、答案与解题步骤。',
        en: 'Grow the bank with one stable format for prompts and solutions.',
        ja: '問題文、解答、解説を同じ形式で継続的に追加します。',
      );
  String get browseLibrary =>
      _text(zhHant: '瀏覽題庫', zhHans: '浏览题库', en: 'Browse library', ja: '問題集を見る');
  String get startPractice =>
      _text(zhHant: '開始練習', zhHans: '开始练习', en: 'Start practice', ja: '練習開始');
  String get startSelectedTopicPractice => _text(
        zhHant: '開始這個主題的練習',
        zhHans: '开始这个主题的练习',
        en: 'Start selected topic',
        ja: 'この分野を練習する',
      );
  String get startQuiz =>
      _text(zhHant: '開始測驗', zhHans: '开始测验', en: 'Start quiz', ja: 'テスト開始');
  String get quizStartHint => _text(
        zhHant: '測驗會依目前年級範圍自動抽題，完成整份後再統一看分數與詳解。',
        zhHans: '测验会按当前年级范围自动抽题，完成整份后再统一看分数与详解。',
        en: 'Quiz questions are selected automatically for the current grade range. Review score and solutions after submission.',
        ja: 'テスト問題は現在の学年範囲に合わせて自動選定され、提出後に得点と解説をまとめて確認します。',
      );
  String get noApprovedQuestionsInRange => _text(
        zhHant: '這個年級範圍目前還沒有通過審查的題目。',
        zhHans: '这个年级范围目前还没有通过审查的题目。',
        en: 'There are no approved questions in this grade range yet.',
        ja: 'この学年範囲には、まだ審査済みの問題がありません。',
      );
  String get languageSettingsTitle => _text(
        zhHant: '語言',
        zhHans: '语言',
        en: 'Language',
        ja: '言語',
      );
  String get languageSettingsSubtitle => _text(
        zhHant: '介面語系在這裡切換，題目內容也會同步切換到可用版本。',
        zhHans: '界面语言在这里切换，题目内容也会同步切换到可用版本。',
        en: 'Switch the interface language here. Question content follows the selected locale when translations are available.',
        ja: 'ここで表示言語を切り替えます。問題文も利用可能な翻訳に合わせて切り替わります。',
      );
  String get helpAndPrivacyTitle => _text(
        zhHant: '支援與隱私',
        zhHans: '支持与隐私',
        en: 'Help & Privacy',
        ja: 'サポートとプライバシー',
      );
  String get helpAndPrivacySubtitle => _text(
        zhHant: '查看使用說明與資料處理方式。',
        zhHans: '查看使用说明与数据处理方式。',
        en: 'Read support information and how data is handled.',
        ja: '使い方とデータの取り扱いを確認します。',
      );
  String get supportLinkLabel =>
      _text(zhHant: '支援', zhHans: '支持', en: 'Support', ja: 'サポート');
  String get privacyLinkLabel => _text(
      zhHant: '隱私政策', zhHans: '隐私政策', en: 'Privacy Policy', ja: 'プライバシーポリシー');
  String get linkOpenFailed => _text(
        zhHant: '目前無法開啟連結。',
        zhHans: '目前无法打开链接。',
        en: 'Unable to open the link right now.',
        ja: '現在このリンクを開けません。',
      );
  String get topicArithmetic =>
      _text(zhHant: '計算', zhHans: '计算', en: 'Arithmetic', ja: '計算');
  String get topicGeometry =>
      _text(zhHant: '幾何', zhHans: '几何', en: 'Geometry', ja: '図形');
  String get topicLogic =>
      _text(zhHant: '邏輯', zhHans: '逻辑', en: 'Logic', ja: '論理');
  String get topicMixed =>
      _text(zhHant: '綜合', zhHans: '综合', en: 'Mixed', ja: '総合');
  String get previewLabel =>
      _text(zhHant: '示範題目', zhHans: '示范题目', en: 'Sample Prompt', ja: 'サンプル問題');
  String get previewQuestion => _text(
        zhHant: '兩個相同的正方形拼成長方形後，周長增加了多少？',
        zhHans: '两个相同的正方形拼成长方形后，周长增加了多少？',
        en: 'If two equal squares form one rectangle, how much does the perimeter change?',
        ja: '同じ正方形 2 つを長方形に並べると、周の長さはどれだけ増えますか。',
      );
  String get openDemoCta => _text(
        zhHant: '查看函數圖形示範',
        zhHans: '查看函数图形示范',
        en: 'View graph demo',
        ja: '関数グラフのデモを見る',
      );
  String get demoTitle => _text(
        zhHant: '座標平面上的正弦與餘弦',
        zhHans: '坐标平面上的正弦与余弦',
        en: 'Sine and cosine on the coordinate plane',
        ja: '座標平面上の sin と cos',
      );
  String get demoSubtitle => _text(
        zhHant: '這一頁完全由 Flutter 直接繪製，不是點陣圖。它包含座標軸、刻度、圖例與重點角度標示。',
        zhHans: '这一页完全由 Flutter 直接绘制，不是位图。它包含坐标轴、刻度、图例与重点角度标示。',
        en: 'This page is drawn directly by Flutter, not a bitmap. It includes axes, ticks, a legend, and highlighted key angles.',
        ja: 'このページはビットマップではなく Flutter で直接描画しています。軸、目盛り、凡例、重要角度の表示を含みます。',
      );
  String get demoQuestion => _text(
        zhHant: '觀察圖形，在區間 0 到 2π 之間，sin(x) 與 cos(x) 分別在何處達到最大值？',
        zhHans: '观察图形，在区间 0 到 2π 之间，sin(x) 与 cos(x) 分别在何处达到最大值？',
        en: 'Inspect the graph. On the interval from 0 to 2π, where do sin(x) and cos(x) each reach their maximum value?',
        ja: '図を見て、0 から 2π の区間で sin(x) と cos(x) がそれぞれ最大になるのはどこですか。',
      );
  String get demoLegend =>
      _text(zhHant: '圖例', zhHans: '图例', en: 'Graph Legend', ja: '凡例');
  String get demoLegendSin => 'sin(x)';
  String get demoLegendCos => 'cos(x)';
  String get demoLegendBand => _text(
        zhHant: '重點觀察區段',
        zhHans: '重点观察区段',
        en: 'Focus interval',
        ja: '注目区間',
      );
  String get demoNote => _text(
        zhHant: '可延伸成互動題：點選角度、逐步顯示輔助線、切換語言標籤。',
        zhHans: '可扩展为互动题：点击角度、逐步显示辅助线、切换语言标签。',
        en: 'This can grow into an interactive problem with tappable angles, guided hints, and multilingual labels.',
        ja: '角度のタップ、補助線の段階表示、多言語ラベル切替などの対話型問題へ発展できます。',
      );
  String get vectorDrawingTitle =>
      _text(zhHant: '向量繪製', zhHans: '向量绘制', en: 'Vector Drawing', ja: 'ベクター描画');
  String get bitmapAssetsLabel => _text(
      zhHant: '點陣素材', zhHans: '位图素材', en: 'Bitmap assets', ja: 'ビットマップ素材');
  String get customPainterLabel => _text(
      zhHant: 'CustomPainter',
      zhHans: 'CustomPainter',
      en: 'CustomPainter',
      ja: 'CustomPainter');
  String get chooseOneAnswer => _text(
        zhHant: '請選擇一個答案',
        zhHans: '请选择一个答案',
        en: 'Choose one answer',
        ja: '答えを 1 つ選んでください',
      );
  String get enterIntegerAnswer => _text(
        zhHant: '請輸入整數答案',
        zhHans: '请输入整数答案',
        en: 'Enter an integer answer',
        ja: '整数で入力してください',
      );
  String get selfCheckLabel => _text(
        zhHant: '先自行作答，再查看解析',
        zhHans: '先自行作答，再查看解析',
        en: 'Solve first, then review the solution',
        ja: 'まず自分で解き、その後で解説を確認します',
      );
  String get answerLabel =>
      _text(zhHant: '作答方式', zhHans: '作答方式', en: 'Answer Mode', ja: '解答方式');
  String get integerHint => _text(
      zhHant: '輸入整數', zhHans: '输入整数', en: 'Enter an integer', ja: '整数を入力');
  String get submitAnswer =>
      _text(zhHant: '提交答案', zhHans: '提交答案', en: 'Submit Answer', ja: '解答を送信');
  String get viewFigure =>
      _text(zhHant: '查看圖形', zhHans: '查看图形', en: 'View figure', ja: '図を表示');
  String get questionLabel =>
      _text(zhHant: '第', zhHans: '第', en: 'Question', ja: '問題');
  String get solvedLabel =>
      _text(zhHant: '完成題數', zhHans: '完成题数', en: 'Solved', ja: '完了数');
  String get accuracyLabel =>
      _text(zhHant: '正確率', zhHans: '正确率', en: 'Accuracy', ja: '正答率');
  String get practiceMode =>
      _text(zhHant: '練習模式', zhHans: '练习模式', en: 'Practice Mode', ja: '練習モード');
  String get practiceSummary => _text(
      zhHant: '練習摘要', zhHans: '练习摘要', en: 'Practice Summary', ja: '練習サマリー');
  String get quizMode =>
      _text(zhHant: '測驗模式', zhHans: '测验模式', en: 'Quiz Mode', ja: 'テストモード');
  String get submitQuiz =>
      _text(zhHant: '交卷', zhHans: '交卷', en: 'Submit quiz', ja: '提出');
  String get nextQuestion =>
      _text(zhHant: '下一題', zhHans: '下一题', en: 'Next question', ja: '次の問題');
  String get quizResult =>
      _text(zhHant: '測驗結果', zhHans: '测验结果', en: 'Quiz Result', ja: 'テスト結果');
  String get correctLabel =>
      _text(zhHant: '答對', zhHans: '答对', en: 'Correct', ja: '正解');
  String get incorrectLabel =>
      _text(zhHant: '答錯', zhHans: '答错', en: 'Incorrect', ja: '不正解');
  String get elapsedLabel =>
      _text(zhHant: '耗時', zhHans: '耗时', en: 'Elapsed', ja: '所要時間');
  String get correctSuffix =>
      _text(zhHant: '題答對', zhHans: '题答对', en: 'correct', ja: '問正解');

  String questionCountLabel(int count) {
    if (isTraditionalChinese || isSimplifiedChinese) {
      return '題';
    }
    if (isJapanese) {
      return '問';
    }
    return 'questions';
  }

  String questionCounter(int current, int total) {
    if (isTraditionalChinese) {
      return '第 $current 題 / 共 $total 題';
    }
    if (isSimplifiedChinese) {
      return '第 $current 题 / 共 $total 题';
    }
    if (isJapanese) {
      return '第 $current 問 / 全 $total 問';
    }
    return 'Question $current / $total';
  }

  String questionLabelWithNumber(int number) {
    if (isTraditionalChinese) {
      return '第 $number 題';
    }
    if (isSimplifiedChinese) {
      return '第 $number 题';
    }
    if (isJapanese) {
      return '第 $number 問';
    }
    return 'Question $number';
  }

  String levelStageDisplay(String levelStage) {
    return singleGradeDisplay(int.parse(levelStage.replaceFirst('grade', '')));
  }

  String singleGradeDisplay(int grade) {
    if (isTraditionalChinese) {
      if (grade <= 6) {
        return '小${_chineseGradeNumeral(grade)}';
      }
      if (grade <= 9) {
        return '國${_chineseGradeNumeral(grade - 6)}';
      }
      return '高${_chineseGradeNumeral(grade - 9)}';
    }
    if (isSimplifiedChinese) {
      if (grade <= 6) {
        return '小学${_chineseGradeNumeral(grade)}年级';
      }
      if (grade <= 9) {
        return '初${_chineseGradeNumeral(grade - 6)}';
      }
      return '高${_chineseGradeNumeral(grade - 9)}';
    }
    if (isJapanese) {
      if (grade <= 6) {
        return '小学 $grade 年';
      }
      if (grade <= 9) {
        return '中学 ${grade - 6} 年';
      }
      return '高校 ${grade - 9} 年';
    }
    return 'Grade $grade';
  }

  String gradeRangeDisplay(int startGrade, int endGrade) {
    if (startGrade == endGrade) {
      return singleGradeDisplay(startGrade);
    }
    if (isTraditionalChinese) {
      return '${singleGradeDisplay(startGrade)}到${singleGradeDisplay(endGrade)}';
    }
    if (isSimplifiedChinese) {
      return '${singleGradeDisplay(startGrade)}到${singleGradeDisplay(endGrade)}';
    }
    if (isJapanese) {
      return '${singleGradeDisplay(startGrade)}から${singleGradeDisplay(endGrade)}';
    }
    return 'Grades $startGrade-$endGrade';
  }

  String _chineseGradeNumeral(int grade) {
    const List<String> numerals = <String>[
      '零',
      '一',
      '二',
      '三',
      '四',
      '五',
      '六',
      '七',
      '八',
      '九',
      '十',
      '十一',
      '十二',
    ];
    return numerals[grade];
  }

  String tierDisplay(String tier) {
    switch (tier) {
      case 'foundation':
        return isTraditionalChinese ? '基礎' : 'Foundation';
      case 'advanced':
        return isTraditionalChinese ? '進階' : 'Advanced';
      case 'competition':
        return isTraditionalChinese ? '競賽' : 'Competition';
      default:
        return tier;
    }
  }
}

class TrigGraphDemoPage extends StatelessWidget {
  const TrigGraphDemoPage({
    super.key,
    required this.services,
    this.initialQuestion,
  });

  final AppServices services;
  final Question? initialQuestion;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final bool wide = MediaQuery.sizeOf(context).width >= 980;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.demoTitle),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Question>(
        future: initialQuestion == null
            ? Future<Question>.value(_buildTrigDemoQuestion())
            : Future<Question>.value(initialQuestion),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final Question question = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: _GraphPanel(
                              strings: strings,
                              question: question,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 4,
                            child: _DemoInfoPanel(
                              strings: strings,
                              question: question,
                              services: services,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _GraphPanel(strings: strings, question: question),
                          const SizedBox(height: 24),
                          _DemoInfoPanel(
                            strings: strings,
                            question: question,
                            services: services,
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

class _GraphPanel extends StatelessWidget {
  const _GraphPanel({required this.strings, required this.question});

  final AppStrings strings;
  final Question question;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.demoTitle,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Text(question.localizedPrompt(_localeCode(context)),
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),
            Text(strings.demoSubtitle,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            _QuestionFigureView(question: question),
          ],
        ),
      ),
    );
  }
}

class _DemoInfoPanel extends StatelessWidget {
  const _DemoInfoPanel({
    required this.strings,
    required this.question,
    required this.services,
  });

  final AppStrings strings;
  final Question question;
  final AppServices services;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionCard(
          title: strings.demoLegend,
          subtitle: question.localizedAnswer(_localeCode(context)),
          child: Column(
            children: [
              _LegendTile(
                label: strings.demoLegendSin,
                color: const Color(0xFF2563EB),
              ),
              const SizedBox(height: 12),
              _LegendTile(
                label: strings.demoLegendCos,
                color: const Color(0xFFDC2626),
              ),
              const SizedBox(height: 12),
              _LegendTile(
                label: strings.demoLegendBand,
                color: const Color(0xFF0F766E),
                isBand: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SectionCard(
          title: strings.answerLabel,
          subtitle: _answerModeSubtitle(strings, question.answerMode),
          child: _AnswerComposer(
            question: question,
            localeCode: _localeCode(context),
            strings: strings,
            services: services,
          ),
        ),
        const SizedBox(height: 20),
        _SectionCard(
          title: strings.vectorDrawingTitle,
          subtitle: strings.demoNote,
          child: _StatRow(
            leftValue: '0',
            leftLabel: strings.bitmapAssetsLabel,
            rightValue: '1',
            rightLabel: strings.customPainterLabel,
          ),
        ),
      ],
    );
  }
}

class _AnswerComposer extends StatelessWidget {
  const _AnswerComposer({
    required this.question,
    required this.localeCode,
    required this.strings,
    required this.services,
  });

  final Question question;
  final String localeCode;
  final AppStrings strings;
  final AppServices services;

  @override
  Widget build(BuildContext context) {
    switch (question.answerMode) {
      case AnswerMode.multipleChoice:
        final List<String> keys = (question.options?.keys.toList() ?? [])
          ..sort();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.chooseOneAnswer),
            const SizedBox(height: 14),
            ...keys.map(
              (key) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OutlinedButton(
                  key: ValueKey<String>('answer_option_${question.id}_$key'),
                  onPressed: () async {
                    final String? learnerId = services.currentLearnerId;
                    if (learnerId == null) {
                      return;
                    }
                    await services.saveQuestionProgress(
                      QuestionProgress(
                        learnerId: learnerId,
                        questionId: question.id,
                        status: key == question.correctAnswer.value
                            ? 'correct'
                            : 'incorrect',
                        lastResult: 'multiple_choice:$key',
                        updatedAtIso: DateTime.now().toUtc().toIso8601String(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(58),
                    alignment: Alignment.centerLeft,
                    foregroundColor: const Color(0xFF111827),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  child: Text(
                    '$key  ${question.localizedOptionLabel(key, localeCode)}',
                  ),
                ),
              ),
            ),
          ],
        );
      case AnswerMode.integerInput:
        return _IntegerAnswerField(
          question: question,
          services: services,
          strings: strings,
        );
      case AnswerMode.selfCheck:
        return Text(strings.selfCheckLabel);
    }
  }
}

class _IntegerAnswerField extends StatefulWidget {
  const _IntegerAnswerField({
    required this.question,
    required this.services,
    required this.strings,
  });

  final Question question;
  final AppServices services;
  final AppStrings strings;

  @override
  State<_IntegerAnswerField> createState() => _IntegerAnswerFieldState();
}

class _IntegerAnswerFieldState extends State<_IntegerAnswerField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String? learnerId = widget.services.currentLearnerId;
    final String value = _controller.text.trim();
    if (learnerId == null || value.isEmpty) {
      return;
    }

    await widget.services.saveQuestionProgress(
      QuestionProgress(
        learnerId: learnerId,
        questionId: widget.question.id,
        status: value == widget.question.correctAnswer.value
            ? 'correct'
            : 'incorrect',
        lastResult: 'integer_input:$value',
        updatedAtIso: DateTime.now().toUtc().toIso8601String(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.strings.enterIntegerAnswer),
        const SizedBox(height: 14),
        TextField(
          key: ValueKey<String>('practice_integer_input_${widget.question.id}'),
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: widget.strings.integerHint,
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          key: ValueKey<String>('submit_answer_${widget.question.id}'),
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF111827),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(widget.strings.submitAnswer),
        ),
      ],
    );
  }
}

class _QuestionFigureView extends StatelessWidget {
  const _QuestionFigureView({required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    final _FigureRenderSpec? spec = _buildFigureRenderSpec(question);
    if (spec == null) {
      return const SizedBox.shrink();
    }

    return AspectRatio(
      aspectRatio: spec.aspectRatio,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey<String>('figure_${question.figure.kind}'),
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            showDialog<void>(
              context: context,
              barrierColor: const Color(0xE6111827),
              builder: (_) => _FigurePreviewDialog(
                question: question,
                spec: spec,
              ),
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            padding: const EdgeInsets.all(16),
            child: spec.child,
          ),
        ),
      ),
    );
  }
}

class _FigureRenderSpec {
  const _FigureRenderSpec({
    required this.child,
    required this.aspectRatio,
  });

  final Widget child;
  final double aspectRatio;
}

_FigureRenderSpec? _buildFigureRenderSpec(Question question) {
  final String kind = question.figure.kind;
  final Widget? figureChild = switch (kind) {
    'trig_plane' => CustomPaint(
        painter: TrigGraphPainter(),
        child: const SizedBox.expand(),
      ),
    'shape_diagram' => CustomPaint(
        painter: ShapeDiagramPainter(
          shape: question.figure.params['shape'] as String? ?? 'rectangle',
          labels: _stringMapFromDynamic(question.figure.params['labels']),
        ),
        child: const SizedBox.expand(),
      ),
    'coordinate_plane' => CustomPaint(
        painter: CoordinatePlanePainter(
          minX: _intFromDynamic(question.figure.params['minX'], fallback: 0),
          maxX: _intFromDynamic(question.figure.params['maxX'], fallback: 6),
          minY: _intFromDynamic(question.figure.params['minY'], fallback: 0),
          maxY: _intFromDynamic(question.figure.params['maxY'], fallback: 6),
          showGrid: question.figure.params['showGrid'] as bool? ?? true,
          points: _pointListFromDynamic(question.figure.params['points']),
          pathPoints: _pointListFromDynamic(question.figure.params['path']),
          highlightPoint: _pointFromDynamic(
            question.figure.params['highlightPoint'],
          ),
        ),
        child: const SizedBox.expand(),
      ),
    'geometry_scene' => CustomPaint(
        painter: GeometryScenePainter(
          scene: GeometryScene.fromParams(question.figure.params),
        ),
        child: const SizedBox.expand(),
      ),
    'composite_grid_shape' => CustomPaint(
        painter: CompositeGridShapePainter(
          rows: _intFromDynamic(question.figure.params['rows'], fallback: 3),
          cols: _intFromDynamic(question.figure.params['cols'], fallback: 3),
          filledCells:
              _cellListFromDynamic(question.figure.params['filledCells']),
          cellLabels:
              _stringMapFromDynamic(question.figure.params['cellLabels']),
        ),
        child: const SizedBox.expand(),
      ),
    'circle_quadrants_point' => CustomPaint(
        painter: CircleQuadrantsPointPainter(
          regionLabels: _stringMapFromDynamic(
            question.figure.params['regionLabels'],
          ),
          pointLabel: question.figure.params['pointLabel'] as String? ?? 'P',
          shadedRegion:
              question.figure.params['shadedRegion'] as String? ?? 'topRight',
        ),
        child: const SizedBox.expand(),
      ),
    _ => null,
  };

  if (figureChild == null) {
    return null;
  }

  final double aspectRatio = switch (kind) {
    'shape_diagram' => 1.25,
    'coordinate_plane' => 1.35,
    'composite_grid_shape' => 1.1,
    'circle_quadrants_point' => 1.15,
    'geometry_scene' => _geometrySceneAspectRatio(question.figure.params),
    _ => 1.55,
  };

  return _FigureRenderSpec(
    child: figureChild,
    aspectRatio: aspectRatio,
  );
}

class _FigurePreviewDialog extends StatelessWidget {
  const _FigurePreviewDialog({
    required this.question,
    required this.spec,
  });

  final Question question;
  final _FigureRenderSpec spec;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      key: const ValueKey<String>('figure_preview_dialog'),
      backgroundColor: const Color(0xFFF8FAFC),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    key: const ValueKey<String>('figure_preview_close'),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      AppStrings.of(context).viewFigure,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                panEnabled: true,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: spec.aspectRatio,
                      child: Container(
                        key: ValueKey<String>(
                          'figure_preview_canvas_${question.figure.kind}',
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: _buildFigureRenderSpec(question)!.child,
                      ),
                    ),
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

double _geometrySceneAspectRatio(Map<String, dynamic> params) {
  final Map<String, dynamic> b =
      Map<String, dynamic>.from(params['bounds'] as Map? ?? const {});
  final double spanX = ((b['maxX'] ?? 1) as num).toDouble() -
      ((b['minX'] ?? 0) as num).toDouble();
  final double spanY = ((b['maxY'] ?? 1) as num).toDouble() -
      ((b['minY'] ?? 0) as num).toDouble();
  if (spanY <= 0) return 1.2;
  return (spanX / spanY).clamp(0.75, 1.7).toDouble();
}

/// 依 [GeometryScene] 宣告式規格畫向量幾何圖（點/線段/陰影多邊形/圓弧/角度/直角/等長記號）。
class GeometryScenePainter extends CustomPainter {
  const GeometryScenePainter({required this.scene, this.labelFontFamily});

  final GeometryScene scene;

  /// 標籤字型；app 端不傳（用系統預設字型），僅供無頭渲染指定字型使用。
  final String? labelFontFamily;

  static const double _pad = 18;
  static const Color _ink = Color(0xFF1F2937);
  static const Color _accent = Color(0xFF2B5FA6);
  static const Color _shadeFill = Color(0x1FE47855);
  static const Color _shadeStroke = Color(0xFFC65B3C);

  Offset _p(String name, Size size) =>
      scene.pointToScreen(name, size, padding: _pad);
  Offset _m(Offset math, Size size) =>
      scene.toScreen(math, size, padding: _pad);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = _ink
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final Paint constrPaint = Paint()
      ..color = _accent
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final Paint markPaint = Paint()
      ..color = _accent
      ..strokeWidth = 1.7
      ..style = PaintingStyle.stroke;
    final Paint tickPaint = Paint()
      ..color = _ink
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    final Paint shadeFillPaint = Paint()
      ..color = _shadeFill
      ..style = PaintingStyle.fill;
    final Paint shadeStrokePaint = Paint()
      ..color = _shadeStroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // 1) 陰影多邊形
    for (final GeometryPolygon poly in scene.polygons) {
      final Path path = Path();
      for (int i = 0; i < poly.vertices.length; i++) {
        final Offset o = _p(poly.vertices[i], size);
        if (i == 0) {
          path.moveTo(o.dx, o.dy);
        } else {
          path.lineTo(o.dx, o.dy);
        }
      }
      path.close();
      canvas.drawPath(path, shadeFillPaint);
      canvas.drawPath(path, shadeStrokePaint);
    }

    // 2) 圓弧（沿數學弧取樣後轉螢幕座標，避免翻轉方向混淆）
    for (final GeometryArc arc in scene.arcs) {
      final Path path = Path();
      const int steps = 48;
      for (int i = 0; i <= steps; i++) {
        final double deg = arc.from + (arc.to - arc.from) * i / steps;
        final double rad = deg * math.pi / 180;
        final Offset sp = _m(
          Offset(
              arc.cx + arc.r * math.cos(rad), arc.cy + arc.r * math.sin(rad)),
          size,
        );
        if (i == 0) {
          path.moveTo(sp.dx, sp.dy);
        } else {
          path.lineTo(sp.dx, sp.dy);
        }
      }
      canvas.drawPath(path, linePaint);
    }

    // 3) 線段（實線 / 虛線輔助線）
    for (final GeometrySegment seg in scene.segments) {
      final Offset a = _p(seg.from, size);
      final Offset b = _p(seg.to, size);
      if (seg.style == GeometryLineStyle.construction) {
        _dashedLine(canvas, a, b, constrPaint);
      } else {
        canvas.drawLine(a, b, linePaint);
      }
    }

    // 4) 直角小方塊
    for (final GeometryRightAngle ra in scene.rightAngles) {
      final Offset v = _p(ra.at, size);
      final Offset d1 = _unit(_p(ra.from, size) - v);
      final Offset d2 = _unit(_p(ra.to, size) - v);
      const double k = 12;
      final Path path = Path()
        ..moveTo(v.dx + d1.dx * k, v.dy + d1.dy * k)
        ..lineTo(v.dx + (d1.dx + d2.dx) * k, v.dy + (d1.dy + d2.dy) * k)
        ..lineTo(v.dx + d2.dx * k, v.dy + d2.dy * k);
      canvas.drawPath(path, markPaint);
    }

    // 5) 角度弧＋數值
    for (final GeometryAngleMark am in scene.angleMarks) {
      final Offset v = _p(am.at, size);
      final Offset d1 = _unit(_p(am.from, size) - v);
      final Offset d2 = _unit(_p(am.to, size) - v);
      final double a1 = math.atan2(d1.dy, d1.dx);
      double sweep = math.atan2(d2.dy, d2.dx) - a1;
      while (sweep <= -math.pi) {
        sweep += 2 * math.pi;
      }
      while (sweep > math.pi) {
        sweep -= 2 * math.pi;
      }
      const double r = 22;
      canvas.drawArc(
          Rect.fromCircle(center: v, radius: r), a1, sweep, false, markPaint);
      if (am.label != null && am.label!.isNotEmpty) {
        final double midA = a1 + sweep / 2;
        final Offset lblAt =
            v + Offset(math.cos(midA), math.sin(midA)) * (r + 12);
        _text(canvas, am.label!, lblAt, size, color: _accent, sizePx: 13);
      }
    }

    // 6) 等長邊記號
    for (final GeometryEqualTick et in scene.equalTicks) {
      for (final List<String> seg in et.segments) {
        if (seg.length < 2) continue;
        final Offset a = _p(seg[0], size);
        final Offset b = _p(seg[1], size);
        final Offset mid = (a + b) / 2;
        final Offset dir = _unit(b - a);
        final Offset perp = Offset(-dir.dy, dir.dx);
        for (int i = 0; i < et.count; i++) {
          final double along = (i - (et.count - 1) / 2) * 5;
          final Offset c = mid + dir * along;
          canvas.drawLine(c - perp * 6, c + perp * 6, tickPaint);
        }
      }
    }

    // 7) 點與標籤（畫最上層）
    final Paint ptFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final Paint ptStroke = Paint()
      ..color = _ink
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    scene.points.forEach((String name, Offset _) {
      if (scene.pointIsVisible[name] == false) return;
      final Offset o = _p(name, size);
      canvas.drawCircle(o, 4.5, ptFill);
      canvas.drawCircle(o, 4.5, ptStroke);
      final Offset dir = _labelDir(scene.pointLabelPos[name] ?? 'r');
      _text(
        canvas,
        name,
        o + dir * 15,
        size,
        color: _ink,
        sizePx: 14,
        bold: true,
      );
    });
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint,
      {double dash = 6, double gap = 5}) {
    final double total = (b - a).distance;
    if (total == 0) return;
    final Offset dir = (b - a) / total;
    double d = 0;
    while (d < total) {
      final Offset s = a + dir * d;
      final Offset e = a + dir * math.min(d + dash, total);
      canvas.drawLine(s, e, paint);
      d += dash + gap;
    }
  }

  Offset _unit(Offset v) {
    final double len = v.distance;
    return len == 0 ? Offset.zero : v / len;
  }

  Offset _labelDir(String pos) => switch (pos) {
        't' => const Offset(0, -1),
        'b' => const Offset(0, 1),
        'l' => const Offset(-1, 0),
        'r' => const Offset(1, 0),
        'tl' => const Offset(-0.7, -0.7),
        'tr' => const Offset(0.7, -0.7),
        'bl' => const Offset(-0.7, 0.7),
        'br' => const Offset(0.7, 0.7),
        _ => const Offset(1, 0),
      };

  void _text(
    Canvas canvas,
    String text,
    Offset center,
    Size bounds, {
    required Color color,
    double sizePx = 13,
    bool bold = false,
  }) {
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: normalizeMathText(text),
        style: TextStyle(
          color: color,
          fontSize: sizePx,
          fontFamily: labelFontFamily,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    const double edgePadding = 4;
    final double halfWidth = tp.width / 2;
    final double halfHeight = tp.height / 2;
    final double clampedX = center.dx.clamp(
      halfWidth + edgePadding,
      bounds.width - halfWidth - edgePadding,
    );
    final double clampedY = center.dy.clamp(
      halfHeight + edgePadding,
      bounds.height - halfHeight - edgePadding,
    );
    tp.paint(canvas, Offset(clampedX - halfWidth, clampedY - halfHeight));
  }

  @override
  bool shouldRepaint(covariant GeometryScenePainter oldDelegate) =>
      oldDelegate.scene != scene;
}

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

Future<void> _openFirstEligiblePack({
  required BuildContext context,
  required AppServices services,
  required LearnerProfile? learner,
  required _SessionLaunchMode mode,
  String? topicCode,
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
  final List<Question> sessionQuestions =
      SessionLaunchPlanBuilder.randomizeQuestionOrderForSession(
    approvedQuestions,
  );

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
      ),
    _SessionLaunchMode.quiz => QuizSessionPage(
        services: services,
        pack: launchPack,
        initialQuestions: sessionQuestions,
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

String _displayTopicCode(String topicCode, AppStrings strings) {
  switch (topicCode) {
    case 'mixed':
      return strings.topicMixed;
    case 'geometry':
      return strings.topicGeometry;
    case 'arithmetic':
      return strings.topicArithmetic;
    case 'logic':
      return strings.topicLogic;
    default:
      return topicCode;
  }
}

bool _isCorrect(Question question, String submittedAnswer) {
  switch (question.answerMode) {
    case AnswerMode.multipleChoice:
    case AnswerMode.integerInput:
    case AnswerMode.selfCheck:
      return submittedAnswer == question.correctAnswer.value;
  }
}

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
      final String optionLabel = question.localizedOptionLabel(
        submittedAnswer,
        localeCode,
      );
      return '$submittedAnswer  $optionLabel';
    case AnswerMode.integerInput:
    case AnswerMode.selfCheck:
      return submittedAnswer;
  }
}

class _LegendTile extends StatelessWidget {
  const _LegendTile({
    required this.label,
    required this.color,
    this.isBand = false,
  });

  final String label;
  final Color color;
  final bool isBand;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 18,
          decoration: BoxDecoration(
            color: isBand ? color.withOpacity(0.18) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: isBand
                ? Container(
                    width: 34,
                    height: 2,
                    color: color,
                  )
                : Container(
                    width: 34,
                    height: 3,
                    color: color,
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }
}

class DiagramPoint {
  const DiagramPoint({
    required this.x,
    required this.y,
    this.label,
  });

  final int x;
  final int y;
  final String? label;
}

class TrigGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double leftPad = 56;
    const double rightPad = 28;
    const double topPad = 28;
    const double bottomPad = 40;
    final Rect plot = Rect.fromLTWH(
      leftPad,
      topPad,
      size.width - leftPad - rightPad,
      size.height - topPad - bottomPad,
    );

    final Paint gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1;
    final Paint axisPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 1.6;
    final Paint sinPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final Paint cosPaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final Paint bandPaint = Paint()
      ..color = const Color(0xFF0F766E).withOpacity(0.10)
      ..style = PaintingStyle.fill;
    final Paint markerPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;

    const double xMin = 0;
    const double xMax = math.pi * 2;
    const double yMin = -1.25;
    const double yMax = 1.25;

    double mapX(double x) =>
        plot.left + (x - xMin) / (xMax - xMin) * plot.width;
    double mapY(double y) =>
        plot.bottom - (y - yMin) / (yMax - yMin) * plot.height;

    final Rect focusBand = Rect.fromLTRB(
      mapX(math.pi / 2),
      plot.top,
      mapX(math.pi),
      plot.bottom,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(focusBand, const Radius.circular(12)),
      bandPaint,
    );

    for (int i = 0; i <= 8; i++) {
      final double y = plot.top + plot.height / 8 * i;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
    }

    for (int i = 0; i <= 8; i++) {
      final double x = plot.left + plot.width / 8 * i;
      canvas.drawLine(Offset(x, plot.top), Offset(x, plot.bottom), gridPaint);
    }

    canvas.drawLine(
      Offset(plot.left, mapY(0)),
      Offset(plot.right, mapY(0)),
      axisPaint,
    );
    canvas.drawLine(
      Offset(plot.left, plot.bottom),
      Offset(plot.left, plot.top),
      axisPaint,
    );

    final Path sinPath = Path();
    final Path cosPath = Path();
    const int samples = 480;
    for (int i = 0; i <= samples; i++) {
      final double t = xMin + (xMax - xMin) * i / samples;
      final Offset sinPoint = Offset(mapX(t), mapY(math.sin(t)));
      final Offset cosPoint = Offset(mapX(t), mapY(math.cos(t)));
      if (i == 0) {
        sinPath.moveTo(sinPoint.dx, sinPoint.dy);
        cosPath.moveTo(cosPoint.dx, cosPoint.dy);
      } else {
        sinPath.lineTo(sinPoint.dx, sinPoint.dy);
        cosPath.lineTo(cosPoint.dx, cosPoint.dy);
      }
    }

    canvas.drawPath(sinPath, sinPaint);
    canvas.drawPath(cosPath, cosPaint);

    final List<double> keyXs = [
      0,
      math.pi / 2,
      math.pi,
      math.pi * 3 / 2,
      math.pi * 2,
    ];
    final List<String> xLabels = ['0', 'π/2', 'π', '3π/2', '2π'];
    const TextStyle textStyle = TextStyle(
      color: Color(0xFF475569),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    for (int i = 0; i < keyXs.length; i++) {
      final double x = mapX(keyXs[i]);
      canvas.drawLine(
        Offset(x, mapY(0) - 6),
        Offset(x, mapY(0) + 6),
        axisPaint,
      );
      _paintText(
        canvas,
        xLabels[i],
        Offset(x - 12, plot.bottom + 10),
        textStyle,
      );
    }

    const List<double> yTicks = [-1, 0, 1];
    for (final double yValue in yTicks) {
      final double y = mapY(yValue);
      canvas.drawLine(
        Offset(plot.left - 6, y),
        Offset(plot.left + 6, y),
        axisPaint,
      );
      _paintText(
        canvas,
        yValue.toStringAsFixed(yValue == 0 ? 0 : 0),
        Offset(14, y - 9),
        textStyle,
      );
    }

    final List<Offset> highlights = [
      Offset(mapX(math.pi / 2), mapY(1)),
      Offset(mapX(0), mapY(1)),
      Offset(mapX(math.pi), mapY(-1)),
      Offset(mapX(math.pi * 3 / 2), mapY(-1)),
    ];
    for (final point in highlights) {
      canvas.drawCircle(point, 4.5, markerPaint);
    }

    _paintText(
      canvas,
      'x',
      Offset(plot.right + 6, mapY(0) - 8),
      const TextStyle(
        color: Color(0xFF334155),
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
    _paintText(
      canvas,
      'y',
      Offset(plot.left - 6, plot.top - 18),
      const TextStyle(
        color: Color(0xFF334155),
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  void _paintText(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ShapeDiagramPainter extends CustomPainter {
  const ShapeDiagramPainter({
    required this.shape,
    required this.labels,
  });

  final String shape;
  final Map<String, String> labels;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outlinePaint = Paint()
      ..color = const Color(0xFF111827)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final Paint fillPaint = Paint()
      ..color = const Color(0xFFE0E7FF)
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromLTWH(
      size.width * 0.18,
      size.height * 0.18,
      size.width * 0.64,
      size.height * 0.48,
    );

    switch (shape) {
      case 'compass':
        final Offset center = Offset(size.width / 2, size.height / 2);
        final Paint linePaint = Paint()
          ..color = const Color(0xFF111827)
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;
        final double arm = math.min(size.width, size.height) * 0.24;
        canvas.drawLine(
          Offset(center.dx, center.dy - arm),
          Offset(center.dx, center.dy + arm),
          linePaint,
        );
        canvas.drawLine(
          Offset(center.dx - arm, center.dy),
          Offset(center.dx + arm, center.dy),
          linePaint,
        );
        _paintText(canvas, labels['top'] ?? 'N',
            Offset(center.dx, center.dy - arm - 22));
        _paintText(canvas, labels['right'] ?? 'E',
            Offset(center.dx + arm + 22, center.dy));
        _paintText(canvas, labels['bottom'] ?? 'S',
            Offset(center.dx, center.dy + arm + 22));
        _paintText(canvas, labels['left'] ?? 'W',
            Offset(center.dx - arm - 22, center.dy));
        _paintText(canvas, labels['center'], center);
        break;
      case 'square':
        final double side = math.min(rect.width, rect.height);
        final Rect square = Rect.fromCenter(
          center: rect.center,
          width: side,
          height: side,
        );
        canvas.drawRect(square, fillPaint);
        canvas.drawRect(square, outlinePaint);
        _paintShapeLabels(canvas, square);
        break;
      case 'triangle':
        final Path triangle = Path()
          ..moveTo(size.width * 0.5, size.height * 0.16)
          ..lineTo(size.width * 0.22, size.height * 0.7)
          ..lineTo(size.width * 0.78, size.height * 0.7)
          ..close();
        canvas.drawPath(triangle, fillPaint);
        canvas.drawPath(triangle, outlinePaint);
        _paintText(
            canvas, labels['top'], Offset(size.width * 0.5, size.height * 0.1));
        _paintText(canvas, labels['left'],
            Offset(size.width * 0.18, size.height * 0.48));
        _paintText(canvas, labels['right'],
            Offset(size.width * 0.82, size.height * 0.48));
        _paintText(canvas, labels['bottom'],
            Offset(size.width * 0.5, size.height * 0.76));
        break;
      case 'trapezoid':
        final Path trapezoid = Path()
          ..moveTo(size.width * 0.34, size.height * 0.22)
          ..lineTo(size.width * 0.66, size.height * 0.22)
          ..lineTo(size.width * 0.8, size.height * 0.7)
          ..lineTo(size.width * 0.2, size.height * 0.7)
          ..close();
        canvas.drawPath(trapezoid, fillPaint);
        canvas.drawPath(trapezoid, outlinePaint);
        _paintText(canvas, labels['top'],
            Offset(size.width * 0.5, size.height * 0.14));
        _paintText(canvas, labels['bottom'],
            Offset(size.width * 0.5, size.height * 0.78));
        _paintText(canvas, labels['left'],
            Offset(size.width * 0.16, size.height * 0.46));
        _paintText(canvas, labels['right'],
            Offset(size.width * 0.84, size.height * 0.46));
        _paintText(canvas, labels['center'],
            Offset(size.width * 0.5, size.height * 0.48));
        break;
      case 'parallelogram':
        final Path parallelogram = Path()
          ..moveTo(size.width * 0.3, size.height * 0.22)
          ..lineTo(size.width * 0.76, size.height * 0.22)
          ..lineTo(size.width * 0.64, size.height * 0.7)
          ..lineTo(size.width * 0.18, size.height * 0.7)
          ..close();
        canvas.drawPath(parallelogram, fillPaint);
        canvas.drawPath(parallelogram, outlinePaint);
        _paintText(canvas, labels['top'],
            Offset(size.width * 0.53, size.height * 0.14));
        _paintText(canvas, labels['bottom'],
            Offset(size.width * 0.41, size.height * 0.78));
        _paintText(canvas, labels['left'],
            Offset(size.width * 0.14, size.height * 0.48));
        _paintText(canvas, labels['right'],
            Offset(size.width * 0.8, size.height * 0.48));
        _paintText(canvas, labels['center'],
            Offset(size.width * 0.47, size.height * 0.46));
        break;
      case 'pentagon':
        final Path pentagon = Path()
          ..moveTo(size.width * 0.5, size.height * 0.14)
          ..lineTo(size.width * 0.78, size.height * 0.34)
          ..lineTo(size.width * 0.68, size.height * 0.7)
          ..lineTo(size.width * 0.32, size.height * 0.7)
          ..lineTo(size.width * 0.22, size.height * 0.34)
          ..close();
        canvas.drawPath(pentagon, fillPaint);
        canvas.drawPath(pentagon, outlinePaint);
        _paintText(canvas, labels['top'],
            Offset(size.width * 0.5, size.height * 0.08));
        _paintText(canvas, labels['left'],
            Offset(size.width * 0.16, size.height * 0.44));
        _paintText(canvas, labels['right'],
            Offset(size.width * 0.84, size.height * 0.44));
        _paintText(canvas, labels['bottom'],
            Offset(size.width * 0.5, size.height * 0.78));
        _paintText(canvas, labels['center'],
            Offset(size.width * 0.5, size.height * 0.46));
        break;
      case 'hexagon':
        final Path hexagon = Path()
          ..moveTo(size.width * 0.34, size.height * 0.18)
          ..lineTo(size.width * 0.66, size.height * 0.18)
          ..lineTo(size.width * 0.82, size.height * 0.44)
          ..lineTo(size.width * 0.66, size.height * 0.7)
          ..lineTo(size.width * 0.34, size.height * 0.7)
          ..lineTo(size.width * 0.18, size.height * 0.44)
          ..close();
        canvas.drawPath(hexagon, fillPaint);
        canvas.drawPath(hexagon, outlinePaint);
        _paintText(
            canvas, labels['top'], Offset(size.width * 0.5, size.height * 0.1));
        _paintText(canvas, labels['left'],
            Offset(size.width * 0.14, size.height * 0.44));
        _paintText(canvas, labels['right'],
            Offset(size.width * 0.86, size.height * 0.44));
        _paintText(canvas, labels['bottom'],
            Offset(size.width * 0.5, size.height * 0.78));
        _paintText(canvas, labels['center'],
            Offset(size.width * 0.5, size.height * 0.44));
        break;
      case 'circle':
        final Offset center = Offset(size.width / 2, size.height / 2);
        final double radius = math.min(size.width, size.height) * 0.24;
        canvas.drawCircle(center, radius, fillPaint);
        canvas.drawCircle(center, radius, outlinePaint);
        _paintText(canvas, labels['center'], center);
        _paintText(
            canvas, labels['top'], Offset(center.dx, center.dy - radius - 18));
        _paintText(canvas, labels['right'],
            Offset(center.dx + radius + 18, center.dy));
        break;
      case 'oval':
        final Rect oval = Rect.fromCenter(
          center: rect.center,
          width: rect.width * 0.92,
          height: rect.height * 0.86,
        );
        canvas.drawOval(oval, fillPaint);
        canvas.drawOval(oval, outlinePaint);
        _paintShapeLabels(canvas, oval);
        break;
      case 'rectangle':
      default:
        canvas.drawRect(rect, fillPaint);
        canvas.drawRect(rect, outlinePaint);
        _paintShapeLabels(canvas, rect);
        break;
    }
  }

  void _paintShapeLabels(Canvas canvas, Rect rect) {
    _paintText(canvas, labels['top'], Offset(rect.center.dx, rect.top - 18));
    _paintText(
        canvas, labels['bottom'], Offset(rect.center.dx, rect.bottom + 18));
    _paintText(canvas, labels['left'], Offset(rect.left - 18, rect.center.dy));
    _paintText(
        canvas, labels['right'], Offset(rect.right + 18, rect.center.dy));
    _paintText(canvas, labels['center'], rect.center);
  }

  @override
  bool shouldRepaint(covariant ShapeDiagramPainter oldDelegate) {
    return oldDelegate.shape != shape ||
        oldDelegate.labels.toString() != labels.toString();
  }
}

class CircleQuadrantsPointPainter extends CustomPainter {
  const CircleQuadrantsPointPainter({
    required this.regionLabels,
    required this.pointLabel,
    required this.shadedRegion,
  });

  final Map<String, String> regionLabels;
  final String pointLabel;
  final String shadedRegion;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outlinePaint = Paint()
      ..color = const Color(0xFF111827)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final Paint connectorPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final Paint fillPaint = Paint()
      ..color = const Color(0xFFE0E7FF)
      ..style = PaintingStyle.fill;
    final Paint pointPaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width, size.height) * 0.34;
    final Offset top = Offset(center.dx, center.dy - radius);
    final Offset right = Offset(center.dx + radius, center.dy);
    final Offset bottom = Offset(center.dx, center.dy + radius);
    final Offset left = Offset(center.dx - radius, center.dy);
    final Offset pointP =
        Offset(center.dx - radius * 0.18, center.dy + radius * 0.1);

    if (shadedRegion == 'topRight') {
      final Path shadedPath = Path()
        ..moveTo(top.dx, top.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          -math.pi / 2,
          math.pi / 2,
          false,
        )
        ..lineTo(pointP.dx, pointP.dy)
        ..close();
      canvas.drawPath(shadedPath, fillPaint);
    }

    canvas.drawCircle(center, radius, outlinePaint);
    canvas.drawLine(top, pointP, connectorPaint);
    canvas.drawLine(right, pointP, connectorPaint);
    canvas.drawLine(bottom, pointP, connectorPaint);
    canvas.drawLine(left, pointP, connectorPaint);

    canvas.drawCircle(pointP, 4.5, pointPaint);

    _paintText(canvas, 'A', Offset(top.dx - 6, top.dy - 24));
    _paintText(canvas, 'B', Offset(right.dx + 18, right.dy - 8));
    _paintText(canvas, 'C', Offset(bottom.dx - 6, bottom.dy + 12));
    _paintText(canvas, 'D', Offset(left.dx - 24, left.dy - 8));
    _paintText(canvas, pointLabel, pointP + const Offset(-6, -22));

    _paintText(
      canvas,
      regionLabels['topLeft'],
      Offset(center.dx - radius * 0.34, center.dy - radius * 0.28),
    );
    _paintText(
      canvas,
      regionLabels['topRight'],
      Offset(center.dx + radius * 0.28, center.dy - radius * 0.26),
    );
    _paintText(
      canvas,
      regionLabels['bottomLeft'],
      Offset(center.dx - radius * 0.38, center.dy + radius * 0.3),
    );
    _paintText(
      canvas,
      regionLabels['bottomRight'],
      Offset(center.dx + radius * 0.26, center.dy + radius * 0.3),
    );
  }

  @override
  bool shouldRepaint(covariant CircleQuadrantsPointPainter oldDelegate) {
    return oldDelegate.regionLabels.toString() != regionLabels.toString() ||
        oldDelegate.pointLabel != pointLabel ||
        oldDelegate.shadedRegion != shadedRegion;
  }
}

class CoordinatePlanePainter extends CustomPainter {
  const CoordinatePlanePainter({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.showGrid,
    required this.points,
    required this.pathPoints,
    required this.highlightPoint,
  });

  final int minX;
  final int maxX;
  final int minY;
  final int maxY;
  final bool showGrid;
  final List<DiagramPoint> points;
  final List<DiagramPoint> pathPoints;
  final DiagramPoint? highlightPoint;

  @override
  void paint(Canvas canvas, Size size) {
    const double leftPad = 42;
    const double rightPad = 22;
    const double topPad = 20;
    const double bottomPad = 34;
    final Rect plot = Rect.fromLTWH(
      leftPad,
      topPad,
      size.width - leftPad - rightPad,
      size.height - topPad - bottomPad,
    );
    final Paint gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;
    final Paint axisPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 1.6;
    final Paint pointPaint = Paint()
      ..color = const Color(0xFF1D4ED8)
      ..style = PaintingStyle.fill;
    final Paint highlightPaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.fill;
    final Paint pathPaint = Paint()
      ..color = const Color(0xFF0F766E)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final int xSpan = math.max(maxX - minX, 1);
    final int ySpan = math.max(maxY - minY, 1);
    double mapX(int x) => plot.left + (x - minX) / xSpan * plot.width;
    double mapY(int y) => plot.bottom - (y - minY) / ySpan * plot.height;

    if (showGrid) {
      for (int x = minX; x <= maxX; x++) {
        final double dx = mapX(x);
        canvas.drawLine(
            Offset(dx, plot.top), Offset(dx, plot.bottom), gridPaint);
        _paintText(canvas, '$x', Offset(dx, plot.bottom + 14));
      }
      for (int y = minY; y <= maxY; y++) {
        final double dy = mapY(y);
        canvas.drawLine(
            Offset(plot.left, dy), Offset(plot.right, dy), gridPaint);
        if (y != 0) _paintText(canvas, '$y', Offset(plot.left - 14, dy));
      }
    }

    final double axisX = minX <= 0 && 0 <= maxX ? mapX(0) : plot.left;
    final double axisY = minY <= 0 && 0 <= maxY ? mapY(0) : plot.bottom;
    canvas.drawLine(
        Offset(plot.left, axisY), Offset(plot.right, axisY), axisPaint);
    canvas.drawLine(
        Offset(axisX, plot.bottom), Offset(axisX, plot.top), axisPaint);

    if (pathPoints.length >= 2) {
      final Path path = Path()
        ..moveTo(mapX(pathPoints.first.x), mapY(pathPoints.first.y));
      for (final DiagramPoint point in pathPoints.skip(1)) {
        path.lineTo(mapX(point.x), mapY(point.y));
      }
      canvas.drawPath(path, pathPaint);
    }

    for (final DiagramPoint point in points) {
      final Offset offset = Offset(mapX(point.x), mapY(point.y));
      final bool isHighlighted = highlightPoint != null &&
          point.x == highlightPoint!.x &&
          point.y == highlightPoint!.y;
      canvas.drawCircle(offset, 5, isHighlighted ? highlightPaint : pointPaint);
      if (point.label != null && point.label!.isNotEmpty) {
        _paintText(canvas, point.label, offset + const Offset(0, -16));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CoordinatePlanePainter oldDelegate) {
    return oldDelegate.minX != minX ||
        oldDelegate.maxX != maxX ||
        oldDelegate.minY != minY ||
        oldDelegate.maxY != maxY ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.points.length != points.length ||
        oldDelegate.pathPoints.length != pathPoints.length ||
        oldDelegate.highlightPoint?.x != highlightPoint?.x ||
        oldDelegate.highlightPoint?.y != highlightPoint?.y;
  }
}

class CompositeGridShapePainter extends CustomPainter {
  const CompositeGridShapePainter({
    required this.rows,
    required this.cols,
    required this.filledCells,
    required this.cellLabels,
  });

  final int rows;
  final int cols;
  final List<GridCell> filledCells;
  final Map<String, String> cellLabels;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = const Color(0xFFE0E7FF)
      ..style = PaintingStyle.fill;
    final Paint emptyPaint = Paint()
      ..color = const Color(0xFFF8FAFC)
      ..style = PaintingStyle.fill;
    final Paint gridPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final Paint outlinePaint = Paint()
      ..color = const Color(0xFF111827)
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke;

    final Set<String> filledKeys =
        filledCells.map((cell) => '${cell.row},${cell.col}').toSet();

    final double cellSize = math.min(
      (size.width * 0.72) / cols,
      (size.height * 0.72) / rows,
    );
    final double gridWidth = cols * cellSize;
    final double gridHeight = rows * cellSize;
    final double startX = (size.width - gridWidth) / 2;
    final double startY = (size.height - gridHeight) / 2;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final Rect cellRect = Rect.fromLTWH(
          startX + col * cellSize,
          startY + row * cellSize,
          cellSize,
          cellSize,
        );
        final String key = '$row,$col';
        canvas.drawRect(
            cellRect, filledKeys.contains(key) ? fillPaint : emptyPaint);
        canvas.drawRect(cellRect, gridPaint);
        _paintText(canvas, cellLabels[key], cellRect.center);
      }
    }

    for (final GridCell cell in filledCells) {
      final Rect cellRect = Rect.fromLTWH(
        startX + cell.col * cellSize,
        startY + cell.row * cellSize,
        cellSize,
        cellSize,
      );

      if (!filledKeys.contains('${cell.row - 1},${cell.col}')) {
        canvas.drawLine(cellRect.topLeft, cellRect.topRight, outlinePaint);
      }
      if (!filledKeys.contains('${cell.row + 1},${cell.col}')) {
        canvas.drawLine(
            cellRect.bottomLeft, cellRect.bottomRight, outlinePaint);
      }
      if (!filledKeys.contains('${cell.row},${cell.col - 1}')) {
        canvas.drawLine(cellRect.topLeft, cellRect.bottomLeft, outlinePaint);
      }
      if (!filledKeys.contains('${cell.row},${cell.col + 1}')) {
        canvas.drawLine(cellRect.topRight, cellRect.bottomRight, outlinePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CompositeGridShapePainter oldDelegate) {
    return oldDelegate.rows != rows ||
        oldDelegate.cols != cols ||
        oldDelegate.filledCells.toString() != filledCells.toString() ||
        oldDelegate.cellLabels.toString() != cellLabels.toString();
  }
}

void _paintText(Canvas canvas, String? text, Offset center) {
  if (text == null || text.isEmpty) {
    return;
  }
  final TextPainter painter = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(
        color: Color(0xFF0F172A),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(
    canvas,
    Offset(center.dx - painter.width / 2, center.dy - painter.height / 2),
  );
}

class GridCell {
  const GridCell({required this.row, required this.col});

  final int row;
  final int col;

  @override
  String toString() => 'GridCell(row: $row, col: $col)';
}

List<GridCell> _cellListFromDynamic(dynamic value) {
  if (value is! List) {
    return const <GridCell>[];
  }
  return value.whereType<List>().map((entry) {
    final int row =
        entry.isNotEmpty ? _intFromDynamic(entry[0], fallback: 0) : 0;
    final int col =
        entry.length > 1 ? _intFromDynamic(entry[1], fallback: 0) : 0;
    return GridCell(row: row, col: col);
  }).toList();
}

Map<String, String> _stringMapFromDynamic(dynamic raw) {
  if (raw is! Map) {
    return const {};
  }
  return Map<String, String>.from(
    raw.map((key, value) => MapEntry(key.toString(), value.toString())),
  );
}

int _intFromDynamic(dynamic raw, {required int fallback}) {
  if (raw is int) {
    return raw;
  }
  return int.tryParse(raw?.toString() ?? '') ?? fallback;
}

DiagramPoint? _pointFromDynamic(dynamic raw) {
  if (raw is! Map) {
    return null;
  }
  return DiagramPoint(
    x: _intFromDynamic(raw['x'], fallback: 0),
    y: _intFromDynamic(raw['y'], fallback: 0),
    label: raw['label']?.toString(),
  );
}

List<DiagramPoint> _pointListFromDynamic(dynamic raw) {
  if (raw is! List) {
    return const [];
  }
  return raw
      .whereType<Map>()
      .map(
        (item) => DiagramPoint(
          x: _intFromDynamic(item['x'], fallback: 0),
          y: _intFromDynamic(item['y'], fallback: 0),
          label: item['label']?.toString(),
        ),
      )
      .toList();
}
