class Task {
  String taskName;
  DateTime taskDate;
  Priority taskPriority;
  Category taskCategory;

  Task({
    required this.taskName,
    required this.taskDate,
    required this.taskPriority,
    required this.taskCategory,
  });
}

enum Priority {
  low,
  medium,
  high,
}

enum Category {
  personal,
  work,
  study,
  other,
}
