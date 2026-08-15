import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundary_app/core/utils/logging/logger.dart';
import 'package:laundary_app/data/models/order.dart';

class OrderCloudDb {
  static OrderCloudDb? _instance;
  OrderCloudDb._();
  static OrderCloudDb get instance {
    _instance ??= OrderCloudDb._();
    return _instance!;
  }

  final orders = FirebaseFirestore.instance.collection('orders');

  /// Fetches all orders once from Firestore (used for initial login seeding).
  Future<List<LaundryOrder>> fetchAllOrders({String? clientId}) async {
    Query query = orders;
    if (clientId != null && clientId.isNotEmpty) {
      query = query.where('clientId', isEqualTo: clientId);
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => LaundryOrder.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Streams active orders (status NOT delivered and NOT cancelled) in real-time.
  Stream<List<LaundryOrder>> watchActiveOrders({String? clientId}) {
    final activeStatuses = [
      OrderStatus.pending.toShortString(),
      OrderStatus.picked.toShortString(),
      OrderStatus.washing.toShortString(),
      OrderStatus.ready.toShortString(),
    ];

    Query query = orders.where('status', whereIn: activeStatuses);
    if (clientId != null && clientId.isNotEmpty) {
      query = query.where('clientId', isEqualTo: clientId);
    }

    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => LaundryOrder.fromJson(
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  /// Streams orders created after the local cache's high watermark.
  /// If [clientId] is provided, isolates records specifically for that user.
  Stream<List<LaundryOrder>> watchOrders({
    required int lastSyncTime,
    String? clientId,
    int limit = 200,
  }) {
    Query query;

    if (lastSyncTime > 0) {
      query = orders.where('updatedAt', isGreaterThan: lastSyncTime);
      if (clientId != null && clientId.isNotEmpty) {
        query = query.where('clientId', isEqualTo: clientId);
      }
    } else {
      if (clientId != null && clientId.isNotEmpty) {
        query = orders.where('clientId', isEqualTo: clientId).limit(limit);
      } else {
        query = orders.limit(limit);
      }
    }

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) =>
                    LaundryOrder.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  Future<String> addOrder(LaundryOrder order) async {
    final docRef = orders.doc();
    final newOrder = order.copyWith(id: docRef.id);
    await docRef.set(newOrder.toFirestoreMap());
    
    return docRef.id;
  }

  Future<void> updateOrder(LaundryOrder order) async {
    await orders.doc(order.id).update(order.toFirestoreMap());
    // OrderController.instance.updateOrder(order);
  }

  Future<void> deleteOrder(LaundryOrder order) async {
    await orders.doc(order.id).delete();
    // OrderController.instance.deleteOrder(order);
  }

  Future<void> cleanUpOrdersCollection() async {
    final collectionRef = FirebaseFirestore.instance.collection('orders');
    final snapshot = await collectionRef.get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var doc in snapshot.docs) {
      // If the legacy document explicitly contains the old field
      if (doc.data().containsKey('deleted')) {
        batch.update(doc.reference, {
          // FieldValue.delete() completely scrubs the key out of the remote document record
          'deleted': FieldValue.delete(),
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
      }
    }

    // Execute structural migrations instantly
    await batch.commit();
    print("Database cleanup complete! All stale order columns scrubbed.");
  }

  // / Purges all orders from Firestore that match the given client ID.
  // / Automatically batches operations to safely handle lists larger than 500 documents.
  Future<void> purgeClientOrders() async {
    const String clientId = "DO3biFNwnQtauUruU8hG";
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // 1. Query all orders belonging to the specified client
      final querySnapshot =
          await firestore
              .collection('orders')
              .where('clientId', isEqualTo: clientId)
              .get();

      if (querySnapshot.docs.isEmpty) {
        AppLogger.logInfo("[PURGE INFO]: No orders found for clientId: $clientId");
        return;
      }

      WriteBatch batch = firestore.batch();
      int counter = 0;
      int totalPurged = 0;

      AppLogger.logInfo(
        "[PURGE INFO]: Starting order purge for client $clientId. Found ${querySnapshot.docs.length} records.",
      );

      // 2. Stage documents for deletion in batches
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
        counter++;
        totalPurged++;

        // 3. Commit and reset batch execution context when hitting the 500 ceiling
        if (counter == 500) {
          await batch.commit();
          batch = firestore.batch();
          counter = 0;
          AppLogger.logInfo("[PURGE INFO]: Progress: Committed 500 deletions...");
        }
      }

      // Commit any remaining staged items
      if (counter > 0) {
        await batch.commit();
      }

      AppLogger.logInfo("[PURGE INFO]: Success! Total purged: $totalPurged records.");
    } catch (e) {
      AppLogger.logInfo("[PURGE ERROR]: Failed to purge client orders: $e");
      rethrow;
    }
  }
}
