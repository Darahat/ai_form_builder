import 'package:ai_form_builder/core/services/hive_service.dart';
import 'package:ai_form_builder/features/ai_form_builder/domain/ai_form_submission_model.dart';
import 'package:ai_form_builder/features/ai_form_builder/domain/form_field_model.dart';
import 'package:hive/hive.dart';

/// Separated from ai generated chat repository to handle only generated form part easily
class AiGeneratedFormRepository {
  final HiveService _hiveService;

  Box<AiGeneratedFormModel> get _getFormBox =>
      _hiveService.aiGeneratedFormInfoBox;

  ///    AiGeneratedFormRepository constructor
  AiGeneratedFormRepository(this._hiveService);

  ///Save form to hive db
  Future<void> saveAiGeneratedForm(AiGeneratedFormModel form) async {
    await _getFormBox.put(form.id, form);
  }

  /// Get AIGenerated Form by ID from hive database

  AiGeneratedFormModel? getAiGeneratedFormById(String id) {
    return _getFormBox.get(id);
  }
}

abstract class FormSubmissionRepository {
  Future<void> addSubmission(AiFormSubmissionModel submission);
  Future<List<AiFormSubmissionModel>> getSubmissions();
  Future<List<AiFormSubmissionModel>> getSubmissionByFormId(String formId);
}
