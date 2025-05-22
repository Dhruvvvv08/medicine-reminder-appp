import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize(Function(String reminderId) onActionTapped) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.actionId == 'TAKEN_ACTION') {
          final String? payload = response.payload;
          if (payload != null) {
            try {
              final Map<String, dynamic> data = jsonDecode(payload);
              final String reminderId = data['reminderId'];
              onActionTapped(reminderId);
            } catch (e) {
              print('Invalid payload: $e');
            }
          }
        }
      },
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    required String reminderId,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'medicine_reminders',
      'Medicine Reminders',
      channelDescription: 'Notifications for medicine reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ledColor: Colors.blue,
      ledOnMs: 1000,
      ledOffMs: 500,
      showWhen: true,
      autoCancel: true,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'TAKEN_ACTION',
          'Taken',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      ],
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: jsonEncode({"reminderId": reminderId}),
    );
  }

  static Future<void> callApiOnTaken(String reminderId) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-api.com/mark-medicine-taken'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"reminderId": reminderId}),
      );

      if (response.statusCode == 200) {
        print('Success: Reminder $reminderId marked as taken.');
      } else {
        print('Failed to mark reminder $reminderId: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error for reminder $reminderId: $e');
    }
  }
}
