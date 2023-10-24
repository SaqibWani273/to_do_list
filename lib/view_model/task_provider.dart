import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/task.dart';

final List<Task> tasksList = [];

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super(tasksList);
  void addNewTask(Task newTask) {
    state = [...state, newTask];
    print(
        "Called Add new task in task_providr.dart , task= ${newTask.toString()}");
  }
}

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
