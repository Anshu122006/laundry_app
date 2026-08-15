import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundary_app/core/utils/logging/logger.dart';
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

  /// Fetches all transactions once from Firestore (used during initial login seeding).
  Future<List<LaundryTransaction>> fetchAllTransactions({
    String? clientId,
  }) async {
    Query query = transactions;
    if (clientId != null && clientId.isNotEmpty) {
      query = query.where('client.id', isEqualTo: clientId);
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map(
          (doc) => LaundryTransaction.fromJson(
            doc.data() as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Streams only transactions created after the local cache's high watermark
  Stream<List<LaundryTransaction>> watchTransactions({
    required int lastSyncTime,
    String? clientId,
    int limit = 200,
  }) {
    Query query;

    if (lastSyncTime > 0) {
      query = transactions.where('updatedAt', isGreaterThan: lastSyncTime);
      if (clientId != null && clientId.isNotEmpty) {
        query = query.where('client.id', isEqualTo: clientId);
      }
    } else {
      if (clientId != null && clientId.isNotEmpty) {
        query = transactions.where('client.id', isEqualTo: clientId).limit(limit);
      } else {
        query = transactions.limit(limit);
      }
    }

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) => LaundryTransaction.fromJson(
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  Future<String> addTransaction(LaundryTransaction transaction) async {
    final docRef = transactions.doc();
    final newTransaction = transaction.copyWith(id: docRef.id);
    await docRef.set(newTransaction.toFirestoreMap());
    TransactionController.instance.addTransaction(newTransaction);

    return docRef.id;
  }

  Future<void> updateTransaction(LaundryTransaction transaction) async {
    transaction = transaction.copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await transactions.doc(transaction.id).update(transaction.toFirestoreMap());
    TransactionController.instance.updateTransaction(transaction);
  }

  Future<void> deleteTransaction(LaundryTransaction transaction) async {
    await transactions.doc(transaction.id).delete();
    TransactionController.instance.deleteTransaction(transaction);
  }


  Future<void> purgeClientTransactions() async {
    const String clientId = "DO3biFNwnQtauUruU8hG";
    final firestore = FirebaseFirestore.instance;

    // 1. Fetch documents where client.id matches the provided clientId
    final snapshot =
        await firestore
            .collection('transactions')
            .where('client.id', isEqualTo: clientId)
            .get();

    if (snapshot.docs.isEmpty) {
      AppLogger.logInfo("No transactions found for client ID: $clientId");
      return;
    }

    WriteBatch batch = firestore.batch();
    int counter = 0;
    int totalDeleted = 0;

    for (var doc in snapshot.docs) {
      // Queue document for deletion
      batch.delete(doc.reference);

      counter++;
      totalDeleted++;

      // Firestore batch limit is 500 operations
      if (counter == 500) {
        await batch.commit();
        batch = firestore.batch();
        counter = 0;
      }
    }

    // Commit any remaining deletes in the batch
    if (counter > 0) {
      await batch.commit();
    }

    AppLogger.logInfo(
      "Successfully deleted $totalDeleted transaction(s) for client ID: $clientId",
    );
  }
}
