// To parse this JSON data, do
//
//     final editMedicineDetails = editMedicineDetailsFromJson(jsonString);

import 'dart:convert';

EditMedicineDetails editMedicineDetailsFromJson(String str) => EditMedicineDetails.fromJson(json.decode(str));

String editMedicineDetailsToJson(EditMedicineDetails data) => json.encode(data.toJson());

class EditMedicineDetails {
    bool success;
    Data data;

    EditMedicineDetails({
        required this.success,
        required this.data,
    });

    factory EditMedicineDetails.fromJson(Map<String, dynamic> json) => EditMedicineDetails(
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
    String user;
    String dosage;
    String instructions;
    String category;
    String createdAt;
    int v;
    String dataId;

    Data({
        required this.id,
        required this.name,
        required this.user,
        required this.dosage,
        required this.instructions,
        required this.category,
        required this.createdAt,
        required this.v,
        required this.dataId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        name: json["name"],
        user: json["user"],
        dosage: json["dosage"],
        instructions: json["instructions"],
        category: json["category"],
        createdAt: json["createdAt"],
        v: json["__v"],
        dataId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "user": user,
        "dosage": dosage,
        "instructions": instructions,
        "category": category,
        "createdAt": createdAt,
        "__v": v,
        "id": dataId,
    };
}
