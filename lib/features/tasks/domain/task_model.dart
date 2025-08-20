import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
/// its User model for authentication
class TaskModel {
  /// first field for the hive/table is uid
  @HiveField(0)
  final String? tid;

  /// second non required field
  @HiveField(1)
  final String? title;

  /// third required field for login
  @HiveField(2)
  final bool isCompleted;

  /// third required field for login
  @HiveField(3)
  final String? taskCreationTime;

  /// its construct of UserModel class . its for call UserModel to other dart file.  this.name is not required
  TaskModel({
    this.tid,
    this.title,
    required this.isCompleted,
    this.taskCreationTime,
  });

  ///creating a copy of an existing object with some updated fields and the actual object remain unchanged
  ///its used when need to update any field .
  ///used riverpod to state management.
  TaskModel copyWith({
    String? tid,
    String? title,
    bool? isCompleted,
    String? taskCreationTime,
  }) {
    return TaskModel(
      tid: tid ?? this.tid,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      taskCreationTime: taskCreationTime ?? this.taskCreationTime,
    );
  }
}

///making an extension instead of calling getTask() everytime to load all tasks
extension TaskListUtils on List<TaskModel> {
  /// Returns a task by its ID and applies the update.
  List<TaskModel> updated(String tid, TaskModel updatedTask) {
    return [
      for (final task in this)
        if (task.tid == tid)
          /// When we find the task, create a new one with the updated title
          updatedTask
        else
          /// Otherwise, keep the existing task
          task,
    ];
  }
}
