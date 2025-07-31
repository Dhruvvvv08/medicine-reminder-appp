import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:flutter/material.dart';
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/view/bottom_nav_bar/bottom_nav.dart';

Future<void> signInWithGoogleAndCallBackend(BuildContext context) async {
  try {
    // Trigger Google Sign-In
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      print('User canceled the login');
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);

    final String? firebaseIdToken = await userCredential.user?.getIdToken();

    if (firebaseIdToken != null) {
      // ✅ Call your backend API now
      await loginn(firebaseIdToken, context);
    }
  } catch (e) {
    print('Error during Google Sign-In: $e');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Google Sign-In failed: $e')));
  }
}

Future<void> loginn(String firebaseIdToken, BuildContext context) async {
  String fcmtoken = SharedPref.pref!.getString(Preferences.fcmtoken) ?? "";
  try {
    var response = await ApiManager().googlesignin(
      body: {"fcmToken": fcmtoken, "idToken": firebaseIdToken},
    );

    if (response.isSuccessed!) {
      String token = response.data!.data.token.toString();
      print(token);
      bool success =
          await SharedPref.pref?.setString(Preferences.token, token) ?? false;
      print("Token saved: $success");
      bool logintrue = await SharedPref.pref!.setBool(Preferences.login, true);
      print(logintrue);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Botoomnavbar(initialIndex: 0)),
      );
    } else {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      firebaseIdToken = '';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something Went Wrong')));
    }
  } catch (e) {
    print('Error calling backend: $e');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
  }
}
