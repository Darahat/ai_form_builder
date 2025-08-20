import 'package:ai_chat/features/tasks/provider/task_providers.dart';
import 'package:ai_chat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ShowAddTaskDialog is for Manage Task Update, delete
void showAddTaskDialog(BuildContext context, WidgetRef ref) {
  final textController = TextEditingController();

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.addNewTask,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enterTaskDescription,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            autofocus: true,
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  ref
                      .read(taskControllerProvider.notifier)
                      .addTask(textController.text.trim());
                  Navigator.pop(context);
                }
              },
              child: Text(AppLocalizations.of(context)!.addTask),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
        ),
  );
}
