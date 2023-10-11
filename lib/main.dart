import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/firebase_files/firebase_options.dart';

import 'package:to_do_list/view/screens/home_screen.dart';

import 'view/screens/auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp(
            theme: ThemeData(
              // Set the primary color.
              primaryColor: Color.fromARGB(255, 150, 100, 255),

              // Keep the colors lighter.
              brightness: Brightness.light,
            ),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator.adaptive()),
                  );
                }
                if (snapshot.hasData) {
                  return HomeScreen();
                }
                return AuthScreen();
              },
            )));
  }
}
