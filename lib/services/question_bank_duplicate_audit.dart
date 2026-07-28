import 'dart:convert';
import 'dart:io';

class DuplicateAuditQuestion {
  DuplicateAuditQuestion({
    required this.id,
    required this.topic,
    required this.subtopic,
    required this.levelStage,
    required this.promptZhHant,
    required this.sourcePath,
  });

  final String id;
  final String topic;
  final String subtopic;
  final String levelStage;
  final String promptZhHant;
  final String sourcePath;
}

class DuplicateCandidateGroup {
  DuplicateCandidateGroup({
    required this.topic,
    required this.subtopic,
    required this.fingerprint,
    required this.heuristic,
    required this.questionIds,
    required this.prompts,
    required this.sourcePaths,
  });

  final String topic;
  final String subtopic;
  final String fingerprint;
  final String heuristic;
  final List<String> questionIds;
  final List<String> prompts;
  final List<String> sourcePaths;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'topic': topic,
        'subtopic': subtopic,
        'fingerprint': fingerprint,
        'heuristic': heuristic,
        'questionIds': questionIds,
        'prompts': prompts,
        'sourcePaths': sourcePaths,
      };
}

class QuestionDuplicateAuditResult {
  QuestionDuplicateAuditResult({
    required this.scannedQuestions,
    required this.candidateGroups,
  });

  final int scannedQuestions;
  final List<DuplicateCandidateGroup> candidateGroups;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'scannedQuestions': scannedQuestions,
        'candidateGroups': candidateGroups.map((group) => group.toJson()).toList(),
      };
}

class DuplicateReviewDecision {
  DuplicateReviewDecision({
    required this.status,
    required this.topic,
    required this.subtopic,
    required this.questionIds,
  });

  final String status;
  final String topic;
  final String subtopic;
  final List<String> questionIds;

  bool matches(DuplicateCandidateGroup group) {
    if (topic != group.topic || subtopic != group.subtopic) {
      return false;
    }
    final List<String> left = List<String>.from(questionIds)..sort();
    final List<String> right = List<String>.from(group.questionIds)..sort();
    if (left.length != right.length) {
      return false;
    }
    for (int index = 0; index < left.length; index += 1) {
      if (left[index] != right[index]) {
        return false;
      }
    }
    return true;
  }
}

class QuestionBankDuplicateAudit {
  static final RegExp _numberPattern =
      RegExp(r'\d+(?:\.\d+)?(?:/\d+)?');
  static final RegExp _personNamePattern = RegExp(r'小[\u4E00-\u9FFF]');
  static final RegExp _classicNamePattern = RegExp(r'[甲乙丙丁戊己庚辛壬癸]');
  static final RegExp _latinPlaceholderPattern =
      RegExp(r'\b[A-Z]\b', caseSensitive: false);

  static const List<String> _orderedKeywords = <String>[
    '一共有',
    '一樣多',
    '平均分成',
    '平均分給',
    '不能連著走',
    '不能使用',
    '正好是',
    '比原來的數多',
    '比原來多',
    '比原來少',
    '原來的數',
    '原來有',
    '先乘以',
    '先除以',
    '先加上',
    '先減去',
    '乘以',
    '除以',
    '加上',
    '減去',
    '失去',
    '送給',
    '給',
    '打開',
    '切換',
    '共有',
    '條路',
    '結果',
    '最後',
    '剩下',
    '原本',
    '多少',
    '幾種',
    '最大',
    '最小',
  ];

