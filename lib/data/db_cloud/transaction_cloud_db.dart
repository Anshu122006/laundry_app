import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundary_app/data/controllers/transaction_controller.dart';
import 'package:laundary_app/data/models/transaction.dart';

class TransactionCloudDb {
  static TransactionCloudDb? _instance;
  TransactionCloudDb._();
  static TransactionCloudDb get instance {
    _instance ??= TransactionCloudDb._();
    return _instance!;
  }

  final transactions = FirebaseFirestore.instance.collection('transactions');
  // StreamSubscription? _subscription;

  // Future<void> listenToChanges() async {
  //   final box = GetStorage();
  //   int lastSyncTime = box.read('last_sync_time') ?? 0;

  //   await _subscription?.cancel();
  //   _subscription = transactions
  //       .where('updatedAt', isGreaterThan: lastSyncTime)
  //       .snapshots()
  //       .listen((querySnapshot) async {
  //         int latestUpdate = lastSyncTime;

  //         try {
  //           for (var docChange in querySnapshot.docChanges) {
  //             final data = docChange.doc.data();
  //             if (data == null) continue;

  //             final transaction = LaundryTransaction.fromJson(data);

  //             if (transaction.updatedAt > latestUpdate) {
  //               latestUpdate = transaction.updatedAt;
  //             }

  //             switch (docChange.type) {
  //               case DocumentChangeType.added:
  //               case DocumentChangeType.modified:
  //                 if (!transaction.deleted) {
  //                   await TransactionLocalDb.instance.upsertTransaction(
  //                     transaction,
  //                   );
  //                 } else {
  //                   await TransactionLocalDb.instance.deleteTransaction(
  //                     transaction.id,
  //                   );
  //                 }
  //                 break;

  //               case DocumentChangeType.removed:
  //                 await TransactionLocalDb.instance.deleteTransaction(
  //                   transaction.id,
  //                 );
  //                 break;
  //             }
  //           }

  //           TransactionController.instance.scheduleUpdate();

  //           box.write('last_sync_time', latestUpdate);
  //         } catch (e) {
  //           // print('Error during transaction change listener: $e');
  //         }
  //       });
  // }

  // Future<void> removeListner() async {
  //   await _subscription?.cancel();
  //   _subscription = null;
  // }

  // Transaction CRUD Functions

  Future<String> addTransaction(LaundryTransaction transaction) async {
    final docRef = await transactions.add(transaction.toMap());
    await transactions.doc(docRef.id).update({"id": docRef.id});
    transaction = transaction.copyWith(id: docRef.id);
    TransactionController.instance.addTransaction(transaction);
    return docRef.id;
  }

  Future<void> updateTransaction(LaundryTransaction transaction) async {
    transaction = transaction.copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      deleted: false,
    );
    await transactions.doc(transaction.id).update(transaction.toMap());
    TransactionController.instance.updateTransaction(transaction);
  }

  Future<List<LaundryTransaction>> getAllTransactions() async {
    final query = await transactions.get();
    return query.docs
        .map((doc) => LaundryTransaction.fromJson(doc.data()))
        .toList();
  }

  Future<void> deleteTransaction(LaundryTransaction transaction) async {
    await transactions.doc(transaction.id).delete();
    TransactionController.instance.deleteTransaction(transaction);
  }
}
