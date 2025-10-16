import 'dart:core';

class Offer {
  String id;
  String title;
  String desc;
  int priority;
  int updatedAt;
  bool deleted;

  Offer({
    required this.id,
    required this.title,
    required this.desc,
    required this.priority,
    required this.updatedAt,
    required this.deleted,
  });

  static Offer empty() {
    return Offer(
      id: "",
      title: "",
      desc: "",
      priority: 0,
      updatedAt: 0,
      deleted: false,
    );
  }

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json["id"],
      title: json["title"] ?? "",
      desc: json["desc"] ?? "",
      priority: json["priority"] ?? 0,
      updatedAt: json["updatedAt"] ?? 0,
      deleted: json["deleted"] == 1 || json["deleted"] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "desc": desc,
      "priority": priority,
      "updatedAt": updatedAt,
      "deleted": deleted ? 1 : 0,
    };
  }

  Offer copyWith({
    String? id,
    String? title,
    String? desc,
    int? priority,
    int? updatedAt,
    bool? deleted,
  }) {
    return Offer(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      priority: priority ?? this.priority,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }
}
