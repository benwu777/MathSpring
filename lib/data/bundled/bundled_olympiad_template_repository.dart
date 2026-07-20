import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mathspring/models/olympiad_template.dart';

class BundledOlympiadTemplateRepository {
  static const String _registryPath =
      'assets/question_templates/olympiad_template_registry.v1.json';

  Future<OlympiadTemplateRegistry> loadRegistry() async {
    final String rawJson = await rootBundle.loadString(_registryPath);
    final Map<String, dynamic> decoded =
        jsonDecode(rawJson) as Map<String, dynamic>;
    return OlympiadTemplateRegistry.fromJson(decoded);
  }

  List<OlympiadTemplateDefinition> templatesForTopic(
    String topicCode,
    OlympiadTemplateRegistry registry,
  ) {
    return registry.templates
        .where((template) => template.topicCode == topicCode)
        .toList();
  }

  List<OlympiadTemplateDefinition> templatesForTier(
    String challengeTier,
    OlympiadTemplateRegistry registry,
  ) {
    return registry.templates
        .where((template) => template.challengeTier == challengeTier)
        .toList();
  }
}
