// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Task {
  String id;
  String taskName;
  DateTime taskDate;
  Priority taskPriority;
  Category taskCategory;
  bool isCompleted;

  Task({
    required this.id,
    required this.taskName,
    required this.taskDate,
    required this.taskPriority,
    required this.taskCategory,
    required this.isCompleted,
  });

  Task copyWith({
    String? id,
    String? taskName,
    DateTime? taskDate,
    Priority? taskPriority,
    Category? taskCategory,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      taskDate: taskDate ?? this.taskDate,
      taskPriority: taskPriority ?? this.taskPriority,
      taskCategory: taskCategory ?? this.taskCategory,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'taskName': taskName,
      'taskDate': taskDate.millisecondsSinceEpoch,
      'taskPriority': taskPriority.name,
      'taskCategory': taskCategory.name,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      taskName: map['taskName'],
      taskDate: DateTime.fromMillisecondsSinceEpoch(map['taskDate'] as int),
      taskPriority: priorityMap[map['taskPriority']]!,
      taskCategory: categoryMap[map['taskCategory']]!,
      isCompleted: map['isCompleted'] == 0 ? false : true,
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
