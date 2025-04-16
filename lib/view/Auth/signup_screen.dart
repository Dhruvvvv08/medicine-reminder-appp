import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/textstyles.dart';
import 'package:healthmvp/ViewModel/auth_viewmodel.dart';
import 'package:healthmvp/widgets/textformfield.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
var  _formkeyy=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provdier =Provider.of<AuthViewmodel>(context);
    return Form(
      key: _formkeyy,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F8),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
       
            padding: const EdgeInsets.only(top: 16.0, left: 16.0,right: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 16.0,right: 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                              context.go('/loginscreen');
                          },
                        ),
                      ],
                    ),
                  ),
                 
                  const SizedBox(height: 16),
                  const Text(
                    'Create Your Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      'Never miss a dose again! Sign up now to manage your medications and stay on top of your health journey.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TitledInputField(
                        
                        title: "Full Name",
                        hintText: "Enter Full Name",
                        backgroundColor: Colors.transparent,
                        textEditingController: provdier.fullnamecontrollersignup,
                        validators: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is required";
                          }
                          return null;
                        },
                      ),
                  const SizedBox(height: 16),
                  TitledInputField(
                        
                        title: "Email",
                        hintText: "Enter Email",
                        backgroundColor: Colors.transparent,
                        textEditingController: provdier.emailcontrollersignup,
                        validators: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is required";
                          }
                          return null;
                        },
                      ),
                   const SizedBox(height: 16),
                    TitledInputField(
                        
                        title: "Phone Number",
                        hintText: "Enter Phone Number",
                        backgroundColor: Colors.transparent,
                        textEditingController: provdier.phonenumbercontrollersignup,
                        validators: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is required";
                          }
                          return null;
                        },
                      ),
                  const SizedBox(height: 16),
                 TitledInputField(
                      title: "Password",
                      hintText: "Enter Password",
                      textEditingController: provdier.passswordcontrollersignup,
                      backgroundColor: Colors.transparent,
                      isTextObscured: provdier.isTextObscured,
                      validators: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        } else if (value.length < 3) {
                          return "Must be more than 2 characters";
                        } else if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
                          return "Password must contain at least one uppercase letter";
                        } else if (!RegExp(
                          r'^(?=.*[@$&+,:;=?@#|<>.^*()%!-])',
                        ).hasMatch(value)) {
                          return "Password must contain at least one special character";
                        } else if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
                          return "Password must contain at least one number";
                        }
                        return null;
                      },
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            provdier.isTextObscured = !provdier.isTextObscured;
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
                  const SizedBox(height: 16),
                   TitledInputField(
                      title: "Confirm Password",
                      hintText: "Enter Confirm Password",
                      textEditingController: provdier.confirmpasswordcontrollersignup,
                      backgroundColor: Colors.transparent,
                      isTextObscured: provdier.isTextObscured,
                      validators: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        } else if(value!=provdier.passswordcontroller.text){
                           return "Password do not match";
                        }
                        return null;
                      },
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            provdier.isTextObscured = !provdier.isTextObscured;
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
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formkeyy.currentState!.validate()){
                            provdier.signup(context); 
                        }
                       
                      },
                      style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF525CEB),
                       foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
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
                  const SizedBox(height: 24),
                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: Divider(color: Colors.grey)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Or',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.grey)),
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
                          decoration: BoxDecoration(color: Color(0xfff0f9fc)),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.login, size: 25),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () async {
                          final Uri url = Uri.parse('https://www.apple.com');
                          // if (!await launchUrl(url)) {
                          //   throw Exception('Could not launch $url');
                          // }
                        },
                        child: Container(
                          decoration: BoxDecoration(color: Color(0xfff0f9fc)),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.apple, size: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // IconButton(
                      //   icon: Image.network(
                      //     'https://img.icons8.com/color/50/000000/google-logo.png',
                      //     width: 30,
                      //   ),
                      //   onPressed: () {},
                      // ),
                      // IconButton(
                      //   icon: Image.network(
                      //     'https://img.icons8.com/color/50/000000/facebook-new.png',
                      //     width: 30,
                      //   ),
                      //   onPressed: () {},
                      // ),
                      // IconButton(
                      //   icon: Image.network(
                      //     'https://img.icons8.com/ios-filled/50/000000/apple-logo.png',
                      //     width: 30,
                      //   ),
                      //   onPressed: () {},
                      // ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        'Already have an account?',
                        style:   u_14_500_k000000,
                      ),
                      TextButton(
                        onPressed: () {},
                        child:  Text(
                          'Log in',
                          style: u_14_500_k3a2aab
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
    );
  }
}