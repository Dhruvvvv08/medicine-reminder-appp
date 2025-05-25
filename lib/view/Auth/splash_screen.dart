import 'dart:async';

import 'package:flutter/material.dart';

import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/view/Auth/auth.dart';
import 'package:healthmvp/view/Auth/login_screen.dart';
import 'package:healthmvp/view/bottom_nav_bar/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    wheretogo();
    // Timer(Duration(seconds: 3), () {

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2563EB),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,

            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Image.asset(
                  'images/HealthMVP Primary Logo (Color Var. 1) PNG.png',
                ),
              ),

              // Image.asset('assets/images/SplashScreen.png'),
            ),
          ),

          // Positioned(
          //     child: Image.asset('assets/images/UpperVector.png'),
          //   top: -0,
          // right: 0,
          //   left: 50),
          // Positioned(child:
          //     Image.asset('assets/images/LowerVector.png'),
          //   bottom: 0)
        ],
      ),
    );
  }

  void wheretogo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool weatherloggedin = prefs.getBool(Preferences.login) ?? false;
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        if (weatherloggedin == null || !weatherloggedin) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => AuthScreen()),
          // );
        } else {
          print("Is logged in: $weatherloggedin");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Botoomnavbar()),
          );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => Botoomnavbar()),
          // );
        }
      }
    });
  }
}
