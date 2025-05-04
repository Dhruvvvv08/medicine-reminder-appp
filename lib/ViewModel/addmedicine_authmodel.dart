import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/HomeModel/AddMedicine/MedicineName.dart';
import 'package:healthmvp/models/userMedicineModel/submitaddmedicinemodel.dart';
import 'package:healthmvp/services/notification_service.dart';

class AddmedicineAuthmodel extends ChangeNotifier {
  bool getmedicine = false;
  String? type;
  TextEditingController medicinenamecontroller = TextEditingController();
  final TextEditingController notecontroller = TextEditingController();
  final TextEditingController dosecontroller = TextEditingController();
  String? frequencyy;
  List<TimeOfDay> selectedTimes = []; // Changed to non-nullable
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
        times: selectedTimes, 
      );
    } catch (e) {
      print('Error scheduling notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool submitaddmedicinebool = false;

  Future getallmedicine(BuildContext context) async {
    getmedicine = true;
    notifyListeners();

    try {
      var response = await ApiManager().getnamesofmedicine();
      if (response.isSuccessed!) {
        medicinemodel = response.data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message.toString()),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching medicines: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      getmedicine = false;
      notifyListeners();
    }
  }

  Future submitaddmedicine(BuildContext context, Map body) async {
    submitaddmedicinebool = true;
    notifyListeners();

    try {
      var response = await ApiManager().addmedicinesubmitapi(body: body);
      if (response.isSuccessed!) {
        // if (startdate != null && endate != null) {
        //   await _scheduleMedicineNotifications(
        //     medicinenamecontroller.text,
        //     DateTime.parse(startdate!),
        //     DateTime.parse(endate!),
        //     selectedTimes,
        //   );
        // }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Reminder Set Successfully"),
            duration: Duration(seconds: 3),
          ),
        );

        // Reset form
        medicinenamecontroller.clear();
        notecontroller.clear();
        dosecontroller.clear();
        selectedTimes.clear();
        isoTimes.clear();
        startdate = null;
        endate = null;
        frequencyy = null;
        type = null;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message.toString()),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting medicine: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      submitaddmedicinebool = false;
      notifyListeners();
    }
  }
}
