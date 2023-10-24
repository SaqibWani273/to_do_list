// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Task {
  String taskName;
  DateTime taskDate;
  Priority taskPriority;
  Category taskCategory;
  bool isCompleted;

  Task({
    required this.taskName,
    required this.taskDate,
    required this.taskPriority,
    required this.taskCategory,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskName': taskName,
      'taskDate': taskDate.millisecondsSinceEpoch,
      'taskPriority': taskPriority.name,
      'taskCategory': taskCategory.name,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskName: map['taskName'] as String,
      taskDate: DateTime.fromMillisecondsSinceEpoch(map['taskDate'] as int),
      taskPriority: priorityMap[map['taskPriority']]!,
      taskCategory: categoryMap[map['taskCategory']]!,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);
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

Map<String, Priority> priorityMap = {
  Priority.low.name: Priority.low,
  Priority.medium.name: Priority.medium,
  Priority.high.name: Priority.high,
};
Map<String, Category> categoryMap = {
  Category.personal.name: Category.personal,
  Category.work.name: Category.work,
  Category.study.name: Category.study,
  Category.other.name: Category.other,
};
