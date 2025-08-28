import 'package:ai_form_builder/core/services/hive_service.dart';
import 'package:ai_form_builder/features/ai_form_builder/domain/form_field_model.dart';
import 'package:hive/hive.dart';

class AiGeneratedFormRepository {
  final HiveService _hiveService;
  Box<AiGeneratedFormModel> get _getFormbox =>
      _hiveService.aiGeneratedFormInfoBox;
  AiGeneratedFormRepository(this._hiveService);

  AiGeneratedFormModel? getAiGeneratedFormById(String id) {
    return _getFormbox.get(id);
  }
}
