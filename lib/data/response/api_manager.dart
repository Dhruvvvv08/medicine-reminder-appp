import 'package:healthmvp/data/network/bases.dart';
import 'package:healthmvp/data/network/error_handling.dart';
import 'package:healthmvp/models/AuthModel/google_signin.dart';
import 'package:healthmvp/models/AuthModel/login_model.dart';
import 'package:healthmvp/models/AuthModel/logout_model.dart';
import 'package:healthmvp/models/AuthModel/otp_model.dart';
import 'package:healthmvp/models/AuthModel/register_model.dart';
import 'package:healthmvp/models/AuthModel/verify_otp_model.dart';
import 'package:healthmvp/models/HomeModel/AddMedicine/MedicineName.dart';
import 'package:healthmvp/models/dashboard/dashboard.dart';
import 'package:healthmvp/models/dependent/dependent_model.dart';
import 'package:healthmvp/models/fcm/fcm_token.dart';
import 'package:healthmvp/models/profile/linkdependent.dart';
import 'package:healthmvp/models/profileModel/profilemodel.dart';
import 'package:healthmvp/models/remindersmodel/reminder_model.dart';
import 'package:healthmvp/models/remindersmodel/take_reminder.dart';
import 'package:healthmvp/models/subscriptionModel/subscription_model.dart';
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
        request: postDataa(url: "/users/request-otp", body: {"email": email}),
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
          url: "/users/verify-otp",
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
        request: postDataa(url: "/users/", body: body),
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

  Future<OnComplete<SubmitAddApi>> addmedicinesubmitapi({
    required Map body,
  }) async {
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

  Future<OnComplete<LinkDepedentDataModel>> linkdependent({
    required Map body,
  }) async {
    try {
      ApiResponse response = await apiRequest(
        request: postDataa(url: "/users/link-dependent", body: body),
      );

      if (response.success == true) {
        return OnComplete.success(
          LinkDepedentDataModel.fromJson(response.result),
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

  Future<OnComplete<DashboardData>> dashboardmedicinedata({
    String? date,
  }) async {
    try {
      ApiResponse response = await apiRequest(
        request: getdataaa(url: "/reminders/dashboard?date=$date"),
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

  Future<OnComplete<ProfileModelData>> getprofileinfo({String? date}) async {
    try {
      ApiResponse response = await apiRequest(
        request: getdataaa(url: "/users/profile"),
      );

      if (response.success == true) {
        return OnComplete.success(ProfileModelData.fromJson(response.result));
      } else {
        return OnComplete.error(
          response.message.toString() ?? "Service Not Available",
        );
      }
    } catch (e) {
      return OnComplete.error("");
    }
  }
   Future<OnComplete<SubscriptionModel>> getsubsciptiondetails({String? date}) async {
    try {
      ApiResponse response = await apiRequest(
        request: getdataaa(url: "/subscription"),
      );

      if (response.success == true) {
        return OnComplete.success(SubscriptionModel.fromJson(response.result));
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
      ApiResponse response = await apiRequest(
        request: fetchData(
          // queryParams: query,
          url: "/reminders/with-medicine-details?date=$date",
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

  Future<OnComplete<ReminderModel>> getdependentreminder({
    String? date,
    dependentid,
  }) async {
    try {
      print(dependentid);
      ApiResponse response = await apiRequest(
        request: fetchData(
          // queryParams: query,
          url: "/reminders/dependent/$dependentid?date=$date",
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

  Future<OnComplete<DepedentDashboardDataModel>> getdependentdashboard({
    String? date,
    dependentid,
  }) async {
    try {
      ApiResponse response = await apiRequest(
        request: fetchData(
          // queryParams: query,
          url: "/reminders/dashboard/dependent/$dependentid?date=$date",
        ),
      );

      if (response.success == true) {
        return OnComplete.success(
          DepedentDashboardDataModel.fromJson(response.result),
        );
      } else {
        return OnComplete.error(response.message.toString());
      }
    } catch (e) {
      return OnComplete.error(e.toString());
    }
  }

  Future<OnComplete<TakenApiModel>> markastaken({reminderid}) async {
    try {
      ApiResponse response = await apiRequest(
        request: putdataa(
          body: {"": ""},
          // queryParams: query,
          url: "/reminders/$reminderid/take",
        ),
      );

      if (response.success == true) {
        return OnComplete.success(TakenApiModel.fromJson(response.result));
      } else {
        return OnComplete.error(response.message.toString());
      }
    } catch (e) {
      return OnComplete.error(e.toString());
    }
  }

  Future<OnComplete<FcmTokenModel>> fcmtoken({fcmtoken}) async {
    try {
      ApiResponse response = await apiRequest(
        request: putdataa(
          // queryParams: query,
          url: "/users/fcm-token",
          body: {"fcmToken": fcmtoken},
        ),
      );

      if (response.success == true) {
        return OnComplete.success(FcmTokenModel.fromJson(response.result));
      } else {
        return OnComplete.error(response.message.toString());
      }
    } catch (e) {
      return OnComplete.error(e.toString());
    }
  }

  Future<OnComplete<LogoutModelApi>> logout() async {
    try {
      ApiResponse response = await apiRequest(
        request: getdataaa(
          // queryParams: query,
          url: "/users/logout",
        ),
      );

      if (response.success == true) {
        return OnComplete.success(LogoutModelApi.fromJson(response.result));
      } else {
        return OnComplete.error(response.message.toString());
      }
    } catch (e) {
      return OnComplete.error(e.toString());
    }
  }

  Future<OnComplete<GoogleloginModelApi>> googlesignin({
    required Map body,
  }) async {
    try {
      ApiResponse response = await apiRequest(
        request: postDataa(url: "/users/login/google", body: body),
      );

      if (response.success == true) {
        return OnComplete.success(
          GoogleloginModelApi.fromJson(response.result),
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
}
