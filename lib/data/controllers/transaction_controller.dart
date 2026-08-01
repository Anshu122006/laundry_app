import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/core/utils/logging/logger.dart';
import 'package:laundary_app/data/db_cloud/transaction_cloud_db.dart';
import 'package:laundary_app/data/models/transaction.dart';

class TransactionController extends GetxController {
  static TransactionController get instance {
    return Get.find<TransactionController>();
  }

  final transactions = <Rx<LaundryTransaction>>[].obs;
  StreamSubscription<List<LaundryTransaction>>? _transactionSubscription;

  final _storage = GetStorage();
  static const String _storageKey = 'cached_transactions';

  static Future<void> initController() async {
    if (!Get.isRegistered<TransactionController>()) {
      Get.put(TransactionController(), permanent: true);
    }
    await TransactionController.instance._loadLocalDataAndSync();
  }

  /// Synchronously bootstraps local data and hooks up the real-time delta stream
  Future<void> _loadLocalDataAndSync() async {
    final List<dynamic>? cachedData = _storage.read(_storageKey);
    int highWatermarkTimestamp = 0;

    // Step 1: Load cached transactions immediately
    if (cachedData != null) {
      final loadedTransactions =
          cachedData.map((json) {
            final tx = LaundryTransaction.fromJson(
              Map<String, dynamic>.from(json),
            );
            if (tx.updatedAt > highWatermarkTimestamp) {
              highWatermarkTimestamp = tx.updatedAt;
            }
            return tx.obs;
          }).toList();

      transactions.assignAll(loadedTransactions);
    }

    // Step 2: Sync new deltas live from the server
    _transactionSubscription?.cancel();
    _transactionSubscription = TransactionCloudDb.instance
        .watchTransactions(lastSyncTime: highWatermarkTimestamp)
        .listen(
          (incomingDeltas) {
            if (incomingDeltas.isEmpty) return;

            for (var updatedTx in incomingDeltas) {
              final existingIndex = indexof(updatedTx.id);

              if (existingIndex != -1) {
                transactions[existingIndex].value = updatedTx;
              } else {
                transactions.add(updatedTx.obs);
              }
            }

            transactions.refresh();
            _saveToLocalDisk();
          },
          onError: (error) {
            AppLogger.logInfo(
              "Can't subscribe to the transaction delta stream: $error",
            );
          },
        );
  }

  /// Flushes memory logs down to flash disk
  void _saveToLocalDisk() {
    final rawDataList = transactions.map((t) => t.value.toMap()).toList();
    _storage.write(_storageKey, rawDataList);
  }

  int indexof(String id) {
    return transactions.indexWhere((t) => t.value.id == id);
  }

  void addTransaction(LaundryTransaction transaction) {
    if (indexof(transaction.id) == -1) {
      transactions.add(transaction.obs);
      _saveToLocalDisk();
    }
  }

  void updateTransaction(LaundryTransaction transaction) {
    for (int i = 0; i < transactions.length; i++) {
      if (transactions[i].value.id == transaction.id) {
        transactions[i].value = transaction;
        transactions.refresh();
        _saveToLocalDisk();
        break;
      }
    }
  }

  void deleteTransaction(LaundryTransaction transaction) {
    transactions.removeWhere((e) => e.value.id == transaction.id);
    _saveToLocalDisk();
  }

  @override
  void onClose() {
    _transactionSubscription?.cancel();
    super.onClose();
  }
}
