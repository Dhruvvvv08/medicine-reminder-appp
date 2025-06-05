import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthmvp/data/response/api_manager.dart';
@pragma('vm:entry-point')
  markastakenapibackground(NotificationResponse response) async {
  if (response.actionId == 'take_action') {
    try {
      final reminderId = response.payload?.toString();
      print("📤 Calling markastakenapi with ID: $reminderId");
      var res = await ApiManager().markastaken(reminderid: reminderId);
    } catch (e) {
      print("❌ API error: $e");
    }
  }
}

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: markastakenapi,
      onDidReceiveBackgroundNotificationResponse: markastakenapibackground,
      
    );
  }

  static void showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm'),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'take_action',
          'Take',
          showsUserInterface: true,
          
        ),
      ],
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

   static markastakenapi(NotificationResponse response) async {
  if (response.actionId == 'take_action') {
    try {
      final reminderId = response.payload?.toString();
      print("📤 Calling markastakenapi with ID: $reminderId");
      var res = await ApiManager().markastaken(reminderid: reminderId);
    } catch (e) {
      print("❌ API error: $e");
    }
  }
}
}

