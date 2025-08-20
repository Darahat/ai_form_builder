import 'package:ai_chat/features/tasks/provider/task_providers.dart';
import 'package:ai_chat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dialog Task Update and Delete function
void showUpdateDeleteTaskDialog(BuildContext context, WidgetRef ref, task) {
  final textController = TextEditingController();
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.takeAction),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.taskTitle,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                ref.read(taskControllerProvider.notifier).removeTask(task.tid!);
              },
              child: Text(AppLocalizations.of(context)!.done),
            ),
            TextButton(
              onPressed: () {
                ref.read(taskControllerProvider.notifier).toggleTask(task.tid!);
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  ref
                      .read(taskControllerProvider.notifier)
                      .editTask(task.tid!, textController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
  );
}
