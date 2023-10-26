import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/edit_task.dart';
import '../model/task.dart';
import '../view/screens/add_task_screen.dart';

final List<Task> tasksList = [];

final fireStoreRef = FirebaseFirestore.instance.collection('tasks');

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super(tasksList);

  Future<List<Task>?> getTasksList() async {
    log('get tasks future called');
    final data = await fireStoreRef.get();
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> docsList =
        data.docs;

    if (docsList.isEmpty) {
      return null;
    }
    final tasksList = docsList.map((e) {
      late Task task;
      try {
        task = Task.fromMap(e.data());
      } catch (e) {
        log("error in task.fromMap = ${e.toString()}");
      }
      return task;
    }).toList();
    state = tasksList;
    return tasksList;
  }

  void addNewTask(Task newTask) {
    final newstate = [...state, newTask];
    state = newstate;
    fireStoreRef
        .doc(newTask.taskDate.toString())
        .set(newTask.toMap())
        .then((value) => log('added new task'))
        .catchError((error, stackTrace) {
      log('error in adding new task : ${error.toString()}');
    });
  }

  void editTask(Task task, Task editedTask) {
    final taskIndex = state.indexOf(task);
    state[taskIndex] = editedTask;
    state = [...state];
  }

  void deleteTask(Task task, BuildContext context) {
    final taskIndex = state.indexOf(task);
    final newState = [...state];
    newState.removeAt(taskIndex);

    state = newState;
    fireStoreRef.doc(task.taskDate.toString()).delete().then((value) {
      log('deleted task');
    }).catchError((error, stackTrace) {
      log('error in deleting : ${error.toString()}');
    });
  }

  void toggleIsCompleteStatus(Task task) {
    final taskIndex = state.indexOf(task);
    state[taskIndex].isCompleted = !state[taskIndex].isCompleted;
    state = [...state];
  }
}

//outside notifier class
void updateTask({
  required TaskEnum value,
  required WidgetRef ref,
  required Task currentTask,
  required BuildContext context,
}) {
  if (value == TaskEnum.Edit) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddTaskScreen(
        onSave: (editedTask) {
          ref.read(taskProvider.notifier).editTask(currentTask, editedTask);
        },
        task: currentTask,
      ),
    ));
  } else if (value == TaskEnum.Delelte) {
    ref.read(taskProvider.notifier).deleteTask(currentTask, context);
  } else {
    ref.read(taskProvider.notifier).toggleIsCompleteStatus(currentTask);
  }
}

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
