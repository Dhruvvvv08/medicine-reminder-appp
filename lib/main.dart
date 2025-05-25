import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/ViewModel/addmedicine_authmodel.dart';
import 'package:healthmvp/ViewModel/dashboard_viewmodel.dart';
import 'package:healthmvp/ViewModel/dependent_autmodel.dart';
import 'package:healthmvp/ViewModel/profile_authmodel.dart';
import 'package:healthmvp/ViewModel/reminder_authviewmodel.dart';
import 'package:healthmvp/ViewModel/show_medicine_authmodel.dart';
import 'package:healthmvp/ViewModel/subscription_model_authview.dart';
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/demo.dart';
import 'package:healthmvp/firebase_options.dart';
import 'package:healthmvp/get_data.dart';
import 'package:healthmvp/services/background_service.dart';
import 'package:healthmvp/services/fcm_services.dart';
import 'package:healthmvp/services/notification_helper.dart';
import 'package:healthmvp/view/Auth/auth.dart';
import 'package:healthmvp/view/Auth/emailwithotp.dart';
import 'package:healthmvp/view/Auth/login_screenn.dart';
import 'package:healthmvp/view/Auth/otp_screen.dart';
import 'package:healthmvp/view/Auth/signup_screen.dart';
import 'package:healthmvp/view/Auth/splash_screen.dart';
import 'package:healthmvp/view/bottom_nav_bar/bottom_nav.dart';
import 'package:healthmvp/view/home/Dashbaord/dashboard.dart';
import 'package:healthmvp/view/home/Medicine/add_medicine.dart';
import 'package:healthmvp/view/home/Medicine/show_medicine.dart';
import 'package:healthmvp/view/onboarding/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:healthmvp/ViewModel/auth_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
//import 'services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:healthmvp/services/socket_service.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(); // Required to handle background messages
//   print("Handling background message: ${message.messageId}");
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // Initialize SharedPreferences
  SharedPref.pref = await SharedPreferences.getInstance();
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Request notification permission
  final status = await Permission.notification.request();
  print('Notification permission status: $status');

  // Initialize notification service
  await NotificationHelper.initialize((reminderId) {
    print("🧠 You tapped on reminder: $reminderId");
    // Optional: navigate or update state
  });

  // Create Socket.IO service instance without initializing
  // final socketService = SocketService();
  SharedPref.pref = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final fcmservice = FcmServices();
  fcmservice.setupFcm();
  // await initializeBackgroundService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardViewmodel()),
        ChangeNotifierProvider(create: (_) => AuthViewmodel()),
        ChangeNotifierProvider(create: (_) => AddmedicineAuthmodel()),
        ChangeNotifierProvider(create: (_) => ReminderAuthviewmodel()),
        ChangeNotifierProvider(create: (_) => ShowMedicineAuthmodel()),
        ChangeNotifierProvider(create: (_) => ProfileAuthmodel()),
        ChangeNotifierProvider(create: (_) => DependentAutmodel()),
        ChangeNotifierProvider(create: (_) => SubscriptionModelAuthview()),
        //    ChangeNotifierProvider(create: (_) => Providerdemo()),
        // Provider<SocketService>.value(value: socketService),
      ],
      child: MyApp(),
    ),
  );
}

// final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: kf0f9ff)),
      home: const SplashScreen(),
    );
  }
}
