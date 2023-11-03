import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:to_do_list/constants/other_constants.dart';
import 'package:uuid/uuid.dart';

import '../constants/edit_task.dart';
import '../model/task.dart';
import '../view/screens/add_task_screen.dart';

final List<Task> tasksList = [];
final userId = FirebaseAuth.instance.currentUser!.uid;
final fireStoreRef = FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection('tasks');

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super(tasksList);

  Future<void> setTasksList() async {
//first try to get tasksList from local storage
    late List<Task>? tasksList;
    try {
      tasksList = await tasksListFromLocal();
    } catch (err) {
      log('error in getting tasks from local storage : ${err.toString()}');
    }
    if (tasksList != null) {
      state = tasksList;
      return;
    }
    //=>tasksList is null
    final sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getBool(userHasNoData) != null &&
        sharedPref.getBool(userHasNoData) == true) {
      return;
    }
    //=>tasksList is null

    // final data = await fireStoreRef.get();
    // final List<QueryDocumentSnapshot<Map<String, dynamic>>> docsList =
    //     data.docs;

    // if (docsList.isEmpty) {
    //   return;
    // }
    // final tasksList = docsList.map((e) {
    //   late Task task;
    //   try {
    //     task = Task.fromMap(e.data());
    //   } catch (e) {
    //     log("error in task.fromMap = ${e.toString()}");
    //   }
    //   return task;
    // }).toList();
    // state = tasksList;
  }

  Future<void> addNewTask(Task newTask) async {
    final newstate = [...state, newTask];
    state = newstate;
    try {
      await addToLocalDb(newTask);
    } catch (e) {
      log('Error in add new task to local db : ${e.toString()}');
      return;
    }
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(userHasData, true);
    // fireStoreRef
    //     .doc(newTask.taskDate.toString())
    //     .set(newTask.toMap())
    //     .then((value) => log('added new task'))
    //     .catchError((error, stackTrace) {
    //   log('error in adding new task : ${error.toString()}');
    // });
  }

  Future<void> editTask(Task task, Task editedTask) async {
    try {
      await editFromLocalDb(editedTask);
    } catch (e) {
      log('error in editing task : ${e.toString()}');
      return;
    }
    final taskIndex = state.indexOf(task);
    state[taskIndex] = editedTask;
    state = [...state];
    // fireStoreRef
    //     .doc(editedTask.taskDate.toString())
    //     .set(
    //       editedTask.toMap(),
    //       SetOptions(merge: true),
    //     )
    //     .then((value) {
    //   log('edited task');
    // }).catchError((error, stackTrace) {
    //   log('error in editing task : ${error.toString()}');
    // });
  }

  Future<void> deleteTask(Task task, BuildContext context) async {
    try {
      await deleteFromLocalDb(task.id);
    } catch (e) {
      log('error in deleting from local db : ${e.toString()}');
      return;
    }

    final taskIndex = state.indexOf(task);
    final newState = [...state];
    newState.removeAt(taskIndex);

    state = newState;
    //to update whether user has data or not
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(userHasData, state.isNotEmpty);
    // fireStoreRef.doc(task.taskDate.toString()).delete().then((value) {
    //   log('deleted task');
    // }).catchError((error, stackTrace) {
    //   log('error in deleting : ${error.toString()}');
    // });
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

Future<List<Task>?> tasksListFromLocal() async {
  //to get the appdirectory where the databases are stored
  List<Task>? tasksList;
  final dbPath = await sqflite.getDatabasesPath();
  //here we open a specific database
  final db = await sqflite.openDatabase(
    path.join(dbPath, 'todo.db'),
  );

  final dataInTable = await db.query('Tasks_List');
  if (dataInTable.isNotEmpty) {
    tasksList = dataInTable.map((e) => Task.fromMap(e)).toList();
  }
  return tasksList;
}

Future<void> addToLocalDb(Task newTask) async {
  //to get the appdirectory where the databases are stored
  final dbPath = await sqflite.getDatabasesPath();

  //the query to create a table for storing tasks
  const createQuery = '''Create table Tasks_List(id  TEXT,
       taskName TEXT,
      taskDate int,
       taskPriority TEXT,
       taskCategory TEXT,
        isCompleted INTEGER)''';

  //here we open a specific database
  final db = await sqflite.openDatabase(path.join(dbPath, 'todo.db'),
      onCreate: (db, version) {
    //oncreate gets called only for the first time when this 'todo.db' gets created
    return db.execute(createQuery);
  }, version: 1);
  //now insert the data into table
  await db.insert(
    'Tasks_List',
    newTask.toMap(),
  );
  final dataInTable = await db.query('Tasks_List');
  log('local database data= ${dataInTable.toString()}');
}

Future<void> deleteFromLocalDb(String id) async {
  final dbPath = await sqflite.getDatabasesPath();
  //here we open a specific database
  final db = await sqflite.openDatabase(
    path.join(dbPath, 'todo.db'),
  );
  await db.delete('Tasks_List', where: 'id = ?', whereArgs: [id]);
}

Future<void> editFromLocalDb(Task editedTask) async {
  final dbPath = await sqflite.getDatabasesPath();
  //here we open a specific database
  final db = await sqflite.openDatabase(
    path.join(dbPath, 'todo.db'),
  );
  //query to update data in sqflite database

  await db.update(
    'Tasks_List',
    {
      'taskName': editedTask.taskName,
      'taskDate': editedTask.taskDate.millisecondsSinceEpoch,
      'taskPriority': editedTask.taskPriority.name,
      'taskCategory': editedTask.taskCategory.name,
      'isCompleted': editedTask.isCompleted ? 1 : 0,
    },
    where: 'id = ?',
    whereArgs: [editedTask.id],
  );
}

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
