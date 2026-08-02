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

  /// Streams only transactions created after the local cache's high watermark
  Stream<List<LaundryTransaction>> watchTransactions({
    required int lastSyncTime,
    String? clientId,
  }) {
    Query query = transactions.where('updatedAt', isGreaterThan: lastSyncTime);

    if (clientId != null && clientId.isNotEmpty) {
      query = query.where('client.id', isEqualTo: clientId);
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


  Future<void> cleanUpTransactionsCollection() async {
    final firestore = FirebaseFirestore.instance;

    // 1. Fetch documents from the collection.
    final snapshot = await firestore.collection('transactions').get();

    if (snapshot.docs.isEmpty) {
      AppLogger.logInfo("Transactions collection is completely empty.");
      return;
    }

    WriteBatch batch = firestore.batch();
    int counter = 0;
    int totalCleaned = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      bool needsUpdate = false;
      Map<String, dynamic> updates = {};

      // 3. Check for the legacy nested 'delete' field inside the 'client' object
      if (data.containsKey('client') && data['client'] is Map) {
        final clientMap = Map<String, dynamic>.from(data['client'] as Map);

        if (clientMap.containsKey('deleted')) {
          clientMap.remove('deleted'); // Strip it out locally
          updates['client'] = clientMap; // Queue the cleaned object for update
          needsUpdate = true;
        }
      }

      // 4. Apply updates if any matches were hit
      if (needsUpdate) {
        updates['updatedAt'] = DateTime.now().millisecondsSinceEpoch;

        batch.update(doc.reference, updates);

        counter++;
        totalCleaned++;

        // Commit and reset the batch if it hits the 500 operation safety ceiling
        if (counter == 500) {
          await batch.commit();
          batch = firestore.batch();
          counter = 0;
        }
      }
    }

    // Commit any remaining operations in the final batch
    if (counter > 0) {
      await batch.commit();
    }

    if (totalCleaned == 0) {
      AppLogger.logInfo(
        "Scan complete: No transactions contained a legacy 'delete' field at root or nested levels.",
      );
    } else {
      AppLogger.logInfo(
        "Transaction database cleanup complete! Cleaned $totalCleaned records.",
      );
    }
  }
}
