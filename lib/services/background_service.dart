// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'socket_service.dart';  // your existing file
// import 'package:healthmvp/data/services/shared_pref_service.dart';

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//   WidgetsFlutterBinding.ensureInitialized();

//   SharedPref.pref = await SharedPreferences.getInstance();
//   final socketService = SocketService();
//   socketService.initializeSocket();

//   Timer.periodic(const Duration(minutes: 1), (timer) async {
//     if (service is AndroidServiceInstance &&
//         await service.isForegroundService()) {
//       service.setForegroundNotificationInfo(
//         title: 'Socket.IO Service',
//         content: socketService.isConnected()
//             ? 'Connected to server'
//             : 'Reconnecting...',
//       );
//     }

//     if (!socketService.isConnected()) {
//       socketService.reconnect();
//     }

//     socketService.emitEvent('heartbeat', {
//       'timestamp': DateTime.now().toIso8601String(),
//     });

//     service.invoke('update_status', {
//       'connected': socketService.isConnected(),
//       'timestamp': DateTime.now().toIso8601String(),
//     });
//   });
// }

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();

//   SharedPref.pref = await SharedPreferences.getInstance();
//   final socketService = SocketService();
//   socketService.initializeSocket();

//   return true;
// }

// Future<void> initializeBackgroundService() async {
//   final service = FlutterBackgroundService();

//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'socket_channel',
//     'Socket Background Service',
//     description: 'Keeps the socket connection alive',
//     importance: Importance.low,
//   );

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       autoStart: true,
//       isForegroundMode: true,
//       notificationChannelId: 'socket_channel',
//       initialNotificationTitle: 'Socket.IO Service',
//       initialNotificationContent: 'Connecting to server...',
//       foregroundServiceNotificationId: 999,
//     ),
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//       onForeground: onStart,
//       onBackground: onIosBackground,
//     ),
//   );

//   await service.startService();
// }
