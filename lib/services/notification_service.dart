import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotification {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        await _handleNotificationResponse(details);
      },
    );
  }

  static Future<void> _handleNotificationResponse(details) async {
    // await navigatorKey.currentState?.push(
    //   MaterialPageRoute(
    //     builder: (context) =>
    //     const DownloadScreen(), // Navigate to DownloadScreen
    //   ),
    // );
  }

  static Future showNotification(
      {required int id,
        required String title,
        required String body,
        required String payload}) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('CINLINE', 'PushNotificationAppChannel',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(id, title, body, notificationDetails, payload: payload);
  }

  Future scheduleNotification(
      {required int id,
        String? title,
        String? body,
        String? payLoad,
        required DateTime scheduledNotificationDateTime}) async {
    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails("CINLINE", "PushNotificationAppChannel",
        importance: Importance.max, priority: Priority.high);
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    return _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  void stopNotifications(
      int id,
      ) async {
    _flutterLocalNotificationsPlugin.cancel(id);
  }
}