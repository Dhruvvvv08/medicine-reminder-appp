import 'package:flutter/material.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/HomeModel/AddMedicine/MedicineName.dart';

class AddmedicineAuthmodel extends ChangeNotifier{
  bool getmedicine=false;
  MedicneNameModel ?medicinemodel;
  Future getallmedicine(BuildContext context) async {
    getmedicine = true;


    var response = await ApiManager().getnamesofmedicine(

    );
    if (response.isSuccessed!) {
      print("doneeeee");
     medicinemodel=response.data;
     print(medicinemodel?.data[0].name??"");
      getmedicine = false;
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
      notifyListeners();
    }
  }
}