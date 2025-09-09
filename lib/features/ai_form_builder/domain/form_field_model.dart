import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'form_field_model.g.dart';

@HiveType(typeId: 8)
class FormFieldModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String question;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final List<String>? options;

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
      options = json.containsKey('options')
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
class AiGeneratedFormModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final List<FormFieldModel> fields;

  AiGeneratedFormModel({
    required this.id,
    required this.title,
    required this.fields,
  });

  /// Convert ai return (the Fields and title part) from json to FormFieldModel data structure

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
