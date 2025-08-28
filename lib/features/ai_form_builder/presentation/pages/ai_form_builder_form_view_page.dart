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
      appBar: AppBar(title: Text('Form')),
      body:
          formAsync == null
              ? const Center(child: CircularProgressIndicator())
              : formAsync.when(
                data: (form) {
                  if (form == null)
                    return const Center(child: Text('Form not found'));
                  // Render the form fields dynamically here
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children:
                        form.fields.map((field) {
                          // Build UI based on field.type
                          return ListTile(
                            title: Text(field.question),
                            subtitle: Text(field.type),
                          );
                        }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
              ),
    );
  }
}
