import 'package:ai_chat/core/services/hive_service.dart';
import 'package:hive/hive.dart';

import '../domain/task_model.dart';

/// A repository class for managing task-related operation using hive
class TaskRepository {
  /// The hive box containing [TaskModel] instances.

  Box<TaskModel> get _box => HiveService.taskBox;

  /// Retrives all tasks from the local Hive storages.
  ///
  /// Returns a [List] of [TaskModel] instances
  Future<List<TaskModel>> getTasks() async {
    return _box.values.toList();
  }

  /// Adds a new task with the given [text] as the title.
  Future<TaskModel?> addTask(String text) async {
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    final task = TaskModel(
      tid: key,
      title: text,
      isCompleted: false,
      taskCreationTime: DateTime.now().toIso8601String(),
    );
    await _box.put(key, task);
    return task;
  }

  /// Toggles the completion status of a task identified by [tid]
  ///
  /// if the task exists, it will be updated with the opposite 'isCompleted' value.
  Future<void> toggleTask(String tid) async {
    final task = _box.get(tid);
    if (task != null) {
      final updated = task.copyWith(isCompleted: !task.isCompleted);
      await _box.put(tid, updated);
    }
  }

  /// Removes the task identified by [tid] from local storage
  Future<void> removeTask(String tid) async {
    await _box.delete(tid);
  }

  /// Updates the title of the task identified by [tid] with [newText]
  Future<void> editTask(String tid, String newText) async {
    final task = _box.get(tid);
    if (task != null) {
      final updated = task.copyWith(title: newText);
      await _box.put(tid, updated);
    }
  }
}
