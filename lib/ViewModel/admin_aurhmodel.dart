import 'package:flutter/material.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/admin/getallusers.dart';
import 'package:healthmvp/models/payment/payment_transaction.dart';

class AdminAurhmodel extends ChangeNotifier {
  bool isadminloading = false;
  String errorMessage = '';
  List<ViewallUsersModel> viewallUsers = [];
  
  // Payment transactions
  bool isTransactionsLoading = false;
  String transactionsErrorMessage = '';
  List<PaymentTransaction> paymentTransactions = [];

  Future getallusersdata(BuildContext context) async {
    isadminloading = true;
    errorMessage = ''; // Reset error message
    notifyListeners();

    var res = await ApiManager().getallusers();

    if (res.isSuccessed!) {
      try {
        // res.data is now directly a List<ViewallUsersModel>
        if (res.data is List<ViewallUsersModel>) {
          viewallUsers = res.data!;
        } else {
          errorMessage = "Unexpected data format: ${res.data.runtimeType}";
        }
        
        // Debug print to see what we got
        print("API Response data type: ${res.data.runtimeType}");
        print("Parsed users count: ${viewallUsers.length}");
        if (viewallUsers.isNotEmpty) {
          print("First user: ${viewallUsers.first.name}");
        }
        
      } catch (e) {
        errorMessage = "Parsing error: $e";
        print("Error parsing users data: $e");
      }
    } else {
      errorMessage = res.message ?? "Something went wrong";
      print("API error: ${res.message}");
    }

    isadminloading = false;
    notifyListeners();
  }

  Future<bool> deleteUser(BuildContext context, String userId) async {
    try {
      var res = await ApiManager().deleteUser(userId);
      
      if (res.isSuccessed!) {
        // Remove the user from the local list
        viewallUsers.removeWhere((user) => user.id == userId);
        notifyListeners();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        return true;
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete user: ${res.message}'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting user: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  Future getPaymentTransactions(BuildContext context) async {
    isTransactionsLoading = true;
    transactionsErrorMessage = ''; // Reset error message
    notifyListeners();

    var res = await ApiManager().getPaymentTransactions();

    if (res.isSuccessed!) {
      try {
        // res.data is now directly a List<PaymentTransaction>
        if (res.data is List<PaymentTransaction>) {
          paymentTransactions = res.data!;
        } else {
          transactionsErrorMessage = "Unexpected data format: ${res.data.runtimeType}";
        }
        
        // Debug print to see what we got
        print("Payment API Response data type: ${res.data.runtimeType}");
        print("Parsed transactions count: ${paymentTransactions.length}");
        if (paymentTransactions.isNotEmpty) {
          print("First transaction amount: ${paymentTransactions.first.amount}");
        }
        
      } catch (e) {
        transactionsErrorMessage = "Parsing error: $e";
        print("Error parsing payment transactions: $e");
      }
    } else {
      transactionsErrorMessage = res.message ?? "Something went wrong";
      print("Payment API error: ${res.message}");
    }

    isTransactionsLoading = false;
    notifyListeners();
  }
}
