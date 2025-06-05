// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:healthmvp/data/response/api_manager.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:permission_handler/permission_handler.dart';

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   static const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'medicine_reminders',
//     'Medicine Reminders',
//     description: 'Notifications for medicine reminders',
//     importance: Importance.max,
//     playSound: true,
//     enableVibration: true,
//     enableLights: true,
//     ledColor: Colors.blue,
//   );

//   static const AndroidNotificationDetails androidDetails =
//       AndroidNotificationDetails(
//         'medicine_reminders',
//         'Medicine Reminders',
//         channelDescription: 'Notifications for medicine reminders',
//         importance: Importance.max,
//         priority: Priority.high,
//         playSound: true,
//         enableVibration: true,
//         enableLights: true,
//         sound: RawResourceAndroidNotificationSound('medicine'),
//         fullScreenIntent: true,
//         ledColor: Colors.blue,
//         ledOnMs: 1000,
//         ledOffMs: 500,
//         showWhen: true,
//         autoCancel: true,
//         actions: <AndroidNotificationAction>[
//           AndroidNotificationAction(
//             'TAKEN_ACTION', // Action ID
//             'Taken', // Button label
//             showsUserInterface: true,
//             cancelNotification: true,
//           ),
//         ],
//       );

//   static const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//     presentAlert: true,
//     presentBadge: true,
//     presentSound: true,
//   );

//   static const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidDetails, iOS: iosDetails);

//   Future<bool> requestPermissions() async {
//     print('🔔 Requesting notification permissions...');
//     final status = await Permission.notification.request();
//     print('📱 Notification permission status: $status');

//     if (status.isGranted) {
//       if (await Permission.scheduleExactAlarm.shouldShowRequestRationale) {
//         final alarmStatus = await Permission.scheduleExactAlarm.request();
//         print('⏰ Exact alarm permission status: $alarmStatus');
//         return alarmStatus.isGranted;
//       }
//       return true;
//     }
//     return false;
//   }

//   Future<void> initialize() async {
//     try {
//       print('🔔 Initializing notification service...');
//       tz.initializeTimeZones();

//       final hasPermission = await requestPermissions();
//       if (!hasPermission) {
//         print('❌ Notification permissions not granted');
//         return;
//       }

//       final androidImplementation =
//           _notifications
//               .resolvePlatformSpecificImplementation<
//                 AndroidFlutterLocalNotificationsPlugin
//               >();

//       if (androidImplementation != null) {
//         print('🤖 Setting up Android notifications...');
//         await androidImplementation.requestPermission();
//         await androidImplementation.createNotificationChannel(channel);
//         print('✅ Android notification channel created');
//       }

//       const androidSettings = AndroidInitializationSettings(
//         '@mipmap/ic_launcher',
//       );
//       const iosSettings = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//       );

//       const initSettings = InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       );

//       await _notifications.initialize(
//         initSettings,
//         onDidReceiveNotificationResponse: (
//           NotificationResponse response,
//         ) async {
//           final data = jsonDecode(response.payload.toString());
//           final reminderId = data['reminderId'];
//           print('👆 Notification tapped: $reminderId');
//           if (response.actionId == 'TAKEN_ACTION') {
//             print('💊 "Taken" button pressed');
//             await markastakenapi(reminderId.toString());
//           }
//         },
//       );

//       print('✅ Notification service initialized successfully');
//     } catch (e, stackTrace) {
//       print('❌ Error initializing notification service: $e');
//       print('Stack trace: $stackTrace');
//       rethrow;
//     }
//   }

//   Future<void> scheduleMedicineReminders({
//     required String medicineName,
//     required DateTime startDate,
//     required DateTime endDate,
//     required List<TimeOfDay> times,
//   }) async {
//     try {
//       // Check permissions before scheduling
//       final hasPermission = await requestPermissions();
//       if (!hasPermission) {
//         print('Cannot schedule notifications: permissions not granted');
//         throw Exception('Notification permissions not granted');
//       }

//       final now = DateTime.now();
//       print('Current time: $now');

