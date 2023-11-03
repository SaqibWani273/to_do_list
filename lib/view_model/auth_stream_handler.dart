import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view/screens/auth_screen.dart';
import '../view/screens/dashboard_screen.dart';

class AuthStreamHandler extends StatelessWidget {
  const AuthStreamHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (snapshot.hasData) {
            return const DashboardScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
