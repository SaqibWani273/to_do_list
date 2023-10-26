import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user_model.dart';

final userRef = FirebaseFirestore.instance.collection('users');

class UserProvider extends StateNotifier<UserModel?> {
  UserProvider() : super(null);

  void setUser(UserModel userModel) {}
  Future<UserModel?> getUser() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await userRef.get();
    final isUserCreated = snapshot.docs.any((element) => element.id == userId);
    if (isUserCreated) {
      return UserModel.fromMap(snapshot.docs.first.data());
    }
    return null;
  }
}

final userProvider = StateNotifierProvider<UserProvider, UserModel?>((ref) {
  return UserProvider();
});
