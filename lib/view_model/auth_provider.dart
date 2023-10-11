import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthScreenVariables {
  isRegistered,
  isverifying,
  phoneNumber,
}

final Map<AuthScreenVariables, dynamic> authMap = {
  AuthScreenVariables.isRegistered: false,
  AuthScreenVariables.isverifying: false,
  AuthScreenVariables.phoneNumber: '',
};

class AuthNotifier extends StateNotifier<Map<AuthScreenVariables, dynamic>> {
  AuthNotifier() : super(authMap);
  void toggleIsRegistered() {
    final Map<AuthScreenVariables, dynamic> newState = {
      ...state,
      AuthScreenVariables.isRegistered: !state[AuthScreenVariables.isRegistered]
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
}

final authProvider =
    StateNotifierProvider<AuthNotifier, Map<AuthScreenVariables, dynamic>>(
        (ref) => AuthNotifier());
