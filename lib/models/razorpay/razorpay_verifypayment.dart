// To parse this JSON data, do
//
//     final verifyPayment = verifyPaymentFromJson(jsonString);

import 'dart:convert';

VerifyPayment verifyPaymentFromJson(String str) => VerifyPayment.fromJson(json.decode(str));

String verifyPaymentToJson(VerifyPayment data) => json.encode(data.toJson());

class VerifyPayment {
    bool valid;

    VerifyPayment({
        required this.valid,
    });

    factory VerifyPayment.fromJson(Map<String, dynamic> json) => VerifyPayment(
        valid: json["valid"],
    );

    Map<String, dynamic> toJson() => {
        "valid": valid,
    };
}
