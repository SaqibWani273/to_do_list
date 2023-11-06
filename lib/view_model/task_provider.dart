import 'dart:developer';
import 'dart:ffi';

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

import '../model/task.dart';
import '../view/screens/add_task_screen.dart';

List<Task> completeTasksList = [];
final userId = FirebaseAuth.instance.currentUser!.uid;
final fireStoreRef = FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection('tasks');

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
      state = tasksList;
      completeTasksList = state;
      log('from local storage : ${state.map((e) => e.taskTime)}');
      return;
    }
    //=>tasksList is null at local db
    final sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getBool(userHasNoData) != null &&
        sharedPref.getBool(userHasNoData) == true) {
      //=> user has no data
      return;
    }
    //Code below will get executed only if user has recently uninstalled or
    //cleared app data
    //to do : check if there is internet connection then show message to
    //user accordingly
    tasksList = await taskListFromFireStore();
    if (tasksList != null) {
      state = tasksList;
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
    try {
      //do not use await as it will wait for the task to be added to firestore
      //before updating state and for that internet connection is required
      fireStoreRef.doc(newTask.id).set(newTask.toMap());
    } catch (e) {
      log('error in adding new task to firestore: ${e.toString()}');
      return;
    }
    //update state at the end
    state = newstate;
  }

  Future<void> editTask(Task task, Task editedTask) async {
    try {
      await editFromLocalDb(editedTask);
    } catch (e) {
      log('error in editing task at local db: ${e.toString()}');
      return;
    }

    try {
      fireStoreRef
          .doc(editedTask.id)
          .set(editedTask.toMap(), SetOptions(merge: true));
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
      await deleteFromLocalDb(task.id);
    } catch (e) {
      log('error in deleting from local db : ${e.toString()}');
      return;
    }

    try {
      fireStoreRef.doc(task.id).delete();
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
      sharedPref.setBool(userHasNoData, true);
    }
  }

  Future<void> toggleIsCompleteStatus(Task task) async {
    //update at local db
    try {
      await toggleIsCompleteStatusFromLocalDb(task);
    } catch (e) {
      log("Error in updating local db : ${e.toString()}");
    }
    try {
      fireStoreRef.doc(task.id).update({'isCompleted': !task.isCompleted});
    } catch (e) {
      log("Error in updating firestore : ${e.toString()}");
    }
    final newState = [...state];
    final taskIndex = newState.indexOf(task);
    newState[taskIndex].isCompleted = !newState[taskIndex].isCompleted;
    state = newState;
  }

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

Future<List<Task>?> tasksListFromLocal() async {
  //to get the appdirectory where the databases are stored
  List<Task>? tasksList;
  final dbPath = await sqflite.getDatabasesPath();
  //here we open a specific database
  final db = await sqflite.openDatabase(
    path.join(dbPath, 'todo.db'),
  );
  // db.execute('DROP TABLE IF EXISTS Tasks_List');

  final tableExists = await db.query(
    'sqlite_master',
    where: 'name = ?',
    whereArgs: ['Tasks_List'],
  );

  if (tableExists.isNotEmpty) {
    final dataInTable = await db.query('Tasks_List');
    tasksList = dataInTable.map((e) => Task.fromMap(e)).toList();
    //to update device status
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(usedDevice, true);
  }
  return tasksList;
}

Future<List<Task>?> taskListFromFireStore() async {
  final data = await fireStoreRef.get();
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docsList = data.docs;

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
  return tasksList;
}

Future<void> addToLocalDb(Task newTask) async {
  //to get the appdirectory where the databases are stored
  final dbPath = await sqflite.getDatabasesPath();

  //the query to create a table for storing tasks
  const createQuery = '''Create table IF NOT EXISTS Tasks_List(id  TEXT,
       taskName TEXT,
       description TEXT,
      taskDate int,
      taskTime int,
       taskPriority TEXT,
       taskCategory TEXT,
        isCompleted INTEGER)''';

  //here we open a specific database
  final db = await sqflite.openDatabase(path.join(dbPath, 'todo.db'));
  db.execute(createQuery);

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
  final tableData = await db.query('Tasks_List');
  if (tableData.isEmpty) {
    // final sharedPref = await SharedPreferences.getInstance();
    // sharedPref.setBool(userHasNoData, true);
    log('empty in local db');
  }
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

Future<void> toggleIsCompleteStatusFromLocalDb(Task task) async {
  final dbPath = await sqflite.getDatabasesPath();

  //here we open a specific database
  final db = await sqflite.openDatabase(
    path.join(dbPath, 'todo.db'),
  );
  //query to update data in sqflite database
  await db.update(
    'Tasks_List',
    {'isCompleted': task.isCompleted ? 0 : 1},
    where: 'id = ?',
    whereArgs: [task.id],
  );
}

//notifier
final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());

//
class CustomMenuController extends StateNotifier<bool> {
  CustomMenuController() : super(false);

  void toggleVisibility() {
    print('called ');
    state = !state;
  }
}

final customMenuControllerProvider =
    StateNotifierProvider<CustomMenuController, bool>(
  (ref) => CustomMenuController(),
);
