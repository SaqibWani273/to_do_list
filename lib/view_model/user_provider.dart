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

  void addUserProfile(UserModel userModel) {
    userProfileRef
        .set(userModel.toMap(), SetOptions(merge: true))
        .then((value) => log('added new user'))
        .catchError((error, stackTrace) {
      log('error in adding user profile : ${error.toString()}');
    });
  }

  Future<UserModel?> getUserProfile() async {
    final snapshot = await userProfileRef.get();
    //check if user has profile info in the collection or not
    final isUserProfileCreated = snapshot.data() != null &&
        snapshot.data()!.containsKey('profilePictureUrl');

    if (isUserProfileCreated) {
      return UserModel.fromMap(snapshot.data()!);
    }
    return null;
  }
}

final userProvider = StateNotifierProvider<UserProvider, UserModel?>((ref) {
  return UserProvider();
});
