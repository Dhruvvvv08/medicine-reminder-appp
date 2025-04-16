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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                    context.go('/loginscreen');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                 Center(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Image.asset(
                      'images/healthmvp.jpeg',
                
                ),
              ),
            ),
               Center(child: Text('Login With OTP', style: u_24_800_k000000)),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Sign in to access your account and stay connected to',
                      style: u_12_500_kkc0c0c0,
                    ),
                  ),
                  Center(
                    child: Text(
                      'your health journey.',
                      style: u_12_500_kkc0c0c0,
                    ),
                  ),

                const SizedBox(height: 60),

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
                      backgroundColor: const Color(0xFF525CEB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                     provider.getotp(context);
                    },
                    child: const Text('Submit', style: TextStyle(fontSize: 16)),
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
