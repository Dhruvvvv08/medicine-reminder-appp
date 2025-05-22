import 'package:flutter/material.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/remindersmodel/reminder_model.dart';
import 'package:healthmvp/view/bottom_nav_bar/bottom_nav.dart';
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

  bool markastaken = false;

  Future<bool> markastakenapi(BuildContext context, String reminderid) async {
    markastaken = true;
    notifyListeners();

    try {
      var res = await ApiManager().markastaken(reminderid: reminderid);

      if (res.isSuccessed!) {
        markastaken = false;
        notifyListeners();
        return true; // Return success status
      } else {
        if (res.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(res.message!)));
        }
        markastaken = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      markastaken = false;
      notifyListeners();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      return false;
    }
  }
}
