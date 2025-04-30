import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/Utils/textstyles.dart';
import 'package:healthmvp/ViewModel/auth_viewmodel.dart';
import 'package:healthmvp/view/Auth/signup_screen.dart';
import 'package:healthmvp/widgets/textformfield.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthViewmodel>(context);
    return Scaffold(
      backgroundColor: Color(0xFF2563EB),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App Logo
                    Center(
                      child: Image.asset(
                        "images/HealthMVP Logo Mark PNG 1 .png",
                        height: 150,
                        width: 150,
                      ),
                    ),
                    const SizedBox(height: 32),

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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Welcome Back", style: u_30_500_k000000),

                                TitledInputField(
                                  hintText: "Enter Email or Phone",
                                  backgroundColor: kf0f9ff,
                                  textEditingController:
                                      provider.usernamecontroller,
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
                                SizedBox(height: 12),
                                TitledInputField(
                                  hintText: "Enter Password",
                                  textEditingController:
                                      provider.passswordcontroller,
                                  backgroundColor: kf0f9ff,
                                  isTextObscured: provider.isTextObscured,
                                  validators: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required";
                                    } else if (value.length < 3) {
                                      return "Must be more than 2 characters";
                                    }
                                    // } else if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
                                    //   return "Password must contain at least one uppercase letter";
                                    // } else if (!RegExp(
                                    //   r'^(?=.*[@$&+,:;=?@#|<>.^*()%!-])',
                                    // ).hasMatch(value)) {
                                    //   return "Password must contain at least one special character";
                                    // } else if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
                                    //   return "Password must contain at least one number";
                                    // }
                                    return null;
                                  },
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        provider.isTextObscured =
                                            !provider.isTextObscured;
                                      });
                                    },
                                    child: Icon(
                                      provider.isTextObscured
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Color(0xff8e8e93),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      context.go('/loginwithotp');
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => Emailwithotp(),
                                      //   ),
                                      // );
                                    },
                                    child: Text(
                                      "Sign In With OTP",
                                      style: u_12_500_k2563EB,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: k2563EB,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        provider.loginn(context);
                                      }
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Divider(color: Colors.grey),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text(
                                        'Or Sign in With',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      child: Divider(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        //  final Uri url = Uri.parse('https://www.apple.com');
                                        // if (!await launchUrl(url)) {
                                        //   throw Exception('Could not launch $url');
                                        // }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xfff0f9fc),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: const Icon(
                                            Icons.g_mobiledata,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    InkWell(
                                      onTap: () async {
                                        final Uri url = Uri.parse(
                                          'https://www.apple.com',
                                        );
                                        // if (!await launchUrl(url)) {
                                        //   throw Exception('Could not launch $url');
                                        // }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xfff0f9fc),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: const Icon(
                                            Icons.apple,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account?",
                                      style: u_14_500_k000000,
                                    ),
                                    SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => SignupScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Register',
                                        style: u_14_500_k3a2aab,
                                      ),
                                    ),
                                  ],
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
        ),
      ),
    );
  }
}
