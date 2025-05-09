import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/ViewModel/addmedicine_authmodel.dart';
import 'package:healthmvp/ViewModel/dashboard_viewmodel.dart';
import 'package:healthmvp/ViewModel/profile_authmodel.dart';
import 'package:healthmvp/ViewModel/reminder_authviewmodel.dart';
import 'package:healthmvp/ViewModel/show_medicine_authmodel.dart';
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/demo.dart';
import 'package:healthmvp/get_data.dart';
import 'package:healthmvp/providerdemo.dart';
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
import 'package:healthmvp/view/Auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'services/notification_service.dart';
import 'package:healthmvp/view/notification/notification_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:healthmvp/services/socket_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // Initialize SharedPreferences
  SharedPref.pref = await SharedPreferences.getInstance();

  // Request notification permission
  final status = await Permission.notification.request();
  print('Notification permission status: $status');

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Initialize Socket.IO service
  final socketService = SocketService();
  socketService.initializeSocket();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardViewmodel()),
        ChangeNotifierProvider(create: (_) => AuthViewmodel()),
        ChangeNotifierProvider(create: (_) => AddmedicineAuthmodel()),
        ChangeNotifierProvider(create: (_) => ReminderAuthviewmodel()),
        ChangeNotifierProvider(create: (_) => ShowMedicineAuthmodel()),
        ChangeNotifierProvider(create: (_) => ProfileAuthmodel()),
        //    ChangeNotifierProvider(create: (_) => Providerdemo()),
        Provider<SocketService>.value(value: socketService),
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
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: kf0f9ff)),
      // home: const SignInScreen(),
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/splashscreen',
    routes: [
      GoRoute(path: '/auth', builder: (context, state) => AuthScreen()),
      GoRoute(
        path: '/splashscreen',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/loginscreen',
        builder: (context, state) => SignInScreen(),
      ),
      GoRoute(
        path: '/signupscreen',
        builder: (context, state) => SignupScreen(),
      ),
      GoRoute(
        path: '/loginwithotp',
        builder: (context, state) => Emailwithotp(),
      ),
      GoRoute(path: '/otpscreen', builder: (context, route) => OtpScreen()),
      GoRoute(
        path: '/bottomnavbar',
        builder: (context, route) => Botoomnavbar(),
      ),
      GoRoute(path: '/addmedicine', builder: (context, route) => AddMedicine()),
      GoRoute(
        path: '/medicinescreen',
        builder: (context, route) => MedicineScreen(),
      ),
      GoRoute(
        path: '/onboardingscreen',
        builder: (context, route) => OnboardingScreen(),
      ),
      GoRoute(path: '/getdata', builder: (context, route) => Getdata()),
      //    GoRoute(
      //   path: '/notificationdemo',
      //   builder: (context, route) => NotificationButton(),
      // ),
      // GoRoute(
      //   path: '/notificationscreen',
      //   builder: (context, route) => const NotificationScreen(),
      // ),
      GoRoute(
        path: '/dashboardscreen',
        builder: (context, route) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/createreminder',
        builder: (context, route) => const AddMedicine(),
      ),
      GoRoute(
        path: '/demooooooo',
        builder: (context, route) => const Demoooo(),
      ),
    ],
  );
}
