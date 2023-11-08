import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/constants/shared_ref_consts.dart';

import '../constants/firestore_sqlite_consts.dart';
import '../model/task.dart';

Future<List<Task>?> tasksListFromLocal() async {
  final db = await openDb('todo.db');
  List<Task>? tasksList;
  final tableExists = await db!.query(
    'sqlite_master',
    where: 'name = ?',
    whereArgs: ['Tasks_List'],
  );

  if (tableExists.isNotEmpty) {
    final dataInTable = await db.query('Tasks_List');
    tasksList = dataInTable.map((e) => Task.fromMap(e)).toList();
    //to recognize device as used
    SharedRef().recognizeDevice();
  }
  return tasksList;
}

Future<void> addToLocalDb(Task newTask) async {
  //the query to create a table for storing tasks
  const createQuery = '''Create table IF NOT EXISTS Tasks_List(id  TEXT,
       taskName TEXT,
       description TEXT,
      taskDate int,
      taskTime int,
       taskPriority TEXT,
       taskCategory TEXT,
        isCompleted INTEGER)''';

  final db = await openDb('todo.db');
  db!.execute(createQuery);

  //now insert the data into table
  await db.insert(
    'Tasks_List',
    newTask.toMap(),
  );
  final dataInTable = await db.query('Tasks_List');
  log('local database data= ${dataInTable.toString()}');
}

Future<void> deleteAtLocalDb(String id) async {
  final db = await openDb('todo.db');
  await db!.delete('Tasks_List', where: 'id = ?', whereArgs: [id]);
  final tableData = await db.query('Tasks_List');
  if (tableData.isEmpty) {
    SharedRef().setNoTasksData();
    log('empty in local db');
  }
}

Future<void> editFromLocalDb(Task editedTask) async {
  final db = await openDb('todo.db');

  await db!.update(
    'Tasks_List',
    editedTask.toMap(),
    where: 'id = ?',
    whereArgs: [editedTask.id],
  );
}

Future<void> toggleIsCompleteStatusAtLocalDb(Task task) async {
  final db = await openDb('todo.db');
  //query to update data in sqflite database
  await db!.update(
    'Tasks_List',
    {'isCompleted': task.isCompleted ? 0 : 1},
    where: 'id = ?',
    whereArgs: [task.id],
  );
}
//............................FireStore Operations.........................

//do not use await as it will wait for the task to be added to firestore
//before updating state and for that internet connection is required

Future<void> toggleIsCompleteStatusAtFireStore(Task task) async {
  fireStoreRef.doc(task.id).update({'isCompleted': task.isCompleted ? 0 : 1});
}

void editAtFirestore(Task editedTask) async {
  // fireStoreRef
  //     .doc(editedTask.id)
  //     .update(editedTask.toMap());

  fireStoreRef
      .doc(editedTask.id)
      .set(editedTask.toMap(), SetOptions(merge: true));
}

deleteAtFireStore(String id) async {
  fireStoreRef.doc(id).delete();
}

addToFireStore(Task newTask) async {
  fireStoreRef.doc(newTask.id).set(newTask.toMap());
}

// use await as it will be called only when user uninstalls or clears data

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
      log("error in task.fromMap = ${e.toString()}, data = ${e.runtimeType}");
    }
    return task;
  }).toList();
  return tasksList;
}
