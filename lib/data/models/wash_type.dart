import 'dart:core';

class WashType {
  String id;
  String name;
  int priority;

  WashType({required this.id, required this.name, required this.priority});

  factory WashType.fromJson(Map<String, dynamic> json) {
    return WashType(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      priority: json["priority"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "priority": priority};
  }

  WashType copyWith({String? id, String? name, int? priority}) {
    return WashType(
      id: id ?? this.id,
      name: name ?? this.name,
      priority: priority ?? this.priority,
    );
  }
}
