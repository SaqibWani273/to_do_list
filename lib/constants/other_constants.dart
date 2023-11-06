import 'package:flutter/material.dart';

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

  return '${hr < 10 ? '0${hr}' : hr}:${time.minute < 10 ? '0${time.minute}' : time.minute}  ${time.hour > 12 ? 'PM' : 'AM'}';
}