  static QuestionDuplicateAuditResult analyze(
    List<DuplicateAuditQuestion> questions,
    List<DuplicateReviewDecision> decisions,
  ) {
    final Map<String, List<DuplicateAuditQuestion>> grouped =
        <String, List<DuplicateAuditQuestion>>{};

    for (final DuplicateAuditQuestion question in questions) {
      final String fingerprint = buildFingerprint(question);
      final String key =
          '${question.topic}|${question.subtopic}|$fingerprint';
      grouped.putIfAbsent(key, () => <DuplicateAuditQuestion>[]).add(question);
    }

    final List<DuplicateCandidateGroup> candidateGroups =
        grouped.entries.where((entry) => entry.value.length > 1).map((entry) {
      final List<DuplicateAuditQuestion> group = entry.value;
      return DuplicateCandidateGroup(
        topic: group.first.topic,
        subtopic: group.first.subtopic,
        fingerprint: buildFingerprint(group.first),
        heuristic: explainHeuristic(group.first),
        questionIds: group.map((question) => question.id).toList(),
        prompts: group.map((question) => question.promptZhHant).toList(),
        sourcePaths: group.map((question) => question.sourcePath).toList(),
      );
    }).where((group) => !_isResolved(group, decisions)).toList()
          ..sort((left, right) {
            final int subtopicOrder =
                left.subtopic.compareTo(right.subtopic);
            if (subtopicOrder != 0) {
              return subtopicOrder;
            }
            return left.questionIds.first.compareTo(right.questionIds.first);
          });

    return QuestionDuplicateAuditResult(
      scannedQuestions: questions.length,
      candidateGroups: candidateGroups,
    );
  }

  static bool _isResolved(
    DuplicateCandidateGroup group,
    List<DuplicateReviewDecision> decisions,
  ) {
    return decisions.any(
      (decision) =>
          const <String>{
            'acceptable_variant',
            'corrected',
            'merged-away',
          }.contains(decision.status) &&
          decision.matches(group),
    );
  }

  static List<DuplicateAuditQuestion> loadQuestions({
    required String rootPath,
    String? inputPath,
  }) {
    final List<File> files;
    if (inputPath != null) {
      files = <File>[File(inputPath)];
    } else {
      files = _loadManifestScopedFiles(rootPath);
    }

    final List<DuplicateAuditQuestion> questions = <DuplicateAuditQuestion>[];
    for (final File file in files) {
      final Map<String, dynamic> payload =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      if (!payload.containsKey('questions')) {
        continue;
      }

      final List<dynamic> rawQuestions = payload['questions'] as List<dynamic>;
      for (final dynamic rawQuestion in rawQuestions) {
        final Map<String, dynamic> question =
            rawQuestion as Map<String, dynamic>;
        final Map<String, dynamic> prompt =
            (question['prompt'] as Map?)?.cast<String, dynamic>() ??
                <String, dynamic>{};
        final String promptZhHant =
            (prompt['zh-Hant'] ?? prompt['zh_Hant'] ?? '').toString();
        if (promptZhHant.isEmpty) {
          continue;
        }
        questions.add(
          DuplicateAuditQuestion(
            id: question['id'].toString(),
            topic: question['topic'].toString(),
            subtopic: question['subtopic'].toString(),
            levelStage: question['levelStage'].toString(),
            promptZhHant: promptZhHant,
            sourcePath: file.path.replaceFirst('$rootPath/', ''),
          ),
        );
      }
    }

    return questions;
  }

  static List<DuplicateReviewDecision> loadDecisions(String rootPath) {
    final File decisionsFile =
        File('$rootPath/docs/question-bank-duplicate-decisions.json');
    if (!decisionsFile.existsSync()) {
      return <DuplicateReviewDecision>[];
    }

    final Map<String, dynamic> payload =
        jsonDecode(decisionsFile.readAsStringSync()) as Map<String, dynamic>;
    final List<dynamic> groups = payload['groups'] as List<dynamic>? ?? <dynamic>[];
    return groups
        .map((dynamic rawGroup) => rawGroup as Map<String, dynamic>)
        .map(
          (Map<String, dynamic> raw) => DuplicateReviewDecision(
            status: raw['status'].toString(),
            topic: raw['topic'].toString(),
            subtopic: raw['subtopic'].toString(),
            questionIds:
                List<String>.from(raw['questionIds'] as List<dynamic>),
          ),
        )
        .toList();
  }

