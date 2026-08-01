class Client {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String hostel;
  final String room;
  final int balance;
  final int updatedAt;
  final List<String>? fcmTokens;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.hostel,
    required this.room,
    required this.balance,
    required this.updatedAt,
    this.fcmTokens,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      hostel: json["hostel"] ?? "",
      room: json["room"] ?? "",
      balance: json["balance"]?.toInt() ?? 0,
      updatedAt: json["updatedAt"]?.toInt() ?? 0,
      fcmTokens:
          json["fcmTokens"] != null
              ? List<String>.from(json["fcmTokens"])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "hostel": hostel,
      "room": room,
      "balance": balance,
      "updatedAt": updatedAt,
      "fcmTokens": fcmTokens,
    };
  }

  Client copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? hostel,
    String? room,
    int? balance,
    int? updatedAt,
    List<String>? fcmTokens,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      hostel: hostel ?? this.hostel,
      room: room ?? this.room,
      balance: balance ?? this.balance,
      updatedAt: updatedAt ?? this.updatedAt,
      fcmTokens: fcmTokens ?? this.fcmTokens,
    );
  }
}
