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
  void toggleIsRegistered(bool val) {
    state[AuthScreenVariables.isRegistered] = !val;
    print(state.toString());
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, Map<AuthScreenVariables, dynamic>>(
        (ref) => AuthNotifier());
