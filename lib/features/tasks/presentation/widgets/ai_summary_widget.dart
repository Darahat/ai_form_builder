import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_chat/features/tasks/provider/task_providers.dart';
import 'package:ai_chat/l10n/app_localizations.dart';

/// AISummaryWidget is for showing AI provided summary
class AISummaryWidget extends ConsumerWidget {
  ///const AISummaryWidget to call AISummaryWidget from other
  const AISummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(incompleteTasksProvider);
    final isExpandedAiSummary = ref.watch(isExpandedSummaryProvider);
    final summaryAsync = ref.watch(aiSummaryProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.aiGeneratedSummary,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          if (!tasks.hasValue)
            Text(AppLocalizations.of(context)!.noTasksAvailableToSummarize)
          else
            summaryAsync.when(
              data: (summary) {
                final showToggle = summary.length > 200;
                final displayText =
                    isExpandedAiSummary
                        ? summary
                        : '${summary.substring(0, 200)}...';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayText),

                    if (showToggle)
                      TextButton(
                        onPressed: () {
                          ref.read(isExpandedSummaryProvider.notifier).state =
                              !isExpandedAiSummary;
                        },
                        child: Text(
                          isExpandedAiSummary
                              ? AppLocalizations.of(context)!.seeLess
                              : AppLocalizations.of(context)!.seeMore,
                        ),
                      ),
                  ],
                );
              },
              loading:
                  () => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!.generatingSummary,
                    ),
                  ),
              error:
                  (e, _) => Text(
                    AppLocalizations.of(context)!.unableToGenerateSummary,
                  ),
            ),
        ],
      ),
    );
  }
}
