// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../model/task.dart';

enum TaskEnum {
  Edit,
  Delelte,
  ToggleMark,
}

final List<TaskEnum> popMenuItemList = [
  TaskEnum.Delelte,
  TaskEnum.Edit,
  TaskEnum.ToggleMark,
];

enum ShowList {
  all,
  completed,
}

const personalColor = Colors.blue;
const workdColor = Colors.yellowAccent;
const studyColor = Colors.green;
const otherColor = Colors.grey;

const lowPriorityColor = Colors.blue;
const mediumPriorityColor = Colors.orange;
const highPriorityColor = Colors.redAccent;
Color getPriorityColor(Priority priority) {
  switch (priority) {
    case Priority.low:
      return lowPriorityColor;
    case Priority.medium:
      return mediumPriorityColor;
    case Priority.high:
      return highPriorityColor;
  }
}

Color getCategoryColor(Category category) {
  switch (category) {
    case Category.personal:
      return personalColor;
    case Category.work:
      return workdColor;
    case Category.study:
      return studyColor;
    case Category.other:
      return otherColor;
  }
}
