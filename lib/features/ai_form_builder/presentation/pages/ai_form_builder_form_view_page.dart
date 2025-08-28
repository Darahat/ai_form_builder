import 'package:ai_form_builder/features/ai_form_builder/domain/form_field_model.dart';
import 'package:ai_form_builder/features/ai_form_builder/provider/ai_form_builder_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormViewPage extends ConsumerWidget {
  final String formId;

  const FormViewPage({super.key, required this.formId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formAsync = ref.watch(aiGeneratedFormModelProvider(formId));

    return Scaffold(
      appBar: AppBar(
        title: formAsync.when(
          data: (form) => Text(form?.title ?? 'Form'),
          error: (e, s) => const Text('Form'),
          loading: () => const Text('Form'),
        ),
      ),
      body: formAsync.when(
        data: (form) {
          if (form == null) {
            return const Center(child: Text('Form not found'));
          }
          // Render the form fields dynamically here
          return Form(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: form.fields.length,
              itemBuilder: (context, index) {
                final field = form.fields[index];
                return _buildFormField(field);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildFormField(FormFieldModel field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.question,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildInputWidget(field),
        ],
      ),
    );
  }

  Widget _buildInputWidget(FormFieldModel field) {
    switch (field.type) {
      case 'text':
        return TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter Text',
          ),
        );
      case 'number':
        return TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a number',
          ),
          keyboardType: TextInputType.number,
        );
      case 'textarea':
        return TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter long Text',
          ),
          maxLines: 4,
        );
      case 'multiple-choice':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              field.options?.map((option) {
                return RadioListTile(
                  title: Text(option),
                  value: option,
                  groupValue:
                      null, // This needs state management to work properly
                  onChanged: (value) {
                    // This needs state management to work properly
                  },
                );
              }).toList() ??
              [],
        );
      default:
        return Text('Unsupported field type: ${field.type}');
    }
  }
}
