import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//error dialog
class ErrorDialog extends StatelessWidget {
  final String errorMessage;

  const ErrorDialog({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(errorMessage),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

//otpDialog
class OtpDialog extends StatefulWidget {
  final String verificationId;
  const OtpDialog({super.key, required this.verificationId});

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  final _codeController = TextEditingController();
  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enter SMS Code"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _codeController,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            "Done",
            style: TextStyle(
              backgroundColor: Colors.redAccent,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            FirebaseAuth auth = FirebaseAuth.instance;

            final smsCode = _codeController.text.trim();

            final _credential = PhoneAuthProvider.credential(
              verificationId: widget.verificationId,
              smsCode: smsCode,
            );

            auth.signInWithCredential(_credential);
          },
        )
      ],
    );
  }
}

//for showing error if phone verification failed
void showError({required BuildContext ctx, required String msg}) {
  final errorDialog = ErrorDialog(errorMessage: msg);

  showDialog(context: ctx, builder: (context1) => errorDialog);
}

//to let user enter otp
void showOtpDialog({required BuildContext ctx, required String vId}) {
  showDialog(
    context: ctx,
    builder: (context) => OtpDialog(verificationId: vId),
  );
}
