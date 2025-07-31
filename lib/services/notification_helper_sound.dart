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

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

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
    required String type, // Add type as a parameter
  }) async {
    List<AndroidNotificationAction> actions = [];

    if (type == 'reminder') {
      actions.add(
        AndroidNotificationAction(
          'take_action',
          'Take',
          showsUserInterface: true,
        ),
      );
    }
    final androidPlatformChannelSpecifics =
        type == 'reminder'
            ? AndroidNotificationDetails(
              'high_importance_channel', // channel id
              'High Importance Notifications', // name
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              sound: RawResourceAndroidNotificationSound('alarm'),
              actions: actions,
            )
            : AndroidNotificationDetails(
              'high_importance', // channel id
              'High Importance', // name
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              // No sound field means system default
              actions: actions,
            );
    // final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    //   'high_importance_channel',
    //   'High Importance Notifications',
    //   importance: Importance.max,
    //   priority: Priority.high,
    //   playSound: true,
    //   sound:
    //       type == 'reminder'
    //           ? RawResourceAndroidNotificationSound('alarm') // custom sound
    //           : null,
    //   actions: actions,
    // );

    final platformChannelSpecifics = NotificationDetails(
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
