import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:to_do_list/constants/other_constants.dart';
import 'package:to_do_list/constants/shared_ref_consts.dart';
import 'package:to_do_list/utility/date_&_time_format.dart';

import '../model/task.dart';
import '../services/tasks_service.dart';
import '../utility/notification_service.dart';

List<Task> completeTasksList = [];

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super(completeTasksList);

  Future<void> setTasksList() async {
//first try to get tasksList from local storage
    late List<Task>? tasksList;
    try {
      tasksList = await tasksListFromLocal();
    } catch (err) {
      log('error in getting tasks from local storage : ${err.toString()}');
    }
    if (tasksList != null) {
      state = sortbyDateAndTime(tasksList);
      completeTasksList = state;
      return;
    }
    //=>tasksList is null at local db
    if (await SharedRef().noTasksData) {
      //if true => user didnot add any task yet or has deleted all
      return;
    }
    //Code below will get executed only if user has recently uninstalled or
    //cleared app data
    log('user uninstalled app or cleared app data');

    tasksList = await taskListFromFireStore();
    if (tasksList != null) {
      //store these tasks in local db now
      try {
        for (Task task in tasksList) {
          await addToLocalDb(task);
        }
      } catch (err) {
        log('error in storing tasks from firestore to local db : ${err.toString()}');
      }

      state = sortbyDateAndTime(tasksList);
      completeTasksList = state;
    }
    //=>tasksList is null at firestore
  }

  Future<void> addNewTask(Task newTask) async {
    final newstate = [...state, newTask];

    try {
      await addToLocalDb(newTask);
    } catch (e) {
      log('Error in add new task to local db : ${e.toString()}');
      return;
    }
    try {} catch (e) {
      log('error in adding new task to firestore: ${e.toString()}');
      return;
    }
    //update state at the end
    state = newstate;

//to schedule notification
    final scheduledTime = DateTime(
        newTask.taskDate.year,
        newTask.taskDate.month,
        newTask.taskDate.day,
        newTask.taskTime.hour,
        newTask.taskTime.minute);

    try {
      await NotificationService().scheduleNotification(
          title: '${newTask.taskName}',
          body: '${newTask.description}',
          scheduledNotificationDateTime: scheduledTime);
    } catch (e) {
      log("Error in sending local_notification at scheduled time : $e");
    }
  }

  Future<void> editTask(Task task, Task editedTask) async {
    try {
      await editFromLocalDb(editedTask);
    } catch (e) {
      log('error in editing task at local db: ${e.toString()}');
      return;
    }

    try {
      editAtFirestore(editedTask);
    } catch (e) {
      log('error in editing task at firestore: ${e.toString()}');
      return;
    }
    //update state
    final taskIndex = state.indexOf(task);
    state[taskIndex] = editedTask;
    state = [...state];
  }

  Future<void> deleteTask(Task task, BuildContext context) async {
    try {
      await deleteAtLocalDb(task.id);
    } catch (e) {
      log('error in deleting from local db : ${e.toString()}');
      return;
    }

    try {
      deleteAtFireStore(task.id);
    } catch (e) {
      log('error in deleting from firestore : ${e.toString()}');
      return;
    }
    final taskIndex = state.indexOf(task);
    final newState = [...state];
    newState.removeAt(taskIndex);

    state = newState;

    //to update whether user has data or not
    final sharedPref = await SharedPreferences.getInstance();
    if (state.isEmpty) {
      sharedPref.setBool(userHasNoTasksData, true);
    }
  }

  Future<void> toggleIsCompleteStatus(Task task) async {
    //update at local db
    try {
      await toggleIsCompleteStatusAtLocalDb(task);
    } catch (e) {
      log("Error in updating local db : ${e.toString()}");
    }
    try {
      //update at firestore
      toggleIsCompleteStatusAtFireStore(task);
      // fireStoreRef.doc(task.id).update({'isCompleted': !task.isCompleted});
    } catch (e) {
      log("Error in updating firestore : ${e.toString()}");
    }
    final newState = [...state];
    final taskIndex = newState.indexOf(task);
    newState[taskIndex].isCompleted = !newState[taskIndex].isCompleted;
    state = newState;
  }

// ...  to list taks as per user choice in menu bar
  void listBy(enumName) {
    log('in listby, completelist = ${completeTasksList.toString()}');

    switch (enumName) {
      case ShowList.all:
        state = completeTasksList;
        break;

      case ShowList.completed:
        final temp =
            completeTasksList.where((element) => element.isCompleted).toList();
        state = temp;
        break;

      default:
        //the remaining are of type Category enum
        final temp = completeTasksList
            .where((element) => element.taskCategory == enumName)
            .toList();
        state = temp;
        break;
    }
  }
}

//outside notifier class

//notifier
final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
