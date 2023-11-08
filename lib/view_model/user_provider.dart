import 'dart:async';

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/shared_ref_consts.dart';
import '../model/user_model.dart';
import '../services/user_service.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;

class UserProvider extends StateNotifier<UserModel?> {
  UserProvider() : super(null);

  Future<void> addUserProfile(UserModel userModel) async {
    try {
      await addUserToLocalDb(userModel);
    } catch (err) {
      log('error in adding user profile to local db :err.toString()');
    }

    try {
      await addUserToFirestore(userModel);
    } catch (err) {
      log('error in adding user profile to firestore :err.toString()');
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

    final snapshotData = await getUserFromFirestore();

    //check if user has profile info in the collection or not
    final isUserProfileCreated =
        snapshotData != null && snapshotData.containsKey('profilePictureUrl');

    if (isUserProfileCreated) {
      state = UserModel.fromMap(snapshotData);
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
