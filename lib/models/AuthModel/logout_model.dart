// To parse this JSON data, do
//
//     final logoutModelApi = logoutModelApiFromJson(jsonString);

import 'dart:convert';

LogoutModelApi logoutModelApiFromJson(String str) => LogoutModelApi.fromJson(json.decode(str));

String logoutModelApiToJson(LogoutModelApi data) => json.encode(data.toJson());

class LogoutModelApi {
    String message;

    LogoutModelApi({
        required this.message,
    });

    factory LogoutModelApi.fromJson(Map<String, dynamic> json) => LogoutModelApi(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
