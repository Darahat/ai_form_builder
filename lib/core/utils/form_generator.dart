import 'dart:convert';

import 'package:ai_form_builder/core/services/hive_service.dart';
import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:ai_form_builder/features/ai_form_builder/domain/form_field_model.dart';
import 'package:ai_form_builder/features/ai_form_builder/infrastructure/ai_generated_form_repository.dart';
import 'package:flutter/material.dart';

/// Form Generator function
class FormGenerator {
  /// parse json which getting from ai and save to hive db
  static Future<AiGeneratedFormModel?> parseAndSaveForm(
    ref,
    HiveService hiveService,
    AiGeneratedFormRepository aiGeneratedFormRepository,
    String jsonString,
  ) async {
    final logger = ref.watch(appLoggerProvider);
    logger.info(
      'Raw AI response: ${jsonString.substring(0, jsonString.length > 300 ? 300 : jsonString.length)}',
    );
    try {
      final cleanedJson = extractJson(jsonString);
      // If cleanedJson is empty, it means no valid JSON was found.
      // Check if cleanedJson is valid before decoding

      if (cleanedJson == null || cleanedJson.isEmpty) {
        debugPrint('No valid JSON found in AI response.');
        logger.debug(
          'Cleaned JSON******************************* $cleanedJson ',
        );
        return null;
      }
      logger.debug(
        'Cleaned JSON*********out out out********************** $cleanedJson ',
      );
      final decodedJson = jsonDecode(cleanedJson);

      if (decodedJson is Map<String, dynamic> &&
          decodedJson.containsKey('title') &&
          decodedJson.containsKey('fields')) {
        final form = AiGeneratedFormModel.fromJson(decodedJson);
        logger.info(
          'Cleaned JSON*********inside if condition********************** $decodedJson ',
        );
        // final box = hiveService.aiGeneratedFormInfoBox;
        // await box.put(form.id, form);
        await aiGeneratedFormRepository.saveAiGeneratedForm(form);
        return form;
      }
    } on FormatException catch (e) {
      debugPrint('Error parsing JSON: $e');
    } catch (e, st) {
      debugPrint('Unexpected error parsing JSON: $e');
      debugPrint('$st');
    }
    return null;
  }
}

/// Extract json from the AI reply
String? extractJson(String input) {
  // Changed return type to String?
  // Remove markdown code block delimiters if present
  String cleanedInput = input.trim();
  if (cleanedInput.startsWith('```json')) {
    cleanedInput = cleanedInput.substring(7).trim(); // Remove '```json'
  } else if (cleanedInput.startsWith('```')) {
    cleanedInput = cleanedInput.substring(3).trim(); // Remove '```'
  }
  if (cleanedInput.endsWith('```')) {
    cleanedInput = cleanedInput
        .substring(0, cleanedInput.length - 3)
        .trim(); // Remove '```'
  }

  int start = cleanedInput.indexOf('{');
  int end = cleanedInput.lastIndexOf('}');

  // If no curly braces, try square brackets
  if (start == -1 || end == -1 || end < start) {
    start = cleanedInput.indexOf('[');
    end = cleanedInput.lastIndexOf(']');
  }

  // If valid start and end found, extract substring
  if (start != -1 && end != -1 && end > start) {
    // Use cleanedInput here
    return cleanedInput.substring(start, end + 1);
  }

  // If no valid JSON structure found, return null
  return null;
}
