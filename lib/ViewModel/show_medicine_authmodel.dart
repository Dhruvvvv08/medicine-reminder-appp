import 'package:flutter/material.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/userMedicineModel/usermedicinemodel.dart';

class ShowMedicineAuthmodel  extends ChangeNotifier{
  bool showmedicines=false;
   GetUsersMedicineModel ?getusermedicines;
  Future getallmedicineusers(BuildContext context) async {
    showmedicines = true;


    var response = await ApiManager().getnamesofusermedicine(

    );
    if (response.isSuccessed!) {
      print("doneeeee");
     getusermedicines=response.data;
     print(getusermedicines?.data[0].name);
      showmedicines = false;
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