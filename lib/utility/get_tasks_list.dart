import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/task.dart';

final fireStoreRef = FirebaseFirestore.instance.collection('tasks');
Future<List<Task>?> getTasksList() async {
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
