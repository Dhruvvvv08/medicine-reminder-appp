import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPay extends ChangeNotifier{
  late Razorpay _razorpay;
  RazorPay() {
    _initializeRazorpay(); // << FIXED
  }



  void _initializeRazorpay() {
  
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future initializeBookingAndPay(
    // required String coachId,
    // required String startTime,
    // required String endTime,
    // required double amount,
  ) async {
    try {
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
      // final orderResponse = await repository.createOrder(
      //   amount: amount,
      //   coachId: coachId,
      //   userId: userId,
      // );

      // if (!orderResponse.isSuccessed!) {
      //   throw orderResponse.message ?? "Order creation failed";
      // }

      // Open Razorpay checkout with all payment methods
      final options = {
        'key': 'rzp_test_mBUnGoTInviYkN',
  'amount': 100,
  'name': 'Acme Corp.',
  'description': 'Fine T-Shirt',
  'prefill': {
    'contact': '8888888888',
    'email': 'test@razorpay.com'
  }
        // 'key': 'rzp_test_mBUnGoTInviYkN', // Your test key
        // 'amount': "60",
        // 'name': 'HealthMVP',
        // 'description': 'Coach Consultation',
        // 'order_id': "123455",
        // 'prefill': {
        //   'contact': 'USER_PHONE',
        //   'email': 'USER_EMAIL',
        // },
        // 'theme': {
        //   'color': '#157878'
        // },
        // // Enable all payment methods
        // 'method': {
        //   'netbanking': true,
        //   'card': true,
        //   'upi': true,
        //   'wallet': true,
        // },
        // // UPI configuration
        // 'upi': {
        //   'flow': 'collect',
        //   'apps': [
        //     'gpay',
        //     'phonepe',
        //     'paytm',
        //     'bhim',
        //     'amazonpay'
        //   ]
        // },
        // // Card configuration
        // 'card': {
        //   'emi': false,
        //   'network': [
        //     'visa',
        //     'mastercard',
        //     'rupay',
        //     'maestro',
        //     'amex'
        //   ]
        // },
        // // Wallet configuration
        // 'wallet': [
        //   'paytm',
        //   'phonepe',
        //   'amazonpay',
        //   'freecharge',
        //   'mobikwik'
        // ],
        // // Enable netbanking
        // 'bank': {
        //   'enabled': true
        // },
        // 'remember_customer': true,
        // 'send_sms_hash': true,
        // 'retry': {
        //   'enabled': true,
        //   'max_count': 3
        // },
        // 'external': {
        //   'wallets': [
        //     'paytm',
        //     'phonepe',
        //     'amazonpay',
        //     'freecharge',
        //     'mobikwik'
        //   ]
        // },
        // 'timeout': 300,
        // 'notes': {
        //   'user_id': "1jhhj1223jj3jb3455gg8"
        // }
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
    print("Payment Error: ${response.message}, Code: ${response.code}"); // Debug log
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