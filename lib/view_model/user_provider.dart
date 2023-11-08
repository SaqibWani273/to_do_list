import 'dart:async';

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/shared_ref_consts.dart';
import '../model/user_model.dart';
import '../services/user_service.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;

class UserProvider extends StateNotifier<UserModel?> {
  UserProvider() : super(null);

  Future<void> addUserProfile(UserModel userModel) async {
    try {
      await addUserToLocalDb(userModel);
    } on DatabaseException catch (err) {
      log('Db error while adding user profile to local db :$err');
    } catch (err) {
      log('error in adding user profile to local db :${err.toString()}');
    }

    try {
      addUserToFirestore(userModel);
    } catch (err) {
      log('error in adding user profile to firestore :${err.toString()}');
    }

    state = userModel;
  }

  Future<void> updateUserProfile(UserModel userModel) async {
    try {
      await updateUserAtLocalDb(userModel);
    } on DatabaseException catch (err) {
      log('Db error while updating user profile at local db :$err');
    } catch (err) {
      log('error in updating user profile at local db :${err.toString()}');
    }
    try {
      updateUserAtFirestore(userModel);
    } catch (err) {
      log('error in updating user profile at firestore :${err.toString()}');
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

    if (await SharedRef().noUserData) {
      //if true => user didnot add any profile info or has deleted account
      return;
    }
    log('user uninstalled app or cleared app data');
//gets executed only  when app is uninstalled or app data is cleared
    final snapshotData = await getUserFromFirestore();

    //check if user has profile info in the collection or not
    final isUserProfileCreated =
        snapshotData != null && snapshotData.containsKey('profilePictureUrl');

    if (isUserProfileCreated) {
//to do : store user data locally now

      final userData = UserModel.fromMap(snapshotData);
//Add new imagePath and keep rest as it is
      try {
        final newImagePath = await setNewPath(userData.imagePath!);
        userData.imagePath = newImagePath;
        await addUserToLocalDb(userData);
      } catch (err) {
        log('error in adding user profile data from firestore to local db : ${err.toString()}......');
        return;
      }
      state = userData;
    } else {
      state = null;
    }
  }
  //at the time of adding delete user
  //to do: update userHasProfile to true in sharedPref
}

final userProvider = StateNotifierProvider<UserProvider, UserModel?>((ref) {
  return UserProvider();
});
