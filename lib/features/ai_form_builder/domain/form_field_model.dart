import 'dart:convert';

import 'package:uuid/uuid.dart';

class FormFieldModel {
  final String id;
  final String question;
  final String type;
  final List<String>? options;

  FormFieldModel({
    required this.id,
    required this.question,
    required this.type,
    this.options,
  });

  factory FormFieldModel.fromMap(Map<String, dynamic> map) {
    return FormFieldModel(
      id: map['id'],
      question: map['question'],
      type: map['type'],
      options: map['options'] != null ? List<String>.from(jsonDecode(map['options'])) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'type': type,
      'options': options != null ? jsonEncode(options) : null,
    };
  }

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

class AiGeneratedFormModel {
  final String id;
  final String title;
  final List<FormFieldModel> fields;

  AiGeneratedFormModel({
    required this.id,
    required this.title,
    required this.fields,
  });

  factory AiGeneratedFormModel.fromMap(Map<String, dynamic> map, List<FormFieldModel> fields) {
    return AiGeneratedFormModel(
      id: map['id'],
      title: map['title'],
      fields: fields,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

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
