import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/models/profileModel/profilemodel.dart';
import 'package:healthmvp/models/dependent/dependent_model.dart';
import 'package:healthmvp/view/Auth/auth.dart';

class ProfileAuthmodel extends ChangeNotifier {
  bool profileloading = false;
  bool linkdependent = false;
  bool dependentloading = false;
  bool islogout = false;

  ProfileModelData? profiledatamodel;
  DepedentDashboardDataModel? dependentdashboard;
  String? dependentid;

  Future<void> getdashboarddata(BuildContext context) async {
    profileloading = true;
    notifyListeners();

    try {
      final response = await ApiManager().getprofileinfo();
      if (response.isSuccessed == true) {
        profiledatamodel = response.data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Failed to load profile"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading profile: $e"),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      profileloading = false;
      notifyListeners();
    }
  }

  Future<void> linkdependentapi(
    BuildContext context,
    Map<String, dynamic> body,
  ) async {
    linkdependent = true;
    notifyListeners();

    try {
      final response = await ApiManager().linkdependent(body: body);
      if (response.isSuccessed == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Dependent linked successfully"),
            duration: const Duration(seconds: 3),
          ),
        );
        await getdashboarddata(context); // Refresh profile data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Failed to link dependent"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error linking dependent: $e"),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      linkdependent = false;
      notifyListeners();
    }
  }

  Future<void> getdependentdashboard(
    BuildContext context,
    String date,
    String dependentid,
  ) async {
    dependentloading = true;
    notifyListeners();

    try {
      final res = await ApiManager().getdependentdashboard(
        date: date,
        dependentid: dependentid,
      );

      if (res.isSuccessed == true) {
        dependentdashboard = res.data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.message ?? "Failed to load dependent dashboard"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading dependent dashboard: $e"),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      dependentloading = false;
      notifyListeners();
    }
  }

  Future<void> logoutstatus(BuildContext context) async {
    islogout = true;
    notifyListeners();

    try {
      final response = await ApiManager().logout();
      if (response.isSuccessed == true) {
        SharedPref.pref!.setBool(Preferences.login, false);
        SharedPref.pref!.remove(Preferences.token);
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Failed to logout"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error during logout: $e"),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      islogout = false;
      notifyListeners();
    }
  }
}
