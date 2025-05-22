import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/services/notification_helper.dart';

class FcmServices {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // This method sets up Firebase Cloud Messaging
  void setupFcm() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Request notification permission for iOS (important for iOS)
    await firebaseMessaging.requestPermission();

    // Get FCM token for device
    String? token = await firebaseMessaging.getToken();
    print("FCM Token: $token");
    bool success =
        await SharedPref.pref?.setString(
          Preferences.fcmtoken,
          token.toString(),
        ) ??
        false;
    print("Token saved: $success");

    // Listen to messages while app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Full FCM Notification Received:\n${message.toMap()}');

      if (message.notification != null) {
        NotificationHelper.showNotification(
          title: message.notification!.title ?? 'No Title',
          body: message.notification!.body ?? 'No Body',
          reminderId: message.data['reminderId'] ?? '',
        );
      }
    });

    // Handle when the user taps the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('User tapped notification: ${message.data}');
      // Handle app navigation or other actions on tapping the notification
    });
  }
}
