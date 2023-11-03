import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/constants/firebase_files/firebase_options.dart';

import 'package:to_do_list/constants/other_constants.dart';
import 'package:to_do_list/constants/theme/custom_theme.dart';
import 'package:to_do_list/view/screens/on_board_screen.dart';

import 'view_model/my_app.dart';

Future<void> main() async {
  final showOnBoard = await asyncTasksHandler();

  runApp(showOnBoard ? const OnBoardScreen() : const AuthStreamHandler());
  FlutterNativeSplash.remove();
}

Future<bool> asyncTasksHandler() async {
  final sharedPref = await SharedPreferences.getInstance();
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//to change top status bar theme settings
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: ColorSchemes.primaryColorScheme.onPrimary,
    statusBarIconBrightness: Brightness.dark,
  ));

  //use sharedprefrence to check whether newdevice or not
  if (sharedPref.getBool(usedDevice) != null) {
    //do not show onboardScreen
    return false;
  }
//to check at firestore, maybe app might
//have been used before on this device ,
//then uninstalled or data cleared later
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late String? uinqueDeviceId;

  if (kIsWeb) {
    final webInfo = await deviceInfo.webBrowserInfo;
    // uinqueDeviceId = webInfo.userAgent;
  } else {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      uinqueDeviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      //handle ios  device more accurately later
      final iosInfo = await deviceInfo.iosInfo;
      uinqueDeviceId = iosInfo.identifierForVendor;
    }
  }
  //check if firestore collection contains this unique identifier
  final ref = FirebaseFirestore.instance.collection('Devices');
  final doc = await ref.doc(uinqueDeviceId).get();
  if (!doc.exists) {
    //device using app for first time
    sharedPref.setBool(userHasNoData, true);
    await ref.doc(uinqueDeviceId).set({'id': uinqueDeviceId});
    //true for showing onboardscreen
    return true;
  }
  //device has been used before
  return false;
}
