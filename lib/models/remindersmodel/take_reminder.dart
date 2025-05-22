// To parse this JSON data, do
//
//     final takenApiModel = takenApiModelFromJson(jsonString);

import 'dart:convert';

TakenApiModel takenApiModelFromJson(String str) =>
    TakenApiModel.fromJson(json.decode(str));

String takenApiModelToJson(TakenApiModel data) => json.encode(data.toJson());

class TakenApiModel {
  bool success;
  Data data;

  TakenApiModel({required this.success, required this.data});

  factory TakenApiModel.fromJson(Map<String, dynamic> json) => TakenApiModel(
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"success": success, "data": data.toJson()};
}

class Data {
  String id;
  Medicine medicine;
  String user;
  String scheduleStart;
  String scheduleEnd;
  bool active;
  String frequency;
  String time;
  String status;
  dynamic missedAt;
  bool notificationSent;
  int notificationCount;
  bool parentNotified;
  String repeat;
  List<dynamic> daysOfWeek;
  List<dynamic> daysOfMonth;
  int repeatInterval;
  String repeatUnit;
  String createdAt;
  int v;

  Data({
    required this.id,
    required this.medicine,
    required this.user,
    required this.scheduleStart,
    required this.scheduleEnd,
    required this.active,
    required this.frequency,
    required this.time,
    required this.status,
    required this.missedAt,
    required this.notificationSent,
    required this.notificationCount,
    required this.parentNotified,
    required this.repeat,
    required this.daysOfWeek,
    required this.daysOfMonth,
    required this.repeatInterval,
    required this.repeatUnit,
    required this.createdAt,
    required this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    medicine: Medicine.fromJson(json["medicine"]),
    user: json["user"],
    scheduleStart: json["scheduleStart"],
    scheduleEnd: json["scheduleEnd"],
    active: json["active"],
    frequency: json["frequency"],
    time: json["time"],
    status: json["status"],
    missedAt: json["missedAt"],
    notificationSent: json["notificationSent"],
    notificationCount: json["notificationCount"],
    parentNotified: json["parentNotified"],
    repeat: json["repeat"],
    daysOfWeek: List<dynamic>.from(json["daysOfWeek"].map((x) => x)),
    daysOfMonth: List<dynamic>.from(json["daysOfMonth"].map((x) => x)),
    repeatInterval: json["repeatInterval"],
    repeatUnit: json["repeatUnit"],
    createdAt: json["createdAt"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "medicine": medicine.toJson(),
    "user": user,
    "scheduleStart": scheduleStart,
    "scheduleEnd": scheduleEnd,
    "active": active,
    "frequency": frequency,
    "time": time,
    "status": status,
    "missedAt": missedAt,
    "notificationSent": notificationSent,
    "notificationCount": notificationCount,
    "parentNotified": parentNotified,
    "repeat": repeat,
    "daysOfWeek": List<dynamic>.from(daysOfWeek.map((x) => x)),
    "daysOfMonth": List<dynamic>.from(daysOfMonth.map((x) => x)),
    "repeatInterval": repeatInterval,
    "repeatUnit": repeatUnit,
    "createdAt": createdAt,
    "__v": v,
  };
}

class Medicine {
  String id;
  String name;
  String dosage;
  String instructions;
  String category;
  String medicineId;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.instructions,
    required this.category,
    required this.medicineId,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
    id: json["_id"],
    name: json["name"],
    dosage: json["dosage"],
    instructions: json["instructions"],
    category: json["category"],
    medicineId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "dosage": dosage,
    "instructions": instructions,
    "category": category,
    "id": medicineId,
  };
}
