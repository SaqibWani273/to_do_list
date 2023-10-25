import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/task.dart';

final List<Task> tasksList = [];
final ref = FirebaseFirestore.instance.collection('tasks');

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super(tasksList);
  void addNewTask(Task newTask) {
    state = [...state, newTask];
    ref.add(newTask.toMap()).catchError((error, stackTrace) {
      log('${error.toString()}');
    });
  }

  void editTask(Task task, Task editedTask) {
    final taskIndex = state.indexOf(task);
    state[taskIndex] = editedTask;
    state = [...state];
  }

  void deleteTask(Task task) {
    final taskIndex = state.indexOf(task);
    state.removeAt(taskIndex);
    state = [...state];
  }

  void toggleIsCompleteStatus(Task task) {
    final taskIndex = state.indexOf(task);
    state[taskIndex].isCompleted = !state[taskIndex].isCompleted;
    state = [...state];
  }
}

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
