import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/ViewModel/addmedicine_authmodel.dart';
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/view/Auth/emailwithotp.dart';
import 'package:healthmvp/view/Auth/login_screenn.dart';
import 'package:healthmvp/view/Auth/otp_screen.dart';
import 'package:healthmvp/view/Auth/signup_screen.dart';
import 'package:healthmvp/view/Auth/splash_screen.dart';
import 'package:healthmvp/view/bottom_nav_bar/bottom_nav.dart';
import 'package:healthmvp/view/home/Medicine/add_medicine.dart';
import 'package:healthmvp/view/home/Medicine/show_medicine.dart';
import 'package:healthmvp/view/onboarding/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:healthmvp/ViewModel/auth_viewmodel.dart';
import 'package:healthmvp/view/Auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPref.pref = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        
        ChangeNotifierProvider(create: (_) => AuthViewmodel()),
         ChangeNotifierProvider(create: (_) => AddmedicineAuthmodel())
        
        ],
     
      child:  MyApp(),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kf0f9ff),
      ),
      // home: const SignInScreen(),
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/bottomnavbar',
    routes: [
      GoRoute(
        path: '/splashscreen',
        builder: (context, state) =>  SplashScreen(),
      ),
      GoRoute(
        path: '/loginscreen',
        builder: (context, state) =>  SignInScreen(),
      ),
      GoRoute(
        path: '/signupscreen',
        builder: (context, state) =>  SignupScreen(),
      ),
      GoRoute(
        path: '/loginwithotp',
        builder: (context, state) =>  Emailwithotp(),
      ),
      GoRoute(
        path: '/otpscreen',
        builder: (context, route) =>  OtpScreen(),
      ),
      GoRoute(
        path: '/bottomnavbar',
        builder: (context, route) =>  Botoomnavbar(),
      ),
       GoRoute(
        path: '/addmedicine',
        builder: (context, route) =>  AddMedicine(),
      ),
       GoRoute(
        path: '/medicinescreen',
        builder: (context, route) =>  MedicineScreen(),
      ),
       GoRoute(
        path: '/onboardingscreen',
        builder: (context, route) =>  OnboardingScreen(),
      ),
    ],
  );
}
