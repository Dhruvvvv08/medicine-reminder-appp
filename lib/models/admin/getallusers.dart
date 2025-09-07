class ViewallUsersModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final Subscription? subscription;

  ViewallUsersModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.subscription,
  });

  factory ViewallUsersModel.fromJson(Map<String, dynamic> json) {
    return ViewallUsersModel(
      id: json["_id"] ?? json["id"] ?? "", // Try _id first, then fallback to id
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"],
      subscription: json["subscription"] != null
          ? Subscription.fromJson(json["subscription"])
          : null,
    );
  }
}


class Subscription {
  final String status;
  final String endDate;

  Subscription({
    required this.status,
    required this.endDate,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      status: json["status"] ?? "Free",
      endDate: json["endDate"] ?? "",
    );
  }
}
