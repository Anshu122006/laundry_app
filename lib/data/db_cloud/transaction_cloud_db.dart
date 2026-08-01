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

  /// Streams only transactions created after the local cache's high watermark
  Stream<List<LaundryTransaction>> watchTransactions({
    required int lastSyncTime,
  }) {
    return transactions
        .where('updatedAt', isGreaterThan: lastSyncTime)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => LaundryTransaction.fromJson(doc.data()))
                  .toList(),
        );
  }

  Future<String> addTransaction(LaundryTransaction transaction) async {
    final docRef = await transactions.add(transaction.toFirestoreMap());
    await transactions.doc(docRef.id).update({"id": docRef.id});
    transaction = transaction.copyWith(id: docRef.id);
    TransactionController.instance.addTransaction(transaction);
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

    // 1. Target only documents where the old 'delete' field actually exists
    final collectionRef = firestore
        .collection('transactions')
        .where('delete', isNull: false);
    final snapshot = await collectionRef.get();

    if (snapshot.docs.isEmpty) {
      return;
    }

    WriteBatch batch = firestore.batch();
    int counter = 0;
    int totalCleaned = 0;

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {
        // Completely strips the key out of the remote transaction record
        'delete': FieldValue.delete(),
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      counter++;
      totalCleaned++;

      // 2. Commit and reset the batch if it hits the 500 operation safety ceiling
      if (counter == 500) {
        await batch.commit();
        batch = firestore.batch();
        counter = 0;
      }
    }

    if (counter > 0) {
      await batch.commit();
    }

    print(
      "Transaction database cleanup complete! Cleaned $totalCleaned records.",
    );
  }
}
