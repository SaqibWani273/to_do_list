import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/widgets/dialog.dart';

final _auth = FirebaseAuth.instance;
void registerUser(String phoneNumber, BuildContext context) async {
  await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      //[verificationCompleted] Triggered when an SMS is
      // auto-retrieved or the phone number has been instantly verified.
      verificationCompleted: (phoneAuthCredential) async {
        print('verified phone');
        final userCredential =
            await _auth.signInWithCredential(phoneAuthCredential);
        print('signed in');
      },
      verificationFailed: (error) {
        showError(ctx: context, msg: error.code);
      },
      //if auto-code retreival doesnot work on a particular device
      codeSent: (verificationId, forceResendingToken) {
        showOtpDialog(ctx: context, vId: verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        print('timeout for auto code retreival');
      },
      timeout: Duration(seconds: 120));
}
