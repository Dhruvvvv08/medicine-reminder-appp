// To parse this JSON data, do
//
//     final linkDepedentDataModel = linkDepedentDataModelFromJson(jsonString);

import 'dart:convert';

LinkDepedentDataModel linkDepedentDataModelFromJson(String str) => LinkDepedentDataModel.fromJson(json.decode(str));

String linkDepedentDataModelToJson(LinkDepedentDataModel data) => json.encode(data.toJson());

class LinkDepedentDataModel {
    bool success;
    String message;

    LinkDepedentDataModel({
        required this.success,
        required this.message,
    });

    factory LinkDepedentDataModel.fromJson(Map<String, dynamic> json) => LinkDepedentDataModel(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
