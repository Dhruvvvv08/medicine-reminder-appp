// To parse this JSON data, do
//
//     final delectAccountmodel = delectAccountmodelFromJson(jsonString);

import 'dart:convert';

DelectAccountmodel delectAccountmodelFromJson(String str) => DelectAccountmodel.fromJson(json.decode(str));

String delectAccountmodelToJson(DelectAccountmodel data) => json.encode(data.toJson());

class DelectAccountmodel {
    String message;

    DelectAccountmodel({
        required this.message,
    });

    factory DelectAccountmodel.fromJson(Map<String, dynamic> json) => DelectAccountmodel(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
