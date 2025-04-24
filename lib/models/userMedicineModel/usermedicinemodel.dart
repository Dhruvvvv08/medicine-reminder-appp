// To parse this JSON data, do
//
//     final getUsersMedicineModel = getUsersMedicineModelFromJson(jsonString);

import 'dart:convert';

GetUsersMedicineModel getUsersMedicineModelFromJson(String str) => GetUsersMedicineModel.fromJson(json.decode(str));

String getUsersMedicineModelToJson(GetUsersMedicineModel data) => json.encode(data.toJson());

class GetUsersMedicineModel {
    bool success;
    int count;
    List<Datum> data;
    String baseUrl;

    GetUsersMedicineModel({
        required this.success,
        required this.count,
        required this.data,
        required this.baseUrl,
    });

    factory GetUsersMedicineModel.fromJson(Map<String, dynamic> json) => GetUsersMedicineModel(
        success: json["success"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        baseUrl: json["baseURL"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "baseURL": baseUrl,
    };
}

class Datum {
    String id;
    String name;
    String dosage;
    String category;
    String datumId;

    Datum({
        required this.id,
        required this.name,
        required this.dosage,
        required this.category,
        required this.datumId,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        name: json["name"],
        dosage: json["dosage"],
        category: json["category"],
        datumId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "dosage": dosage,
        "category": category,
        "id": datumId,
    };
}
