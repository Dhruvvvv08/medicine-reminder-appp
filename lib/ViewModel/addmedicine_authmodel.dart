import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/HomeModel/AddMedicine/MedicineName.dart';
import 'package:healthmvp/models/userMedicineModel/submitaddmedicinemodel.dart';
import 'package:healthmvp/services/notification_service.dart';

class AddmedicineAuthmodel extends ChangeNotifier {
  bool getmedicine = false;
  String? type;
  final TextEditingController medicinenamecontroller = TextEditingController();
  final TextEditingController notecontroller = TextEditingController();
  final TextEditingController dosecontroller = TextEditingController();
  String? frequencyy;
  List<TimeOfDay?> selectedTimes = [];
  List<String> isoTimes = [];
  String? startdate;
  String? endate;
  MedicneNameModel? medicinemodel;
  SubmitAddApi? submitaddmodel;

  final NotificationService _notificationService = NotificationService();
  bool _isLoading = false;

  Future<void> _scheduleMedicineNotifications(
    String medicineName,
    DateTime startDate,
    DateTime endDate,
    List<TimeOfDay> selectedTimes,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _notificationService.scheduleMedicineReminders(
        medicineName: medicineName,
        startDate: startDate,
        endDate: endDate,
        times:
            selectedTimes
                .where((time) => time != null)
                .cast<TimeOfDay>()
                .toList(),
      );
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
    }
  }

  bool submitaddmedicinebool = false;

  Future getallmedicine(BuildContext context) async {
    getmedicine = true;

    var response = await ApiManager().getnamesofmedicine();
    if (response.isSuccessed!) {
      print("doneeeee");
      medicinemodel = response.data;
      print(medicinemodel?.data[0].name ?? "");
      getmedicine = false;

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

  Future submitaddmedicine(BuildContext context, Map body) async {
    submitaddmedicinebool = true;
    notifyListeners();

    var response = await ApiManager().addmedicinesubmitapi(body: body);
    if (response.isSuccessed!) {
      // _scheduleMedicineNotifications(
      //   medicinenamecontroller.text,
      //   DateTime.parse(startdate!),

      //   DateTime.parse(endate!),
      //   selectedTimes.where((time) => time != null).cast<TimeOfDay>().toList(),
      // );
      print("doneeeee");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Reminder Set Sucessfully"),
          // icon: const Icon(Icons.refresh),
          duration: const Duration(seconds: 3),
        ),
      );
      //  context.go('/dashboardscreen');
      submitaddmedicinebool = false;
      medicinenamecontroller.clear();
      notecontroller.clear();
      dosecontroller.clear();
      selectedTimes = [];
      isoTimes = [];
      startdate = null;
      frequencyy = null;
      type = null;

      endate = null;

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
