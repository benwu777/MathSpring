import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mathspring/models/question.dart';
import 'package:mathspring/models/question_bank.dart';

class BundledQuestionPackInfo {
  const BundledQuestionPackInfo({
    required this.path,
    required this.topic,
    required this.topicCode,
    this.olympiadTopic,
    this.olympiadTopicCode,
    required this.levelStage,
    required this.challengeTier,
    required this.questionCount,
  });

  final String path;
  final String topic;
  final String topicCode;
  final String? olympiadTopic;
  final String? olympiadTopicCode;
  final String levelStage;
  final String challengeTier;
  final int questionCount;

  factory BundledQuestionPackInfo.fromJson(Map<String, dynamic> json) {
    return BundledQuestionPackInfo(
      path: json['path'] as String,
      topic: json['topic'] as String,
      topicCode: json['topicCode'] as String,
      olympiadTopic: json['olympiadTopic'] as String?,
      olympiadTopicCode: json['olympiadTopicCode'] as String?,
      levelStage: json['levelStage'] as String,
      challengeTier: json['challengeTier'] as String,
      questionCount: json['questionCount'] as int,
    );
  }
}

class BundledQuestionManifest {
  const BundledQuestionManifest({
    required this.version,
    required this.packs,
  });

  final int version;
  final List<BundledQuestionPackInfo> packs;

  factory BundledQuestionManifest.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawPacks = json['packs'] as List<dynamic>? ?? const [];
    return BundledQuestionManifest(
      version: json['version'] as int? ?? 1,
      packs: rawPacks
          .map(
            (item) => BundledQuestionPackInfo.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}

class BundledQuestionBankRepository {
  static const String _manifestPath = 'assets/questions/manifest.json';

  Future<BundledQuestionManifest> loadManifest() async {
    final String rawJson = await rootBundle.loadString(_manifestPath);
    final Map<String, dynamic> decoded =
        jsonDecode(rawJson) as Map<String, dynamic>;
    return BundledQuestionManifest.fromJson(decoded);
  }

  Future<List<QuestionBank>> loadAllPacks() async {
    final BundledQuestionManifest manifest = await loadManifest();
    final List<QuestionBank> packs = <QuestionBank>[];

    for (final BundledQuestionPackInfo packInfo in manifest.packs) {
      packs.add(await loadPack(packInfo.path));
    }

    return packs;
  }

  Future<QuestionBank> loadPack(String path) async {
    final String rawJson = await rootBundle.loadString(path);
    final Map<String, dynamic> decoded =
        jsonDecode(rawJson) as Map<String, dynamic>;
    return QuestionBank.fromJson(decoded);
  }

  Future<QuestionBank> loadFirstPack() async {
    final List<QuestionBank> packs = await loadAllPacks();
    return packs.first;
  }

  Future<Question?> loadQuestionForSession({
    required String topicCode,
    required String levelStage,
    required String challengeTier,
    required String questionId,
  }) async {
    final BundledQuestionManifest manifest = await loadManifest();
    final BundledQuestionPackInfo? packInfo = manifest.packs.where((item) {
      return item.topicCode == topicCode &&
          item.levelStage == levelStage &&
          item.challengeTier == challengeTier;
    }).cast<BundledQuestionPackInfo?>().firstWhere(
          (item) => item != null,
          orElse: () => null,
        );

    if (packInfo != null) {
      final QuestionBank pack = await loadPack(packInfo.path);
      for (final Question question in pack.questions) {
        if (question.id == questionId) {
          return question;
        }
      }
    }

    final List<QuestionBank> allPacks = await loadAllPacks();
    for (final QuestionBank pack in allPacks) {
      for (final Question question in pack.questions) {
        if (question.id == questionId) {
          return question;
        }
      }
    }
    return null;
  }
}
