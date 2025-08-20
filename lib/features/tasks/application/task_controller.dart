import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/task_model.dart';
import '../infrastructure/task_repository.dart';

/// Used to indicate loading status in the UI
final taskLoadingProvider = StateProvider<bool>((ref) => false);

/// Main Task Controller connected to Hive-backed TaskRepository
class TaskController extends StateNotifier<AsyncValue<List<TaskModel>>> {
  final TaskRepository _repo;

  /// ref is a riverpod object which used by providers to interact with other providers and life cycle
  /// of the application
  /// example ref.read, ref.write etc
  final Ref ref;

  /// TaskController Constructor to call it from outside
  TaskController(this._repo, this.ref) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  /// Load all tasks from repository and update the state
  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    try {
      final tasks = await _repo.getTasks();

      /// Filter for incomplete tasks and set the data state
      state = AsyncValue.data(
        tasks.where((task) => task.isCompleted == false).toList(),
      );
    } catch (e, s) {
      /// If loading fails, set the error state
      state = AsyncValue.error(e, s);
    }
  }

  /// Load all tasks from repository
  // Future<void> getTask() async {
  //   ref.read(taskLoadingProvider.notifier).state = true;

  //   final tasks = await _repo.getTasks();
  //   state = tasks.where((task) => task.isCompleted == false).toList();

  //   ref.read(taskLoadingProvider.notifier).state = false;
  // }

  /// Add a new task and reload list
  Future<void> addTask(String text) async {
    /// Get The current list of tasks from the state's value
    final currentTasks = state.value ?? [];
    final task = await _repo.addTask(text);
    if (task != null) {
      state = AsyncValue.data([...currentTasks, task]);
    }
  }

  /// Toggle a task and reload list
  Future<void> toggleTask(String tid) async {
    final currentTasks = state.value ?? [];
    if (currentTasks.isEmpty) return;
    await _repo.toggleTask(tid);

    final taskToUpdate = currentTasks.firstWhere((t) => t.tid == tid);

    /// changing task according to which tid is toggled check and updated using copy with
    /// which generates copy of that exact object which is toggled
    ///
    final updatedList = currentTasks.updated(
      tid,
      taskToUpdate.copyWith(isCompleted: !taskToUpdate.isCompleted),
    );

    /// Update the state with the new list
    state = AsyncValue.data(updatedList);
  }

  /// Remove a task and reload list
  Future<void> removeTask(String tid) async {
    final currentTasks = state.value ?? [];

    await _repo.removeTask(tid);
    state = AsyncValue.data(
      currentTasks.where((task) => task.tid != tid).toList(),
    );
  }

  /// Edit a task and reload list
  Future<void> editTask(String tid, String newText) async {
    final currentTasks = state.value ?? [];
    if (currentTasks.isEmpty) return;
    await _repo.editTask(tid, newText);
    final taskToUpdate = currentTasks.firstWhere((t) => t.tid == tid);

    /// changing task according to which tid is toggled check and updated using copy with
    /// which generates copy of that exact object which is toggled
    final updatedList = currentTasks.updated(
      tid,
      taskToUpdate.copyWith(title: newText),
    );

    /// Update the state with the new list
    state = AsyncValue.data(updatedList);
  }
}
