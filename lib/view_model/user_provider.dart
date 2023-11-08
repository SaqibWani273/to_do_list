import 'dart:async';

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart' as path;

import '../constants/other_constants.dart';
import '../model/user_model.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;
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

class UserProvider extends StateNotifier<UserModel?> {
  UserProvider() : super(null);

  Future<void> addUserProfile(UserModel userModel) async {
    try {
      await addUserToLocalDb(userModel);
    } catch (err) {
      log('error in adding user profile to local db :err.toString()');
    }

    try {
      await userProfileRef.set(userModel.toMap(), SetOptions(merge: true));
    } catch (err) {
      log('error in adding user profile :err.toString()');
    }

    state = userModel;
  }

  Future<void> setUserProfile() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userModelFromLocal = await getUserFromLocalDb(userId);
    if (userModelFromLocal != null) {
      state = userModelFromLocal;
      return;
    }

    //=>user data is null at local db
    final sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getBool(userHasNoData) != null &&
        sharedPref.getBool(userHasNoData) == true) {
      //=> user has no data
      return;
    }

    final snapshot = await userProfileRef.get();
    //check if user has profile info in the collection or not
    final isUserProfileCreated = snapshot.data() != null &&
        snapshot.data()!.containsKey('profilePictureUrl');

    if (isUserProfileCreated) {
      state = UserModel.fromMap(snapshot.data()!);
    } else {
      state = null;
    }
  }
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

  await db.insert('user', userModel.toMap(),
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
  log(' users table data = ${await db.rawQuery('SELECT * FROM user')}');
}

Future<UserModel?> getUserFromLocalDb(String userId) async {
  final db = await openDb('user.db');
  // await db!.delete('user', where: 'id = ?', whereArgs: [userId]);
  final snapshot =
      await db!.query('user', where: 'id = ?', whereArgs: [userId]);
  if (snapshot.isEmpty) {
    return null;
  }
  return UserModel.fromMap(snapshot.first);
}

final userProvider = StateNotifierProvider<UserProvider, UserModel?>((ref) {
  return UserProvider();
});
