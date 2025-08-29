import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'ai_form_submission_model.g.dart';

@HiveType(typeId: 10)
/// Model for Form Submission
class AiFormSubmissionModel extends HiveObject {
  /// Form submission id
  @HiveField(0)
  final String id;

  /// Form ID
  @HiveField(1)
  final String formId;

  /// submitted form title for easier display
  @HiveField(2)
  final String formTitle;

  /// Which user is submitted, here an outside user may submit the form
  @HiveField(3)
  final String submitterId;

  /// Users Response Data
  @HiveField(4)
  final List<Map<String, String>> responses;

  ///When User Response
  @HiveField(5)
  final DateTime submittedAt;

  /// AiForm Submission model constructor
  AiFormSubmissionModel({
    required this.id,
    required this.formId,
    required this.formTitle,
    required this.submitterId,
    required this.responses,
    required this.submittedAt,
  });

  /// Data Structure for Create form response
  factory AiFormSubmissionModel.create({
    required String formId,
    required String formTitle,
    String? userId, // can be null for anonymous users
    required List<Map<String, String>> responses,
  }) {
    final submitterId = userId ?? 'anonymous_${const Uuid().v4()}';
    return AiFormSubmissionModel(
      id: const Uuid().v4(),
      formId: formId,
      formTitle: formTitle,
      submitterId: submitterId,
      responses: responses,
      submittedAt: DateTime.now(),
    );
  }
}
