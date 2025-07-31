import 'package:flutter/material.dart';
import 'package:healthmvp/data/response/api_manager.dart';
import 'package:healthmvp/models/subscriptionModel/subscription_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubscriptionModelAuthview extends ChangeNotifier {
  bool subscriptionloading = false;
  int getMonthsFromDuration(String duration) {
  duration = duration.toLowerCase();
  if (duration.contains("year")) return 12;
  if (duration.contains("6")) return 6;
  if (duration.contains("1")) return 1;
  return 1; // default to 1 if unknown
}
int ?monthcount;
  SubscriptionModel? subscriptionmodel;

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
    SubscriptionType plan,
    // required String coachId,
    // required String startTime,
    // required String endTime,
    // required double amount,
  ) async {
    monthcount = getMonthsFromDuration(plan.duration);
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
        body: {
          "amount": (plan.discountedPrice ?? plan.price).toInt() * 100,
          "currency": "INR",
          "receipt": "receipt_${DateTime.now().millisecondsSinceEpoch}",
        },
      );

      if (!orderResponse.isSuccessed!) {
        throw orderResponse.message ?? "Order creation failed";
      }

      final options = {
        'key': orderResponse.data?.keyId, // Your test key
        'amount': orderResponse.data?.amount,
        'name': 'HealthMVP',
        'description': 'Coach Consultation',
        'order_id': orderResponse.data?.id,
        // 'prefill': {'contact': 'USER_PHONE', 'email': 'USER_EMAIL'},
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
        // 'notes': {'user_id': "1jhhj1223jj3jb3455gg8"},
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
  void _handlePaymentSuccess(PaymentSuccessResponse response)async 
  {
    
    final verifypayment = await ApiManager().razorpayverifyapi(
        body: {
          "order_id":response.orderId,
          "payment_id":response.paymentId,
          "signature":response.signature,
          "month":monthcount,

        },

      );
              if(verifypayment.isSuccessed!){
                 
              }
    print("Payment Success: ${response.paymentId}");
    print("Payment Success222: ${response.signature}");
    print("Payment Success3333: ${response.orderId}"); // Debug log
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
