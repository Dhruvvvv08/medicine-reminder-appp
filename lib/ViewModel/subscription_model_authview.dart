import 'package:flutter/material.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/subscriptionModel/subscription_model.dart';

class SubscriptionModelAuthview extends ChangeNotifier{

  bool subscriptionloading=false;
  SubscriptionModel ? subscriptionmodel;

  Future<void> getdashboarddata(BuildContext context) async {
    subscriptionloading = true;
    notifyListeners();

    try {
      final response = await ApiManager().getsubsciptiondetails();
      if (response.isSuccessed == true) {
        subscriptionmodel = response.data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Failed to load Subscription"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading Subscription: $e"),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      subscriptionloading = false;
      notifyListeners();
    }
  }
}