// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Initialization
//   Future<void> initNotification() async {
//     tz.initializeTimeZones();

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await _notificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
//         // Handle notification response (for both iOS and Android)
//         final String? payload = notificationResponse.payload;
//         if (payload != null) {
//           print('Notification Payload: $payload');
//         }
//       },
//     );
//   }

//   // Notification Details
//   NotificationDetails _notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channelId',
//         'channelName',
//         channelDescription: 'This is the channel description',
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker',
//       ),
//       iOS: DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       ),
//     );
//   }

//   // Show Notification
//   Future<void> showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//   }) async {
//     await _notificationsPlugin.show(
//       id,
//       title,
//       body,
//       await _notificationDetails(),
//       payload: payload,
//     );
//   }

//   // Schedule Notification
//   Future<void> scheduleNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//     required DateTime scheduledNotificationDateTime,
//   }) async {
//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
//       await _notificationDetails(),
    
//       matchDateTimeComponents: DateTimeComponents.time, androidScheduleMode: ,
//     );
//   }
// }
