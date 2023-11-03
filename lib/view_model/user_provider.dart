import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user_model.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;
final userProfileRef =
    FirebaseFirestore.instance.collection('users').doc(userId);

class UserProvider extends StateNotifier<UserModel?> {
  UserProvider() : super(null);

  Future<void> addUserProfile(UserModel userModel) async {
    try {
      await userProfileRef.set(userModel.toMap(), SetOptions(merge: true));
    } catch (err) {
      log('error in adding user profile :err.toString()');
    }

    state = userModel;
  }

  Future<void> setUserProfile() async {
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

final userProvider = StateNotifierProvider<UserProvider, UserModel?>((ref) {
  return UserProvider();
});
