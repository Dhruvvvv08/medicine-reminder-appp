// To parse this JSON data, do
//
//     final submitAddApi = submitAddApiFromJson(jsonString);

import 'dart:convert';

SubmitAddApi submitAddApiFromJson(String str) => SubmitAddApi.fromJson(json.decode(str));

String submitAddApiToJson(SubmitAddApi data) => json.encode(data.toJson());

class SubmitAddApi {
    bool success;
    String message;

    SubmitAddApi({
        required this.success,
        required this.message,
    });

    factory SubmitAddApi.fromJson(Map<String, dynamic> json) => SubmitAddApi(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
