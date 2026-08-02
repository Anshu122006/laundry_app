import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/models/transaction.dart';

class AtomicQueryManager {
  static AtomicQueryManager? _instance;
  AtomicQueryManager._();
  static AtomicQueryManager get instance {
    _instance ??= AtomicQueryManager._();
    return _instance!;
  }

  final clients = FirebaseFirestore.instance.collection("clients");
  final orders = FirebaseFirestore.instance.collection("orders");
  final transactions = FirebaseFirestore.instance.collection("transactions");

  /// Reactive boolean broadcasting whether an atomic mutation is active.
  final RxBool isProcessing = false.obs;

  /// Global execution time limits for atomic queries on weak networks.
  final Duration networkTimeoutCeiling = const Duration(seconds: 3);
  final int maxAttemptsLimit = 3;

  // ─── ATOMIC MUTATION OPERATORS ──────────────────────────────────────────

  /// **Operation 1: Balance Adjustment & Ledger Entry**
  Future<void> adjustClientBalanceAndLogTransaction({
    required String clientId,
    required double balanceDelta,
    required LaundryTransaction transactionModel,
  }) async {
    _setLoading(true);

    try {
      final firestore = FirebaseFirestore.instance;

      await firestore.runTransaction(
        (transactionHandler) async {
          final clientRef = clients.doc(clientId);
          final clientSnapshot = await transactionHandler.get(clientRef);

          if (!clientSnapshot.exists) {
            throw Exception("Client document $clientId does not exist.");
          }

          final currentBalance =
              (clientSnapshot.data()?['balance'] ?? 0).toDouble();
          final newBalance = currentBalance + balanceDelta;
          final timestamp = DateTime.now().millisecondsSinceEpoch;

          // 1. Update the client document balance
          transactionHandler.update(clientRef, {
            'balance': newBalance,
            'updatedAt': timestamp,
          });

          // 2. Complete missing metadata for the transaction log entry safely
          final newTransactionRef = transactions.doc();
          final transactionData = transactionModel.toMap();

          transactionData['id'] = newTransactionRef.id;
          transactionData['curBal'] = newBalance.toInt();
          transactionData['updatedAt'] = timestamp;

          transactionHandler.set(newTransactionRef, transactionData);
        },
        // Tell the Firebase SDK directly to abort if it takes too long
        timeout: networkTimeoutCeiling,
        // Limit the number of retry attempts the SDK makes if the document changes
        maxAttempts: maxAttemptsLimit,
      );
    } catch (e) {
      // Firebase throws a FirebaseException when its native timeout hits
      throw Exception("Transaction failed or timed out: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// **Operation 2: Balance Adjustment, Ledger Entry & Order Status Update**
  Future<void> processOrderCompletionWithPayment({
    required String clientId,
    required String orderId,
    required double balanceDelta,
    required String newOrderStatus,
    required LaundryTransaction transactionModel,
  }) async {
    _setLoading(true);

    try {
      final firestore = FirebaseFirestore.instance;

      await firestore.runTransaction(
        (transactionHandler) async {
          final clientRef = clients.doc(clientId);
          final orderRef = orders.doc(orderId);

          final clientSnapshot = await transactionHandler.get(clientRef);
          final orderSnapshot = await transactionHandler.get(orderRef);

          if (!clientSnapshot.exists) {
            throw Exception("Client document $clientId does not exist.");
          }
          if (!orderSnapshot.exists) {
            throw Exception("Order document $orderId does not exist.");
          }

          final currentBalance =
              (clientSnapshot.data()?['balance'] ?? 0).toDouble();
          final newBalance = currentBalance + balanceDelta;
          final timestamp = DateTime.now().millisecondsSinceEpoch;

          // 1. Update Client Balance
          transactionHandler.update(clientRef, {
            'balance': newBalance,
            'updatedAt': timestamp,
          });

          // 2. Hydrate and Create Transaction Ledger Record
          final newTransactionRef = transactions.doc();
          final transactionData = transactionModel.toMap();

          transactionData['id'] = newTransactionRef.id;
          transactionData['curBal'] = newBalance.toInt();
          transactionData['updatedAt'] = timestamp;

          transactionHandler.set(newTransactionRef, transactionData);

          // 3. Update Order Status
          transactionHandler.update(orderRef, {
            'status': newOrderStatus,
            'updatedAt': timestamp,
          });
        },
        // Let Firebase SDK handle the timeout to prevent offline caching
        timeout: networkTimeoutCeiling,
        maxAttempts: maxAttemptsLimit,
      );
    } catch (e) {
      throw Exception("Transaction failed or timed out: $e");
    } finally {
      _setLoading(false);
    }
  }

  // ─── AUXILIARY CONTROL HELPERS ──────────────────────────────────────────

  void _setLoading(bool value) {
    isProcessing.value = value;
  }
}
