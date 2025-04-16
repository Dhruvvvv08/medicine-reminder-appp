// To parse this JSON data, do
//
//     final otpModel = otpModelFromJson(jsonString);

import 'dart:convert';

OtpModel otpModelFromJson(String str) => OtpModel.fromJson(json.decode(str));

String otpModelToJson(OtpModel data) => json.encode(data.toJson());

class OtpModel {
    bool success;
    String message;
    Data data;

    OtpModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String userId;

    Data({
        required this.userId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
    };
}
