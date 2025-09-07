// To parse this JSON data, do
//
//     final timeZoneModel = timeZoneModelFromJson(jsonString);

import 'dart:convert';

TimeZoneModel timeZoneModelFromJson(String str) => TimeZoneModel.fromJson(json.decode(str));

String timeZoneModelToJson(TimeZoneModel data) => json.encode(data.toJson());

class TimeZoneModel {
    int amount;
    int amountDue;
    int amountPaid;
    int attempts;
    int createdAt;
    String currency;
    String entity;
    String id;
    List<dynamic> notes;
    dynamic offerId;
    String receipt;
    String status;
    String keyId;

    TimeZoneModel({
        required this.amount,
        required this.amountDue,
        required this.amountPaid,
        required this.attempts,
        required this.createdAt,
        required this.currency,
        required this.entity,
        required this.id,
        required this.notes,
        required this.offerId,
        required this.receipt,
        required this.status,
        required this.keyId,
    });

    factory TimeZoneModel.fromJson(Map<String, dynamic> json) => TimeZoneModel(
        amount: json["amount"],
        amountDue: json["amount_due"],
        amountPaid: json["amount_paid"],
        attempts: json["attempts"],
        createdAt: json["created_at"],
        currency: json["currency"],
        entity: json["entity"],
        id: json["id"],
        notes: List<dynamic>.from(json["notes"].map((x) => x)),
        offerId: json["offer_id"],
        receipt: json["receipt"],
        status: json["status"],
        keyId: json["key_id"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "amount_due": amountDue,
        "amount_paid": amountPaid,
        "attempts": attempts,
        "created_at": createdAt,
        "currency": currency,
        "entity": entity,
        "id": id,
        "notes": List<dynamic>.from(notes.map((x) => x)),
        "offer_id": offerId,
        "receipt": receipt,
        "status": status,
        "key_id": keyId,
    };
}
