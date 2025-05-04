import 'package:flutter/material.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/remindersmodel/reminder_model.dart';
import 'package:intl/intl.dart';

class ReminderAuthviewmodel extends ChangeNotifier {
  bool isreminderloading = true;
  ReminderModel? remindermodell;

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future getreminderoftheday(
    BuildContext context,
    String date,
    String status,
  ) async {
    isreminderloading = true;

    var res = await ApiManager().getremindersofmedicine(
      date: "${date}",
      status: status,
    );

    if (res.isSuccessed!) {
      remindermodell = res.data;
      isreminderloading = false;

      notifyListeners();
    } else {
      if (res.message != null) {}

      isreminderloading = false;
      notifyListeners();
    }
  }
}
