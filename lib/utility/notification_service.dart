import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    //initialize and pass image for notification, which should be at
    //android\app\src\main\res\drawable\

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('splash_img');

    final initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      //to do : handle notification click
    });
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          '123456789qwermn', //channel id
          'chan222nelName9812', //channel name
          importance: Importance.max,
        ),
        iOS: DarwinNotificationDetails());
  }

  Future<void> showNotification({
    int id = 121111,
    String? title,
    String? body = "i M  body",
    String? payload,
  }) async {
    log(" id : $id , title : $title , body : $body , payload : $payload");

    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  Future<void> scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime}) async {
    log('dateTimeReceived=$scheduledNotificationDateTime');
    log('dateTime =${DateTime.now().add(const Duration(seconds: 20))}');
    final dateTime = DateTime.now().add(Duration(seconds: 120));
    await AndroidFlutterLocalNotificationsPlugin()
        .requestExactAlarmsPermission();
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    tz.initializeTimeZones();

    await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
        //  tz.TZDateTime.now(tz.local).add(const Duration(seconds: 100),),
        // TZDateTime.from(scheduledNotificationDateTime, local),
        await notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
