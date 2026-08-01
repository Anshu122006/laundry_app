import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/data/models/transaction.dart';

class OrderCloudDb {
  static OrderCloudDb? _instance;
  OrderCloudDb._();
  static OrderCloudDb get instance {
    _instance ??= OrderCloudDb._();
    return _instance!;
  }

  final orders = FirebaseFirestore.instance.collection('orders');

  /// Streams only orders modified or created after the local cache's highest timestamp
  Stream<List<LaundryOrder>> watchOrders({required int lastSyncTime}) {
    return orders
        .where('updatedAt', isGreaterThan: lastSyncTime)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => LaundryOrder.fromJson(doc.data()))
                  .toList(),
        );
  }

  Future<String> addOrder(LaundryOrder order) async {
    final docRef = await orders.add(order.toFirestoreMap());
    await orders.doc(docRef.id).update({"id": docRef.id});
    order = order.copyWith(id: docRef.id);
    OrderController.instance.addOrder(order);
    return docRef.id;
  }

  Future<void> updateOrder(LaundryOrder order) async {
    await orders.doc(order.id).update(order.toFirestoreMap());
    OrderController.instance.updateOrder(order);
  }

  Future<void> deleteOrder(LaundryOrder order) async {
    await orders.doc(order.id).delete();
    OrderController.instance.deleteOrder(order);
  }

  Future<void> processDeliveryAtomic({
    required LaundryOrder order,
    required Client client,
    required int amount,
    required int newBalance,
  }) async {
    final db = FirebaseFirestore.instance;
    final batch = db.batch();

    final orderRef = db.collection('orders').doc(order.id);
    final clientRef = db.collection('clients').doc(client.id);
    final txRef = db.collection('transactions').doc(); // Auto ID

    final currentTime = DateTime.now().millisecondsSinceEpoch;

    final tx = LaundryTransaction(
      id: txRef.id,
      type: "removed",
      orderType: order.type,
      amount: amount.abs(),
      curBal: newBalance,
      client: client.copyWith(balance: newBalance),
      date: DateTime.now(),
      updatedAt: currentTime,
    );

    // Queue updates using native Firestore mapping rules
    batch.update(orderRef, order.toFirestoreMap());
    batch.update(clientRef, {'balance': newBalance, 'updatedAt': currentTime});
    batch.set(txRef, tx.toFirestoreMap());

    await batch.commit();
  }

  Future<void> processCancellationAtomic({
    required LaundryOrder order,
    required Client client,
    required int amount,
    required int newBalance,
  }) async {
    final db = FirebaseFirestore.instance;
    final batch = db.batch();

    final orderRef = db.collection('orders').doc(order.id);
    final clientRef = db.collection('clients').doc(client.id);
    final txRef = db.collection('transactions').doc(); // Auto ID

    final currentTime = DateTime.now().millisecondsSinceEpoch;

    final tx = LaundryTransaction(
      id: txRef.id,
      type: "cancelled",
      orderType: order.type,
      amount: amount.abs(),
      curBal: newBalance,
      client: client.copyWith(balance: newBalance),
      date: DateTime.now(),
      updatedAt: currentTime,
    );

    batch.update(orderRef, order.toFirestoreMap());
    batch.update(clientRef, {'balance': newBalance, 'updatedAt': currentTime});
    batch.set(txRef, tx.toFirestoreMap());

    await batch.commit();
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
}
