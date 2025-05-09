import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/models/AuthModel/login_model.dart';
import 'package:healthmvp/view/Auth/auth.dart';
import 'package:healthmvp/view/Auth/login_screen.dart';
import 'package:healthmvp/view/Auth/login_screenn.dart';
import 'package:healthmvp/view/Auth/otp_screen.dart';
import 'package:healthmvp/view/bottom_nav_bar/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewmodel extends ChangeNotifier {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passswordcontroller = TextEditingController();
  TextEditingController loginwithotp = TextEditingController();
  bool isotploading = false;
  bool isTextObscured = false;
  bool loginstatus = false;
  bool islogin = false;
  bool resendotp = false;
  bool isresendenable = false;
  int counter = 30;
  Timer? _resendTimer;

  void resendotppp() {
    isresendenable = false;
    counter = 30;

    _resendTimer?.cancel(); // Cancel any existing timer

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter > 0) {
        counter--;
      } else {
        isresendenable = true;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  LoginModel? loginmodel;

  Future loginn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    islogin = true;

    notifyListeners();

    var response = await ApiManager().loginapi(
      usernamecontroller.text,
      passswordcontroller.text,
    );

    if (response.isSuccessed!) {
      loginmodel = response.data;
      String token = response.data!.data.token.toString();
      print(token);
      bool success =
          await SharedPref.pref?.setString(Preferences.token, token) ?? false;
      print("Token saved: $success");

      String id = response.data!.data.id.toString();
      print(id);
      bool sucessid =
          await SharedPref.pref?.setString(Preferences.id, id) ?? false;
      print("id saved: $sucessid");
      //prefs.setString(Preferences.token,token);
      //  print("${ SharedPref.pref?.setString(Preferences.token, token)}");
      islogin = false;

      context.go('/bottomnavbar');
      notifyListeners();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${response.message}')));
      islogin = false;
      notifyListeners();
    }
  }

  bool getotploading = false;
  String InputOtp = '';
  void submitotp(BuildContext context) {
    if (InputOtp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a Valid OTP'),
          // icon: const Icon(Icons.refresh),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future getotp(BuildContext context) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    getotploading = true;
    notifyListeners();

    var response = await ApiManager().loginwithotp(email: loginwithotp.text);
    if (response.isSuccessed!) {
      print(loginwithotp.text.toString());
      print("doneeeee");
      String userid = response.data!.data.userId.toString();
      print(userid);
      bool success =
          await SharedPref.pref?.setString(Preferences.userid, userid) ?? false;
      print("Token saved: $success");
      //   otpModel.value = response.data;
      // token.value=response.data!.data.token;
      // print("tokennnnnnnnn${token}");
      // // prefs.setString(Preferences.token, token.value);
      // // print("${prefs.setString(Preferences.token, token.value)}");

      //       Get.to(OtpScreen());
      getotploading = false;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpScreen()),
      );
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message.toString()),
          // icon: const Icon(Icons.refresh),
          duration: const Duration(seconds: 3),
        ),
      );
      notifyListeners();
    }
  }

  Future verifyotp(BuildContext context) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = SharedPref.pref!.getString(Preferences.id) ?? "";
    getotploading = true;
    notifyListeners();

    var response = await ApiManager().verifyotp(
      otp: InputOtp,
      userid: '${userId}',
    );
    if (response.isSuccessed!) {
      print(loginwithotp.text.toString());
      print("doneeeee");
      //   otpModel.value = response.data;
      // token.value=response.data!.data.token;
      // print("tokennnnnnnnn${token}");
      // // prefs.setString(Preferences.token, token.value);
      // // print("${prefs.setString(Preferences.token, token.value)}");

      //       Get.to(OtpScreen());
      getotploading = false;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Botoomnavbar()),
      );
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message.toString()),
          // icon: const Icon(Icons.refresh),
          duration: const Duration(seconds: 3),
        ),
      );
      notifyListeners();
    }
  }

  //      Sign up Logic
  bool issignup = false;
  final TextEditingController fullnamecontrollersignup =
      TextEditingController();
  final TextEditingController emailcontrollersignup = TextEditingController();
  final TextEditingController passswordcontrollersignup =
      TextEditingController();
  final TextEditingController confirmpasswordcontrollersignup =
      TextEditingController();
  final TextEditingController phonenumbercontrollersignup =
      TextEditingController();

  Future signup(BuildContext context) async {
    issignup = true;
    notifyListeners();

    var response = await ApiManager().signupapi(
      body: {
        "name": fullnamecontrollersignup.text,
        "email": emailcontrollersignup.text,
        "password": passswordcontrollersignup.text,
        "phone": "+91${phonenumbercontrollersignup.text}",
      },
    );
    if (response.isSuccessed!) {
      print("doneeeee");

      getotploading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User Registered Sucessfully"),
          // icon: const Icon(Icons.refresh),
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
      );
      issignup = false;
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message.toString()),
          // icon: const Icon(Icons.refresh),
          duration: const Duration(seconds: 3),
        ),
      );
      issignup = false;
      notifyListeners();
    }
  }
}
