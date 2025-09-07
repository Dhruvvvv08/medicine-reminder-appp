class PaymentTransaction {
  final String id;
  final String amount;
  final String? plan;
  final String createdAt;
  final String transactionId;
  final User? user;

  PaymentTransaction({
    required this.id,
    required this.amount,
    this.plan,
    required this.createdAt,
    required this.transactionId,
    this.user,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json["_id"] ?? json["id"] ?? "",
      amount: json["amount"] ?? "",
      plan: json["plan"],
      createdAt: json["createdAt"] ?? "",
      transactionId: json["id"] ?? "",
      user: json["user"] != null ? User.fromJson(json["user"]) : null,
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String userId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"] ?? json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      userId: json["id"] ?? "",
    );
  }
} 