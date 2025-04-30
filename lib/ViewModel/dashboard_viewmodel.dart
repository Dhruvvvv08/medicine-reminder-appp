import 'package:flutter/material.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/dashboard/dashboard.dart';
import 'package:intl/intl.dart';

class DashboardViewmodel extends ChangeNotifier {
  bool isdashboardloading = false;
  DashboardData? dashboardata;
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  Future getdashboarddata(BuildContext context) async {
    isdashboardloading = true;

    var response = await ApiManager().dashboardmedicinedata(
      date : date,

    );
    if (response.isSuccessed!) {
      print("doneeeee");
      dashboardata = response.data;
      print(dashboardata?.data.mostTakenMedicines);
      isdashboardloading = false;
      //   Navigator.push(context, MaterialPageRoute(builder: (context)=> OtpScreen()));
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message.toString()),
          // icon: const Icon(Icons.refresh),
          duration: const Duration(seconds: 3),
        ),
      );
        isdashboardloading = false;
      notifyListeners();
    }
  }
}
