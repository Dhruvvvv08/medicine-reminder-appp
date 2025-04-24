import 'package:healthmvp/data/network/bases.dart';
import 'package:healthmvp/data/network/error_handling.dart';
import 'package:healthmvp/models/AuthModel/login_model.dart';
import 'package:healthmvp/models/AuthModel/otp_model.dart';
import 'package:healthmvp/models/AuthModel/register_model.dart';
import 'package:healthmvp/models/AuthModel/verify_otp_model.dart';
import 'package:healthmvp/models/HomeModel/AddMedicine/MedicineName.dart';
import 'package:healthmvp/models/dashboard/dashboard.dart';
import 'package:healthmvp/models/remindersmodel/reminder_model.dart';
import 'package:healthmvp/models/userMedicineModel/submitaddmedicinemodel.dart';
import 'package:healthmvp/models/userMedicineModel/usermedicinemodel.dart';

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

  Future<OnComplete<VerifyOtpModel>> verifyotp({
    String? otp,
    String? userid,
  }) async {
    try {
      ApiResponse response = await apiRequest(
        request: postDataa(
          url: "/verify-otp",
          body: {"otp": otp, "userId": userid},
        ),
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
  Future<OnComplete<SubmitAddApi>> addmedicinesubmitapi({required Map body}) async {
    try {
      ApiResponse response = await apiRequest(
        request: postDataa(url: "/reminders", body: body),
      );

      if (response.success == true) {
        return OnComplete.success(SubmitAddApi.fromJson(response.result));
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

  Future<OnComplete<GetUsersMedicineModel>> getnamesofusermedicine() async {
    try {
      ApiResponse response = await apiRequest(
        request: getdataaa(url: "/medicines"),
      );

      if (response.success == true) {
        return OnComplete.success(
          GetUsersMedicineModel.fromJson(response.result),
        );
      } else {
        return OnComplete.error(
          response.message.toString() ?? "Service Not Available",
        );
      }
    } catch (e) {
      return OnComplete.error("");
    }
  }

  Future<OnComplete<DashboardData>> dashboardmedicinedata() async {
    try {
      ApiResponse response = await apiRequest(
        request: getdataaa(url: "/reminders/dashboard"),
      );

      if (response.success == true) {
        return OnComplete.success(DashboardData.fromJson(response.result));
      } else {
        return OnComplete.error(
          response.message.toString() ?? "Service Not Available",
        );
      }
    } catch (e) {
      return OnComplete.error("");
    }
  }

  Future<OnComplete<ReminderModel>> getremindersofmedicine({
    String? date,
    status,
  }) async {
    try {
      String query = '';

      if (date != null && date != '') query += 'date=$date&';

      if (status != null && status != '') query += 'status=$status&';

      ApiResponse response = await apiRequest(
        request: fetchData(
          queryParams: query,
          url: "/reminders/with-medicine-details",
        ),
      );

      if (response.success == true) {
        return OnComplete.success(ReminderModel.fromJson(response.result));
      } else {
        return OnComplete.error(response.message.toString());
      }
    } catch (e) {
      return OnComplete.error(e.toString());
    }
  }
}
