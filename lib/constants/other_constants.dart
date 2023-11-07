// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../model/task.dart';

const String usedDevice = 'usedDevice';
const String userHasNoData = 'userHasNoData';

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

String formatTime(TimeOfDay time) {
  int hr = time.hour;
  if (time.hour > 12) {
    hr = time.hour - 12;
  }

  return '${hr < 10 ? '0$hr' : hr}:${time.minute < 10 ? '0${time.minute}' : time.minute}  ${time.hour > 12 ? 'PM' : 'AM'}';
}

String timeLeft(DateTime date, TimeOfDay time) {
  DateTime now = DateTime.now();

  Duration difference = date.difference(now);
  //for past
  if (date.day - now.day < 0) {
    return '${date.day - now.day} days left';
  }

  //for today
  if (difference.inDays == 0) {
    if (time.hour - now.hour - 1 == 0) {
      return '${time.minute - now.minute + 60}min left';
    }
    return '${time.hour - now.hour - 1}h ${time.minute - now.minute + 60}min left';
  }
//for future
  return '${difference.inDays} days left';
}

String dayAndMonth(DateTime date) {
  // return '${date.day}/${date.month}';
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();
  switch (date.month) {
    case 1:
      return '$day Jan';
    case 2:
      return '$day Feb';
    case 3:
      return '$day Mar';
    case 4:
      return '$day Apr';

    case 5:
      return '$day May';

    case 6:
      return '$day Jun';

    case 7:
      return '$day Jul';

    case 8:
      return '$day Aug';

    case 9:
      return '$day Sep';

    case 10:
      return '$day Oct';

    case 11:
      return '$day Nov';

    case 12:
      return '$day Dec';

    default:
      return '$day Jan';
  }
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
