import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/constants/firebase_files/firebase_options.dart';
import 'package:to_do_list/constants/theme/custom_theme.dart';

import 'package:to_do_list/view/screens/dashboard_screen.dart';

import 'view/screens/auth_screen.dart';
import 'view/screens/onboard/onBoardScreen1.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//to change top status bar theme settings
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: ColorSchemes.primaryColorScheme.onPrimary,
    statusBarIconBrightness: Brightness.dark,
  ));

  //use sharedprefrence to check whether newuser or not
  bool isNewUser = false;
  // FlutterNativeSplash.remove();

  runApp(
    MyApp(isNewUser: isNewUser),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final bool isNewUser;
  const MyApp({super.key, required this.isNewUser});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: isNewUser
                ? const onBoardScreen1()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.userChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Scaffold(
                          body: Center(
                              child: CircularProgressIndicator.adaptive()),
                        );
                      }
                      if (snapshot.hasData) {
                        return DashboardScreen();
                      }
                      return AuthScreen();
                    },
                  )));
  }
}