//       final days = endDate.difference(startDate).inDays + 1;
//       print(
//         'Scheduling notifications for $days days with ${times.length} times per day',
//       );

//       for (int i = 0; i < days; i++) {
//         final currentDate = startDate.add(Duration(days: i));

//         for (int j = 0; j < times.length; j++) {
//           final time = times[j];

//           // Schedule the 30-minute warning notification
//           final warningTime = DateTime(
//             currentDate.year,
//             currentDate.month,
//             currentDate.day,
//             time.hour,
//             time.minute - 30,
//           );

//           // Schedule the actual medicine time notification
//           final medicineTime = DateTime(
//             currentDate.year,
//             currentDate.month,
//             currentDate.day,
//             time.hour,
//             time.minute,
//           );

//           print('Day ${i + 1}, Time slot ${j + 1}:');
//           print('Warning time: $warningTime');
//           print('Medicine time: $medicineTime');

//           final warningId = (i * times.length * 2) + (j * 2);
//           final medicineId = warningId + 1;

//           if (warningTime.isAfter(now)) {
//             await _scheduleNotification(
//               id: warningId,
//               title: 'Medicine Reminder',
//               body: '30 minutes left to take $medicineName',
//               scheduledDate: warningTime,
//             );
//           }

//           if (medicineTime.isAfter(now)) {
//             await _scheduleNotification(
//               id: medicineId,
//               title: 'Medicine Time',
//               body: 'Time to take $medicineName',
//               scheduledDate: medicineTime,
//             );
//           }
//         }
//       }
//     } catch (e) {
//       print('Error scheduling medicine reminders: $e');
//       rethrow;
//     }
//   }

//   Future<void> _scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//   }) async {
//     try {
//       final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

//       if (tzDateTime.isAfter(tz.TZDateTime.now(tz.local))) {
//         print('Scheduling notification:');
//         print('ID: $id');
//         print('Title: $title');
//         print('Body: $body');
//         print('Scheduled time: $tzDateTime');

//         await _notifications.zonedSchedule(
//           id,
//           title,
//           body,
//           tzDateTime,
//           platformChannelSpecifics,
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//           uiLocalNotificationDateInterpretation:
//               UILocalNotificationDateInterpretation.absoluteTime,
//         );

//         print('Notification scheduled successfully');
//       }
//     } catch (e) {
//       print('Error scheduling notification: $e');
//       rethrow;
//     }
//   }

//   Future<void> showNotificationNow({
//     required String title,
//     required String body,
//     String? payload,
//     String? reminderid,
//   }) async {
//     try {
//       print('🔔 Attempting to show notification:');
//       print('  - Title: $title');
//       print('  - Body: $body');
//       print('  - Payload: $payload');

//       final hasPermission = await requestPermissions();
//       if (!hasPermission) {
//         print('❌ Cannot show notification: permissions not granted');
//         throw Exception('Notification permissions not granted');
//       }

//       final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       print('📝 Generated notification ID: $notificationId');

//       await _notifications.show(
//         notificationId,
//         title,
//         body,
//         platformChannelSpecifics,
//         payload: reminderid,
//       );

//       print('✅ Notification shown successfully');
//     } catch (e, stackTrace) {
//       print('❌ Error showing notification: $e');
//       print('Stack trace: $stackTrace');
//       rethrow;
//     }
//   }

//   Future<void> cancelAllNotifications() async {
//     print('🧹 Cancelling all notifications...');
//     await _notifications.cancelAll();
//     print('✅ All notifications cancelled');
//   }

//   Future<bool> markastakenapi(String reminderid) async {
//     try {
//       var res = await ApiManager().markastaken(reminderid: reminderid);

//       if (res.isSuccessed!) {
//         return true; // Return success status
//       } else {
//         // if (res.message != null) {
//         //   ScaffoldMessenger.of(context).showSnackBar(
//         //     SnackBar(content: Text(res.message!)),
//         //   );
//         // }
//         // markastaken = false;
//         // notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       // markastaken = false;
//       // notifyListeners();
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(content: Text('Error: $e')),
//       // );
//       return false;
//     }
//   }
// }