  static List<File> _loadManifestScopedFiles(String rootPath) {
    final File manifestFile = File('$rootPath/assets/questions/manifest.json');
    if (!manifestFile.existsSync()) {
      final Directory baseDir = Directory('$rootPath/assets/questions');
      return baseDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.json'))
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));
    }

    final Map<String, dynamic> manifest =
        jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
    final List<dynamic> packs = manifest['packs'] as List<dynamic>? ?? <dynamic>[];
    final List<File> files = packs
        .map((dynamic rawPack) => rawPack as Map<String, dynamic>)
        .map((Map<String, dynamic> pack) => File('$rootPath/${pack['path']}'))
        .where((File file) => file.existsSync())
        .toList()
      ..sort((left, right) => left.path.compareTo(right.path));
    return files;
  }

  static String buildFingerprint(DuplicateAuditQuestion question) {
    final String normalizedPrompt = _normalizePrompt(question.promptZhHant);
    final List<String> keywords = _extractKeywords(normalizedPrompt);
    final int numberCount = _numberPattern.allMatches(question.promptZhHant).length;
    final List<String> structureTags = _extractStructureTags(question);
    return [
      'n=$numberCount',
      'kw=${keywords.join('>')}',
      'tags=${structureTags.join('>')}',
    ].join('|');
  }

  static String explainHeuristic(DuplicateAuditQuestion question) {
    final List<String> keywords = _extractKeywords(
      _normalizePrompt(question.promptZhHant),
    );
    final List<String> structureTags = _extractStructureTags(question);
    return 'same subtopic + same structure tags + keywords: ${[...structureTags, ...keywords].join(', ')}';
  }

  static String _normalizePrompt(String prompt) {
    String normalized = prompt;
    normalized = normalized.replaceAll(_numberPattern, '<n>');
    normalized = normalized.replaceAll(_personNamePattern, '<person>');
    normalized = normalized.replaceAll(_classicNamePattern, '<person>');
    normalized = normalized.replaceAll(_latinPlaceholderPattern, '<slot>');
    normalized = normalized
        .replaceAll('送給', '給')
        .replaceAll('哥哥', '<person>')
        .replaceAll('妹妹', '<person>')
        .replaceAll('弟弟', '<person>')
        .replaceAll('姐姐', '<person>')
        .replaceAll('媽媽', '<person>')
        .replaceAll('爸爸', '<person>')
        .replaceAll('貼紙', '<item>')
        .replaceAll('糖果', '<item>')
        .replaceAll('卡片', '<item>')
        .replaceAll('代幣', '<item>')
        .replaceAll('盒子', '<container>')
        .replaceAll('盒', '<container>')
        .replaceAll('家', '<place>')
        .replaceAll('公園', '<place>')
        .replaceAll('學校', '<place>')
        .replaceAll('圖書館', '<place>')
        .replaceAll('甲地', '<place>')
        .replaceAll('乙地', '<place>')
        .replaceAll('丙地', '<place>')
        .replaceAll('張', '<unit>')
        .replaceAll('顆', '<unit>')
        .replaceAll('個', '<unit>')
        .replaceAll('條', '<unit>')
        .replaceAll('本', '<unit>')
        .replaceAll('盞', '<unit>')
        .replaceAll('根', '<unit>')
        .replaceAll('元', '<unit>')
        .replaceAll('公分', '<unit>')
        .replaceAll('平方公分', '<unit>')
        .replaceAll('公尺', '<unit>')
        .replaceAll('平方公尺', '<unit>');
    normalized = normalized.replaceAll(RegExp(r'[，。；：！？、「」（）\(\)\s]'), '');
    return normalized;
  }

  static List<String> _extractKeywords(String prompt) {
    final List<MapEntry<int, String>> located = <MapEntry<int, String>>[];
    for (final String keyword in _orderedKeywords) {
      int start = 0;
      while (true) {
        final int index = prompt.indexOf(keyword, start);
        if (index == -1) {
          break;
        }
        located.add(MapEntry<int, String>(index, keyword));
        start = index + keyword.length;
      }
    }
    located.sort((left, right) => left.key.compareTo(right.key));
    return located.map((entry) => entry.value).toList();
  }

  static String _collapseToShape(String prompt) {
    String shape = prompt;
    shape = shape.replaceAll(RegExp(r'<n>'), 'N');
    shape = shape.replaceAll(RegExp(r'<person>'), 'P');
    shape = shape.replaceAll(RegExp(r'<place>'), 'L');
    shape = shape.replaceAll(RegExp(r'<item>'), 'I');
    shape = shape.replaceAll(RegExp(r'<container>'), 'C');
    shape = shape.replaceAll(RegExp(r'<slot>'), 'S');
    shape = shape.replaceAll(RegExp(r'<unit>'), 'U');
    shape = shape.replaceAll(RegExp(r'[\u4E00-\u9FFF]+'), 'W');
    shape = shape.replaceAll(RegExp(r'(W)\1+'), 'W');
    return shape;
  }

  static List<String> _extractStructureTags(DuplicateAuditQuestion question) {
    final String prompt = question.promptZhHant;
    final List<String> tags = <String>[];

    void addIf(bool condition, String tag) {
      if (condition) {
        tags.add(tag);
      }
    }

    addIf(prompt.contains('周長'), 'asks_perimeter');
    addIf(prompt.contains('面積'), 'asks_area');
    addIf(prompt.contains('最大'), 'asks_max');
    addIf(prompt.contains('最小'), 'asks_min');
    addIf(prompt.contains('中間'), 'asks_middle');
    addIf(prompt.contains('第一'), 'asks_first');
    addIf(prompt.contains('第二'), 'asks_second');
    addIf(prompt.contains('第三'), 'asks_third');
    addIf(prompt.contains('第四'), 'asks_fourth');
    addIf(prompt.contains('第五'), 'asks_fifth');
    addIf(prompt.contains('多少度') || prompt.contains('角'), 'angles');
    addIf(prompt.contains('幾個'), 'asks_count');
    addIf(prompt.contains('幾種'), 'asks_count');
    addIf(prompt.contains('總和'), 'asks_sum');
    addIf(prompt.contains('比') && prompt.contains('倍'), 'ratio_and_multiple');
    addIf(prompt.contains('一共有') || prompt.contains('共裝') || prompt.contains('合起來'), 'total_given');
    addIf(prompt.contains('再過') || prompt.contains('年後') || prompt.contains('年前'), 'time_shift');
    addIf(
      prompt.contains('移') ||
          prompt.contains('拿') ||
          prompt.contains('送') ||
          prompt.contains('給'),
      'transfer_action',
    );
    addIf(prompt.contains('一樣多'), 'equalized');
    addIf(prompt.contains('相差') || prompt.contains('多 2 顆') || prompt.contains('多 4 顆'), 'difference_target');
    addIf(prompt.contains('排成一直線'), 'line_tiling');
    addIf(prompt.contains('L 形'), 'l_shape');
    addIf(prompt.contains('小正方形'), 'unit_squares');
    addIf(prompt.contains('長方形'), 'rectangle');
    addIf(prompt.contains('正方形'), 'square');
    addIf(prompt.contains('三角形'), 'triangle');
    addIf(prompt.contains('梯形'), 'trapezoid');
    addIf(prompt.contains('平行四邊形'), 'parallelogram');
    addIf(prompt.contains('五邊形'), 'pentagon');
    addIf(prompt.contains('四邊形'), 'quadrilateral');
    addIf(prompt.contains('外角'), 'exterior_angle');
    addIf(prompt.contains('內角和'), 'interior_angle_sum');
    addIf(prompt.contains('對角線'), 'diagonal_split');
    addIf(prompt.contains('中位線'), 'midline');
    addIf(prompt.contains('拼成'), 'composed_shape');
    addIf(prompt.contains('重新拼成'), 'reassemble_shape');
    addIf(prompt.contains('走道'), 'walkway');
    addIf(prompt.contains('平均切成'), 'equal_partition');
    addIf(prompt.contains('沿對角線') || prompt.contains('分成兩個三角形'), 'split_into_triangles');
    addIf(prompt.contains('上底與下底的和'), 'sum_of_bases');
    addIf(prompt.contains('上底是下底的一半'), 'half_base_relation');
    addIf(prompt.contains('下底比上底長'), 'base_difference_relation');
    addIf(prompt.contains('高都相同') || prompt.contains('同高'), 'same_height');
    addIf(prompt.contains('每一步可以走 1 階或 2 階'), 'stairs_1_or_2');
    addIf(prompt.contains('3 階'), 'stairs_3_allowed');
    addIf(prompt.contains('不能連續兩次都走 2 階'), 'stairs_no_double_two');
    addIf(prompt.contains('剛好要用兩次 2 階'), 'stairs_exact_two_twos');
    addIf(prompt.contains('第一步不能走 2 階') || prompt.contains('最後一步也不能走 2 階'), 'stairs_end_restriction');
    addIf(prompt.contains('最左邊'), 'leftmost_position');
    addIf(prompt.contains('最右邊'), 'rightmost_position');
    addIf(prompt.contains('最前面'), 'frontmost_position');
    addIf(prompt.contains('最後面'), 'backmost_position');
    addIf(prompt.contains('相鄰') || prompt.contains('緊接'), 'adjacent_required');
    addIf(prompt.contains('對 x 軸'), 'reflect_x_axis');
    addIf(prompt.contains('對 y 軸'), 'reflect_y_axis');
    addIf(prompt.contains('水平距離'), 'horizontal_distance');
    addIf(prompt.contains('垂直距離'), 'vertical_distance');
    addIf(prompt.contains('x 座標'), 'mentions_x_coordinate');
    addIf(prompt.contains('y 座標'), 'mentions_y_coordinate');

    switch (question.subtopic) {
      case 'arrangements':
        addIf(
          !prompt.contains('不能站在') &&
              !prompt.contains('相鄰') &&
              !prompt.contains('最前面') &&
              !prompt.contains('最左邊') &&
              !prompt.contains('最右邊'),
          'arrangement_unconstrained',
        );
        addIf(prompt.contains('不能站在最左邊'), 'arrangement_forbid_left');
        addIf(prompt.contains('不能站在最右邊'), 'arrangement_forbid_right');
        addIf(prompt.contains('不能站在最前面'), 'arrangement_forbid_front');
        addIf(prompt.contains('相鄰') || prompt.contains('緊接'), 'arrangement_adjacent_pair');
        break;
      case 'perimeter_area':
        addIf(prompt.contains('周長是'), 'perimeter_given');
        addIf(prompt.contains('面積是'), 'area_given');
        addIf(prompt.contains('長比寬多'), 'length_width_difference');
        addIf(prompt.contains('長是寬的'), 'length_multiple_width');
        addIf(prompt.contains('對摺'), 'folding');
        break;
      case 'area_counting':
        addIf(prompt.contains('正方形') && prompt.contains('重新拼成'), 'square_reassembled_to_rectangle');
        addIf(prompt.contains('走道'), 'rectangle_walkway');
        addIf(prompt.contains('平均切成'), 'rectangle_equal_partition');
        break;
      case 'average_new_member':
        addIf(prompt.contains('新加入'), 'average_add_member');
        addIf(prompt.contains('轉出') || prompt.contains('轉入'), 'average_replace_member');
        break;
      case 'balance':
        addIf(prompt.contains('從右邊拿') || prompt.contains('從右邊移'), 'balance_right_to_left');
        addIf(prompt.contains('從左邊拿') || prompt.contains('從左邊移'), 'balance_left_to_right');
        break;
      case 'border_counting':
        addIf(prompt.contains('邊框'), 'border_frame');
        addIf(prompt.contains('不算四個角'), 'exclude_corners');
        addIf(prompt.contains('長方形'), 'border_rectangle');
        addIf(prompt.contains('正方形'), 'border_square');
        addIf(prompt.contains('長邊') || prompt.contains('長的一邊'), 'border_long_side_info');
        addIf(prompt.contains('短邊') || prompt.contains('寬的一邊'), 'border_short_side_info');
        addIf(prompt.contains('整圈'), 'border_total_count');
        addIf(prompt.contains('長邊排了幾顆') || prompt.contains('長的一邊排了幾顆'),
            'border_ask_long_side_count');
        break;
      case 'coordinate_distance':
        addIf(prompt.contains('到') && prompt.contains('距離'), 'point_to_point_distance');
        addIf(prompt.contains('對 x 軸的鏡射點'), 'distance_with_x_reflection');
        addIf(prompt.contains('對 y 軸鏡射後'), 'distance_with_y_reflection');
        addIf(prompt.contains('第一象限'), 'first_quadrant');
        break;
      case 'coordinate_geometry':
        addIf(prompt.contains('再向左移'), 'net_horizontal_after_backtrack');
        addIf(prompt.contains('再向上平移'), 'horizontal_after_vertical');
        addIf(prompt.contains('最後的 x 座標'), 'asks_final_x');
        break;
      case 'coordinate_midpoint_style':
        addIf(prompt.contains('中點') && prompt.contains('離 A 幾格'), 'midpoint_distance_from_endpoint');
        addIf(prompt.contains('B 點的座標'), 'recover_endpoint_from_midpoint');
        break;
      case 'ordering':
        addIf(prompt.contains('左邊'), 'ordering_left_right');
        addIf(prompt.contains('前面') || prompt.contains('後面'), 'ordering_front_back');
        addIf(prompt.contains('早到'), 'ordering_arrival');
        addIf(prompt.contains('得第二名') || prompt.contains('名'), 'ordering_race_rank');
        addIf(prompt.contains('一定'), 'ordering_must');
        break;
      case 'matching':
        addIf(prompt.contains('而且每人') || prompt.contains('都不同'), 'matching_all_distinct');
        addIf(prompt.contains('同時也各喜歡一種'), 'matching_two_dimensions');
        addIf(prompt.contains('帽子'), 'matching_hats');
        addIf(prompt.contains('書包'), 'matching_bags');
        addIf(prompt.contains('飲料'), 'matching_drinks');
        addIf(prompt.contains('寵物'), 'matching_pets');
        addIf(prompt.contains('水果'), 'matching_fruits');
        addIf(prompt.contains('社團') || prompt.contains('活動'), 'matching_activities');
        addIf(prompt.contains('襪子'), 'matching_pair_existence');
        break;
      case 'case_reasoning':
        addIf(prompt.contains('不是茶就是水') || prompt.contains('只有一盞是亮的'), 'binary_elimination');
        addIf(prompt.contains('恰好只有一人說真話'), 'exactly_one_truth');
        addIf(prompt.contains('恰好兩人說真話'), 'exactly_two_truths');
        addIf(prompt.contains('說謊'), 'includes_liar_statement');
        addIf(prompt.contains('贏一局得 3 分') || prompt.contains('平局兩人各得 1 分'), 'score_system_case');
        addIf(prompt.contains('座位編號之和') || prompt.contains('都是奇數'), 'seat_number_case');
        break;
      case 'comparison':
        addIf(prompt.contains('比') && prompt.contains('多') && prompt.contains('少'), 'comparison_chain');
        addIf(prompt.contains('連桶共重') || prompt.contains('倒出一半'), 'comparison_container_weight');
        addIf(prompt.contains('誰比較矮') || prompt.contains('誰最快') || prompt.contains('誰比較重'),
            'comparison_identity_query');
        addIf(prompt.contains('天平'), 'comparison_balance_scale');
        addIf(prompt.contains('誰比較矮'), 'comparison_shorter_query');
        addIf(prompt.contains('誰最快'), 'comparison_fastest_query');
        addIf(prompt.contains('小安和小華'), 'comparison_cross_pair_query');
        break;
      case 'calendar_counting':
        addIf(prompt.contains('星期二'), 'calendar_start_tuesday');
        addIf(prompt.contains('星期六'), 'calendar_start_saturday');
        addIf(prompt.contains('22 號'), 'calendar_target_22');
        addIf(prompt.contains('26 號'), 'calendar_target_26');
        break;
      case 'composite_area':
        addIf(prompt.contains('游泳池'), 'outer_walkway_pool');
        addIf(prompt.contains('花圃'), 'outer_walkway_garden');
        addIf(prompt.contains('走道的面積是多少'), 'asks_walkway_area');
        addIf(prompt.contains('花圃的長是多少'), 'asks_inner_length');
        break;
      case 'concentration_mixture':
        addIf(prompt.contains('倒在一起') || prompt.contains('配成濃度'), 'mixture_combine');
        addIf(prompt.contains('倒出') && prompt.contains('清水'), 'mixture_dilution_replace');
        break;
      case 'congruences':
        addIf(prompt.contains('有幾個'), 'congruence_count');
        addIf(prompt.contains('總和'), 'congruence_sum');
        break;
      case 'deduction_chain':
        addIf(prompt.contains('三杯果汁'), 'deduction_direct_choice');
        addIf(prompt.contains('如果下雨'), 'deduction_converse_trap');
        break;
      case 'digit_counting':
        addIf(prompt.contains('1 到 12'), 'digit_count_to_12');
        addIf(prompt.contains('1 到 20'), 'digit_count_to_20');
        break;
      case 'direction':
        addIf(prompt.contains('左邊') && prompt.contains('右邊'), 'direction_basic_left_right');
        addIf(prompt.contains('正北方') || prompt.contains('正東方'), 'direction_compass');
        break;
      case 'position_direction':
        addIf(prompt.contains('裡面') || prompt.contains('外面') || prompt.contains('上面') || prompt.contains('下面'),
            'position_vocab');
        addIf(prompt.contains('面向') && prompt.contains('轉'), 'turning_direction');
        addIf(prompt.contains('方格') || prompt.contains('格線') || prompt.contains('起點'),
            'grid_movement');
        addIf(prompt.contains('同一個點') || prompt.contains('不同的點'), 'same_endpoint_check');
        addIf(prompt.contains('最少要走幾格'), 'return_distance');
        addIf(prompt.contains('哪個方向') || prompt.contains('哪個方位'), 'asks_direction');
        break;
      case 'divisibility':
        addIf(prompt.contains('能被 2 整除'), 'divisible_by_2');
        addIf(prompt.contains('能被 6 整除'), 'divisible_by_6');
        addIf(prompt.contains('能被 4 整除'), 'divisible_by_4');
        addIf(prompt.contains('儘量大'), 'target_largest');
        addIf(prompt.contains('儘量小'), 'target_smallest');
        break;
      case 'gcd_lcm':
        addIf(prompt.contains('最大公因數是 4'), 'gcd_4');
        addIf(prompt.contains('最大公因數是 3'), 'gcd_3');
        addIf(prompt.contains('最小公倍數是 84'), 'lcm_84');
        addIf(prompt.contains('最小公倍數是 36'), 'lcm_36');
        break;
      case 'piece_value':
        addIf(prompt.contains('盒子'), 'piece_value_boxes');
        addIf(prompt.contains('袋子'), 'piece_value_bags');
        addIf(prompt.contains('一共是'), 'piece_value_total');
        break;
      case 'pigeonhole':
        addIf(prompt.contains('星期一到星期日') || prompt.contains('星期幾'), 'pigeonhole_weekday');
        addIf(prompt.contains('生日月份') || prompt.contains('月份'), 'pigeonhole_month');
        addIf(prompt.contains('餘數相同') || prompt.contains('除以'), 'pigeonhole_remainder');
        break;
      case 'position':
        addIf(prompt.contains('座位不同') || prompt.contains('坐在'), 'position_seating_assignment');
        addIf(prompt.contains('盒') || prompt.contains('櫃') || prompt.contains('抽屜'), 'position_hidden_location');
        addIf(prompt.contains('左邊') || prompt.contains('右邊'), 'position_relative_side');
        addIf(prompt.contains('不在') && prompt.contains('右邊') && prompt.contains('左邊'),
            'position_range_filter');
        break;
      case 'set_filtering':
        addIf(prompt.contains('乘法表中') && !prompt.contains('個位數字'), 'set_filtering_multiples');
        addIf(prompt.contains('個位數字') || prompt.contains('十位數字'), 'set_filtering_digit_condition');
        break;
      case 'sequence':
        addIf(prompt.contains('__'), 'sequence_next_term');
        addIf(prompt.contains('每次加') || prompt.contains('每次減'), 'sequence_additive');
        addIf(prompt.contains('每次乘') || prompt.contains('每一項都是前一項'), 'sequence_multiplicative');
        break;
      case 'shapes_properties':
        addIf(prompt.contains('沒有角'), 'no_corner_property');
        addIf(prompt.contains('四個角都一樣大') || prompt.contains('四個直角'), 'four_right_angles_property');
        addIf(prompt.contains('每條邊都一樣長'), 'equal_sides_property');
        addIf(prompt.contains('哪一個圖形') || prompt.contains('哪個圖形'), 'identify_shape');
        addIf(prompt.contains('反駁老師') || prompt.contains('反駁他'), 'counterexample_reasoning');
        break;
      case 'symmetry':
        addIf(prompt.contains('正方形'), 'symmetry_square');
        addIf(prompt.contains('大寫英文字母') || prompt.contains('字母'), 'symmetry_letter');
        addIf(prompt.contains('對稱線'), 'symmetry_line_count');
        addIf(prompt.contains('對摺') && prompt.contains('重合'), 'symmetry_fold_overlap');
        break;
      case 'successive_changes':
        addIf(prompt.contains('先漲價') && prompt.contains('再打'), 'successive_markup_discount');
        addIf(prompt.contains('成本') && prompt.contains('可賺得'), 'successive_profit_after_discount');
        break;
      case 'translation':
        addIf(prompt.contains('從 (') && prompt.contains('平移到'), 'translation_direct_vector');
        addIf(prompt.contains('平移前的座標'), 'translation_reverse_lookup');
        addIf(prompt.contains('a 格') || prompt.contains('b 格'), 'translation_symbolic_vector');
        break;
      case 'truth_deduction':
        addIf(prompt.contains('也比小美矮'), 'truth_self_contradiction');
        addIf(prompt.contains('寶石在紅盒') || prompt.contains('盒子上的話'), 'truth_box_statements');
        addIf(prompt.contains('恰好只有一句真話') || prompt.contains('恰好一人說真話'), 'truth_exactly_one');
        break;
      case 'truth_network':
        addIf(prompt.contains('打破了花瓶'), 'truth_culprit_case');
        addIf(prompt.contains('甲說：「乙說真話。」'), 'truth_meta_chain');
        break;
      case 'venn_diagram':
        addIf(prompt.contains('兩者都不喜歡') || prompt.contains('兩者都不會'), 'venn_neither');
        addIf(prompt.contains('只會') || prompt.contains('只喜歡'), 'venn_only_one');
        break;
      case 'trapezoid_area':
        addIf(prompt.contains('平行四邊形'), 'trap_to_parallelogram');
        addIf(prompt.contains('對角線'), 'trap_diagonal');
        addIf(prompt.contains('中位線'), 'trap_midline');
        addIf(prompt.contains('三角形'), 'trap_compare_triangle');
        addIf(prompt.contains('高都相同') || prompt.contains('同高'),
            'trap_same_height_compare');
        break;
      case 'age_problem':
        addIf(prompt.contains('合起來'), 'age_total');
        addIf(prompt.contains('比') && prompt.contains('大'), 'age_difference');
        addIf(prompt.contains('倍'), 'age_multiple');
        break;
      case 'balance_transfer':
        addIf(prompt.contains('比變成'), 'transfer_ratio_result');
        addIf(prompt.contains('正好變成原來的 2 倍'), 'transfer_double_result');
        addIf(prompt.contains('仍然會比'), 'transfer_difference_after_move');
        break;
      default:
        break;
    }

    final List<String> sortedTags = tags.toSet().toList()..sort();
    return sortedTags;
  }
}
