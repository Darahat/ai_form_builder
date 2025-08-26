import 'dart:convert';

import 'package:ai_form_builder/core/services/hive_service.dart';
import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:ai_form_builder/features/ai_form_builder/domain/form_field_model.dart';

/// Form Generator function
class FormGenerator {
  static Future<AiGeneratedFormModel?> parseAndSaveForm(
    ref,
    HiveService hiveService,
    String jsonString,
  ) async {
    final logger = ref.watch(appLoggerProvider);

    try {
      final decodedJson = jsonDecode(jsonString) as Map<String, dynamic>;

      if (decodedJson.containsKey('title') &&
          decodedJson.containsKey('fields')) {
        final fields = decodedJson['fields'];
        if (fields is List &&
            fields.every(
              (f) => f.containsKey('question') && f.containsKey('type'),
            )) {
          final form = AiGeneratedFormModel.fromJson(decodedJson);
          final hiveService = ref.read(hiveServiceProvider);
          final box = hiveService.aiGeneratedFormInfoBox;
          await box.put(form.id, form);
          return form;
        }
      }
    } catch (e) {
      logger.error('Generated Error From Form Generator dart file $e');
    }
    return null;
  }
}
