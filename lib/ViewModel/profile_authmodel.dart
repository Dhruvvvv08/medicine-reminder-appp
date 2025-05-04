import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/dashboard/dashboard.dart';
import 'package:healthmvp/models/profileModel/profilemodel.dart';

class ProfileAuthmodel extends ChangeNotifier {
  bool profileloading = false;
  ProfileModelData? profiledatamodel;
  Future getdashboarddata(BuildContext context) async {
    profileloading = true;
    notifyListeners();
    var response = await ApiManager().getprofileinfo();
    if (response.isSuccessed!) {
      print("doneeeee");
      profiledatamodel = response.data;
      print(profiledatamodel?.data.name);
      profileloading = false;
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
      profileloading = false;
      notifyListeners();
    }
  }
}
