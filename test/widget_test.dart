import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/data/bundled/bundled_question_bank_repository.dart';
import 'package:mathspring/data/local/app_services.dart';
import 'package:mathspring/main.dart';
import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/learner_profile.dart';
import 'package:mathspring/models/question.dart';
import 'package:mathspring/models/question_bank.dart';
import 'package:mathspring/ui/layout_spec.dart';
import 'package:mathspring/models/question_progress.dart';
import 'package:mathspring/models/session_answer_record.dart';
import 'package:mathspring/services/session_launch_plan_builder.dart';
import 'package:mathspring/services/formal_exam_preset.dart';
import 'package:mathspring/services/monetization_service.dart';
import 'package:mathspring/services/storekit_monetization_service.dart';
import 'package:mathspring/widgets/avatar_preview.dart';

void main() {
  test('application visual tokens use indigo primary and teal progress', () {
    expect(AppVisualTokens.brand, const Color(0xFF273B78));
    expect(AppVisualTokens.progress, const Color(0xFF168A82));
    expect(AppVisualTokens.primary, AppVisualTokens.brand);
  });

  // rootBundle 會快取讀檔的 Future；前一個測試在它自己的 fake-async zone 裡
  // 開始讀的題庫，到下一個測試永遠不會完成，畫面就卡在載入中。
  setUp(() => rootBundle.clear());

  tearDown(() {
    TestWidgetsFlutterBinding.ensureInitialized()
        .platformDispatcher
        .clearLocaleTestValue();
  });

  AppServices createTestServices({
    bool completeDailyMission = true,
    Future<void> Function(QuestionProgress progress)? onSaveQuestionProgress,
    Future<void> Function(
      AnswerSession session,
      List<SessionAnswerRecord> records,
    )? onSaveAnswerSession,
    List<QuestionProgress>? initialProgress,
    List<AnswerSession>? initialSessions,
    Map<String, List<SessionAnswerRecord>>? initialSessionRecords,
  }) {
    final DateTime now = DateTime.now();
    final AnswerSession dailySession = AnswerSession(
      id: 'completed_daily_mission',
      learnerId: 'learner_allen',
      mode: 'practice',
      topicCode: 'mixed',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      startedAtIso: now.toUtc().toIso8601String(),
      endedAtIso: now.toUtc().toIso8601String(),
      elapsedSeconds: 0,
      totalQuestions: 5,
      correctCount: 5,
    );
    final List<SessionAnswerRecord> dailyRecords = <SessionAnswerRecord>[
      for (int index = 0; index < 5; index += 1)
        SessionAnswerRecord(
          sessionId: dailySession.id,
          questionId: 'daily_question_$index',
          sequence: index + 1,
          submittedAnswer: 'A',
          isCorrect: true,
          answeredAtIso: now.toUtc().toIso8601String(),
        ),
    ];
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
      initialSessions: initialSessions ??
          (completeDailyMission ? <AnswerSession>[dailySession] : null),
      initialSessionRecords: initialSessionRecords ??
          (completeDailyMission
              ? <String, List<SessionAnswerRecord>>{
                  dailySession.id: dailyRecords,
                }
              : null),
    );
  }

  Question createDemoQuestion({List<String>? englishSolutionSteps}) {
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
        'en': englishSolutionSteps ??
            [
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

  testWidgets('我的收藏會顯示空狀態並可從學習回顧開啟', (WidgetTester tester) async {
    final AppServices services = createTestServices();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'TW'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: FavoritesPage(services: services),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('我的收藏'), findsWidgets);
    expect(find.text('從答題畫面收藏題目，它們會出現在這裡。'), findsOneWidget);
  });

  testWidgets('我的收藏可新增自訂書籤', (WidgetTester tester) async {
    final AppServices services = createTestServices();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'TW'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: FavoritesPage(services: services),
      ),
    );
    await tester.pumpAndSettle();

    await tester
        .tap(find.byKey(const ValueKey<String>('add_favorite_collection')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '問老師');
    await tester.tap(find.text('儲存'));
    await tester.pumpAndSettle();

    await tester
        .tap(find.byKey(const ValueKey<String>('favorite_collection_picker')));
    await tester.pumpAndSettle();
    expect(find.text('問老師'), findsOneWidget);
  });

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

  Question createFormulaQuestion() {
    return Question.fromJson({
      'id': 'algebra_grade10_foundation_formula_001',
      'topic': 'algebra',
      'difficulty': 'foundation',
      'levelStage': 'grade10',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '設 f(x) = x^2 - 4x + 7，且定義域為 -1 <= x <= a。',
        'en': 'Let f(x) = x^2 - 4x + 7 on the interval -1 <= x <= a.',
      },
      'answer': {
        'zh-Hant': '先把 f(x) 改寫成 (x-2)^2 + 3。',
        'en': 'Rewrite f(x) as (x-2)^2 + 3 first.',
      },
      'solutionSteps': {
        'zh-Hant': [
          '因為 x^2 - 4x + 7 = (x-2)^2 + 3。',
          '再判斷區間端點與頂點的位置。',
        ],
        'en': [
          'Because x^2 - 4x + 7 = (x-2)^2 + 3.',
          'Then compare the interval endpoints with the vertex.',
        ],
      },
      'figure': {
        'type': 'custom',
        'kind': 'none',
        'params': <String, dynamic>{},
      },
      'answerMode': 'integer_input',
      'correctAnswer': {
        'type': 'integer',
        'value': '3',
      },
      'inputConstraints': {
        'allowNegative': false,
        'maxDigits': 1,
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
        'en':
            'In the rectangle below, the length is 5 and the width is 3. What is its perimeter?',
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
        'en':
            'On the coordinate plane, if the point (4, 1) moves up 3 units, where does it land?',
      },
      'answer': {
        'zh-Hant': '往上移只增加縱坐標，所以到 (4,4)。',
        'en':
            'Moving up increases only the y-coordinate, so the point becomes (4,4).',
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
        'zh-Hant':
            '如圖，圓內有一點 P，與圓周上的四等分點 A、B、C、D 相連，分成四部分，其中三部分面積為 12、15、20。陰影部分面積是多少？',
        'en':
            'In the diagram, a point P inside the circle is connected to four equally spaced points A, B, C, and D on the circle, creating four regions. Three regions have areas 12, 15, and 20. What is the shaded area?',
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
            'bottomLeft': '12',
            'bottomRight': '20',
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
        'en':
            'Choose the option that best matches the rule and explain how you decided.',
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
        'en': [
          'Observe how each row changes.',
          'Only B satisfies both conditions.'
        ],
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

  Future<void> pumpApp(WidgetTester tester, AppServices services,
      {Size size = const Size(1200, 1600),
      MonetizationService? monetizationService}) async {
    // 用 tester.view 而不是 setSurfaceSize：後者不會改變 MediaQuery
    // （實測 setSurfaceSize(390, 844) 之後 MediaQuery.sizeOf 仍回報 800），
    // 所以依賴寬度的版面在測試裡不會生效。
    //
    // 但仍要先清掉 setSurfaceSize 的覆寫：本檔有其他測試直接呼叫它設 430x932
    // 且沒有還原，殘留下來會讓「排版用的尺寸」與「view 的尺寸」不一致，
    // 結果是版面算在一個尺寸、點擊命中在另一個尺寸，tap 會打空。
    await tester.binding.setSurfaceSize(null);
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MathSpringApp(
      services: services,
      monetizationService: monetizationService,
    ));
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

  testWidgets('review does not offer the avatar simulator',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    await pumpApp(tester, createTestServices());
    await tester.tap(find.text('Review').first);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('review_avatar_tab')),
      findsNothing,
    );
  });

  Question createDualIntegerQuestion() {
    return Question.fromJson({
      'id': 'dual_integer_001',
      'topic': 'arithmetic',
      'difficulty': 'foundation',
      'levelStage': 'grade2',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '鉛筆和橡皮擦各買幾盒？',
        'en': 'How many boxes of pencils and erasers are needed?',
      },
      'answer': {
        'zh-Hant': '鉛筆 4 盒，橡皮擦 3 盒。',
        'en': '4 pencil boxes and 3 eraser boxes.',
      },
      'solutionSteps': {
        'zh-Hant': ['最小公倍數是 24。'],
        'en': ['The least common multiple is 24.'],
      },
      'figure': {
        'type': 'custom',
        'kind': 'none',
        'params': <String, dynamic>{},
      },
      'answerMode': 'integer_input',
      'correctAnswer': {
        'type': 'integer',
        'value': '4',
        'values': ['4', '3'],
        'inputLabels': {
          'zh-Hant': ['鉛筆', '橡皮擦'],
          'en': ['Pencils', 'Erasers'],
        },
      },
    });
  }

  testWidgets('shows English home content when system locale is English',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();
    final InMemoryMonetizationService monetization =
        InMemoryMonetizationService.withProduct();
    await monetization.initialize();
    await monetization.purchaseFullUnlock();

    await pumpApp(tester, services, monetizationService: monetization);

    expect(find.text('MathSpring'), findsAtLeastNWidgets(1));
    expect(find.text('Practice'), findsWidgets);
    expect(find.text('Start practice'), findsOneWidget);
    expect(find.text('Choose topic'), findsOneWidget);
    expect(find.text('Geometry'), findsNothing);
    expect(find.text('Arithmetic'), findsNothing);
    expect(find.text('Logic'), findsNothing);
  });

  testWidgets('app 的字級跟著寬度級別走，不是固定一套手機值', (WidgetTester tester) async {
    // iPad 不該是放大的 iPhone：TextTheme 由 LayoutSpec 依寬度產生，
    // 已經在用 Theme.of(context).textTheme 的畫面因此自動縮放。
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    TextTheme themeAt(WidgetTester t) =>
        Theme.of(t.element(find.byType(Scaffold).first)).textTheme;

    // compact：與改造前的既有值完全相同，iPhone 一個像素都不變
    await pumpApp(tester, services, size: const Size(390, 844));
    final TextTheme compact = themeAt(tester);
    final LayoutSpec compactSpec = LayoutSpec.forWidth(390);
    expect(compact.displaySmall?.fontSize, compactSpec.displayText);
    expect(compact.displaySmall?.fontSize, 32);
    expect(compact.headlineSmall?.fontSize, 22);
    expect(compact.titleLarge?.fontSize, 18);
    expect(compact.bodyLarge?.fontSize, 15);
    expect(compact.bodyMedium?.fontSize, 13);
    expect(compact.bodySmall?.fontSize, 11);

    // expanded：字級放大，但行高與顏色這些視覺屬性不可被吃掉
    await pumpApp(tester, services, size: const Size(1180, 820));
    final TextTheme expanded = themeAt(tester);
    final LayoutSpec expandedSpec = LayoutSpec.forWidth(1180);
    expect(expanded.displaySmall?.fontSize, expandedSpec.displayText);
    expect(expanded.bodyLarge?.fontSize, expandedSpec.bodyText);
    expect(expanded.bodyLarge?.fontSize,
        greaterThan(compact.bodyLarge!.fontSize!));
    expect(expanded.bodyLarge?.height, 1.5);
    expect(expanded.bodyMedium?.height, 1.4);
    expect(expanded.bodySmall?.height, 1.35);

    // 按鈕字級目前不隨寬度變，維持原樣
    final ThemeData theme =
        Theme.of(tester.element(find.byType(Scaffold).first));
    expect(
      theme.filledButtonTheme.style?.textStyle
          ?.resolve(const <WidgetState>{})?.fontSize,
      14,
    );
    expect(
      theme.outlinedButtonTheme.style?.textStyle
          ?.resolve(const <WidgetState>{})?.fontSize,
      14,
    );
  });

  testWidgets('core surfaces use refreshed visual tokens',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    final BuildContext context = tester.element(find.byType(Scaffold).first);
    final ThemeData theme = Theme.of(context);
    final CardThemeData cardTheme = theme.cardTheme;
    expect(theme.scaffoldBackgroundColor, AppVisualTokens.canvas);
    expect(cardTheme.color, AppVisualTokens.surface);
    expect(cardTheme.shadowColor, const Color(0x1217201D));
    expect(cardTheme.surfaceTintColor, Colors.transparent);
    expect((cardTheme.shape as RoundedRectangleBorder).borderRadius,
        BorderRadius.circular(14));
    expect(theme.navigationBarTheme.backgroundColor, AppVisualTokens.surface);
    expect(
        theme.navigationBarTheme.indicatorColor, AppVisualTokens.primarySoft);
  });

  testWidgets('home shell applies refreshed cards and profile styling',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    expect(find.byKey(const ValueKey<String>('home_hero_surface')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('home_background_glow')),
        findsNothing);
    await tester.tap(find.text('Settings').first);
    await tester.pumpAndSettle();

    expect(
        find.byKey(const ValueKey<String>('home_shell_frame')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('top_bar_brand_chip')),
        findsOneWidget);
    expect(
        find.byKey(const ValueKey<String>('section_card_Profiles & Settings')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('learner_summary_banner')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('profile_tile_learner_allen')),
        findsOneWidget);
  });

  testWidgets('home shell shows bounded current learner identity',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    await pumpApp(tester, createTestServices(), size: const Size(320, 844));

    final Finder identity =
        find.byKey(const ValueKey<String>('current_learner_identity'));
    expect(identity, findsOneWidget);
    expect(find.descendant(of: identity, matching: find.text('Allen')),
        findsOneWidget);
    expect(find.descendant(of: identity, matching: find.text('Grades 3-4')),
        findsOneWidget);
    expect(find.descendant(of: identity, matching: find.byType(AvatarPreview)),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home shell hides current learner identity without a learner',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = AppServices.forTesting(
      learnerProfiles: const <LearnerProfile>[],
      currentLearnerId: '',
    )..currentLearnerId = null;
    await pumpApp(tester, services);

    expect(
      find.byKey(const ValueKey<String>('current_learner_identity')),
      findsNothing,
    );
  });

  testWidgets('answer sessions show current learner identity',
      (WidgetTester tester) async {
    const LearnerProfile learner = LearnerProfile(
      id: 'learner_allen',
      displayName: 'Allen',
      levelStage: 'grade4',
      challengeTier: 'advanced',
      createdAtIso: '2026-07-16T00:00:00Z',
    );
    const BundledQuestionPackInfo pack = BundledQuestionPackInfo(
      path: 'unused',
      topic: 'Mixed',
      topicCode: 'mixed',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      questionCount: 1,
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
        home: PracticeSessionPage(
          services: createTestServices(),
          pack: pack,
          initialQuestions: [createDemoQuestion()],
          learner: learner,
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('current_learner_identity')),
      findsOneWidget,
    );
    expect(find.text('Allen'), findsOneWidget);
    expect(find.text('Grade 4'), findsWidgets);
    expect(find.byType(AvatarPreview), findsOneWidget);

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
          services: createTestServices(),
          pack: pack,
          initialQuestions: [createDemoQuestion()],
          formalExamPreset: FormalExamPreset.standard.first,
          learner: learner,
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('current_learner_identity')),
      findsOneWidget,
    );
    expect(find.text('Allen'), findsOneWidget);
    expect(find.text('Grade 4'), findsWidgets);
    expect(find.byType(AvatarPreview), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: PracticeSessionPage(
          services: createTestServices(),
          pack: pack,
          initialQuestions: [createDemoQuestion()],
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('current_learner_identity')),
      findsNothing,
    );
  });

  testWidgets('question pages use refreshed study card styling',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(430, 932));
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
            path:
                'assets/questions/geometry/grade2_foundation.geometry.v1.json',
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

    expect(find.byKey(const ValueKey<String>('practice_question_header')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('study_surface_card')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('question_meta_badge')),
        findsOneWidget);

    final Container header = tester.widget<Container>(
      find.byKey(const ValueKey<String>('practice_question_header')),
    );
    final BoxDecoration headerDecoration = header.decoration! as BoxDecoration;
    expect(headerDecoration.borderRadius, BorderRadius.circular(14));

    final Container badge = tester.widget<Container>(
      find.byKey(const ValueKey<String>('question_meta_badge')),
    );
    final BoxDecoration badgeDecoration = badge.decoration! as BoxDecoration;
    expect(badgeDecoration.color, AppVisualTokens.primarySoft);
    expect(badgeDecoration.borderRadius, BorderRadius.circular(10));
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

  testWidgets('shows the daily mission before ordinary practice',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MathSpringApp(services: createTestServices(completeDailyMission: false)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('daily_mission_landing')),
        findsOneWidget);
    expect(find.text('0 / 5'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('start_daily_mission')),
        findsOneWidget);
  });

  testWidgets('daily mission landing follows the English locale',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    await tester.pumpWidget(
      MathSpringApp(services: createTestServices(completeDailyMission: false)),
    );
    await tester.pumpAndSettle();

    final Finder landing =
        find.byKey(const ValueKey<String>('daily_mission_landing'));
    expect(find.descendant(of: landing, matching: find.text('Daily 5')),
        findsOneWidget);
    final Iterable<String> texts = tester
        .widgetList<Text>(
            find.descendant(of: landing, matching: find.byType(Text)))
        .map((Text text) => text.data ?? text.textSpan?.toPlainText() ?? '');
    for (final String text in texts) {
      expect(text, isNot(matches(RegExp(r'[\u3040-\u30ff\u4e00-\u9fff]'))));
    }
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

  testWidgets('home tagline uses mathematical thinking wording',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'TW');

    await pumpApp(tester, createTestServices());

    expect(find.text('數學思維與進階練習'), findsOneWidget);
    expect(find.textContaining('奧數'), findsNothing);
  });

  testWidgets(
      'shows Simplified Chinese home content when system locale is zh-CN',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'CN');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);

    expect(find.text('开始练习'), findsWidgets);
    expect(find.text('数学思维与进阶练习'), findsOneWidget);
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
    expect(find.text('数学的思考と発展練習'), findsOneWidget);
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
    await tester
        .ensureVisible(find.byKey(const ValueKey<String>('locale_option_en')));
    await tester.tap(find.byKey(const ValueKey<String>('locale_option_en')));
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsOneWidget);
    await tester.tap(find.text('Practice'));
    await tester.pumpAndSettle();
    expect(find.text('Start practice'), findsOneWidget);
    expect(find.text('Practice'), findsWidgets);
  });

  testWidgets('settings offers all four supported language choices',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'TW');

    await pumpApp(tester, createTestServices());
    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();

    expect(
        find.byKey(const ValueKey<String>('locale_option_zh')), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('locale_option_zh_hans')),
      findsOneWidget,
    );
    expect(
        find.byKey(const ValueKey<String>('locale_option_en')), findsOneWidget);
    expect(
        find.byKey(const ValueKey<String>('locale_option_ja')), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('locale_option_ja')),
    );
    await tester.pumpAndSettle();
    expect(find.text('言語'), findsOneWidget);
  });

  testWidgets('settings shows a learners overview for families',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    await pumpApp(tester, createTestServices());
    await tester.tap(find.text('Settings').first);
    for (int attempt = 0;
        attempt < 30 && find.textContaining('5 questions').evaluate().isEmpty;
        attempt += 1) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();
    }

    final Finder overview =
        find.byKey(const ValueKey<String>('learners_overview'));
    expect(overview, findsOneWidget);
    expect(
        find.descendant(
            of: find.byKey(
                const ValueKey<String>('learner_overview_learner_allen')),
            matching:
                find.text('Last 7 days: 1 day · 5 questions · 100% correct')),
        findsOneWidget);
    expect(
        find.descendant(
            of: find
                .byKey(const ValueKey<String>('learner_overview_learner_mia')),
            matching: find.text('No practice in the last 7 days')),
        findsOneWidget);
  });

  testWidgets('settings hides the learners overview for a single learner',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');
    final AppServices services = AppServices.forTesting(
      learnerProfiles: const <LearnerProfile>[
        LearnerProfile(
          id: 'learner_allen',
          displayName: 'Allen',
          levelStage: 'grade4',
          challengeTier: 'advanced',
          createdAtIso: '2026-07-16T00:00:00Z',
        ),
      ],
      currentLearnerId: 'learner_allen',
    );

    await pumpApp(tester, services);
    await tester.tap(find.text('Settings').first);
    await tester.pumpAndSettle();

    expect(
        find.byKey(const ValueKey<String>('learners_overview')), findsNothing);
  });

  testWidgets('settings exposes support and privacy links in English',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'TW');
    final AppServices services = createTestServices();

    await pumpApp(tester, services);
    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('locale_option_en')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('open_support_link')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('open_privacy_link')),
        findsOneWidget);
    expect(find.text('Support'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
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
    await tester
        .tap(find.byKey(const ValueKey<String>('topic_action_geometry')));
    await tester.pumpAndSettle();

    expect(find.text('Selected topic'), findsOneWidget);
    expect(find.text('Geometry'), findsAtLeastNWidgets(1));
    expect(find.byKey(const ValueKey<String>('open_start_practice')),
        findsOneWidget);
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

  testWidgets('formal exam start offers the fixed exam presets',
      (WidgetTester tester) async {
    await tester.pumpWidget(MathSpringApp(services: createTestServices()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Quiz'));
    await tester.pumpAndSettle();
    final Finder startButton =
        find.byKey(const ValueKey<String>('open_start_quiz'));
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    expect(
        find.byKey(const ValueKey<String>('formal_exam_5_10')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('formal_exam_10_20')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('formal_exam_15_30')),
        findsOneWidget);
  });

  testWidgets('formal exam exposes a question navigator with point values',
      (WidgetTester tester) async {
    const BundledQuestionPackInfo pack = BundledQuestionPackInfo(
      path: 'unused',
      topic: 'Mixed',
      topicCode: 'mixed',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      questionCount: 2,
    );
    await tester.pumpWidget(MaterialApp(
      home: QuizSessionPage(
        services: createTestServices(),
        pack: pack,
        initialQuestions: <Question>[
          createDemoQuestion(),
          createSecondDemoQuestion()
        ],
        formalExamPreset: FormalExamPreset.standard.first,
      ),
    ));
    await tester.pump();
    final Finder navigatorButton =
        find.byKey(const ValueKey<String>('open_exam_navigator'));
    await tester.ensureVisible(navigatorButton);
    await tester.tap(navigatorButton);
    await tester.pump();

    expect(find.text('Question overview'), findsWidgets);
    expect(find.textContaining('pts'), findsWidgets);
  });

  testWidgets('formal exam screens show no Chinese in English',
      (WidgetTester tester) async {
    const BundledQuestionPackInfo pack = BundledQuestionPackInfo(
      path: 'unused',
      topic: 'Mixed',
      topicCode: 'mixed',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      questionCount: 2,
    );
    await tester.pumpWidget(MaterialApp(
      home: QuizSessionPage(
        services: createTestServices(),
        pack: pack,
        initialQuestions: <Question>[
          createDemoQuestion(),
          createSecondDemoQuestion()
        ],
        formalExamPreset: FormalExamPreset.standard.first,
      ),
    ));
    await tester.pump();
    final Finder navigatorButton =
        find.byKey(const ValueKey<String>('open_exam_navigator'));
    await tester.ensureVisible(navigatorButton);
    await tester.tap(navigatorButton);
    await tester.pump();

    final RegExp cjk = RegExp(r'[\u4e00-\u9fff]');
    final Iterable<String> labels = <String>[
      for (final Text text in tester.widgetList<Text>(find.byType(Text)))
        text.data ?? text.textSpan?.toPlainText() ?? '',
      for (final IconButton button
          in tester.widgetList<IconButton>(find.byType(IconButton)))
        button.tooltip ?? '',
    ];
    final Iterable<String> chrome = labels.where((String label) =>
        !createDemoQuestion().prompt.values.contains(label) &&
        !createSecondDemoQuestion().prompt.values.contains(label));
    expect(chrome.where(cjk.hasMatch), isEmpty);
    expect(find.text('Question overview'), findsWidgets);
  });

  testWidgets('home page offers no developer demo entry',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    await pumpApp(tester, createTestServices());

    expect(
        find.byKey(const ValueKey<String>('hero_primary_cta')), findsNothing);
    expect(find.text('View graph demo'), findsNothing);
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
            path:
                'assets/questions/geometry/grade2_foundation.geometry.v1.json',
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
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('figure_shape_diagram')),
        findsOneWidget);
  });

  testWidgets('question figures can open in fullscreen preview',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(430, 932));
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
            path:
                'assets/questions/geometry/grade2_foundation.geometry.v1.json',
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

    await tester.tap(
      find.byKey(const ValueKey<String>('figure_shape_diagram')).last,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('figure_preview_dialog')),
        findsOneWidget);
    expect(
        find.byKey(
            const ValueKey<String>('figure_preview_canvas_shape_diagram')),
        findsOneWidget);

    await tester
        .tap(find.byKey(const ValueKey<String>('figure_preview_close')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('figure_preview_dialog')),
        findsNothing);
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
            path:
                'assets/questions/geometry/grade4_foundation.geometry.v1.json',
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
            path:
                'assets/questions/geometry/grade6_foundation.geometry.v1.json',
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

  testWidgets('review figures can also open in fullscreen preview',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(430, 932));
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
            path:
                'assets/questions/geometry/grade2_foundation.geometry.v1.json',
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

    await tester.enterText(
      find.byKey(const ValueKey<String>(
          'practice_integer_input_geometry_grade2_foundation_001')),
      '16',
    );
    await tester.tap(
      find.byKey(const ValueKey<String>(
          'submit_answer_geometry_grade2_foundation_001')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey<String>('figure_shape_diagram')).last,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('figure_preview_dialog')),
        findsOneWidget);
    expect(
        find.byKey(
            const ValueKey<String>('figure_preview_canvas_shape_diagram')),
        findsOneWidget);
  });

  testWidgets('practice renders and checks ordered multiple integer answers',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');
    final AppServices services = createTestServices();

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
            path:
                'assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json',
            topic: 'Arithmetic',
            topicCode: 'arithmetic',
            levelStage: 'grade2',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: [createDualIntegerQuestion()],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(
          const ValueKey<String>('practice_integer_input_dual_integer_001_0')),
      findsOneWidget,
    );
    expect(
      find.byKey(
          const ValueKey<String>('practice_integer_input_dual_integer_001_1')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(
          const ValueKey<String>('practice_integer_input_dual_integer_001_0')),
      '4',
    );
    await tester.enterText(
      find.byKey(
          const ValueKey<String>('practice_integer_input_dual_integer_001_1')),
      '3',
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('submit_answer_dual_integer_001')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Correct'), findsOneWidget);
  });

  testWidgets('quiz renders ordered multiple integer answers',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

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
          services: createTestServices(),
          pack: const BundledQuestionPackInfo(
            path:
                'assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json',
            topic: 'Arithmetic',
            topicCode: 'arithmetic',
            levelStage: 'grade2',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: [createDualIntegerQuestion()],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(
          const ValueKey<String>('quiz_integer_input_dual_integer_001_0')),
      findsOneWidget,
    );
    expect(
      find.byKey(
          const ValueKey<String>('quiz_integer_input_dual_integer_001_1')),
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
            path:
                'assets/questions/geometry/grade3_foundation.geometry.v1.json',
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

  testWidgets(
      'practice question display uses simplified Chinese localized text widgets',
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

  testWidgets(
      'switches current learner and attributes progress to that learner',
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
        home: PracticeSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path:
                'assets/questions/geometry/grade4_foundation.geometry.v1.json',
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

    await tester.tap(
      find.byKey(
        const ValueKey<String>(
            'practice_option_geometry_grade4_foundation_001_B'),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump(const Duration(milliseconds: 150));

    expect(savedProgress, isNotNull);
    expect(savedProgress!.learnerId, 'learner_mia');
  });

  testWidgets(
      'settings shows learner grade ranges instead of competition profiles',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Grades 3-4'), findsWidgets);
    expect(find.text('Grades 1-2'), findsOneWidget);
    expect(find.textContaining('Kangaroo'), findsNothing);
    expect(find.textContaining('Advanced'), findsNothing);
  });

  testWidgets('settings current learner card localizes grade range label',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'TW');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);
    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();

    expect(find.text('年級範圍'), findsWidgets);
    expect(find.text('小三到小四'), findsWidgets);
    expect(find.textContaining('袋鼠競賽'), findsNothing);
  });

  testWidgets('learner edit page shows range slider and live range summary',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'TW');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);
    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();
    await tester
        .tap(find.byKey(const ValueKey<String>('edit_learner_learner_allen')));
    await tester.pumpAndSettle();

    expect(find.text('年級範圍'), findsWidgets);
    expect(find.byType(RangeSlider), findsOneWidget);
    expect(find.text('小三到小四'), findsWidgets);
    expect(find.text('程度'), findsNothing);
    expect(find.text('挑戰層級'), findsNothing);
  });

  testWidgets('settings profile card uses smaller labels and larger values',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'TW');

    final AppServices services = createTestServices();

    await pumpApp(tester, services);
    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();

    final Text currentRoleLabel = tester.widget<Text>(find.text('目前角色').first);
    final Text allenValue = tester.widget<Text>(find.text('Allen').first);

    expect(currentRoleLabel.style, isNotNull);
    expect(allenValue.style, isNotNull);
    expect(allenValue.style!.fontSize,
        greaterThan(currentRoleLabel.style!.fontSize!));
  });

  testWidgets(
      'secondary and high school ranges do not use primary-school labels',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'TW');

    final AppServices services = AppServices.forTesting(
      learnerProfiles: const [
        LearnerProfile(
          id: 'learner_senior',
          displayName: 'Allen',
          levelStage: 'grade12',
          minLevelStage: 'grade7',
          maxLevelStage: 'grade12',
          challengeTier: 'foundation',
          createdAtIso: '2026-08-02T00:00:00Z',
        ),
      ],
      currentLearnerId: 'learner_senior',
    );

    await pumpApp(tester, services);
    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();

    expect(find.text('國一到高三'), findsWidgets);
    expect(find.textContaining('小十'), findsNothing);
    expect(find.textContaining('小12'), findsNothing);
  });

  testWidgets('adds a learner from the profiles section',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();
    final InMemoryMonetizationService monetization =
        InMemoryMonetizationService.withProduct();
    await monetization.initialize();
    await monetization.purchaseFullUnlock();

    await pumpApp(tester, services, monetizationService: monetization);

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

    expect(find.text('Noah'), findsWidgets);
    expect(
      services.learnerProfiles.any((profile) => profile.displayName == 'Noah'),
      isTrue,
    );
  });

  testWidgets('asks before deleting the current learner',
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

    expect(find.text('Delete learner'), findsOneWidget);
    expect(find.textContaining('Answer history'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Allen'), findsWidgets);
    expect(services.currentLearnerId, 'learner_allen');
  });

  testWidgets('deletes the current learner after confirmation',
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
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Allen'), findsNothing);
    expect(find.text('Mia'), findsWidgets);
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

  testWidgets('free quiz review locks the solution steps',
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
            path:
                'assets/questions/geometry/grade4_foundation.geometry.v1.json',
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
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('unlock_solution_steps')),
      findsOneWidget,
    );
  });

  Future<void> pumpPracticeAndAnswer(
    WidgetTester tester,
    AppServices services, {
    Question? question,
  }) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');
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
            path:
                'assets/questions/geometry/grade4_foundation.geometry.v1.json',
            topic: '幾何',
            topicCode: 'geometry',
            levelStage: 'grade4',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: [question ?? createDemoQuestion()],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byKey(const ValueKey<String>(
        'practice_option_geometry_grade4_foundation_001_B')));
    await tester.pump();
    await tester.pumpAndSettle();
  }

  testWidgets('free practice review can spend a daily free solution',
      (WidgetTester tester) async {
    final AppServices services = createTestServices();

    await pumpPracticeAndAnswer(tester, services);

    const String firstStep =
        'Look at the highest point of the blue sin(x) curve.';
    expect(find.text(firstStep), findsNothing);
    expect(find.text('View this solution free (3 left today)'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('use_free_solution')));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();

    expect(find.text(firstStep), findsOneWidget);
    expect((await services.getFreeSolutionAllowance()).remaining, 2);
  });

  testWidgets('free practice reveal scrolls the first solution step into view',
      (WidgetTester tester) async {
    final AppServices services = createTestServices();
    const String firstStep =
        'Look at the highest point of the blue sin(x) curve.';

    await pumpPracticeAndAnswer(
      tester,
      services,
      question: createDemoQuestion(
        englishSolutionSteps: <String>[
          firstStep,
          for (int index = 0; index < 80; index += 1)
            'This extra explanation keeps the solution scrollable ($index).',
        ],
      ),
    );
    await tester.binding.setSurfaceSize(const Size(390, 700));
    await tester.pumpAndSettle();

    final Finder reveal =
        find.byKey(const ValueKey<String>('use_free_solution'));
    await tester.ensureVisible(reveal);
    await tester.tap(reveal);
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pumpAndSettle();

    final Rect stepBounds = tester.getRect(find.text(firstStep));
    expect(stepBounds.top, greaterThanOrEqualTo(0));
    expect(stepBounds.top, lessThanOrEqualTo(140));
  });

  testWidgets('free practice review explains when free solutions run out',
      (WidgetTester tester) async {
    final AppServices services = createTestServices();
    for (final String id in <String>['other_1', 'other_2', 'other_3']) {
      await services.unlockFreeSolution(id);
    }

    await pumpPracticeAndAnswer(tester, services);

    expect(
        find.byKey(const ValueKey<String>('use_free_solution')), findsNothing);
    expect(
        find.text(
            "Today's 3 free solutions are used. Come back tomorrow, or unlock every solution."),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('unlock_solution_steps')),
        findsOneWidget);
  });

  testWidgets('full unlock shows quiz solution steps',
      (WidgetTester tester) async {
    final InMemoryMonetizationService monetization =
        InMemoryMonetizationService.withProduct();
    await monetization.initialize();
    await monetization.purchaseFullUnlock();
    final DateTime now = DateTime.utc(2026, 9, 13);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: MonetizationScope(
          service: monetization,
          child: QuizResultPage(
            services: createTestServices(),
            result: QuizSessionResult(
              records: [
                QuizAnswerRecord(
                  question: createDemoQuestion(),
                  submittedAnswer: 'B',
                  isCorrect: true,
                  answeredAt: now,
                ),
              ],
              startedAt: now,
              submittedAt: now,
            ),
          ),
        ),
      ),
    );

    await tester.tap(
      find.byKey(
        const ValueKey<String>('quiz_result_geometry_grade4_foundation_001'),
      ),
    );
    await tester.pump();

    expect(
      find.text('Look at the highest point of the blue sin(x) curve.'),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('unlock_solution_steps')),
      findsNothing,
    );
  });

  testWidgets('quiz result summary fits on a phone',
      (WidgetTester tester) async {
    final DateTime startedAt = DateTime.utc(2026, 10, 28, 9);
    await tester.binding.setSurfaceSize(const Size(390, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: QuizResultPage(
          services: createTestServices(),
          result: QuizSessionResult(
            records: [
              QuizAnswerRecord(
                question: createDemoQuestion(),
                submittedAnswer: 'B',
                isCorrect: true,
                answeredAt: startedAt.add(const Duration(minutes: 2)),
              ),
            ],
            startedAt: startedAt,
            submittedAt: startedAt.add(const Duration(minutes: 2)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('Correct'), findsAtLeastNWidgets(1));
    expect(find.text('Elapsed: 2:00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('session launch picks packs from the learner grade range only', () {
    const LearnerProfile learner = LearnerProfile(
      id: 'learner_allen',
      displayName: 'Allen',
      levelStage: 'grade4',
      minLevelStage: 'grade3',
      maxLevelStage: 'grade6',
      challengeTier: 'foundation',
      createdAtIso: '2026-07-16T00:00:00Z',
    );

    const List<BundledQuestionPackInfo> packs = [
      BundledQuestionPackInfo(
        path: 'g2.json',
        topic: '幾何',
        topicCode: 'geometry',
        levelStage: 'grade2',
        challengeTier: 'foundation',
        questionCount: 10,
      ),
      BundledQuestionPackInfo(
        path: 'g3.json',
        topic: '幾何',
        topicCode: 'geometry',
        levelStage: 'grade3',
        challengeTier: 'foundation',
        questionCount: 10,
      ),
      BundledQuestionPackInfo(
        path: 'g5.json',
        topic: '幾何',
        topicCode: 'geometry',
        levelStage: 'grade5',
        challengeTier: 'foundation',
        questionCount: 10,
      ),
      BundledQuestionPackInfo(
        path: 'g7.json',
        topic: '幾何',
        topicCode: 'geometry',
        levelStage: 'grade7',
        challengeTier: 'foundation',
        questionCount: 10,
      ),
    ];

    final List<BundledQuestionPackInfo> eligible =
        SessionLaunchPlanBuilder.pickEligiblePacks(
      packs,
      learner,
      topicCode: 'geometry',
    );

    expect(eligible.map((pack) => pack.levelStage), ['grade3', 'grade5']);
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
            path:
                'assets/questions/geometry/grade4_foundation.geometry.v1.json',
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
        const ValueKey<String>(
            'practice_option_geometry_grade4_foundation_001_B'),
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

    await tester.ensureVisible(find.text('Next question'));
    await tester.tap(find.text('Next question'));
    await tester.pump();

    expect(find.textContaining('Question'), findsWidgets);
    expect(find.text('Compute 18 + 27.'), findsOneWidget);
  });

  testWidgets(
      'practice session does not show elapsed time in active practice mode',
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
            path:
                'assets/questions/geometry/grade4_foundation.geometry.v1.json',
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

  testWidgets(
      'practice session localizes mixed topic and hides editorial source',
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
            path:
                'assets/questions/geometry/grade5_foundation.geometry.v1.json',
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

    expect(find.text('綜合'), findsNothing);
    expect(find.text('mixed'), findsNothing);
    expect(find.textContaining('Source:'), findsNothing);
    expect(find.textContaining('MathSpring Editorial'), findsNothing);
  });

  testWidgets(
      'practice session renders normalized math notation for formula questions',
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
            path: 'assets/questions/algebra/grade10_foundation.algebra.v1.json',
            topic: '代數',
            topicCode: 'algebra',
            levelStage: 'grade10',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: [createFormulaQuestion()],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('x² - 4x + 7'), findsOneWidget);
    expect(find.textContaining('-1 ≤ x ≤ a'), findsOneWidget);
    expect(find.textContaining('x^2 - 4x + 7'), findsNothing);
    expect(find.textContaining('-1 <= x <= a'), findsNothing);
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
            path:
                'assets/questions/geometry/grade4_foundation.geometry.v1.json',
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
        const ValueKey<String>(
            'practice_option_geometry_grade4_foundation_001_B'),
      ),
    );
    await tester.pumpAndSettle();
    final Finder nextQuestionButton =
        find.widgetWithText(FilledButton, 'Next question');
    await tester.ensureVisible(nextQuestionButton);
    await tester.tap(nextQuestionButton);
    await tester.pump();

    await tester
        .tap(find.byKey(const ValueKey<String>('close_practice_session')));
    await tester.pumpAndSettle();

    expect(find.text('Practice Summary'), findsAtLeastNWidgets(1));
    expect(find.text('1 / 1 correct'), findsOneWidget);
    expect(find.textContaining('Elapsed'), findsNothing);
  });

  testWidgets(
      'quiz session can submit early and counts unanswered as incorrect',
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
            path:
                'assets/questions/geometry/grade4_foundation.geometry.v1.json',
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
    final Finder viewHistoryButton = find.text('View history');
    await tester.ensureVisible(viewHistoryButton);
    await tester.tap(viewHistoryButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('History'), findsAtLeastNWidgets(1));
    expect(find.text('Quiz Mode'), findsOneWidget);
    expect(find.text('Practice Mode'), findsOneWidget);
    expect(find.text('Geometry'), findsAtLeastNWidgets(1));
    expect(find.text('8 / 10 correct'), findsOneWidget);
    expect(find.textContaining('Elapsed 5:00'), findsOneWidget);
  });

  testWidgets('review tab offers mistake practice for unfixed wrong answers',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');
    final AppServices services = createTestServices(
      initialProgress: const <QuestionProgress>[
        QuestionProgress(
          learnerId: 'learner_allen',
          questionId: 'logic_grade5_foundation_003',
          status: 'incorrect',
          lastResult: 'multiple_choice:A',
          updatedAtIso: '2026-10-16T08:00:00Z',
        ),
        QuestionProgress(
          learnerId: 'learner_allen',
          questionId: 'arithmetic_grade2_foundation_010',
          status: 'correct',
          lastResult: 'integer:1',
          updatedAtIso: '2026-10-16T09:00:00Z',
        ),
      ],
    );

    await pumpApp(tester, services);
    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();

    expect(find.text('1 question to fix'), findsOneWidget);
    final Finder start =
        find.byKey(const ValueKey<String>('start_mistake_practice'));
    await tester.ensureVisible(start);
    await tester.tap(start);
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    await tester.pumpAndSettle();

    expect(find.text('Practice Mode'), findsOneWidget);
    expect(
        find.textContaining('Five students sit evenly spaced'), findsOneWidget);
  });

  testWidgets('daily mission includes one earlier mistake',
      (WidgetTester tester) async {
    final AppServices services = createTestServices(
      completeDailyMission: false,
      initialProgress: const <QuestionProgress>[
        QuestionProgress(
          learnerId: 'learner_allen',
          questionId: 'arithmetic_grade4_foundation_010',
          status: 'incorrect',
          lastResult: 'integer:1',
          updatedAtIso: '2026-10-16T08:00:00Z',
        ),
      ],
    );
    await tester.pumpWidget(MathSpringApp(services: services));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('start_daily_mission')));
    for (int attempt = 0;
        attempt < 50 && find.byType(PracticeSessionPage).evaluate().isEmpty;
        attempt += 1) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });
      await tester.pump();
    }

    final PracticeSessionPage page =
        tester.widget<PracticeSessionPage>(find.byType(PracticeSessionPage));
    final List<String> ids =
        page.initialQuestions!.map((Question q) => q.id).toList();
    expect(ids, hasLength(5));
    expect(ids.last, 'arithmetic_grade4_foundation_010');
  });

  testWidgets('review tab lists concepts that need strengthening',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');
    const List<String> fractionIds = <String>[
      'arithmetic_grade4_foundation_012',
      'arithmetic_grade4_foundation_035',
      'arithmetic_grade4_foundation_037',
    ];
    final AppServices services = createTestServices(
      initialSessions: const <AnswerSession>[
        AnswerSession(
          id: 'session_fractions',
          learnerId: 'learner_allen',
          mode: 'practice',
          topicCode: 'arithmetic',
          levelStage: 'grade4',
          challengeTier: 'foundation',
          startedAtIso: '2026-10-16T09:00:00Z',
          endedAtIso: '2026-10-16T09:05:00Z',
          elapsedSeconds: 300,
          totalQuestions: 3,
          correctCount: 0,
        ),
      ],
      initialSessionRecords: <String, List<SessionAnswerRecord>>{
        'session_fractions': <SessionAnswerRecord>[
          for (int index = 0; index < fractionIds.length; index += 1)
            SessionAnswerRecord(
              sessionId: 'session_fractions',
              questionId: fractionIds[index],
              sequence: index + 1,
              submittedAnswer: '1',
              isCorrect: false,
              answeredAtIso: '2026-10-16T09:0${index + 1}:00Z',
            ),
        ],
      },
    );

    await pumpApp(tester, services);
    await tester.tap(find.text('Review'));
    for (int attempt = 0;
        attempt < 50 && find.textContaining('Fractions').evaluate().isEmpty;
        attempt += 1) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();
    }

    expect(find.text('Concepts to strengthen'), findsOneWidget);
    expect(find.text('Fractions · 0 of 3 correct'), findsOneWidget);
  });

  testWidgets('practice puts weak-concept questions earlier',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');
    const List<String> fractionIds = <String>[
      'arithmetic_grade4_foundation_012',
      'arithmetic_grade4_foundation_035',
      'arithmetic_grade4_foundation_037',
      'arithmetic_grade4_foundation_055',
      'arithmetic_grade4_foundation_067',
    ];
    final String now = DateTime.now().toUtc().toIso8601String();
    // 今天答錯 5 題分數：每日任務已完成，分數成為弱概念
    final AppServices services = createTestServices(
      initialSessions: <AnswerSession>[
        AnswerSession(
          id: 'session_fractions',
          learnerId: 'learner_allen',
          mode: 'practice',
          topicCode: 'arithmetic',
          levelStage: 'grade4',
          challengeTier: 'foundation',
          startedAtIso: now,
          endedAtIso: now,
          elapsedSeconds: 300,
          totalQuestions: 5,
          correctCount: 0,
        ),
      ],
      initialSessionRecords: <String, List<SessionAnswerRecord>>{
        'session_fractions': <SessionAnswerRecord>[
          for (int index = 0; index < fractionIds.length; index += 1)
            SessionAnswerRecord(
              sessionId: 'session_fractions',
              questionId: fractionIds[index],
              sequence: index + 1,
              submittedAnswer: '1',
              isCorrect: false,
              answeredAtIso: now,
            ),
        ],
      },
    );

    await pumpApp(tester, services);
    final Finder start =
        find.byKey(const ValueKey<String>('open_start_practice'));
    await tester.ensureVisible(start);
    await tester.tap(start);
    for (int attempt = 0;
        attempt < 50 && find.byType(PracticeSessionPage).evaluate().isEmpty;
        attempt += 1) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });
      await tester.pump();
    }

    final List<Question> ordered = tester
        .widget<PracticeSessionPage>(find.byType(PracticeSessionPage))
        .initialQuestions!;
    final List<int> fractionRanks = <int>[
      for (int index = 0; index < ordered.length; index += 1)
        if (ordered[index].conceptTags.contains('c:fraction')) index,
    ];
    expect(fractionRanks.length, greaterThan(20));
    final double meanPercentile =
        fractionRanks.reduce((int a, int b) => a + b) /
            fractionRanks.length /
            ordered.length;
    // 權重 3 的題目平均落在約 25% 的位置；不加權時是 50%
    expect(meanPercentile, lessThan(0.4));
  });

  testWidgets('review tab says when there are no mistakes to fix',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    await pumpApp(tester, createTestServices());
    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();

    expect(find.text('No mistakes to fix. Wrong answers will show up here.'),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('start_mistake_practice')),
        findsNothing);
  });

  testWidgets('review tab shows achievements and selects a practiced day',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');
    final AppServices services = createTestServices(
      initialSessions: const [
        AnswerSession(
          id: 'session_calendar',
          learnerId: 'learner_allen',
          mode: 'practice',
          topicCode: 'geometry',
          levelStage: 'grade4',
          challengeTier: 'foundation',
          startedAtIso: '2026-08-20T09:00:00Z',
          endedAtIso: '2026-08-20T09:05:00Z',
          elapsedSeconds: 300,
          totalQuestions: 2,
          correctCount: 1,
        ),
      ],
      initialSessionRecords: const {
        'session_calendar': [
          SessionAnswerRecord(
            sessionId: 'session_calendar',
            questionId: 'q1',
            sequence: 1,
            submittedAnswer: 'A',
            isCorrect: true,
            answeredAtIso: '2026-08-20T09:01:00Z',
          ),
          SessionAnswerRecord(
            sessionId: 'session_calendar',
            questionId: 'q2',
            sequence: 2,
            submittedAnswer: 'B',
            isCorrect: false,
            answeredAtIso: '2026-08-20T09:02:00Z',
          ),
        ],
      },
    );

    await pumpApp(tester, services);
    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();

    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Current streak: 1 day'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('calendar_day_2026-08-20')),
        findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey<String>('calendar_day_2026-08-20')),
    );
    await tester.pumpAndSettle();
    expect(find.text('2 questions · 50% correct'), findsOneWidget);
  });

  testWidgets(
      'history session opens detail view with saved answers and solution',
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

    await tester.tap(find
        .byKey(const ValueKey<String>('history_session_session_quiz_recent')));
    await tester.pump();
    await pumpUntilFound(tester, find.text('Question 1'));

    expect(find.text('Session Detail'), findsAtLeastNWidgets(1));
    expect(find.text('Question 1'), findsOneWidget);
    expect(find.text('Correct'), findsAtLeastNWidgets(1));
    expect(find.text('Your answer: B  sin(x) at π/2, cos(x) at 0'),
        findsOneWidget);
    expect(find.textContaining('sin(x) reaches its maximum value 1 at π/2'),
        findsOneWidget);
  });

  Question createEmphasisQuestion() {
    return Question.fromJson({
      'id': 'number_theory_grade7_foundation_016',
      'topic': 'number_theory',
      'difficulty': 'foundation',
      'levelStage': 'grade7',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '把 2520 做質因數分解。求它有多少個**不同的**質因數。',
        'en':
            'Factorise 2520 into primes. How many **distinct** prime factors does it have?',
      },
      'answer': {
        'zh-Hant': '答案是 4。',
        'en': 'The answer is 4.',
      },
      'solutionSteps': {
        'zh-Hant': ['2520 = 2³ × 3² × 5 × 7，共有 **4** 個不同的質因數。'],
        'en': [
          '2520 = 2³ × 3² × 5 × 7, so it has **4** distinct prime factors.'
        ],
      },
      'figure': {
        'type': 'custom',
        'kind': 'none',
        'params': <String, dynamic>{},
      },
      'answerMode': 'integer_input',
      'inputConstraints': {
        'allowNegative': false,
        'maxDigits': 2,
      },
      'correctAnswer': {
        'type': 'integer',
        'value': '4',
      },
      'source': {
        'type': 'rewritten_olympiad_style',
        'name': 'MathSpring',
        'reference': 'internal',
      },
    });
  }

  testWidgets(
      'question prompts render bold markers instead of showing asterisks',
      (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.localeTestValue = const Locale('en');

    final AppServices services = createTestServices();

    await tester.binding.setSurfaceSize(const Size(430, 932));
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
            path:
                'assets/questions/number_theory/grade7_foundation.number_theory.v1.json',
            topic: 'Number theory',
            topicCode: 'number_theory',
            levelStage: 'grade7',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: [createEmphasisQuestion()],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('**'), findsNothing);

    final Iterable<RichText> richTexts = tester.widgetList<RichText>(
      find.byType(RichText),
    );
    FontWeight? plainWeight;
    FontWeight? boldWeight;
    for (final RichText richText in richTexts) {
      richText.text.visitChildren((InlineSpan span) {
        if (span is! TextSpan || span.text == null) {
          return true;
        }
        if (span.text!.contains('distinct')) {
          boldWeight = span.style?.fontWeight;
        }
        if (span.text!.contains('Factorise 2520')) {
          plainWeight = span.style?.fontWeight;
        }
        return true;
      });
    }

    expect(boldWeight, isNotNull,
        reason: 'the emphasised run should be its own span');
    expect(plainWeight, isNotNull);
    expect(boldWeight!.value, greaterThan(plainWeight!.value));
  });

  testWidgets('選項裡的根號會原樣顯示在畫面上，而且不會被排版擠掉', (WidgetTester tester) async {
    // 題幹與詳解用 √ 的有一百多題，但選項裡出現 √ 是後來才有的事，
    // 一直只從程式碼確認過「選項與題幹走同一條 normalizeMathText 路徑」，
    // 沒有真的把畫面渲染出來看過。這題有 5 個選項，全部帶根號或分數，
    // 是全庫最吃版面的一組。
    TestWidgetsFlutterBinding.ensureInitialized();
    final AppServices services = createTestServices();

    // loadPack 是真的非同步 I/O，要在 runAsync 裡跑；
    // 直接 await 會卡在 widget test 的 fake async zone 裡不回來。
    late final Question question;
    await tester.runAsync(() async {
      final QuestionBank pack = await BundledQuestionBankRepository().loadPack(
        'assets/questions/geometry/grade11_foundation.geometry.v1.json',
      );
      question = pack.questions.firstWhere(
          (Question q) => q.id == 'geometry_grade11_foundation_007');
    });

    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'Hant'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: PracticeSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path:
                'assets/questions/geometry/grade11_foundation.geometry.v1.json',
            topic: '幾何',
            topicCode: 'geometry',
            levelStage: 'grade11',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: <Question>[question],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    for (final QuestionOption option in question.options!.values) {
      final String text = option.labels['zh-Hant']!;
      expect(find.textContaining(text, findRichText: true), findsWidgets,
          reason: '選項「$text」沒有原樣出現在畫面上');
    }
    // 版面塞不下時 Flutter 會在 debug 期丟 overflow 例外
    expect(tester.takeException(), isNull);
  });

  test('full unlock strings cover every supported locale', () {
    expect(
      AppStrings(const Locale('zh', 'TW')).restorePurchases,
      '回復購買',
    );
    expect(
      AppStrings(const Locale('zh', 'CN')).restorePurchases,
      '恢复购买',
    );
    expect(
      AppStrings(const Locale('en')).restorePurchases,
      'Restore Purchases',
    );
    expect(
      AppStrings(const Locale('ja')).restorePurchases,
      '購入を復元',
    );
  });

  testWidgets('settings exposes the full unlock purchase and restore actions',
      (tester) async {
    final InMemoryMonetizationService monetization =
        InMemoryMonetizationService.withProduct();
    await monetization.initialize();
    await tester.pumpWidget(MathSpringApp(
      services: createTestServices(),
      monetizationService: monetization,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    final Finder fullUnlock =
        find.byKey(const ValueKey<String>('open_full_unlock'));
    expect(fullUnlock, findsOneWidget);
    await tester.ensureVisible(fullUnlock);
    await tester.tap(fullUnlock);
    await tester.pumpAndSettle();
    expect(find.text('MathSpring Full Unlock'), findsAtLeastNWidgets(1));
    expect(find.text('Restore Purchases'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('purchase_full_unlock')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('restore_purchases')),
        findsOneWidget);
  });

  Future<void> openFullUnlockSheet(
    WidgetTester tester,
    MonetizationService monetization,
  ) async {
    await tester.pumpWidget(MathSpringApp(
      services: createTestServices(),
      monetizationService: monetization,
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    final Finder fullUnlock =
        find.byKey(const ValueKey<String>('open_full_unlock'));
    await tester.ensureVisible(fullUnlock);
    await tester.tap(fullUnlock);
    await tester.pumpAndSettle();
  }

  testWidgets('restore stays reachable when the product cannot be loaded',
      (tester) async {
    final StoreKitMonetizationService monetization =
        StoreKitMonetizationService(
      gateway: _ScriptedStorefrontGateway(returnNoProducts: true),
    );

    await openFullUnlockSheet(tester, monetization);

    expect(
        find.text('The purchase product cannot be loaded right now. '
            'Please try again later.'),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('purchase_full_unlock')),
        findsNothing);
    expect(find.byKey(const ValueKey<String>('restore_purchases')),
        findsOneWidget);
  });

  testWidgets('a failed purchase shows a friendly message, not the raw error',
      (tester) async {
    final StoreKitMonetizationService monetization =
        StoreKitMonetizationService(
      gateway: _ScriptedStorefrontGateway(throwOnPurchase: true),
    );
    await openFullUnlockSheet(tester, monetization);

    await tester
        .tap(find.byKey(const ValueKey<String>('purchase_full_unlock')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Bad state'), findsNothing);
    expect(
      find.text('The purchase could not be completed. Please try again later.'),
      findsOneWidget,
    );
  });

  testWidgets('restore without a previous purchase tells the user',
      (tester) async {
    final StoreKitMonetizationService monetization =
        StoreKitMonetizationService(gateway: _ScriptedStorefrontGateway());
    await openFullUnlockSheet(tester, monetization);

    await tester.tap(find.byKey(const ValueKey<String>('restore_purchases')));
    await tester.pumpAndSettle();

    expect(
      find.text('No previous purchase was found for this Apple Account.'),
      findsOneWidget,
    );
  });

  testWidgets('question source label follows the app language',
      (WidgetTester tester) async {
    final AppServices services = createTestServices();
    const String packPath =
        'assets/questions/algebra/grade10_foundation.algebra.v1.json';
    late final Question question;
    await tester.runAsync(() async {
      final QuestionBank pack =
          await BundledQuestionBankRepository().loadPack(packPath);
      question = pack.questions
          .firstWhere((Question q) => q.id == 'algebra_grade10_foundation_001');
    });

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'Hant'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: PracticeSessionPage(
          services: services,
          pack: const BundledQuestionPackInfo(
            path: packPath,
            topic: '代數',
            topicCode: 'algebra',
            levelStage: 'grade10',
            challengeTier: 'foundation',
            questionCount: 1,
          ),
          initialQuestions: <Question>[question],
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('出處：IMC Taiwan 2026'), findsOneWidget);
    expect(find.textContaining('Source:'), findsNothing);
  });

  test('purchase feedback strings cover every supported locale', () {
    for (final Locale locale in const <Locale>[
      Locale('zh', 'TW'),
      Locale('zh', 'CN'),
      Locale('en'),
      Locale('ja'),
    ]) {
      final AppStrings strings = AppStrings(locale);
      expect(strings.purchaseFailed, isNotEmpty);
      expect(strings.nothingToRestore, isNotEmpty);
    }
    expect(AppStrings(const Locale('zh', 'TW')).questionSourcePrefix, '出處：');
    expect(AppStrings(const Locale('en')).questionSourcePrefix, 'Source: ');
  });

  testWidgets('app uses the compact indigo and teal learning-workspace theme',
      (WidgetTester tester) async {
    await tester.pumpWidget(MathSpringApp(services: createTestServices()));
    await tester.pumpAndSettle();

    final ThemeData theme =
        Theme.of(tester.element(find.byType(Scaffold).first));
    expect(theme.scaffoldBackgroundColor, const Color(0xFFF8F8F5));
    expect(theme.colorScheme.primary, AppVisualTokens.brand);
    expect(theme.navigationBarTheme.indicatorColor, AppVisualTokens.brandSoft);

    final RoundedRectangleBorder cardShape =
        theme.cardTheme.shape! as RoundedRectangleBorder;
    expect(cardShape.borderRadius, BorderRadius.circular(14));
  });

  testWidgets('home shell avoids decorative glows and filled navigation icons',
      (WidgetTester tester) async {
    await tester.pumpWidget(MathSpringApp(services: createTestServices()));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('home_background_glow')),
        findsNothing);
    expect(find.byIcon(Icons.play_circle_fill), findsNothing);
    expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
  });

  testWidgets('home primary actions use the shared indigo accent',
      (WidgetTester tester) async {
    await tester.pumpWidget(MathSpringApp(services: createTestServices()));
    await tester.pumpAndSettle();

    final FilledButton practiceButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey<String>('open_start_practice')),
    );
    expect(practiceButton.style?.backgroundColor, isNull);
    expect(
      Theme.of(tester.element(find.byKey(
        const ValueKey<String>('open_start_practice'),
      ))).colorScheme.primary,
      AppVisualTokens.primary,
    );
  });
}

// StoreKit 只能在實機或模擬器的原生層執行，flutter test 叫不到，
// 所以只替換最外層的 StorefrontGateway；購買狀態機與畫面都是真的。
class _ScriptedStorefrontGateway implements StorefrontGateway {
  _ScriptedStorefrontGateway({
    this.returnNoProducts = false,
    this.throwOnPurchase = false,
  });

  final bool returnNoProducts;
  final bool throwOnPurchase;

  @override
  Stream<StorePurchaseEvent> get purchaseUpdates =>
      const Stream<StorePurchaseEvent>.empty();

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<List<StorefrontProduct>> loadProducts(Set<String> productIds) async =>
      returnNoProducts
          ? const <StorefrontProduct>[]
          : const <StorefrontProduct>[
              StorefrontProduct(
                id: 'com.benwu.mathspring.full_unlock',
                title: 'MathSpring Full Unlock',
                price: r'$1.99',
              ),
            ];

  @override
  Future<void> purchase(String productId) async {
    if (throwOnPurchase) {
      throw StateError('Product $productId is not loaded.');
    }
  }

  @override
  Future<void> restore() async {}

  @override
  Future<void> complete(String transactionId) async {}
}
