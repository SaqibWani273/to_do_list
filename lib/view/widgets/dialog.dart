import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/view_model/auth_provider.dart';

//error dialog
class ErrorDialog extends ConsumerWidget {
  final String errorMessage;

  const ErrorDialog({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(errorMessage),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            ref.read(authProvider.notifier).toggleIsVerifying();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

// //otpDialog
// class OtpDialog extends ConsumerStatefulWidget {
//   final String verificationId;
//   const OtpDialog({super.key, required this.verificationId});

//   @override
//   ConsumerState<OtpDialog> createState() => _OtpDialogState();
// }

// class _OtpDialogState extends ConsumerState<OtpDialog> {
//   final _codeController = TextEditingController();
//   @override
//   void dispose() {
//     _codeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context1) {
//     return AlertDialog(
//       title: const Text("Enter SMS Code"),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           TextField(
//             controller: _codeController,
//           ),
//         ],
//       ),
//       actions: <Widget>[
//         TextButton(
//           child: Container(
//             width: 100,
//             height: 40,
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.circular(
//                   20), // Adjust the radius for rounded corners
//             ),
//             child: const Center(
//               child: Text(
//                 "Enter",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20, // Adjust the font size
//                 ),
//               ),
//             ),
//           ),
//           onPressed: () async {
//             final errorMsg = await verifyOtp(
//                 smsCode: _codeController.text.trim(),
//                 ref: ref,
//                 vId: widget.verificationId);
//             if (mounted) {
//               Navigator.pop(context1);
//             }
//             if (errorMsg != null) {
//               if (mounted) {
//                 showError(ctx: context1, msg: errorMsg);
//               }
//             }
//           },
//         )
//       ],
//     );
//   }
// }

//for showing any kind of error with a simple error message
void showError({required BuildContext ctx, required String msg}) {
  final errorDialog = ErrorDialog(errorMessage: msg);

  showDialog(
    context: ctx,
    builder: (_) => errorDialog,
    barrierDismissible: false,
  );
}

// //to let user enter otp
// void showOtpDialog({required BuildContext ctx, required String vId}) {
//   ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
//       content: Text('Remember this 6-digit otp for signing in later !')));
//   showDialog(
//     context: ctx,
//     barrierDismissible: false,
//     builder: (_) => OtpDialog(verificationId: vId),
//   );
// }
