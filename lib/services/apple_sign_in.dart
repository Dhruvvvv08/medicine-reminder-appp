import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/view/bottom_nav_bar/bottom_nav.dart';

Future<void> signInWithAppleAndCallBackend(BuildContext context) async {
  try {
    // Trigger the Apple Sign-In flow
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // Convert Apple credentials to a Firebase credential
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    // Sign in to Firebase
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    // Get Firebase ID Token
    final String? firebaseIdToken = await userCredential.user?.getIdToken();

    if (firebaseIdToken != null) {
      // ✅ Call your backend API now
      await loginWithApple(firebaseIdToken, context);
    }
  } catch (e) {
    print("Apple Sign In failed: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Apple Sign-In failed: $e")),
    );
  }
}

Future<void> loginWithApple(String firebaseIdToken, BuildContext context) async {
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
      print("Login saved: $logintrue");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Botoomnavbar(initialIndex: 0)),
      );
    } else {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  } catch (e) {
    print("Error calling backend: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed: $e')),
    );
  }
}
