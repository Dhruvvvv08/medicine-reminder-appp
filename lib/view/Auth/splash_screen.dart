import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/view/Auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      context.go('/onboardingscreen');
    });
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
            color: k5d53ff,
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
}
