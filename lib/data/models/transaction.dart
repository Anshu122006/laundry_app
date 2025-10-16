import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundary_app/data/models/client.dart';

class LaundryTransaction {
  String id;
  String type; // "income" or "expense"
  double amount;
  DateTime date;
  String? orderType;
  Client? client;
  int updatedAt;
  bool deleted;

  LaundryTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.orderType,
    this.client,
    required this.updatedAt,
    required this.deleted,
  });

  factory LaundryTransaction.fromJson(Map<String, dynamic> json) {
    return LaundryTransaction(
      id: json["id"] ?? "",
      type: json["type"] ?? "",
      amount: (json["amount"] ?? 0).toDouble(),
      date:
          json['date'] is Timestamp
              ? (json['date'] as Timestamp).toDate()
              : DateTime.parse(json['date']),
      orderType: json["orderType"] ?? "",
      client: json["client"] != null ? Client.fromJson(json["client"]) : null,
      updatedAt: json["updatedAt"] ?? 0,
      deleted: json["deleted"] == 1 || json["deleted"] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "amount": amount,
      "date": date,
      "orderType": orderType,
      "updatedAt": updatedAt,
      "client": client?.toMap(),
      "deleted": deleted ? 1 : 0,
    };
  }

  LaundryTransaction copyWith({
    String? id,
    String? type,
    double? amount,
    DateTime? date,
    String? orderType,
    Client? client,
    int? updatedAt,
    bool? deleted,
  }) {
    return LaundryTransaction(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      orderType: orderType ?? this.orderType,
      client: client ?? this.client,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }
}
