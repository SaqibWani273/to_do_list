// ignore: unused_import
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
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
    id TEXT,
    name TEXT,
    email TEXT,
    profilePictureUrl TEXT,
    phone TEXT,
    imagePath TEXT
    )''';
  await db!.rawQuery(createUserTableQuery);

  await db.insert('user', userModel.toMap());
}

Future<void> updateUserAtLocalDb(UserModel userModel) async {
  final db = await openDb('user.db');
  await db!.update(
    'user',
    userModel.toMap(),
    where: 'id = ?',
    whereArgs: [userModel.id],
  );
}

Future<void> deleteUserAtLocalDb() async {
  final db = await openDb('user.db');
  await db!.delete(
    'user',
    where: 'id = ?',
    whereArgs: [userId],
  );
}

//...................Firestore.........

Future<void> addUserToFirestore(UserModel userModel) async {
  // fireStoreRef.doc(user.uid).set(user.toMap());

  await userProfileRef.set(userModel.toMap(), SetOptions(merge: true));
}

updateUserAtFirestore(UserModel userModel) async {
  // await userProfileRef.set(userModel.toMap(), SetOptions(merge: true));
  userProfileRef.update(userModel.toMap());
}

Future<Map<String, dynamic>?> getUserFromFirestore() async {
  final snapshot = await userProfileRef.get();
  return snapshot.data();
}

Future<void> deleteUserAtFirestore(UserModel userModel) async {
  await userProfileRef.delete();
  //delete user profile image from firebase storage
  final storageRef = FirebaseStorage.instance.ref();
  final destination = 'profilePics/$userId';

  final fileName = path.basename(userModel.imagePath!);

  await storageRef.child('$destination/$fileName').delete();
  await storageRef.child(destination).delete();
}

//to store user's profile info in local db from firestore after user reinstalls app
Future<String> setNewPath(String oldPath) async {
  //get new local path
  final appDirectory = await path_provider.getApplicationDocumentsDirectory();
  //to get filename

  final fileName = path.basename(oldPath);
  //create new file
  final newLocalImage = File('${appDirectory.path}/$fileName');

//add file data from firebasestorage to local file
  final storageRef = FirebaseStorage.instance.ref();
  final destination = 'profilePics/$userId/$fileName';

  await storageRef.child(destination).writeToFile(File(newLocalImage.path));

  return newLocalImage.path;
}
