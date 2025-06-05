// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:healthmvp/data/response/api_manager.dart';

// class NotificationHelper {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize(
//     Function(String reminderId) onActionTapped,
//   ) async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         print('🔔 Notification clicked!');
//         print('🆔 Action ID: ${response.actionId}');
//         print('📦 Payload: ${response.payload}');

//         final String? payload = response.payload;
//         if (payload != null) {
//           try {
//             final Map<String, dynamic> data = jsonDecode(payload);
//             final String reminderId = data['reminderId'];
//             print('🔎 Reminder ID from payload: $reminderId');

//             // Call UI callback
//             onActionTapped(reminderId);

//             // Call API
//             final bool success = await NotificationHelper().markastakenapi(
//               reminderId,
//             );
//             if (success) {
//               print('✅ Reminder marked as taken.');
//             } else {
//               print('❌ Failed to mark reminder as taken.');
//             }
//           } catch (e) {
//             print('❌ Error decoding payload or calling API: $e');
//           }
//         }
//       },
//     );
//   }

//   static Future<void> showNotification({
//     required String title,
//     required String body,
//     required String reminderId,
//   }) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'medicine_reminders',
//           'Medicine Reminders',
//           channelDescription: 'Notifications for medicine reminders',
//           importance: Importance.max,
//           priority: Priority.high,
//           sound: RawResourceAndroidNotificationSound('medicine'),
//           playSound: true,
//           enableVibration: true,
//           enableLights: true,
//           fullScreenIntent: true,
//           ledColor: Colors.blue,
//           ledOnMs: 1000,
//           ledOffMs: 500,
//           showWhen: true,
//           autoCancel: true,
//           actions: <AndroidNotificationAction>[
//             AndroidNotificationAction(
//               'TAKEN_ACTION',
//               'Taken',
//               showsUserInterface: true, // ✅ Required to trigger callback
//               cancelNotification: true,
//             ),
//           ],
//         );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//       payload: jsonEncode({"reminderId": reminderId}),
//     );
//   }

//   Future<bool> markastakenapi(String reminderId) async {
//     try {
//       print("📤 Calling markastakenapi with ID: $reminderId");
//       var res = await ApiManager().markastaken(reminderid: reminderId);
//       return res.isSuccessed ?? false;
//     } catch (e) {
//       print("❌ API error: $e");
//       return false;
//     }
//   }
// }
