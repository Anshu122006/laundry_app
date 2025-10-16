import 'dart:core';

class Pricing {
  String id;
  String name;
  String type;
  double cost;
  int priority;
  int updatedAt;
  bool deleted;

  Pricing({
    required this.id,
    required this.name,
    required this.type,
    required this.cost,
    required this.priority,
    required this.updatedAt,
    this.deleted = false,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      type: json["type"] ?? "",
      cost: json["cost"]?.toDouble() ?? 0.0,
      priority: json["priority"] ?? 0,
      updatedAt: json["updatedAt"] ?? 0,
      deleted: json["deleted"] == 1 || json["deleted"] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "cost": cost,
      "priority": priority,
      "updatedAt": updatedAt,
      "deleted": deleted ? 1 : 0,
    };
  }

  Pricing copyWith({
    String? id,
    String? name,
    String? type,
    double? cost,
    int? priority,
    int? updatedAt,
    bool? deleted,
  }) {
    return Pricing(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      cost: cost ?? this.cost,
      priority: priority ?? this.priority,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }
}
