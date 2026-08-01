import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class LaundryOrder {
  String id;
  String clientId;
  String type;
  DateTime placedDate;
  OrderStatus status;
  OrderStatus statusBeforeCancelled;

  String? pickupAgentId;
  String? deliverAgentId;
  DateTime? pickupDate;
  DateTime? deliveryDate;

  int clothes;
  int discount;
  int cost;

  int updatedAt;

  LaundryOrder({
    required this.id,
    required this.clientId,
    required this.type,
    required this.placedDate,
    required this.status,
    required this.statusBeforeCancelled,
    required this.clothes,
    this.pickupAgentId,
    this.deliverAgentId,
    this.pickupDate,
    this.deliveryDate,
    required this.discount,
    required this.cost,
    required this.updatedAt,
  });

  static LaundryOrder empty() {
    return LaundryOrder(
      id: "",
      clientId: "",
      type: "",
      placedDate: DateTime.now(),
      status: OrderStatus.pending,
      statusBeforeCancelled: OrderStatus.pending,
      clothes: 0,
      discount: 0,
      cost: 0,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  factory LaundryOrder.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return LaundryOrder(
      id: json['id'] ?? '',
      clientId: json['clientId'] ?? '',
      type: json['type'] ?? '',
      placedDate:
          json['placedDate'] is Timestamp
              ? (json['placedDate'] as Timestamp).toDate()
              : (json['placedDate'] != null
                  ? DateTime.tryParse(json['placedDate'].toString()) ??
                      DateTime.now()
                  : DateTime.now()),
      status: OrderStatusX.fromString(json['status'] ?? ''),
      statusBeforeCancelled: OrderStatusX.fromString(
        json['statusBeforeCancelled'] ?? '',
      ),
      clothes: toInt(json['clothes']),
      pickupAgentId: json['pickupAgentId'],
      deliverAgentId: json['deliverAgentId'],
      pickupDate:
          json['pickupDate'] is Timestamp
              ? (json['pickupDate'] as Timestamp).toDate()
              : (json['pickupDate'] != null
                  ? DateTime.tryParse(json['pickupDate'].toString())
                  : null),
      deliveryDate:
          json['deliveryDate'] is Timestamp
              ? (json['deliveryDate'] as Timestamp).toDate()
              : (json['deliveryDate'] != null
                  ? DateTime.tryParse(json['deliveryDate'].toString())
                  : null),
      discount: toInt(json['discount']),
      cost: toInt(json['cost']),
      updatedAt: toInt(json['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'type': type,
      'placedDate': placedDate.toIso8601String(),
      'status': status.toShortString(),
      'statusBeforeCancelled': statusBeforeCancelled.toShortString(),
      'clothes': clothes,
      'pickupAgentId': pickupAgentId,
      'deliverAgentId': deliverAgentId,
      'pickupDate': pickupDate?.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'discount': discount,
      'cost': cost,
      'updatedAt': updatedAt,
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'clientId': clientId,
      'type': type,
      'placedDate': Timestamp.fromDate(placedDate),
      'status': status.toShortString(),
      'statusBeforeCancelled': statusBeforeCancelled.toShortString(),
      'clothes': clothes,
      'pickupAgentId': pickupAgentId,
      'deliverAgentId': deliverAgentId,
      'pickupDate': pickupDate != null ? Timestamp.fromDate(pickupDate!) : null,
      'deliveryDate':
          deliveryDate != null ? Timestamp.fromDate(deliveryDate!) : null,
      'discount': discount,
      'cost': cost,
      'updatedAt': updatedAt,
    };
  }

  LaundryOrder copyWith({
    String? id,
    String? clientId,
    String? type,
    DateTime? placedDate,
    OrderStatus? status,
    OrderStatus? statusBeforeCancelled,
    int? clothes,
    String? pickupAgentId,
    String? deliverAgentId,
    DateTime? pickupDate,
    DateTime? deliveryDate,
    int? discount,
    int? cost,
    int? updatedAt,
  }) {
    return LaundryOrder(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      type: type ?? this.type,
      placedDate: placedDate ?? this.placedDate,
      status: status ?? this.status,
      statusBeforeCancelled:
          statusBeforeCancelled ?? this.statusBeforeCancelled,
      clothes: clothes ?? this.clothes,
      pickupAgentId: pickupAgentId ?? this.pickupAgentId,
      deliverAgentId: deliverAgentId ?? this.deliverAgentId,
      pickupDate: pickupDate ?? this.pickupDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      discount: discount ?? this.discount,
      cost: cost ?? this.cost,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum OrderStatus { pending, picked, washing, ready, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  String toShortString() => toString().split('.').last;

  int get value {
    switch (this) {
      case OrderStatus.pending:
        return 1;
      case OrderStatus.picked:
        return 2;
      case OrderStatus.washing:
        return 3;
      case OrderStatus.ready:
        return 4;
      case OrderStatus.delivered:
        return 5;
      case OrderStatus.cancelled:
        return 6;
    }
  }

  static OrderStatus fromString(String status) {
    return OrderStatus.values.firstWhere(
      (s) => s.toShortString() == status,
      orElse: () => OrderStatus.pending,
    );
  }

  static OrderStatus fromValue(int value) {
    return OrderStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => OrderStatus.pending,
    );
  }
}
