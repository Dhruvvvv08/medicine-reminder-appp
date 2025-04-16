import 'package:healthmvp/data/network/bases.dart';
import 'package:healthmvp/data/network/error_handling.dart';
import 'package:healthmvp/models/AuthModel/login_model.dart';
import 'package:healthmvp/models/AuthModel/otp_model.dart';
import 'package:healthmvp/models/AuthModel/register_model.dart';
import 'package:healthmvp/models/AuthModel/verify_otp_model.dart';
import 'package:healthmvp/models/HomeModel/AddMedicine/MedicineName.dart';

class ApiManager {
  Future<OnComplete<LoginModel>> loginapi(
    final String email,
    final String pass,
  ) async {
    try {
      ApiResponse response = await apiRequest(
        request: postDataawithouttoken(
          url: "/users/login",
          
          body: {"email": email, "password": pass},
        ),
      );

      if (response.success == true) {
        
        return OnComplete.success(LoginModel.fromJson(response.result));
      } else {
        return OnComplete.error(response.message ?? "Service Not Available");
      }
    } catch (e) {
      return OnComplete.error(e.toString());
    }
  }

  Future<OnComplete<OtpModel>> loginwithotp({String? email}) async {
    try {
      ApiResponse response = await apiRequest(
        request: postDataa(url: "/request-otp", body: {"email": email}),
      );

      if (response.success == true) {
        return OnComplete.success(OtpModel.fromJson(response.result));
      } else {
        return OnComplete.error(
          response.message.toString() ?? "Service Not Available",
        );
      }
    } catch (e) {
      return OnComplete.error("Invalid OTP");
    }
  }

   Future<OnComplete<VerifyOtpModel>> verifyotp({String? otp,String? userid}) async {
    try {
      ApiResponse response = await apiRequest(
        request: postDataa(url: "/verify-otp", body: {"otp":otp,
        "userId":userid,
        }),
      );

      if (response.success == true) {
        return OnComplete.success(VerifyOtpModel.fromJson(response.result));
      } else {
        return OnComplete.error(
          response.message.toString() ?? "Service Not Available",
        );
      }
    } catch (e) {
      return OnComplete.error("Invalid OTP");
    }
  }
 Future<OnComplete<RegisterModel>> signupapi({required Map body}) async {
    try {
      ApiResponse response = await apiRequest(
        request: postDataa(url: "/", body: body),
      );

      if (response.success == true) {
        return OnComplete.success(RegisterModel.fromJson(response.result));
      } else {
        return OnComplete.error(
          response.message.toString() ?? "Service Not Available",
        );
      }
    } catch (e) {
      return OnComplete.error("");
    }
  }

  Future<OnComplete<MedicneNameModel>> getnamesofmedicine() async {
    try {
      ApiResponse response = await apiRequest(
        request: getdataaa(url: "/medicine-stack"),
      );

      if (response.success == true) {
        return OnComplete.success(MedicneNameModel.fromJson(response.result));
      } else {
        return OnComplete.error(
          response.message.toString() ?? "Service Not Available",
        );
      }
    } catch (e) {
      return OnComplete.error("");
    }
  }

}
