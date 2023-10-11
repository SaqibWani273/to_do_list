import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/view/widgets/dialog.dart';

final _auth = FirebaseAuth.instance;
void registerUser(String phoneNumber, BuildContext context) async {
  await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      //[verificationCompleted] Triggered when an SMS is
      // auto-retrieved or the phone number has been instantly verified.
      verificationCompleted: (phoneAuthCredential) async {
        final userCredential =
            await _auth.signInWithCredential(phoneAuthCredential);
      },
      verificationFailed: (error) {
        showError(ctx: context, msg: error.code);
      },
      //if auto-code retreival doesnot work on a particular device
      codeSent: (verificationId, forceResendingToken) {
        showOtpDialog(ctx: context, vId: verificationId);
      },
      timeout: const Duration(seconds: 10),
      codeAutoRetrievalTimeout: (verificationId) {});
}

Future<String?> verifyOtp({
  required String smsCode,
  required WidgetRef ref,
  required String vId,
}) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  final credential = PhoneAuthProvider.credential(
    verificationId: vId,
    smsCode: smsCode,
  );
  try {
    await auth.signInWithCredential(credential);
    return null;
  } on FirebaseAuthException catch (e) {
    // AuthExceptionMapper.map(e.code);
    return e.code;
  } catch (e) {
    return 'unknown error occured !';
  }
}
