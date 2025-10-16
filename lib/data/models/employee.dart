import 'dart:core';

class Employee {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final int updatedAt;
  final bool deleted;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.updatedAt,
    required this.deleted,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      role: json["role"],
      updatedAt: json["updatedAt"] ?? 0,
      deleted: json["deleted"] == 1 || json["deleted"] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "updatedAt": updatedAt,
      "deleted": deleted ? 1 : 0,
    };
  }

  Employee copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    int? updatedAt,
    bool? deleted,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }
}
