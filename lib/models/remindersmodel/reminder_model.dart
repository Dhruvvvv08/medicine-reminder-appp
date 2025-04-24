// To parse this JSON data, do
//
//     final reminderModel = reminderModelFromJson(jsonString);

import 'dart:convert';

ReminderModel reminderModelFromJson(String str) => ReminderModel.fromJson(json.decode(str));

String reminderModelToJson(ReminderModel data) => json.encode(data.toJson());

class ReminderModel {
    bool success;
    int count;
    List<Datum> data;

    ReminderModel({
        required this.success,
        required this.count,
        required this.data,
    });

    factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
        success: json["success"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String reminderId;
    String time;
    String status;
    String medicineName;
    String medicineCategory;

    Datum({
        required this.reminderId,
        required this.time,
        required this.status,
        required this.medicineName,
        required this.medicineCategory,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        reminderId: json["reminder_id"],
        time: json["time"],
        status: json["status"],
        medicineName: json["medicine_name"],
        medicineCategory: json["medicine_category"],
    );

    Map<String, dynamic> toJson() => {
        "reminder_id": reminderId,
        "time": time,
        "status": status,
        "medicine_name": medicineName,
        "medicine_category": medicineCategory,
    };
}
