import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/constants/firebase_files/firebase_options.dart';

import 'package:to_do_list/constants/theme/custom_theme.dart';
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
//............................FCM...............
  final notificationSetting =
      await FirebaseMessaging.instance.requestPermission(provisional: true);
  // if (notificationSetting.authorizationStatus !=
  //     AuthorizationStatus.authorized) {
  //   return null;
  // }
  log('is notification enabled ? : ${notificationSetting.authorizationStatus}');
  final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  log('apns token : $apnsToken');
  final fcmToken = await FirebaseMessaging.instance.getToken();

  log('fcm token : $fcmToken');

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    // TODO: If necessary send token to application server.

    // Note: This callback is fired at each app startup and whenever a new
    // token is generated.
  }).onError((err) {
    log('err getting refreshToken : ${err}');
  });
//.................................FCM.........................

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
