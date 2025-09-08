class TaskModel {
  final String? tid;
  final String? title;
  final bool isCompleted;
  final String? taskCreationTime;

  TaskModel({
    this.tid,
    this.title,
    required this.isCompleted,
    this.taskCreationTime,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      tid: map['tid'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
      taskCreationTime: map['taskCreationTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tid': tid,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
      'taskCreationTime': taskCreationTime,
    };
  }

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
