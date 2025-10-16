import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/data/models/order.dart';

class OrderCloudDb {
  static OrderCloudDb? _instance;
  OrderCloudDb._();
  static OrderCloudDb get instance {
    _instance ??= OrderCloudDb._();
    return _instance!;
  }

  final orders = FirebaseFirestore.instance.collection('orders');
  // StreamSubscription? _subscription;

  // Future<void> listenToChanges(String? clientId) async {
  //   final box = GetStorage();
  //   int lastSyncTime = box.read('Order_last_sync_time') ?? 0;

  //   var query = orders.where('updatedAt', isGreaterThan: lastSyncTime);
  //   if (clientId != null) {
  //     query = orders
  //         .where('clientId', isEqualTo: clientId)
  //         .where('updatedAt', isGreaterThan: lastSyncTime);
  //   }

  //   await _subscription?.cancel();
  //   _subscription = query.snapshots().listen((querySnapshot) async {
  //     int latestUpdate = lastSyncTime;

  //     try {
  //       for (var docChange in querySnapshot.docChanges) {
  //         final data = docChange.doc.data();
  //         if (data == null) continue;

  //         final order = LaundryOrder.fromJson(data);

  //         if (order.updatedAt > latestUpdate) {
  //           latestUpdate = order.updatedAt;
  //         }

  //         switch (docChange.type) {
  //           case DocumentChangeType.added:
  //           case DocumentChangeType.modified:
  //             if (!order.deleted) {
  //               await OrderLocalDb.instance.upsertOrder(order);
  //             } else {
  //               await OrderLocalDb.instance.deleteOrder(order.id);
  //             }
  //             break;
  //           case DocumentChangeType.removed:
  //             await OrderLocalDb.instance.deleteOrder(order.id);
  //             break;
  //         }
  //       }

  //       OrderController.instance.scheduleUpdate();

  //       box.write('Order_last_sync_time', latestUpdate);
  //     } catch (e) {
  //       // print('Error during order change listener: $e');
  //     }
  //   });
  // }

  // Future<void> removeListner() async {
  //   await _subscription?.cancel();
  //   _subscription = null;
  // }

  // Order CRUD Functions

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

  Future<List<LaundryOrder>> getAllOrders({String? clientId}) async {
    QuerySnapshot<Map<String, dynamic>> query;
    if (clientId != null) {
      query = await orders.where("clientId", isEqualTo: clientId).get();
    } else {
      query = await orders.get();
    }
    return query.docs.map((doc) => LaundryOrder.fromJson(doc.data())).toList();
  }

  Future<void> deleteOrder(LaundryOrder order) async {
    await orders.doc(order.id).delete();
    OrderController.instance.deleteOrder(order);
  }
}
