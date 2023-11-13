import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/constants/firebase_files/firebase_options.dart';

import 'package:to_do_list/constants/theme/custom_theme.dart';
import 'package:to_do_list/utility/notification_service.dart';
import 'package:to_do_list/view/screens/no_internet_screen.dart';
import 'package:to_do_list/view/screens/on_board_screen.dart';

import 'constants/shared_ref_consts.dart';
import 'view_model/auth_stream_handler.dart';

Future<void> main() async {
  try {
    bool? showOnBoard = await asyncTasksHandler();
    runApp(ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: showOnBoard == null
            ? const NoInternetScreen()
            : showOnBoard
                ? const OnBoardScreen()
                : const AuthStreamHandler(),
      ),
    ));
  } catch (e) {
    log('error occurred in main : ${e.toString()}');
  }

  FlutterNativeSplash.remove();
}

Future<bool?> asyncTasksHandler() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//to change top status bar theme settings
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: ColorSchemes.primaryColorScheme.onPrimary,
    statusBarIconBrightness: Brightness.dark,
  ));
  final sharedPref = await SharedPreferences.getInstance();
  //use sharedprefrence to check whether newdevice or not
  if (sharedPref.getBool(usedDevice) != null) {
    //do not show onboardScreen

    return false;
  }

  await NotificationService().initNotification();

//to check at firestore, maybe app might
//have been used before on this device ,
//then uninstalled or data cleared later
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late String? uinqueDeviceId;

  if (kIsWeb) {
    //handle for web later
    final webInfo = await deviceInfo.webBrowserInfo;
    uinqueDeviceId = webInfo.userAgent;
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
  //check if user has internet connection
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.ethernet ||
      connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    //probabbly has internet
    //check if firestore collection contains this unique identifier
    final ref = FirebaseFirestore.instance.collection('Devices');
    final doc = await ref.doc(uinqueDeviceId).get();
    if (!doc.exists) {
      //device using app for first time
      sharedPref.setBool(userHasNoTasksData, true);
      await ref.doc(uinqueDeviceId).set({'id': uinqueDeviceId});
      //true for showing onboardscreen
      return true;
    }
    //device has been used before
    //false for not showing onboardscreen
    return false;
  }
  return null;
}
