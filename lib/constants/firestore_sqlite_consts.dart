import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart' as path;

final userId = FirebaseAuth.instance.currentUser!.uid;
final fireStoreRef = FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection('tasks');
final userProfileRef =
    FirebaseFirestore.instance.collection('users').doc(userId);

Future<sqflite.Database?> openDb(String dbName) async {
  //to get the appdirectory where the databases are stored

  final dbPath = await sqflite.getDatabasesPath();
  //here we open a specific database
  final db = await sqflite.openDatabase(
    path.join(dbPath, dbName),
  );
  return db;
}
