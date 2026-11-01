import 'dart:convert';

enum InProgressSessionKind { practice, quiz }

/// 一筆已作答的練習題，用來接回做到一半的練習。
class InProgressPracticeAnswer {
  const InProgressPracticeAnswer({
    required this.questionId,
    required this.submittedAnswer,
    required this.isCorrect,
    required this.answeredAtIso,
  });

  final String questionId;
  final String submittedAnswer;
  final bool isCorrect;
  final String answeredAtIso;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'questionId': questionId,
        'submittedAnswer': submittedAnswer,
        'isCorrect': isCorrect,
        'answeredAtIso': answeredAtIso,
      };

  factory InProgressPracticeAnswer.fromJson(Map<String, dynamic> json) =>
      InProgressPracticeAnswer(
        questionId: json['questionId'] as String,
        submittedAnswer: json['submittedAnswer'] as String,
        isCorrect: json['isCorrect'] as bool,
        answeredAtIso: json['answeredAtIso'] as String,
      );
}

/// 做到一半的練習或測驗。
///
/// App 在背景太久會被 iOS 回收；冷啟動時進入畫面靠這筆紀錄提供「繼續上次」。
/// 每位學習者最多一筆，完成（看摘要或交卷）時清除。
class InProgressSession {
  const InProgressSession({
    required this.kind,
    required this.packJson,
    required this.questionIds,
    required this.currentIndex,
    required this.startedAtIso,
    this.answers = const <String, String>{},
    this.practiceAnswers = const <InProgressPracticeAnswer>[],
    this.isReviewing = false,
    this.examQuestionCount,
    this.examTimeLimitSeconds,
    this.remainingSeconds,
  });

  final InProgressSessionKind kind;

  /// [BundledQuestionPackInfo] 的 JSON，用來重建題包資訊。
  final Map<String, dynamic> packJson;
  final List<String> questionIds;
  final int currentIndex;
  final String startedAtIso;

  /// 測驗：題號 → 已填的答案。
  final Map<String, String> answers;

  /// 練習：依作答順序的紀錄。
  final List<InProgressPracticeAnswer> practiceAnswers;

  /// 練習：目前這題已作答、正在看解答。
  final bool isReviewing;

  /// 正式測驗：題數、時限與剩餘秒數。剩餘時間採暫停計時——app 不在前景時不扣。
  final int? examQuestionCount;
  final int? examTimeLimitSeconds;
  final int? remainingSeconds;

  bool get isFormalExam => examTimeLimitSeconds != null;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'kind': kind.name,
        'pack': packJson,
        'questionIds': questionIds,
        'currentIndex': currentIndex,
        'startedAtIso': startedAtIso,
        'answers': answers,
        'practiceAnswers':
            practiceAnswers.map((InProgressPracticeAnswer a) => a.toJson()).toList(),
        'isReviewing': isReviewing,
        'examQuestionCount': examQuestionCount,
        'examTimeLimitSeconds': examTimeLimitSeconds,
        'remainingSeconds': remainingSeconds,
      };

  String encode() => jsonEncode(toJson());

  factory InProgressSession.fromJson(Map<String, dynamic> json) =>
      InProgressSession(
        kind: InProgressSessionKind.values.byName(json['kind'] as String),
        packJson: Map<String, dynamic>.from(json['pack'] as Map),
        questionIds: List<String>.from(json['questionIds'] as List),
        currentIndex: json['currentIndex'] as int,
        startedAtIso: json['startedAtIso'] as String,
        answers: Map<String, String>.from(
            (json['answers'] as Map?) ?? const <String, String>{}),
        practiceAnswers: ((json['practiceAnswers'] as List?) ?? const <dynamic>[])
            .map((dynamic e) => InProgressPracticeAnswer.fromJson(
                Map<String, dynamic>.from(e as Map)))
            .toList(),
        isReviewing: (json['isReviewing'] as bool?) ?? false,
        examQuestionCount: json['examQuestionCount'] as int?,
        examTimeLimitSeconds: json['examTimeLimitSeconds'] as int?,
        remainingSeconds: json['remainingSeconds'] as int?,
      );

  static InProgressSession? decode(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return InProgressSession.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map));
  }
}
