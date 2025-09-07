import 'package:flutter/material.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/dashboard/dashboard.dart';
import 'package:healthmvp/view/Auth/auth.dart';
import 'package:intl/intl.dart';

class DashboardViewmodel extends ChangeNotifier {
  bool isdashboardloading = false;
  DashboardData? dashboardata;
  String errorMessage = '';
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> getdashboarddata(BuildContext context) async {
    isdashboardloading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final response = await ApiManager().dashboardmedicinedata(date: date);

      if (response.isSuccessed == true) {
        dashboardata = response.data;
      } else {
        errorMessage = response.message ?? 'Failed to load dashboard data';
        if (response.message == "Not authorized to access this route") {
          // Handle unauthorized access
          await Future.delayed(const Duration(seconds: 1));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );
        }
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isdashboardloading = false;
      notifyListeners();
    }
  }

  void clearData() {
    dashboardata = null;
    notifyListeners();
  }
}
