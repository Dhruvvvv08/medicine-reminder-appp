// To parse this JSON data, do
//
//     final dashboardData = dashboardDataFromJson(jsonString);

import 'dart:convert';

DashboardData dashboardDataFromJson(String str) =>
    DashboardData.fromJson(json.decode(str));

String dashboardDataToJson(DashboardData data) => json.encode(data.toJson());

class DashboardData {
  bool success;
  Data data;

  DashboardData({required this.success, required this.data});

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"success": success, "data": data.toJson()};
}

class Data {
  User user;
  ReminderCounts reminderCounts;
  int streakPoints;
  List<dynamic> mostTakenMedicines;

  Data({
    required this.user,
    required this.reminderCounts,
    required this.streakPoints,
    required this.mostTakenMedicines,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: User.fromJson(json["user"]),
    reminderCounts: ReminderCounts.fromJson(json["reminderCounts"]),
    streakPoints: json["streakPoints"],
    mostTakenMedicines: List<dynamic>.from(
      json["mostTakenMedicines"].map((x) => x),
    ),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "reminderCounts": reminderCounts.toJson(),
    "streakPoints": streakPoints,
    "mostTakenMedicines": List<dynamic>.from(mostTakenMedicines.map((x) => x)),
  };
}

class ReminderCounts {
  int taken;
  int missed;
  int pending;
  int total;

  ReminderCounts({
    required this.taken,
    required this.missed,
    required this.pending,
    required this.total,
  });

  factory ReminderCounts.fromJson(Map<String, dynamic> json) => ReminderCounts(
    taken: json["taken"],
    missed: json["missed"],
    pending: json["pending"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "taken": taken,
    "missed": missed,
    "pending": pending,
    "total": total,
  };
}

class User {
  String name;
  String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(name: json["name"], email: json["email"]);

  Map<String, dynamic> toJson() => {"name": name, "email": email};
}
