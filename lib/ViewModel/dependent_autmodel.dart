import 'package:flutter/material.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/remindersmodel/reminder_model.dart';
import 'package:intl/intl.dart';

class DependentAutmodel extends ChangeNotifier {
  bool isdependentloading = false;
  ReminderModel? remindermodell;

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future getdependentreminder(
    BuildContext context,
    String date,
    String dependentid,
  ) async {
    isdependentloading = true;
    notifyListeners();

    var res = await ApiManager().getdependentreminder(
      date: "${date}",
      dependentid: dependentid,
    );

    if (res.isSuccessed!) {
      remindermodell = res.data;
      isdependentloading = false;

      notifyListeners();
    } else {
      if (res.message != null) {}

      isdependentloading = false;
      notifyListeners();
    }
  }
}
