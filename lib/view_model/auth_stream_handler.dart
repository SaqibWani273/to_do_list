import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view/screens/auth_screen.dart';
import '../view/screens/dashboard_screen.dart';
import 'dart:developer';

class AuthStreamHandler extends StatelessWidget {
  const AuthStreamHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          Widget currentScreen;
          if (snapshot.hasData) {
            currentScreen = const DashboardScreen();
          } else {
            currentScreen = const AuthScreen();
          }

          log('waiting... => loading screen');
          return Stack(
            children: [
              currentScreen,
              const LoadingOverlay(),
            ],
          );

          // const Scaffold(
          //   body: Center(child: CircularProgressIndicator.adaptive()),
          // );
        }
        Widget nextScreen;
        if (snapshot.hasData) {
          nextScreen = const DashboardScreen();
        } else {
          nextScreen = const AuthScreen();
        }
        return FutureBuilder(
          future: Future.delayed(
            const Duration(seconds: 1),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return nextScreen;
            } else {
              return Stack(
                children: [
                  nextScreen,
                  const LoadingOverlay(),
                ],
              );

              // const Scaffold(
              //   body: Center(child: CircularProgressIndicator.adaptive()),
              // );
            }
          },
        );
      },
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return

        // Floating loading bar
        Positioned.fill(
      top: 0,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white,
                //      Theme.of(context).colorScheme.primary
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingOverlay1 extends StatelessWidget {
  const LoadingOverlay1({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[800]!.withOpacity(0.7),
              Colors.grey[600]!.withOpacity(0.5)
            ],
          ),
          //  filterBlur: FilterBlur.gaussianBlur(sigmaX: 5, sigmaY: 5),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white,
              // Theme.of(context).colorScheme.primary,
            )),
          ),
        ),
      ),
    );
  }
}
