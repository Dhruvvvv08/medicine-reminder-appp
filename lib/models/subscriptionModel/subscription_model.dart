// To parse this JSON data, do
//
//     final subscriptionModel = subscriptionModelFromJson(jsonString);

import 'dart:convert';

SubscriptionModel subscriptionModelFromJson(String str) => SubscriptionModel.fromJson(json.decode(str));

String subscriptionModelToJson(SubscriptionModel data) => json.encode(data.toJson());

class SubscriptionModel {
    bool success;
    Data data;

    SubscriptionModel({
        required this.success,
        required this.data,
    });

    factory SubscriptionModel.fromJson(Map<String, dynamic> json) => SubscriptionModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
    };
}

class Data {
    List<SubscriptionType> subscriptionTypes;

    Data({
        required this.subscriptionTypes,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        subscriptionTypes: List<SubscriptionType>.from(json["subscriptionTypes"].map((x) => SubscriptionType.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "subscriptionTypes": List<dynamic>.from(subscriptionTypes.map((x) => x.toJson())),
    };
}

class SubscriptionType {
    String id;
    String name;
    int price;
    String duration;
    List<String> features;
    int? discountedPrice;

    SubscriptionType({
        required this.id,
        required this.name,
        required this.price,
        required this.duration,
        required this.features,
        this.discountedPrice,
    });

    factory SubscriptionType.fromJson(Map<String, dynamic> json) => SubscriptionType(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        duration: json["duration"],
        features: List<String>.from(json["features"].map((x) => x)),
        discountedPrice: json["discounted_price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "duration": duration,
        "features": List<dynamic>.from(features.map((x) => x)),
        "discounted_price": discountedPrice,
    };
}
