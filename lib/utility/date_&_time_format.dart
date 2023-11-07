import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:to_do_list/model/task.dart';

const String timeExpired = 'Time Expired';
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
  // yesterday
  if (date.day - now.day < 0 ||
      //today but hours passed
      date.day - now.day == 0 && time.hour - now.hour < 0 ||
      //today but minutes passed
      date.day - now.day == 0 &&
          time.hour - now.hour == 0 &&
          time.minute - now.minute < 0) {
    return timeExpired;
  }

  //for today and tommorrow onwards
  if (difference.inDays == 0) {
    if (date.day == now.day) {
      if (time.hour - now.hour == 0) {
        // 'same hour';
        return '${time.minute - now.minute}min left';
      }
      //after an hour
      return '${time.hour - now.hour - 1}h ${time.minute - now.minute + 60}min left';
    }
    //for tommorrow
    return '1 day left';
  }
//for tomorrow onwards
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

List<Task> sortbyDateAndTime(List<Task> tasksList) {
  tasksList.sort((task1, task2) {
    if (task1.taskDate.day == task2.taskDate.day &&
        task1.taskDate.month == task2.taskDate.month &&
        task1.taskDate.year == task2.taskDate.year) {
      int hourComparison = task1.taskTime.hour.compareTo(task2.taskTime.hour);
      if (hourComparison == 0) {
        return task1.taskTime.minute.compareTo(task2.taskTime.minute);
      }
      return hourComparison;
    }

    return task1.taskDate.compareTo(task2.taskDate);
  });
  return tasksList;
}
