import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/Utils/textstyles.dart';
import 'package:healthmvp/ViewModel/auth_viewmodel.dart';
import 'package:healthmvp/view/Auth/auth.dart';
import 'package:healthmvp/view/Auth/login_screen.dart';
import 'package:healthmvp/view/Auth/login_screenn.dart';
import 'package:healthmvp/widgets/textformfield.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var _formkeyy = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provdier = Provider.of<AuthViewmodel>(context);
    return Scaffold(
      backgroundColor: Color(0xFF2563EB),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child:
            provdier.issignup == true
                ? Center(child: CircularProgressIndicator())
                : SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formkeyy,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // App Logo
                            Center(
                              child: Image.asset(
                                "images/HealthMVP Logo Mark PNG 1 .png",
                                height: 80,
                                width: 80,
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
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                        ),
                                        Text(
                                          "Create Account",
                                          style: u_30_500_k000000,
                                        ),
                                        TitledInputField(
                                          hintText: "Enter Full Name",
                                          backgroundColor: kf0f9ff,
                                          textEditingController:
                                              provdier.fullnamecontrollersignup,
                                          validators: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "This field is required";
                                            }
                                            return null;
                                          },
                                        ),

                                        TitledInputField(
                                          hintText: "Enter Email",
                                          backgroundColor: kf0f9ff,
                                          textEditingController:
                                              provdier.emailcontrollersignup,
                                          validators: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "This field is required";
                                            }
                                            return null;
                                          },
                                        ),

                                        TitledInputField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                              10,
                                            ),
                                          ],

                                          hintText: "Enter Phone Number",
                                          backgroundColor: kf0f9ff,
                                          textEditingController:
                                              provdier
                                                  .phonenumbercontrollersignup,
                                          validators: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "This field is required";
                                            }
                                            return null;
                                          },
                                        ),

                                        TitledInputField(
                                          hintText: "Enter Password",
                                          textEditingController:
                                              provdier
                                                  .passswordcontrollersignup,
                                          backgroundColor: kf0f9ff,
                                          isTextObscured:
                                              provdier.isTextObscured,
                                          validators: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "This field is required";
                                            } else if (value.length < 3) {
                                              return "Must be more than 2 characters";
                                            } else if (!RegExp(
                                              r'^(?=.*[A-Z])',
                                            ).hasMatch(value)) {
                                              return "Password must contain at least one uppercase letter";
                                            } else if (!RegExp(
                                              r'^(?=.*[@$&+,:;=?@#|<>.^*()%!-])',
                                            ).hasMatch(value)) {
                                              return "Password must contain at least one special character";
                                            } else if (!RegExp(
                                              r'^(?=.*\d)',
                                            ).hasMatch(value)) {
                                              return "Password must contain at least one number";
                                            }
                                            return null;
                                          },
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              setState(() {
                                                provdier.isTextObscured =
                                                    !provdier.isTextObscured;
                                              });
                                            },
                                            child: Icon(
                                              provdier.isTextObscured
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Color(0xff8e8e93),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 24),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 32.0,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (_formkeyy.currentState!
                                                  .validate()) {
                                                provdier.signup(context);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: k2563EB,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16.0,
                                                  ),
                                              textStyle: const TextStyle(
                                                fontSize: 18,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                              ),
                                            ),
                                            child: const SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                'Register',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 24),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Already have an account?',
                                              style: u_14_500_k000000,
                                            ),
                                            SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            AuthScreen(),
                                                  ),
                                                );
                                              },

                                              child: Text(
                                                'Log in',
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
