// ignore: unused_import
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/model/user_model.dart';

import '../constants/firestore_sqlite_consts.dart';

Future<UserModel?> getUserFromLocalDb(String userId) async {
  final db = await openDb('user.db');
//  await db!.delete('user', where: 'id = ?', whereArgs: [userId]);

  final tableExists = await db!.query(
    'sqlite_master',
    where: 'name = ?',
    whereArgs: ['user'],
  );
  if (tableExists.isEmpty) {
    return null;
  }
  final snapshot = await db.query('user', where: 'id = ?', whereArgs: [userId]);
  if (snapshot.isEmpty) {
    return null;
  }
  return UserModel.fromMap(snapshot.first);
}

Future<void> addUserToLocalDb(UserModel userModel) async {
  final db = await openDb('user.db');
  const createUserTableQuery = '''CREATE TABLE IF NOT EXISTS user(
    id TEXT PRIMARY KEY,
    name TEXT,
    email TEXT,
    profilePictureUrl TEXT,
    phone TEXT,
    imagePath TEXT
    )''';
  await db!.rawQuery(createUserTableQuery);

  await db.insert('user', userModel.toMap());
}

//...................Firestore.........

Future<void> addUserToFirestore(UserModel userModel) async {
  // fireStoreRef.doc(user.uid).set(user.toMap());

  await userProfileRef.set(userModel.toMap(), SetOptions(merge: true));
}

Future<Map<String, dynamic>?> getUserFromFirestore() async {
  final snapshot = await userProfileRef.get();
  return snapshot.data();
}
