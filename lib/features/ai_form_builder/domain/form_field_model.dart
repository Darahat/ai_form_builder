import 'package:hive/hive.dart';

part 'form_field_model.g.dart';

@HiveType(typeId: 8)
/// Form Field Model is for make a table about conversation between user and ai and question types
class FormFieldModel {
  /// Which Questions
  @HiveField(0)
  final String question;

  /// What kind of questions are the multiple select or yes or no
  @HiveField(1)
  final String type;

  /// Which are questions options
  @HiveField(2)
  final List<String>? options;

  /// model Constructor
  FormFieldModel({required this.question, required this.type, this.options});
}

@HiveType(typeId: 9)
/// Generated Form model.
class AiGeneratedFormModel {
  @HiveField(0)
  /// Title is text box title
  final int id;

  @HiveField(2)
  /// Title is text box title
  final String title;

  /// text box field
  @HiveField(3)
  final List<FormFieldModel> fields;

  /// Ai Generated Form Model
  AiGeneratedFormModel({
    required this.id,
    required this.title,
    required this.fields,
  });
}
