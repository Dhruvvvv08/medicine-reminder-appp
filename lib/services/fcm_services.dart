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
    // await firebaseMessaging.requestPermission();
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    String? apnsToken;
    int retry = 0;
    while (apnsToken == null && retry < 10) {
      apnsToken = await firebaseMessaging.getAPNSToken();
      if (apnsToken == null) {
        await Future.delayed(const Duration(seconds: 1));
        retry++;
      }
    }

    if (apnsToken == null) {
      print("❌ Failed to get APNs token after waiting.");
      return;
    }

    print("✅ APNs Token: $apnsToken");
    // Get FCM token for device
    String? token = await firebaseMessaging.getToken();
    print("FCM Token: $token");
    String? apnsTokennn = await firebaseMessaging.getAPNSToken();
    print("APNs Token: $apnsTokennn");
    String? apnsTokenn = await FirebaseMessaging.instance.getAPNSToken();
    print("APNS Token: $apnsTokenn");
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
