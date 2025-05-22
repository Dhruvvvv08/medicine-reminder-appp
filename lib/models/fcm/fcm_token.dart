// To parse this JSON data, do
//
//     final fcmTokenModel = fcmTokenModelFromJson(jsonString);

import 'dart:convert';

FcmTokenModel fcmTokenModelFromJson(String str) => FcmTokenModel.fromJson(json.decode(str));

String fcmTokenModelToJson(FcmTokenModel data) => json.encode(data.toJson());

class FcmTokenModel {
    bool success;
    String message;

    FcmTokenModel({
        required this.success,
        required this.message,
    });

    factory FcmTokenModel.fromJson(Map<String, dynamic> json) => FcmTokenModel(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
