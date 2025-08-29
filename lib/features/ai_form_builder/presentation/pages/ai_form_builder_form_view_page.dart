import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:ai_form_builder/features/ai_form_builder/domain/form_field_model.dart';
import 'package:ai_form_builder/features/ai_form_builder/provider/ai_form_builder_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AI generated Form view page
class FormViewPage extends ConsumerWidget {
  /// AI generated Form ID

  final String formId;

  /// AI generated Form view page constructor

  const FormViewPage({super.key, required this.formId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formAsync = ref.watch(aiGeneratedFormModelProvider(formId));
    final formValues = ref.watch(formValuesProvider);
    final logger = ref.watch(appLoggerProvider);

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
              itemCount: form.fields.length + 1,
              itemBuilder: (context, index) {
                if (index == form.fields.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        logger.info('Form Values: $formValues');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Form Submitted (Check console)'),
                          ),
                        );
                      },
                      child: const Text('Submit'),
                    ),
                  );
                }
                final field = form.fields[index];
                return _buildFormField(field, ref);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildFormField(FormFieldModel field, WidgetRef ref) {
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
          _buildInputWidget(field, ref),
        ],
      ),
    );
  }

  Widget _buildInputWidget(FormFieldModel field, WidgetRef ref) {
    final formValues = ref.watch(formValuesProvider);
    final notifier = ref.watch(formValuesProvider.notifier);
    switch (field.type) {
      case 'text':
        return TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter Text',
          ),
          onChanged: (value) => notifier.updateValue(field.id, value),
        );
      case 'number':
        return TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a number',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => notifier.updateValue(field.id, value),
        );
      case 'textarea':
        return TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter long Text',
          ),
          maxLines: 4,
          onChanged: (value) => notifier.updateValue(field.id, value),
        );
      case 'multiple-choice':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              field.options?.map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: formValues[field.id],
                  // This needs state management to work properly
                  onChanged: (value) => notifier.updateValue(field.id, value),
                );
              }).toList() ??
              [],
        );
      case 'dropdown':
        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          value: formValues[field.id],
          hint: const Text('Select an option'),
          onChanged:
              (value) => {
                if (value != null) {notifier.updateValue(field.id, value)},
              },
          items:
              field.options?.map((option) {
                return DropdownMenuItem(value: option, child: Text(option));
              }).toList() ??
              [],
        );
      default:
        return Text('Unsupported field type: ${field.type}');
    }
  }
}
