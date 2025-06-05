import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:healthmvp/data/services/notifications_service.dart';
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/services/notification_helper.dart';
import 'package:healthmvp/services/notification_helper_sound.dart';

class FcmServices {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void setupFcm() async {
    await Firebase.initializeApp();
    // Request notification permission for iOS (important for iOS)
    // await firebaseMessaging.requestPermission();
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    // String? apnsToken;
    // int retry = 0;
    // while (apnsToken == null && retry < 10) {
    //   apnsToken = await firebaseMessaging.getAPNSToken();
    //   if (apnsToken == null) {
    //     await Future.delayed(const Duration(seconds: 1));
    //     retry++;
    //   }
    // }

    // if (apnsToken == null) {
    //   print("❌ Failed to get APNs token after waiting.");
    //   return;
    // }

    // print("✅ APNs Token: $apnsToken");
    // Get FCM token for device
    String? token = await firebaseMessaging.getToken();
    print("FCM Token: $token");
    bool success =
        await SharedPref.pref?.setString(
          Preferences.fcmtoken,
          token.toString(),
        ) ??
        false;
    //  print("💾 Token saved in SharedPreferences: $saved");

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Received FCM Message: ${message.toMap()}');
       if (message.notification != null) {
    NotificationHelper.showNotification(
      
      title: message.notification?.title ?? "No Title",
      body: message.notification?.body ?? "No Body",
      payload: message.data['reminderId'] ?? "default",
    );
  }

      // if (message.notification != null) {
      //   NotificationHelper.showNotification(
      //     title: message.notification!.title ?? 'No Title',
      //     body: message.notification!.body ?? 'No Body',
      //     reminderId: message.data['reminderId'] ?? '',
      //   );
      // }
    });

    // When user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 Notification tapped: ${message.data}');
      // Handle navigation or other logic
    });
  }
}
