import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundary_app/data/models/client.dart';

class LaundryTransaction {
  String id;
  String type; // "income" or "expense"
  int amount;
  int curBal;
  DateTime date;
  String? orderType;
  Client? client;
  int updatedAt;

  LaundryTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.curBal,
    required this.date,
    this.orderType,
    this.client,
    required this.updatedAt,
  });

  factory LaundryTransaction.fromJson(Map<String, dynamic> json) {
    return LaundryTransaction(
      id: json["id"] ?? "",
      type: json["type"] ?? "",
      amount: (json["amount"] ?? 0).toInt(),
      curBal: (json["curBal"] ?? 0).toInt(),
      date:
          json['date'] is Timestamp
              ? (json['date'] as Timestamp).toDate()
              : DateTime.parse(
                json['date'] ?? DateTime.now().toIso8601String(),
              ),
      orderType: json["orderType"] ?? "",
      client: json["client"] != null ? Client.fromJson(json["client"]) : null,
      updatedAt: json["updatedAt"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "amount": amount,
      "curBal": curBal,
      "date":
          date.toIso8601String(), // Convert to String so it safely stringifies to disk
      "orderType": orderType,
      "updatedAt": updatedAt,
      "client": client?.toMap(),
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      "id": id,
      "type": type,
      "amount": amount,
      "curBal": curBal,
      "date": Timestamp.fromDate(
        date,
      ), // Map cleanly to Firestore Timestamp structure
      "orderType": orderType,
      "updatedAt": updatedAt,
      "client": client?.toMap(),
    };
  }

  LaundryTransaction copyWith({
    String? id,
    String? type,
    int? amount,
    int? curBal,
    DateTime? date,
    String? orderType,
    Client? client,
    int? updatedAt,
  }) {
    return LaundryTransaction(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      curBal: curBal ?? this.curBal,
      date: date ?? this.date,
      orderType: orderType ?? this.orderType,
      client: client ?? this.client,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
