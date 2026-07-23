import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/data/bundled/bundled_question_bank_repository.dart';
import 'package:mathspring/data/local/app_services.dart';
import 'package:mathspring/main.dart';
import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/learner_profile.dart';
import 'package:mathspring/models/question.dart';
import 'package:mathspring/models/question_progress.dart';
import 'package:mathspring/models/session_answer_record.dart';

void main() {
  tearDown(() {
    TestWidgetsFlutterBinding.ensureInitialized()
        .platformDispatcher
        .clearLocaleTestValue();
  });

  AppServices createTestServices({
    Future<void> Function(QuestionProgress progress)? onSaveQuestionProgress,
    Future<void> Function(
      AnswerSession session,
      List<SessionAnswerRecord> records,
    )? onSaveAnswerSession,
    List<QuestionProgress>? initialProgress,
    List<AnswerSession>? initialSessions,
    Map<String, List<SessionAnswerRecord>>? initialSessionRecords,
  }) {
    return AppServices.forTesting(
      learnerProfiles: const [
        LearnerProfile(
          id: 'learner_allen',
          displayName: 'Allen',
          levelStage: 'grade4',
          challengeTier: 'advanced',
          createdAtIso: '2026-07-16T00:00:00Z',
        ),
        LearnerProfile(
          id: 'learner_mia',
          displayName: 'Mia',
          levelStage: 'grade2',
          challengeTier: 'foundation',
          createdAtIso: '2026-07-16T00:01:00Z',
        ),
      ],
      currentLearnerId: 'learner_allen',
      onSaveQuestionProgress: onSaveQuestionProgress,
      onSaveAnswerSession: onSaveAnswerSession,
      initialProgress: initialProgress,
      initialSessions: initialSessions,
      initialSessionRecords: initialSessionRecords,
    );
  }

  Question createDemoQuestion() {
    return Question.fromJson({
      'id': 'geometry_grade4_foundation_001',
      'topic': 'geometry',
      'difficulty': 'foundation',
      'levelStage': 'grade4',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '觀察圖形，在 0 到 2π 間，sin(x) 與 cos(x) 分別在何處達到最大值？',
        'en':
            'Inspect the graph. On the interval from 0 to 2π, where do sin(x) and cos(x) each reach their maximum value?',
      },
      'answer': {
        'zh-Hant': 'sin(x) 在 π/2 取得最大值 1，cos(x) 在 0 取得最大值 1。',
        'en':
            'sin(x) reaches its maximum value 1 at π/2, and cos(x) reaches its maximum value 1 at 0.',
      },
      'solutionSteps': {
        'zh-Hant': [
          '先觀察藍色 sin(x) 曲線的最高點。',
          '最高點位於 y = 1，對應的 x 為 π/2。',
          '再觀察紅色 cos(x) 曲線的最高點。',
          '最高點位於 y = 1，對應的 x 為 0。',
        ],
        'en': [
          'Look at the highest point of the blue sin(x) curve.',
          'Its peak is at y = 1, which occurs at x = π/2.',
          'Then inspect the highest point of the red cos(x) curve.',
          'Its peak is at y = 1, which occurs at x = 0.',
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
          'en': 'sin(x) at 0, cos(x) at π/2',
        },
        'B': {
          'zh-Hant': 'sin(x) 在 π/2，cos(x) 在 0',
          'en': 'sin(x) at π/2, cos(x) at 0',
        },
        'C': {
          'zh-Hant': '兩者都在 π',
          'en': 'Both at π',
        },
        'D': {
          'zh-Hant': '兩者都在 2π',
          'en': 'Both at 2π',
        },
      },
      'correctAnswer': {
        'type': 'choice',
        'value': 'B',
      },
      'source': {
        'type': 'official_reference',
        'name': 'Math Kangaroo USA',
        'reference': '2025 Grades 3-4 Problem 12',
        'displayText': 'Math Kangaroo USA 2025, Grades 3-4, Problem 12',
      },
    });
  }

  Question createSecondDemoQuestion() {
    return Question.fromJson({
      'id': 'arithmetic_grade4_foundation_002',
      'topic': 'arithmetic',
      'difficulty': 'foundation',
      'levelStage': 'grade4',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '計算 18 + 27 的答案。',
        'en': 'Compute 18 + 27.',
      },
      'answer': {
        'zh-Hant': '答案是 45。',
        'en': 'The answer is 45.',
      },
      'solutionSteps': {
        'zh-Hant': [
          '先把十位數相加：10 + 20 = 30。',
          '再把個位數相加：8 + 7 = 15。',
          '最後合併成 30 + 15 = 45。',
        ],
        'en': [
          'Add the tens first: 10 + 20 = 30.',
          'Then add the ones: 8 + 7 = 15.',
          'Combine them to get 30 + 15 = 45.',
        ],
      },
      'figure': {
        'type': 'none',
        'kind': 'none',
      },
      'answerMode': 'integer_input',
      'correctAnswer': {
        'type': 'integer',
        'value': '45',
      },
    });
  }

  Question createShapeDiagramQuestion() {
    return Question.fromJson({
      'id': 'geometry_grade2_foundation_001',
      'topic': 'geometry',
      'difficulty': 'foundation',
      'levelStage': 'grade2',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '下圖長方形的長是 5，寬是 3，它的周長是多少？',
        'en': 'In the rectangle below, the length is 5 and the width is 3. What is its perimeter?',
      },
      'answer': {
        'zh-Hant': '答案是 16。',
        'en': 'The answer is 16.',
      },
      'solutionSteps': {
        'zh-Hant': [
          '長方形有兩條長和兩條寬。',
          '5 + 3 + 5 + 3 = 16。',
        ],
        'en': [
          'A rectangle has two lengths and two widths.',
          '5 + 3 + 5 + 3 = 16.',
        ],
      },
      'figure': {
        'type': 'custom',
        'kind': 'shape_diagram',
        'params': {
          'shape': 'rectangle',
          'labels': {
            'top': '5',
            'right': '3',
          },
        },
      },
      'answerMode': 'integer_input',
      'correctAnswer': {
        'type': 'integer',
        'value': '16',
      },
      'inputConstraints': {
        'allowNegative': false,
        'maxDigits': 2,
      },
    });
  }

  Question createCoordinatePlaneQuestion() {
    return Question.fromJson({
      'id': 'geometry_grade4_foundation_004',
      'topic': 'geometry',
      'difficulty': 'foundation',
      'levelStage': 'grade4',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '在座標平面上，點 (4, 1) 往上移 3 格後，會到哪一點？',
        'en': 'On the coordinate plane, if the point (4, 1) moves up 3 units, where does it land?',
      },
      'answer': {
        'zh-Hant': '往上移只增加縱坐標，所以到 (4,4)。',
        'en': 'Moving up increases only the y-coordinate, so the point becomes (4,4).',
      },
      'solutionSteps': {
        'zh-Hant': [
          '起點是 (4,1)。',
          '往上 3 格後 y 變成 4，x 不變。',
        ],
        'en': [
          'The start point is (4,1).',
          'After moving up 3 units, y becomes 4 and x stays the same.',
        ],
      },
      'figure': {
        'type': 'custom',
        'kind': 'coordinate_plane',
        'params': {
          'maxX': 6,
          'maxY': 6,
          'showGrid': true,
          'points': [
            {'x': 4, 'y': 1, 'label': 'A'},
            {'x': 4, 'y': 4, 'label': 'A\''},
          ],
          'path': [
            {'x': 4, 'y': 1},
            {'x': 4, 'y': 4},
          ],
          'highlightPoint': {'x': 4, 'y': 4},
        },
      },
      'answerMode': 'multiple_choice',
      'options': {
        'A': {
          'zh-Hant': '(7,1)',
          'en': '(7,1)',
        },
        'B': {
          'zh-Hant': '(4,4)',
          'en': '(4,4)',
        },
        'C': {
          'zh-Hant': '(1,4)',
          'en': '(1,4)',
        },
        'D': {
          'zh-Hant': '(4,-2)',
          'en': '(4,-2)',
        },
      },
      'correctAnswer': {
        'type': 'choice',
        'value': 'B',
      },
      'source': {
        'type': 'official_reference',
        'name': 'Math Kangaroo USA',
        'reference': '2025 Grades 3-4 Problem 12',
        'displayText': 'Math Kangaroo USA 2025, Grades 3-4, Problem 12',
      },
    });
  }

  Question createCircleQuadrantsPointQuestion() {
    return Question.fromJson({
      'id': 'geometry_grade6_foundation_014',
      'topic': 'geometry',
      'difficulty': 'competition',
      'levelStage': 'grade6',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '如圖，圓內有一點 P，與圓周上的四等分點 A、B、C、D 相連，分成四部分，其中三部分面積為 12、15、20。陰影部分面積是多少？',
        'en': 'In the diagram, a point P inside the circle is connected to four equally spaced points A, B, C, and D on the circle, creating four regions. Three regions have areas 12, 15, and 20. What is the shaded area?',
      },
      'answer': {
        'zh-Hant': '答案是 23。',
        'en': 'The answer is 23.',
      },
      'solutionSteps': {
        'zh-Hant': [
          '由四等分點形成的四段弓形面積彼此相等。',
          '利用正方形中心對稱拆分，可得陰影面積 = 15 + 20 - 12 = 23。',
        ],
        'en': [
          'The four circular segments cut by the quarter points are equal in area.',
          'Using the symmetric square model, the shaded area is 15 + 20 - 12 = 23.',
        ],
      },
      'figure': {
        'type': 'custom',
        'kind': 'circle_quadrants_point',
        'params': {
          'regionLabels': {
            'topLeft': '15',
            'bottomLeft': '20',
            'bottomRight': '12',
            'topRight': '?',
          },
          'pointLabel': 'P',
          'shadedRegion': 'topRight',
        },
      },
      'answerMode': 'integer_input',
      'correctAnswer': {
        'type': 'integer',
        'value': '23',
      },
      'inputConstraints': {
        'allowNegative': false,
        'maxDigits': 2,
      },
    });
  }

  Question createCompositeGridShapeQuestion() {
    return Question.fromJson({
      'id': 'geometry_grade3_foundation_019',
      'topic': 'geometry',
      'difficulty': 'foundation',
      'levelStage': 'grade3',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '一個長方形的一邊向內切進一個 2×1 的缺口。新圖形的周長比原來多幾？',
        'en':
            'A 2×1 notch is cut inward from one side of a rectangle. By how much does the perimeter increase?',
      },
      'answer': {
        'zh-Hant': '答案是 2。',
        'en': 'The answer is 2.',
      },
      'solutionSteps': {
        'zh-Hant': [
          '原來被切掉的那一段長是 2。',
          '新圖形多出兩條深度各 1 的邊，所以增加 1 + 1 = 2。',
        ],
        'en': [
          'The removed part on the old edge has length 2.',
          'The notch adds two new depth edges of length 1 each, so the perimeter increases by 2.',
        ],
      },
      'figure': {
        'type': 'custom',
        'kind': 'composite_grid_shape',
        'params': {
          'rows': 3,
          'cols': 4,
          'filledCells': [
            [0, 0],
            [0, 1],
            [0, 2],
            [0, 3],
            [1, 0],
            [1, 3],
            [2, 0],
            [2, 1],
            [2, 2],
            [2, 3],
          ],
          'cellLabels': {
            '1,1': '?',
          },
        },
      },
      'answerMode': 'integer_input',
      'correctAnswer': {
        'type': 'integer',
        'value': '2',
      },
      'inputConstraints': {
        'allowNegative': false,
        'maxDigits': 1,
      },
    });
  }

  Question createEditorialQuestion() {
    return Question.fromJson({
      'id': 'geometry_grade5_foundation_editorial_001',
      'topic': 'geometry',
      'difficulty': 'foundation',
      'levelStage': 'grade5',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '一個三角形三邊長分別是 3、4、5，它的周長是多少？',
        'en': 'A triangle has side lengths 3, 4, and 5. What is its perimeter?',
      },
      'answer': {
        'zh-Hant': '答案是 12。',
        'en': 'The answer is 12.',
      },
      'solutionSteps': {
        'zh-Hant': ['把三邊相加，3 + 4 + 5 = 12。'],
        'en': ['Add the three side lengths: 3 + 4 + 5 = 12.'],
      },
      'figure': {
        'type': 'none',
        'kind': 'none',
      },
      'answerMode': 'integer_input',
      'correctAnswer': {
        'type': 'integer',
        'value': '12',
      },
      'source': {
        'type': 'rewritten_olympiad_style',
        'name': 'MathSpring Editorial',
        'reference': 'geometry-grade5-foundation',
      },
    });
  }

  Question createMultilingualLayoutQuestion() {
    return Question.fromJson({
      'id': 'layout_locale_001',
      'topic': 'logic',
      'difficulty': 'foundation',
      'levelStage': 'grade4',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '在四個選項中，選出最符合規則的一項，並說明你是如何判斷的。',
        'zh-Hans': '在四个选项中，选出最符合规律的一项，并说明你是如何判断的。',
        'en': 'Choose the option that best matches the rule and explain how you decided.',
        'ja': '4 つの選択肢の中から規則に最も合うものを選び、判断のしかたを考えてください。',
      },
      'answer': {
        'zh-Hant': '答案是 B。',
        'zh-Hans': '答案是 B。',
        'en': 'The answer is B.',
        'ja': '答えは B です。',
      },
      'solutionSteps': {
        'zh-Hant': ['觀察每一列的變化。', '只有 B 同時符合兩個條件。'],
        'zh-Hans': ['观察每一列的变化。', '只有 B 同时符合两个条件。'],
        'en': ['Observe how each row changes.', 'Only B satisfies both conditions.'],
        'ja': ['各行の変化を観察します。', '2 つの条件を同時に満たすのは B だけです。'],
      },
      'figure': {
        'type': 'custom',
        'kind': 'none',
        'params': <String, dynamic>{},
      },
      'answerMode': 'multiple_choice',
      'options': {
        'A': {
          'zh-Hant': '第一列與第三列都改變方向',
          'zh-Hans': '第一列与第三列都改变方向',
          'en': 'Both the first and third rows change direction',
          'ja': '1 行目と 3 行目の両方が向きを変える',
        },
        'B': {
          'zh-Hant': '只有第二列同時改變顏色與位置',
          'zh-Hans': '只有第二列同时改变颜色与位置',
          'en': 'Only the second row changes both color and position',
          'ja': '2 行目だけが色と位置の両方を変える',
        },
      },
      'correctAnswer': {
        'type': 'choice',
        'value': 'B',
      },
      'source': {
        'type': 'official_reference',
        'name': 'Math Kangaroo USA',
        'reference': '2025 Grades 3-4 Problem 12',
        'displayText': 'Math Kangaroo USA 2025, Grades 3-4, Problem 12',
      },
    });
  }

  Future<void> pumpApp(WidgetTester tester, AppServices services) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(MathSpringApp(services: services));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    int maxAttempts = 100,
  }) async {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      if (finder.evaluate().isNotEmpty) {
        return;
      }
      await tester.pump(const Duration(milliseconds: 100));
    }
    fail('Finder not found after waiting: $finder');
  }

  testWidgets('shows English home content when system locale is English',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    expect(find.text('MathSpring'), findsAtLeastNWidgets(1));
    expect(find.text('Practice'), findsWidgets);
    expect(find.text('Start practice'), findsOneWidget);
    expect(find.text('Choose topic'), findsOneWidget);
    expect(find.text('Geometry'), findsNothing);
    expect(find.text('Arithmetic'), findsNothing);
    expect(find.text('Logic'), findsNothing);
  });

  testWidgets('app shell shows bottom navigation and defaults to Practice',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Practice'), findsWidgets);
    expect(find.text('Quiz'), findsWidgets);
    expect(find.text('Review'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Start practice'), findsOneWidget);
    expect(find.text('Choose topic'), findsOneWidget);
    expect(find.text('EN'), findsNothing);
    expect(find.text('繁中'), findsNothing);
    expect(find.text('Question Library'), findsNothing);
    expect(find.text('Browse library'), findsNothing);
  });

  testWidgets('shows Traditional Chinese home content when system locale is zh',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'TW');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    expect(find.text('MathSpring'), findsAtLeastNWidgets(1));
    expect(find.text('練習'), findsWidgets);
    expect(find.text('開始練習'), findsWidgets);
    expect(find.text('指定主題'), findsOneWidget);
    expect(find.text('幾何'), findsNothing);
  });

  testWidgets('shows Simplified Chinese home content when system locale is zh-CN',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'CN');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    expect(find.text('开始练习'), findsWidgets);
    expect(find.text('奥数思维训练'), findsOneWidget);
    expect(find.text('练习'), findsWidgets);
    expect(find.text('几何'), findsNothing);
  });

  testWidgets('shows Japanese home content when system locale is ja',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('ja');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    expect(find.text('練習開始'), findsWidgets);
    expect(find.text('オリンピック数学トレーニング'), findsOneWidget);
    expect(find.text('テスト'), findsWidgets);
    expect(find.text('図形'), findsNothing);
  });

  testWidgets('can manually switch from Chinese to English in settings',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'TW');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    expect(find.text('開始練習'), findsWidgets);

    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey<String>('locale_option_en')));
    await tester.tap(find.byKey(const ValueKey<String>('locale_option_en')));
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsOneWidget);
    await tester.tap(find.text('Practice'));
    await tester.pumpAndSettle();
    expect(find.text('Start practice'), findsOneWidget);
    expect(find.text('Practice'), findsWidgets);
  });

  testWidgets('practice topic selection shows chosen topic before starting',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    expect(find.text('Selected topic'), findsNothing);

    await tester.tap(find.byKey(const ValueKey<String>('open_topic_practice')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('topic_action_geometry')));
    await tester.pumpAndSettle();

    expect(find.text('Selected topic'), findsOneWidget);
    expect(find.text('Geometry'), findsAtLeastNWidgets(1));
    expect(find.byKey(const ValueKey<String>('open_start_practice')), findsOneWidget);
  });

  testWidgets('quiz tab focuses on start action instead of topic selection',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    await tester.tap(find.text('Quiz'));
    await tester.pumpAndSettle();

    expect(find.text('Start quiz'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('open_topic_quiz')), findsNothing);
    expect(find.text('Choose topic'), findsNothing);
  });

  testWidgets('home page opens the trigonometry drawing demo',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    QuestionProgress? savedProgress;
    final AppServices services = createTestServices(
      onSaveQuestionProgress: (progress) async {
        savedProgress = progress;
      },
    );

    await pumpApp(tester, services);

    expect(find.text('View graph demo'), findsOneWidget);

    await tester.tap(find.text('View graph demo'));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.text('Sine and cosine on the coordinate plane'),
      findsAtLeastNWidgets(1),
    );
    expect(find.text('Graph Legend'), findsOneWidget);
    expect(find.text('Choose one answer'), findsAtLeastNWidgets(1));
    expect(find.textContaining('B  sin(x) at π/2'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);

    final optionFinder = find.byKey(
      const ValueKey<String>('answer_option_geometry_demo_trig_plane_001_B'),
    );
    await pumpUntilFound(tester, optionFinder);
    await tester.tap(optionFinder);
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump(const Duration(milliseconds: 150));

    expect(savedProgress, isNotNull);
    expect(savedProgress!.learnerId, 'learner_allen');
    expect(savedProgress!.questionId, 'geometry_demo_trig_plane_001');
    expect(savedProgress!.lastResult, 'multiple_choice:B');
  });

  testWidgets('practice session renders a shape diagram figure',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: PracticeSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path: 'assets/questions/geometry/grade2_foundation.geometry.v1.json',
            topic: '幾何',
            topicCode: 'geometry',
            levelStage: 'grade2',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: [createShapeDiagramQuestion()],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const ValueKey<String>('figure_shape_diagram')), findsOneWidget);
  });

  testWidgets('quiz session renders a coordinate plane figure',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: QuizSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path: 'assets/questions/geometry/grade4_foundation.geometry.v1.json',
            topic: '幾何',
            topicCode: 'geometry',
            levelStage: 'grade4',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: [createCoordinatePlaneQuestion()],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byKey(const ValueKey<String>('figure_coordinate_plane')),
      findsOneWidget,
    );
  });

  testWidgets('practice session renders the circle quadrants figure',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: PracticeSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path: 'assets/questions/geometry/grade6_foundation.geometry.v1.json',
            topic: '幾何',
            topicCode: 'geometry',
            levelStage: 'grade6',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: [createCircleQuadrantsPointQuestion()],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byKey(const ValueKey<String>('figure_circle_quadrants_point')),
      findsOneWidget,
    );
  });

  testWidgets('practice session renders a composite grid shape figure',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: PracticeSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path: 'assets/questions/geometry/grade3_foundation.geometry.v1.json',
            topic: '幾何',
            topicCode: 'geometry',
            levelStage: 'grade3',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: [createCompositeGridShapeQuestion()],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byKey(const ValueKey<String>('figure_composite_grid_shape')),
      findsOneWidget,
    );
  });

  testWidgets('practice question display uses simplified Chinese localized text widgets',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'CN');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'CN'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: PracticeSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path: 'assets/questions/logic/grade4_foundation.logic.v1.json',
            topic: '邏輯',
            topicCode: 'logic',
            levelStage: 'grade4',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: [createMultilingualLayoutQuestion()],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byKey(const ValueKey<String>('question_prompt_layout_locale_001')),
      findsOneWidget,
    );
    expect(
      find.text('在四个选项中，选出最符合规律的一项，并说明你是如何判断的。'),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey<String>('question_option_text_layout_locale_001_B'),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('只有第二列同时改变颜色与位置'), findsOneWidget);
    expect(find.textContaining('Math Kangaroo USA 2025'), findsOneWidget);
  });

  testWidgets('quiz question display uses japanese localized text widgets',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('ja');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ja'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: QuizSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path: 'assets/questions/logic/grade4_foundation.logic.v1.json',
            topic: '邏輯',
            topicCode: 'logic',
            levelStage: 'grade4',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: [createMultilingualLayoutQuestion()],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byKey(const ValueKey<String>('question_prompt_layout_locale_001')),
      findsOneWidget,
    );
    expect(
      find.text('4 つの選択肢の中から規則に最も合うものを選び、判断のしかたを考えてください。'),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey<String>('question_option_text_layout_locale_001_B'),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('2 行目だけが色と位置の両方を変える'), findsOneWidget);
    expect(find.textContaining('Math Kangaroo USA 2025'), findsOneWidget);
  });

  testWidgets('switches current learner and attributes progress to that learner',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    QuestionProgress? savedProgress;
    final AppServices services = createTestServices(
      onSaveQuestionProgress: (progress) async {
        savedProgress = progress;
      },
    );

    await pumpApp(tester, services);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Current'), findsOneWidget);

    final miaFinder = find.text('Mia');
    await tester.ensureVisible(miaFinder);
    await tester.tap(miaFinder);
    await tester.pump(const Duration(milliseconds: 150));

    expect(services.currentLearnerId, 'learner_mia');
    expect(find.text('Current'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: TrigGraphDemoPage(
          services: services,
          initialQuestion: createDemoQuestion(),
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.text('Sine and cosine on the coordinate plane'),
      findsAtLeastNWidgets(1),
    );

    final optionFinder = find.byKey(
      const ValueKey<String>('answer_option_geometry_grade4_foundation_001_B'),
    );
    await pumpUntilFound(tester, optionFinder);
    await tester.tap(optionFinder);
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump(const Duration(milliseconds: 150));

    expect(savedProgress, isNotNull);
    expect(savedProgress!.learnerId, 'learner_mia');
  });

  testWidgets('settings shows olympiad competition profiles instead of grade and tier',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Kangaroo 3-4'), findsOneWidget);
    expect(find.text('Kangaroo 1-2'), findsOneWidget);
    expect(find.textContaining('Grade 4'), findsNothing);
    expect(find.textContaining('Advanced'), findsNothing);
  });

  testWidgets('settings current learner card localizes competition profile label',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'TW');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);
    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();

    expect(find.text('袋鼠競賽 3-4 級'), findsOneWidget);
    expect(find.text('Kangaroo 3-4'), findsNothing);
  });

  testWidgets('learner edit page shows bilingual competition level options with helper text',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'TW');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);
    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('edit_learner_learner_allen')));
    await tester.pumpAndSettle();

    expect(find.text('競賽級別'), findsWidgets);
    expect(find.text('袋鼠競賽 1-2 級'), findsOneWidget);
    expect(find.text('袋鼠競賽 3-4 級'), findsOneWidget);
    expect(find.text('袋鼠競賽 5-6 級'), findsOneWidget);
    expect(find.text('約對應小一到小二'), findsOneWidget);
    expect(find.text('約對應小三到小四'), findsOneWidget);
    expect(find.text('約對應小五到小六'), findsOneWidget);
    expect(find.text('程度'), findsNothing);
    expect(find.text('挑戰層級'), findsNothing);
  });

  testWidgets('adds a learner from the profiles section',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add learner'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey<String>('learner_name_field')),
      'Noah',
    );
    await tester.tap(find.byKey(const ValueKey<String>('save_learner_button')));
    await tester.pumpAndSettle();

    expect(find.text('Noah'), findsOneWidget);
    expect(
      services.learnerProfiles.any((profile) => profile.displayName == 'Noah'),
      isTrue,
    );
  });

  testWidgets('deletes the current learner and keeps another learner active',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey<String>('delete_learner_learner_allen')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Allen'), findsNothing);
    expect(find.text('Mia'), findsOneWidget);
    expect(services.currentLearnerId, 'learner_mia');
    expect(find.text('Current'), findsOneWidget);
  });

  testWidgets('home page shows real progress summary for current learner',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices(
      initialProgress: const [
        QuestionProgress(
          learnerId: 'learner_allen',
          questionId: 'q1',
          status: 'correct',
          lastResult: 'multiple_choice:A',
          updatedAtIso: '2026-07-16T09:00:00Z',
        ),
        QuestionProgress(
          learnerId: 'learner_allen',
          questionId: 'q2',
          status: 'incorrect',
          lastResult: 'multiple_choice:B',
          updatedAtIso: '2026-07-16T09:05:00Z',
        ),
        QuestionProgress(
          learnerId: 'learner_mia',
          questionId: 'q3',
          status: 'correct',
          lastResult: 'multiple_choice:C',
          updatedAtIso: '2026-07-16T09:10:00Z',
        ),
      ],
    );

    await pumpApp(tester, services);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Today'));
    expect(find.text('2'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(find.text('Solved'), findsOneWidget);
    expect(find.text('Accuracy'), findsOneWidget);
  });

  testWidgets('progress summary updates when switching learners',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices(
      initialProgress: const [
        QuestionProgress(
          learnerId: 'learner_allen',
          questionId: 'q1',
          status: 'correct',
          lastResult: 'multiple_choice:A',
          updatedAtIso: '2026-07-16T09:00:00Z',
        ),
        QuestionProgress(
          learnerId: 'learner_allen',
          questionId: 'q2',
          status: 'incorrect',
          lastResult: 'multiple_choice:B',
          updatedAtIso: '2026-07-16T09:05:00Z',
        ),
        QuestionProgress(
          learnerId: 'learner_mia',
          questionId: 'q3',
          status: 'correct',
          lastResult: 'multiple_choice:C',
          updatedAtIso: '2026-07-16T09:10:00Z',
        ),
      ],
    );

    await pumpApp(tester, services);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Today'));
    expect(find.text('2'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);

    await tester.tap(find.text('Mia'));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('1'), findsWidgets);
    expect(find.text('100%'), findsOneWidget);
  });

  testWidgets('main shell no longer exposes the question library page',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    expect(find.text('Question Library'), findsNothing);
    expect(find.text('Browse library'), findsNothing);
  });

  testWidgets('can complete a quiz session and review the solution',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: QuizSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path: 'assets/questions/geometry/grade4_foundation.geometry.v1.json',
            topic: '幾何',
            topicCode: 'geometry',
            levelStage: 'grade4',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: [createDemoQuestion()],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final optionFinder = find.byKey(
      const ValueKey<String>('quiz_option_geometry_grade4_foundation_001_B'),
    );
    await pumpUntilFound(tester, optionFinder);

    expect(find.text('Quiz Mode'), findsOneWidget);
    expect(find.text('Question 1 / 1'), findsOneWidget);
    expect(find.text('Submit quiz'), findsNWidgets(2));

    await tester.tap(optionFinder);
    await tester.pump(const Duration(milliseconds: 150));

    await tester.tap(find.byKey(const ValueKey<String>('submit_quiz_early')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Quiz Result'), findsAtLeastNWidgets(1));
    expect(find.text('1 / 1 correct'), findsOneWidget);
    expect(find.textContaining('Elapsed'), findsAtLeastNWidgets(1));

    await tester.tap(
      find.byKey(
        const ValueKey<String>('quiz_result_geometry_grade4_foundation_001'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.textContaining('sin(x) reaches its maximum value 1 at π/2'),
      findsOneWidget,
    );
  });

  testWidgets('quiz launch uses the full competition profile pack range',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();
    final List<Question> mergedQuestions = List<Question>.generate(
      20,
      (index) => index.isEven ? createDemoQuestion() : createSecondDemoQuestion(),
    );
    const BundledQuestionPackInfo launchPack = BundledQuestionPackInfo(
      path: 'assets/questions/geometry/grade4_foundation.geometry.v1.json',
      topic: '幾何',
      topicCode: 'geometry',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      questionCount: 20,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: QuizSessionPage(
          services: services,
          pack: launchPack,
          initialQuestions: mergedQuestions,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Question 1 / 20'), findsOneWidget);
  });

  testWidgets('practice session stays on current question until next is tapped',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: PracticeSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path: 'assets/questions/geometry/grade4_foundation.geometry.v1.json',
            topic: '幾何',
            topicCode: 'geometry',
            levelStage: 'grade4',
            challengeTier: 'foundation',
            questionCount: 2,
          ),
          initialQuestions: [createDemoQuestion(), createSecondDemoQuestion()],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Practice Mode'), findsOneWidget);
    expect(find.textContaining('Question'), findsWidgets);

    await tester.tap(
      find.byKey(
        const ValueKey<String>('practice_option_geometry_grade4_foundation_001_B'),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Correct'), findsWidgets);
    expect(
      find.textContaining('sin(x) reaches its maximum value 1 at π/2'),
      findsOneWidget,
    );
    expect(find.text('Next question'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1400));
    expect(find.textContaining('Question'), findsWidgets);
    expect(
      find.textContaining('sin(x) reaches its maximum value 1 at π/2'),
      findsOneWidget,
    );

    await tester.tap(find.text('Next question'));
    await tester.pump();

    expect(find.textContaining('Question'), findsWidgets);
    expect(find.text('Compute 18 + 27.'), findsOneWidget);
  });

  testWidgets('practice session does not show elapsed time in active practice mode',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: PracticeSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path: 'assets/questions/geometry/grade4_foundation.geometry.v1.json',
            topic: '幾何',
            topicCode: 'geometry',
            levelStage: 'grade4',
            challengeTier: 'foundation',
            questionCount: 2,
          ),
          initialQuestions: [createDemoQuestion(), createSecondDemoQuestion()],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Practice Mode'), findsOneWidget);
    expect(find.textContaining('Elapsed'), findsNothing);
  });

  testWidgets('practice session localizes mixed topic and hides editorial source',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'TW');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'TW'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: PracticeSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path: 'assets/questions/geometry/grade5_foundation.geometry.v1.json',
            topic: '幾何',
            topicCode: 'mixed',
            levelStage: 'grade6',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: [createEditorialQuestion()],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('綜合'), findsOneWidget);
    expect(find.text('mixed'), findsNothing);
    expect(find.textContaining('Source:'), findsNothing);
    expect(find.textContaining('MathSpring Editorial'), findsNothing);
  });

  testWidgets('practice session exit shows summary with accuracy',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: PracticeSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path: 'assets/questions/geometry/grade4_foundation.geometry.v1.json',
            topic: '幾何',
            topicCode: 'geometry',
            levelStage: 'grade4',
            challengeTier: 'foundation',
            questionCount: 2,
          ),
          initialQuestions: [createDemoQuestion(), createSecondDemoQuestion()],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(
      find.byKey(
        const ValueKey<String>('practice_option_geometry_grade4_foundation_001_B'),
      ),
    );
    await tester.pumpAndSettle();
    final Finder nextQuestionButton =
        find.widgetWithText(FilledButton, 'Next question');
    await tester.ensureVisible(nextQuestionButton);
    await tester.tap(nextQuestionButton);
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey<String>('close_practice_session')));
    await tester.pumpAndSettle();

    expect(find.text('Practice Summary'), findsAtLeastNWidgets(1));
    expect(find.text('1 / 1 correct'), findsOneWidget);
    expect(find.textContaining('Elapsed'), findsNothing);
  });

  testWidgets('quiz session can submit early and counts unanswered as incorrect',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    AnswerSession? savedSession;
    List<SessionAnswerRecord>? savedRecords;
    final AppServices services = createTestServices(
      onSaveAnswerSession: (session, records) async {
        savedSession = session;
        savedRecords = records;
      },
    );

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: QuizSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path: 'assets/questions/geometry/grade4_foundation.geometry.v1.json',
            topic: '幾何',
            topicCode: 'geometry',
            levelStage: 'grade4',
            challengeTier: 'foundation',
            questionCount: 2,
          ),
          initialQuestions: [createDemoQuestion(), createSecondDemoQuestion()],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(
      find.byKey(
        const ValueKey<String>('quiz_option_geometry_grade4_foundation_001_B'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));

    await tester.tap(find.byKey(const ValueKey<String>('submit_quiz_early')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Quiz Result'), findsAtLeastNWidgets(1));
    expect(find.text('1 / 2 correct'), findsOneWidget);
    expect(
      find.byKey(
        const ValueKey<String>('quiz_result_arithmetic_grade4_foundation_002'),
      ),
      findsOneWidget,
    );
    expect(savedSession, isNotNull);
    expect(savedSession!.mode, 'quiz');
    expect(savedSession!.totalQuestions, 2);
    expect(savedRecords, isNotNull);
    expect(savedRecords!, hasLength(2));
  });

  testWidgets('review tab opens learner history and shows recent sessions',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices(
      initialSessions: const [
        AnswerSession(
          id: 'session_quiz_recent',
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
        AnswerSession(
          id: 'session_practice_older',
          learnerId: 'learner_allen',
          mode: 'practice',
          topicCode: 'arithmetic',
          levelStage: 'grade3',
          challengeTier: 'foundation',
          startedAtIso: '2026-07-17T08:00:00Z',
          endedAtIso: '2026-07-17T08:03:00Z',
          elapsedSeconds: 180,
          totalQuestions: 3,
          correctCount: 2,
        ),
      ],
    );

    await pumpApp(tester, services);

    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View history'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('History'), findsAtLeastNWidgets(1));
    expect(find.text('Quiz Mode'), findsOneWidget);
    expect(find.text('Practice Mode'), findsOneWidget);
    expect(find.text('Geometry'), findsAtLeastNWidgets(1));
    expect(find.text('8 / 10 correct'), findsOneWidget);
    expect(find.textContaining('Elapsed 5:00'), findsOneWidget);
  });

  testWidgets('history session opens detail view with saved answers and solution',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices(
      initialSessions: const [
        AnswerSession(
          id: 'session_quiz_recent',
          learnerId: 'learner_allen',
          mode: 'quiz',
          topicCode: 'geometry',
          levelStage: 'grade4',
          challengeTier: 'foundation',
          startedAtIso: '2026-07-17T09:00:00Z',
          endedAtIso: '2026-07-17T09:05:00Z',
          elapsedSeconds: 300,
          totalQuestions: 1,
          correctCount: 1,
        ),
      ],
      initialSessionRecords: {
        'session_quiz_recent': const [
          SessionAnswerRecord(
            sessionId: 'session_quiz_recent',
            questionId: 'geometry_grade4_foundation_001',
            sequence: 1,
            submittedAnswer: 'B',
            isCorrect: true,
            answeredAtIso: '2026-07-17T09:03:00Z',
          ),
        ],
      },
    );

    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: AnswerHistoryPage(
          services: services,
          initialQuestionsById: {
            'geometry_grade4_foundation_001': createDemoQuestion(),
          },
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byKey(const ValueKey<String>('history_session_session_quiz_recent')));
    await tester.pump();
    await pumpUntilFound(tester, find.text('Question 1'));

    expect(find.text('Session Detail'), findsAtLeastNWidgets(1));
    expect(find.text('Question 1'), findsOneWidget);
    expect(find.text('Correct'), findsAtLeastNWidgets(1));
    expect(find.text('Your answer: B  sin(x) at π/2, cos(x) at 0'), findsOneWidget);
    expect(find.textContaining('sin(x) reaches its maximum value 1 at π/2'), findsOneWidget);
  });
}
