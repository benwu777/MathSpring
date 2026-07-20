class OlympiadTemplateDefinition {
  const OlympiadTemplateDefinition({
    required this.templateId,
    required this.topicCode,
    required this.subtopic,
    required this.challengeTier,
    required this.templateFamily,
    required this.capabilityGoal,
    required this.reasoningStepsExpected,
    required this.allowedAnswerModes,
    required this.requiresFigure,
  });

  final String templateId;
  final String topicCode;
  final String subtopic;
  final String challengeTier;
  final String templateFamily;
  final String capabilityGoal;
  final String reasoningStepsExpected;
  final List<String> allowedAnswerModes;
  final String requiresFigure;

  factory OlympiadTemplateDefinition.fromJson(Map<String, dynamic> json) {
    return OlympiadTemplateDefinition(
      templateId: json['templateId'] as String,
      topicCode: json['topicCode'] as String,
      subtopic: json['subtopic'] as String,
      challengeTier: json['challengeTier'] as String,
      templateFamily: json['templateFamily'] as String,
      capabilityGoal: json['capabilityGoal'] as String,
      reasoningStepsExpected: json['reasoningStepsExpected'] as String,
      allowedAnswerModes: List<String>.from(
        json['allowedAnswerMode'] as List<dynamic>? ?? const <String>[],
      ),
      requiresFigure: json['requiresFigure'] as String? ?? 'none',
    );
  }
}

class OlympiadTemplateRegistry {
  const OlympiadTemplateRegistry({
    required this.version,
    required this.generatedAt,
    required this.templates,
  });

  final int version;
  final String generatedAt;
  final List<OlympiadTemplateDefinition> templates;

  factory OlympiadTemplateRegistry.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawTemplates =
        json['templates'] as List<dynamic>? ?? const [];

    return OlympiadTemplateRegistry(
      version: json['version'] as int? ?? 1,
      generatedAt: json['generatedAt'] as String? ?? '',
      templates: rawTemplates
          .map(
            (item) => OlympiadTemplateDefinition.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}
