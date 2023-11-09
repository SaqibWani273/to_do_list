import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/view/widgets/dialog.dart';
import 'package:to_do_list/view_model/auth_provider.dart';

import '../view_model/country_provider.dart';

final _auth = FirebaseAuth.instance;
void registerUser(String phoneNumber, BuildContext context,
    {required WidgetRef ref}) async {
  await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      //[verificationCompleted] Triggered when an SMS is
      // auto-retrieved or the phone number has been instantly verified.
      verificationCompleted: (phoneAuthCredential) async {
        //to stop showing progress bar in ui
        ref.read(authProvider.notifier).toggleIsVerifying();

        await _auth.signInWithCredential(phoneAuthCredential);
      },
      verificationFailed: (error) {
        showError(ctx: context, msg: error.code);
      },
      //if auto-code retreival doesnot work on a particular device
      codeSent: (verificationId, forceResendingToken) {
        //   showOtpDialog(ctx: context, vId: verificationId);
        ref.read(authProvider.notifier).setVerificationId(verificationId);
        ref.read(authProvider.notifier).toggleOtpSent();
        //to stop showing progress bar in ui
        ref.read(authProvider.notifier).toggleIsVerifying();
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
    //to stop showing progress bar in ui
    ref.read(authProvider.notifier).toggleIsVerifying();
    await auth.signInWithCredential(credential);

    return null;
  } on FirebaseAuthException catch (e) {
    //  AuthExceptionMapper.map(e.code);
    return e.code;
  } catch (e) {
    return 'unknown error occured !';
  }
}

Future<void> submitForm({
  required Map authVariablesMap,
  required GlobalKey<FormState> formKey,
  required WidgetRef ref,
  required BuildContext context,
  required String phoneNumber,
  required String otp,
}) async {
  //if not receiving otp
  if (!authVariablesMap[AuthScreenVariables.isverifying]) {
    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        //to show progress bar in ui
        ref.read(authProvider.notifier).toggleIsVerifying();
        //whether to get otp or verify otp
        if (authVariablesMap[AuthScreenVariables.otpSent]) {
          //verifyOtp
          final String vId =
              authVariablesMap[AuthScreenVariables.verificationId];
          final errorMsg = await verifyOtp(smsCode: otp, ref: ref, vId: vId);
          if (errorMsg != null) {
            if (context.mounted) {
              showError(ctx: context, msg: errorMsg);
            }
          }
        } else {
          final countryCode = ref.watch(countryProvider).phoneCode;
          if (context.mounted) {
            registerUser("+$countryCode$phoneNumber", context, ref: ref);
          }
        }
      }
    }
  }
}
