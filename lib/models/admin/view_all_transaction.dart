// To parse this JSON data, do
//
//     final viewallTransactions = viewallTransactionsFromJson(jsonString);

import 'dart:convert';

List<ViewallTransactions> viewallTransactionsFromJson(String str) => List<ViewallTransactions>.from(json.decode(str).map((x) => ViewallTransactions.fromJson(x)));

String viewallTransactionsToJson(List<ViewallTransactions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ViewallTransactions {
    String id;
    User? user;
    String amount;
    String? plan;
    String createdAt;
    String viewallTransactionId;

    ViewallTransactions({
        required this.id,
        required this.user,
        required this.amount,
        this.plan,
        required this.createdAt,
        required this.viewallTransactionId,
    });

    factory ViewallTransactions.fromJson(Map<String, dynamic> json) => ViewallTransactions(
        id: json["_id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        amount: json["amount"],
        plan: json["plan"],
        createdAt: json["createdAt"],
        viewallTransactionId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user?.toJson(),
        "amount": amount,
        "plan": plan,
        "createdAt": createdAt,
        "id": viewallTransactionId,
    };
}

class User {
    String id;
    String name;
    String email;
    String userId;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.userId,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        userId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "id": userId,
    };
}
