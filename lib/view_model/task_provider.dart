import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/task.dart';

final List<Task> tasksList = [];
final tasksRef = FirebaseFirestore.instance.collection('tasks');

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
    log("new index = ${state.indexOf(newTask)}");
    tasksRef
        .doc(newTask.taskDate.toString())
        .set(newTask.toMap())
        .catchError((error, stackTrace) {
      log('${error.toString()}');
    });
    // tasksRef.add(newTask.toMap()).catchError((error, stackTrace) {
    //   log('${error.toString()}');
    // });
  }

  void editTask(Task task, Task editedTask) {
    final taskIndex = state.indexOf(task);
    state[taskIndex] = editedTask;
    state = [...state];
  }

  Future<void> deleteTask(Task task) async {
    final taskIndex = state.indexOf(task);
    // for (var element in state) {
    //   log(element.toMap().toString());
    // }
    log(state.isEmpty.toString());
    log("length= ${state.length}");
    log('index = ${taskIndex}');
    state.removeAt(taskIndex);

    state = [...state];
    log("length= ${state.length}");
    try {
      final docRef = tasksRef.doc(task.taskDate.toString()).id;
      log('docRef= ${docRef}');
      await tasksRef.doc(docRef).delete().then((value) {
        log('Deleted');
      }).catchError((error) {
        log('delete failed');
      });
    } catch (e) {
      log("ERror in deleting : ${e.toString()}");
    }
  }

  void toggleIsCompleteStatus(Task task) {
    final taskIndex = state.indexOf(task);
    state[taskIndex].isCompleted = !state[taskIndex].isCompleted;
    state = [...state];
  }
}

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
