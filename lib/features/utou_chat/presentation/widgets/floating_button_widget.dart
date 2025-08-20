import 'package:ai_chat/features/tasks/presentation/widgets/mic_button_widget.dart';
import 'package:ai_chat/features/tasks/presentation/widgets/show_add_task_dialog.dart';
import 'package:ai_chat/features/tasks/provider/task_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Floatingbuttonwidget is for showing floating button and manage multiple options inside this
class FloatingButtonWidget extends ConsumerWidget {
  /// const Floatingbuttonwidget for call Floatingbuttonwidget from outside
  const FloatingButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFabExpanded = ref.watch(isExpandedFabProvider);

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Dismiss overlay when expanded
        if (isFabExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap:
                  () =>
                      ref.read(isExpandedFabProvider.notifier).state =
                          !isFabExpanded,
              child: Container(
                color: Theme.of(context).colorScheme.scrim.withAlpha(
                  100,
                ), // semi-transparent background
              ),
            ),
          ),

        // Mic FAB (Animated Scale & Position)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: isFabExpanded ? 140 : 80,
          right: 20,
          child: AnimatedScale(
            scale: isFabExpanded ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            child: MicButtonWidget(),
          ),
        ),

        // New Task FAB
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: isFabExpanded ? 80 : 80,
          right: isFabExpanded ? 80 : 20,
          child: AnimatedScale(
            scale: isFabExpanded ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            child: FloatingActionButton(
              heroTag: 'addTask',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                ref.read(isExpandedFabProvider.notifier).state = !isFabExpanded;
                showAddTaskDialog(context, ref);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),

        // Main FAB
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            heroTag: 'mainFab',
            onPressed:
                () =>
                    ref.read(isExpandedFabProvider.notifier).state =
                        !isFabExpanded,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: AnimatedRotation(
              turns: isFabExpanded ? 0.125 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.menu),
            ),
          ),
        ),
      ],
    );
  }
}
