import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  // Initialize notifications and time zones
  static Future<void> init() async {
    // Initialize time zones first
    tz.initializeTimeZones();

    await _notification.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      ),
    );
  }

  // Schedule notification
  static Future<void> scheduleNotification(
    String title,
    String body,
    int userDayInput,
  ) async {
    var androidDetails = const AndroidNotificationDetails(
      "important_notification",
      "My Channel",
      importance: Importance.max,
      priority: Priority.high,
    );
    var notificationDetails = NotificationDetails(android: androidDetails);

    // Schedule the notification with a specific time zone
    await _notification.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: userDayInput)),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Cancel all notifications
  static cancelAllNotifications() {
    _notification.cancelAll();
  }
}
