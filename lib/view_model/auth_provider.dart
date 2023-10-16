import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthScreenVariables {
  otpSent,
  isverifying,
  phoneNumber,
  verificationId,
}

final Map<AuthScreenVariables, dynamic> authMap = {
  AuthScreenVariables.otpSent: false,
  AuthScreenVariables.isverifying: false,
  AuthScreenVariables.phoneNumber: '',
  AuthScreenVariables.verificationId: '',
};

class AuthNotifier extends StateNotifier<Map<AuthScreenVariables, dynamic>> {
  AuthNotifier() : super(authMap);
  void toggleOtpSent() {
    final Map<AuthScreenVariables, dynamic> newState = {
      ...state,
      AuthScreenVariables.otpSent: !state[AuthScreenVariables.otpSent]
    };
    state = newState;
  }

  void toggleIsVerifying() {
    final Map<AuthScreenVariables, dynamic> newState = {
      ...state,
      AuthScreenVariables.isverifying: !state[AuthScreenVariables.isverifying],
    };
    state = newState;

    //
  }

  void setVerificationId(String vId) {
    final Map<AuthScreenVariables, dynamic> newState = {
      ...state,
      AuthScreenVariables.verificationId: vId,
    };
    state = newState;

    //
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, Map<AuthScreenVariables, dynamic>>(
        (ref) => AuthNotifier());
