import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/theme/custom_theme.dart';
import '../view/screens/auth_screen.dart';
import '../view/screens/dashboard_screen.dart';
import '../view/screens/onboard/on_board_screen.dart';

class MyApp extends StatelessWidget {
  final bool showOnBoard;
  const MyApp({super.key, required this.showOnBoard});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: showOnBoard
                ? const OnBoardScreen()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.userChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(
                              child: CircularProgressIndicator.adaptive()),
                        );
                      }
                      if (snapshot.hasData) {
                        return DashboardScreen();
                      }
                      return const AuthScreen();
                    },
                  )));
  }
}
