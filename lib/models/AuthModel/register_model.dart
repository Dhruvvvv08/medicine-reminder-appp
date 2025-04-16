// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
    bool success;
    Data data;

    RegisterModel({
        required this.success,
        required this.data,
    });

    factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
    };
}

class Data {
    String id;
    String name;
    String email;
    String phone;
    String role;
    NotificationPreferences notificationPreferences;
    String token;

    Data({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.role,
        required this.notificationPreferences,
        required this.token,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        role: json["role"],
        notificationPreferences: NotificationPreferences.fromJson(json["notificationPreferences"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "role": role,
        "notificationPreferences": notificationPreferences.toJson(),
        "token": token,
    };
}

class NotificationPreferences {
    bool email;
    bool push;
    bool sms;

    NotificationPreferences({
        required this.email,
        required this.push,
        required this.sms,
    });

    factory NotificationPreferences.fromJson(Map<String, dynamic> json) => NotificationPreferences(
        email: json["email"],
        push: json["push"],
        sms: json["sms"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "push": push,
        "sms": sms,
    };
}
