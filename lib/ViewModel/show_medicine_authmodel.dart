import 'package:flutter/material.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/userMedicineModel/usermedicinemodel.dart';
import 'package:healthmvp/view/subscription/subscription.dart';

class ShowMedicineAuthmodel extends ChangeNotifier {
  bool showmedicines = false;
  GetUsersMedicineModel? getusermedicines;
  Future getallmedicineusers(BuildContext context) async {
    showmedicines = true;

    var response = await ApiManager().getnamesofusermedicine();
    if (response.isSuccessed!) {
      print("doneeeee");
      getusermedicines = response.data;
      print(getusermedicines?.data[0].name);
      showmedicines = false;
      //   Navigator.push(context, MaterialPageRoute(builder: (context)=> OtpScreen()));
      notifyListeners();
    } else {
      if (response.message ==
          "Your subscription has expired. Please upgrade to continue using the service.") {
        // Handle unauthorized access
        await Future.delayed(const Duration(seconds: 1));
        showDialog(
          context: context,

          builder: (ctx) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2563EB),
                      Color.fromARGB(255, 36, 75, 158),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_pharmacy,
                      size: 48,
                      color: Colors.white,
                    ), // Crown icon
                    const SizedBox(height: 16),
                    const Text(
                      "Subscription Expired",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Your subscription has ended. Subscribe now to continue enjoying full access to all premium features.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        showSubscriptionSheet(context);
                        // Navigator.pushNamed(context, '/subscription'); // Uncomment if needed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF9733EE),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Subscribe",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => AuthScreen()),
        // );
      }
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

  bool editmedicine = false;
  Future editmedicineee(
    BuildContext context,
    String medicineid,
    String dose,
    String category,
    String name,
  ) async {
    editmedicine = true;

    var response = await ApiManager().editmedicine(
      category: category,
      dose: dose,
      medicineid: medicineid,
      name: name,
    );
    if (response.isSuccessed!) {
      // print("doneeeee");
      //  getusermedicines=response.data;
      //  print(getusermedicines?.data[0].name);
      editmedicine = false;
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
