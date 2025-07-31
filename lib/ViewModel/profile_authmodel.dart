import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/models/profileModel/profilemodel.dart';
import 'package:healthmvp/models/dependent/dependent_model.dart';
import 'package:healthmvp/view/Auth/auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ProfileAuthmodel extends ChangeNotifier {
  bool profileloading = false;
  bool linkdependent = false;
  bool dependentloading = false;
  bool islogout = false;

  ProfileModelData? profiledatamodel;
  DepedentDashboardDataModel? dependentdashboard;
  String? dependentid;
  bool updateprofileloadng = false;
  Future<void> getdashboarddata(BuildContext context) async {
    profileloading = true;
    notifyListeners();

    try {
      final response = await ApiManager().getprofileinfo();
      if (response.isSuccessed == true) {
        profiledatamodel = response.data;
      } else {
        if (response.message == "Not authorized to access this route") {
          // Handle unauthorized access
          await Future.delayed(const Duration(seconds: 1));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Failed to load profile"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading profile: $e"),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      profileloading = false;
      notifyListeners();
    }
  }

  Future<void> updateprofile(
    BuildContext context,
    String name,
    String phone,
  ) async {
    profileloading = true;
    notifyListeners();

    try {
      final response = await ApiManager().updateprofileinfo({
        "phone": phone,
        "name": name,
      });
      if (response.isSuccessed == true) {
        profiledatamodel = response.data;
      } else {
        if (response.message == "Not authorized to access this route") {
          // Handle unauthorized access
          await Future.delayed(const Duration(seconds: 1));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );
        }
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Error updating profile: $e"),
      //     duration: const Duration(seconds: 3),
      //   ),
      // );
    } finally {
      profileloading = false;
      notifyListeners();
    }
  }

  Future<void> linkdependentapi(
    BuildContext context,
    Map<String, dynamic> body,
  ) async {
    linkdependent = true;
    notifyListeners();

    try {
      final response = await ApiManager().linkdependent(body: body);
      if (response.isSuccessed == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Dependent linked successfully"),
            duration: const Duration(seconds: 3),
          ),
        );
        await getdashboarddata(context); // Refresh profile data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Failed to link dependent"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error linking dependent: $e"),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      linkdependent = false;
      notifyListeners();
    }
  }

  Future<void> getdependentdashboard(
    BuildContext context,
    String date,
    String dependentid,
  ) async {
    dependentloading = true;
    notifyListeners();

    try {
      final res = await ApiManager().getdependentdashboard(
        date: date,
        dependentid: dependentid,
      );

      if (res.isSuccessed == true) {
        dependentdashboard = res.data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.message ?? "Failed to load dependent dashboard"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading dependent dashboard: $e"),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      dependentloading = false;
      notifyListeners();
    }
  }

  Future<void> logoutstatus(BuildContext context) async {
    islogout = true;
    notifyListeners();

    try {
      final response = await ApiManager().logout();
      if (response.isSuccessed == true) {
        SharedPref.pref!.setBool(Preferences.login, false);
        SharedPref.pref!.remove(Preferences.token);
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Failed to logout"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error during logout: $e"),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      islogout = false;
      notifyListeners();
    }
  }

  late Razorpay _razorpay;

  // @override
  // void onInit() {
  //   super.onInit();
  //   _initializeRazorpay();
  // }

  void initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  bool ispayment = false;
  Future initializeBookingAndPay(
    BuildContext context,
    // required String coachId,
    // required String startTime,
    // required String endTime,
    // required double amount,
  ) async {
    try {
      ispayment = true;
      //  initializeRazorpay();
      // isLoading.value = true;
      // final userId = StorageService().getId(role: UserRole.endUser).toString();

      // // Initialize booking
      // final bookingResponse = await repository.initializeBooking(
      //   coachId: coachId,
      //   startTime: startTime,
      //   endTime: endTime,
      //   userId: userId,
      // );

      // if (!bookingResponse.isSuccessed!) {
      //   throw bookingResponse.message ?? "Booking initialization failed";
      // }

      // currentBooking.value = bookingResponse.data;

      // // Create order for payment
      final orderResponse = await ApiManager().razorpaycreateorder(
        body: {"amount": 100, "currency": "INR", "receipt": "receipt#1"},
      );

      if (!orderResponse.isSuccessed!) {
        throw orderResponse.message ?? "Order creation failed";
      }

      // Open Razorpay checkout with all payment methods
      final options = {
        'key': 'rzp_test_mBUnGoTInviYkN', // Your test key
        'amount': "60",
        'name': 'HealthMVP',
        'description': 'Coach Consultation',
        //'order_id': "order_Qj9h3DS6cYV24z",
        'prefill': {'contact': 'USER_PHONE', 'email': 'USER_EMAIL'},
        'theme': {'color': '#157878'},
        // Enable all payment methods
        'method': {
          'netbanking': true,
          'card': true,
          'upi': true,
          'wallet': true,
        },
        // UPI configuration
        'upi': {
          'flow': 'collect',
          'apps': ['gpay', 'phonepe', 'paytm', 'bhim', 'amazonpay'],
        },
        // Card configuration
        'card': {
          'emi': false,
          'network': ['visa', 'mastercard', 'rupay', 'maestro', 'amex'],
        },
        // Wallet configuration
        'wallet': ['paytm', 'phonepe', 'amazonpay', 'freecharge', 'mobikwik'],
        // Enable netbanking
        'bank': {'enabled': true},
        'remember_customer': true,
        'send_sms_hash': true,
        'retry': {'enabled': true, 'max_count': 3},
        'external': {
          'wallets': [
            'paytm',
            'phonepe',
            'amazonpay',
            'freecharge',
            'mobikwik',
          ],
        },
        'timeout': 300,
        'notes': {'user_id': "1jhhj1223jj3jb3455gg8"},
      };

      print("Opening Razorpay with options: $options"); // Debug log
      _razorpay.open(options);
      return true;
    } catch (e) {
      print("Error in payment process: $e"); // Debug log
      // Get.snackbar(
      //   'Error',
      //   e.toString(),
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      return false;
    } finally {
      //  isLoading.value = false;
    }
  }

  // Add these handler methods if not already present
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Success: ${response.paymentId}"); // Debug log
    // Get.snackbar(
    //   'Success',
    //   'Payment successful! Payment ID: ${response.paymentId}',
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
    // Navigate to success screen or handle success
    // Get.offAllNamed('/booking-success');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
      "Payment Error: ${response.message}, Code: ${response.code}",
    ); // Debug log
    // Get.snackbar(
    //   'Error',
    //   'Payment failed: ${response.message ?? 'Something went wrong'}',
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: Colors.red,
    //   colorText: Colors.white,
    // );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}"); // Debug log
    // Get.snackbar(
    //   'Info',
    //   'External wallet selected: ${response.walletName}',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }

  // @override
  // void onClose() {
  //   _razorpay.clear();
  //   super.onClose();
  // }
}
