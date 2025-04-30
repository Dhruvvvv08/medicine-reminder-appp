import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/Utils/textstyles.dart';
import 'package:healthmvp/ViewModel/auth_viewmodel.dart';
import 'package:healthmvp/view/Auth/otp_screen.dart';
import 'package:healthmvp/view/Auth/signup_screen.dart';
import 'package:healthmvp/widgets/textformfield.dart';
import 'package:provider/provider.dart';

class Emailwithotp extends StatefulWidget {
  const Emailwithotp({super.key});

  @override
  State<Emailwithotp> createState() => _EmailwithotpState();
}

class _EmailwithotpState extends State<Emailwithotp> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthViewmodel>(context);
    return Scaffold(
      backgroundColor: Color(0xFF2563EB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        context.go('/auth');
                      },
                    ),
                  ],
                ),
                // App Logo
                Center(
                  child: Image.asset(
                    "images/HealthMVP Logo Mark PNG 1 .png",
                    height: 150,
                    width: 150,
                  ),
                ),
                const SizedBox(height: 120),

                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TitledInputField(
                              title: "Email",
                              hintText: "Enter Email",
                              backgroundColor: kf0f9ff,
                              textEditingController: provider.loginwithotp,
                              validators: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field is required";
                                } else if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                ).hasMatch(value)) {
                                  return "Please enter a valid email address";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 27),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: () {
                                  provider.getotp(context);
                                },
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//  Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back_ios),
//                       onPressed: () {
//                         context.go('/auth');
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(50),
//                     child: Image.asset('images/healthmvp.jpeg'),
//                   ),
//                 ),
//                 Center(child: Text('Login With OTP', style: u_24_800_k000000)),
//                 const SizedBox(height: 12),
//                 Center(
//                   child: Text(
//                     'Sign in to access your account and stay connected to',
//                     style: u_14_500_k1890FF,
//                   ),
//                 ),
//                 Center(
//                   child: Text('your health journey.', style: u_14_500_k1890FF),
//                 ),

//                 const SizedBox(height: 60),

//                 TitledInputField(
//                   title: "Email",
//                   hintText: "Enter Email",
//                   backgroundColor: kf0f9ff,
//                   textEditingController: provider.loginwithotp,
//                   validators: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "This field is required";
//                     } else if (!RegExp(
//                       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//                     ).hasMatch(value)) {
//                       return "Please enter a valid email address";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 27),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF525CEB),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                     ),
//                     onPressed: () {
//                       provider.getotp(context);
//                     },
//                     child: const Text('Submit', style: TextStyle(fontSize: 16)),
//                   ),
//                 ),
//               ],
//             ),
