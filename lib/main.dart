import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/firebase_options.dart';
import 'package:to_do_list/screens/auth_screen.dart';

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
      home: AuthScreen(),
    ));
  }
}
