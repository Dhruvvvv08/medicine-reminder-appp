// To parse this JSON data, do
//
//     final profileModelData = profileModelDataFromJson(jsonString);

import 'dart:convert';

ProfileModelData profileModelDataFromJson(String str) => ProfileModelData.fromJson(json.decode(str));

String profileModelDataToJson(ProfileModelData data) => json.encode(data.toJson());

class ProfileModelData {
    bool success;
    Data data;

    ProfileModelData({
        required this.success,
        required this.data,
    });

    factory ProfileModelData.fromJson(Map<String, dynamic> json) => ProfileModelData(
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
    List<Dependent> dependents;
    Subscription subscription;
    NotificationPreferences notificationPreferences;
    String createdAt;

    Data({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.role,
        required this.dependents,
        required this.subscription,
        required this.notificationPreferences,
        required this.createdAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        role: json["role"],
        dependents: List<Dependent>.from(json["dependents"].map((x) => Dependent.fromJson(x))),
        subscription: Subscription.fromJson(json["subscription"]),
        notificationPreferences: NotificationPreferences.fromJson(json["notificationPreferences"]),
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "role": role,
        "dependents": List<dynamic>.from(dependents.map((x) => x.toJson())),
        "subscription": subscription.toJson(),
        "notificationPreferences": notificationPreferences.toJson(),
        "createdAt": createdAt,
    };
}

class Dependent {
    String id;
    String name;
    String email;
    String phone;
    String dependentId;

    Dependent({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.dependentId,
    });

    factory Dependent.fromJson(Map<String, dynamic> json) => Dependent(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        dependentId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "id": dependentId,
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

class Subscription {
    String status;
    String end;

    Subscription({
        required this.status,
        required this.end,
    });

    factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        status: json["status"],
        end: json["end"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "end": end,
    };
}
