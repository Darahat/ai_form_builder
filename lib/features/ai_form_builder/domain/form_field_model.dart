import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'form_field_model.g.dart';

@HiveType(typeId: 8)
/// Form Field Model is for make a table about conversation between user and ai and question types
class FormFieldModel {
  /// Which Questions ID
  @HiveField(0)
  final String id;

  /// Which Questions
  @HiveField(1)
  final String question;

  /// What kind of questions are the multiple select or yes or no
  @HiveField(2)
  final String type;

  /// Which are questions options
  @HiveField(3)
  final List<String>? options;

  /// model Constructor
  FormFieldModel({
    required this.id,
    required this.question,
    required this.type,
    this.options,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('question') || !json.containsKey('type')) {
      throw ArgumentError('Invalid JSON: Missing "question" or "type"');
    }

    final String type = json['type'];
    List<String>? options;

    if (type == 'multiple-choice') {
      if (!json.containsKey('options')) {
        throw ArgumentError(
          'Invalid JSON: "multiple-choice" type requires "options"',
        );
      }
      options = List<String>.from(json['options']);
    } else {
      // For other types like 'text', 'textarea', 'options' are not required
      options =
          json.containsKey('options')
              ? List<String>.from(json['options'])
              : null;
      if (json.containsKey('options') && json['options'] != null) {
        if (json['options'] is! List) {
          throw ArgumentError(
            'Invalid JSON: Options must be a list if present and not null',
          );
        }

        options = List<String>.from(json['options']);
      } else {
        options = null;
      }
    }

    return FormFieldModel(
      id: const Uuid().v4(),
      question: json['question'],
      type: type,
      options: options,
    );
  }
}

@HiveType(typeId: 9)
/// Generated Form model.
class AiGeneratedFormModel {
  @HiveField(0)
  /// Title is form id
  final String id;

  @HiveField(1)
  /// Title is text box title
  final String title;

  /// text box field
  @HiveField(2)
  final List<FormFieldModel> fields;

  /// Ai Generated Form Model
  AiGeneratedFormModel({
    required this.id,
    required this.title,
    required this.fields,
  });

  factory AiGeneratedFormModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('title') || !json.containsKey('fields')) {
      throw ArgumentError('Invalid JSON: Missing title or fields');
    }
    final fieldsList = json['fields'] as List;
    final fields = fieldsList.map((f) => FormFieldModel.fromJson(f)).toList();
    return AiGeneratedFormModel(
      id: const Uuid().v4(),
      title: json['title'],
      fields: fields,
    );
  }
}
