import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/view/screens/on_board_screen.dart';
import 'package:to_do_list/view_model/auth_stream_handler.dart';

import '../../constants/other_constants.dart';

enum InternetResult {
  noInternet,
  oldUser,
  newUSer,
}

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    Future<InternetResult> checkIdAtFirestore() async {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet) {
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
        //check if firestore collection contains this unique identifier

        final ref = FirebaseFirestore.instance.collection('Devices');
        final doc = await ref.doc(uinqueDeviceId).get();
        if (!doc.exists) {
          //device using app for first time
          final sharedPref = await SharedPreferences.getInstance();
          sharedPref.setBool(userHasNoData, true);
          await ref.doc(uinqueDeviceId).set({'id': uinqueDeviceId});
          //for showing onboardscreen
          return InternetResult.newUSer;
        }
        //device has been used before
        //for not showing onboardscreen
        return InternetResult.oldUser;
      }
      //=>no internet
      return InternetResult.noInternet;
    }

    return Scaffold(
        body: FutureBuilder(
            future: checkIdAtFirestore(),
            builder: (context, AsyncSnapshot<InternetResult> snapshot) {
              // if (!snapshot.hasData) {
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }
              if (snapshot.data == InternetResult.noInternet) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.signal_wifi_connected_no_internet_4_sharp,
                        size: 60,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text('No Internet Connection'),
                      const SizedBox(
                        height: 50,
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {});
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.blue.withOpacity(0.4)),
                          ),
                          child: const Text('Retry'))
                    ],
                  ),
                );
              }
              if (snapshot.data == InternetResult.newUSer) {
                return const OnBoardScreen();
              }
              if (snapshot.data == InternetResult.oldUser) {
                return const AuthStreamHandler();
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
