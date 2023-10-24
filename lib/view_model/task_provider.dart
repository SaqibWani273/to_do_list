import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/task.dart';

final List<Task> tasksList = [];

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super(tasksList);
  void addNewTask(Task newTask) {
    state = [...state, newTask];
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
