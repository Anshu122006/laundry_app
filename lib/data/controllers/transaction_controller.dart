import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/core/utils/logging/logger.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/transaction_cloud_db.dart';
import 'package:laundary_app/data/models/transaction.dart';

class TransactionController extends GetxController {
  static TransactionController get instance =>
      Get.find<TransactionController>();

  final transactions = <Rx<LaundryTransaction>>[].obs;
  StreamSubscription<List<LaundryTransaction>>? _transactionSubscription;

  final _storage = GetStorage();

  // Unique identifier string representing the current owner of this session
  String get _currentOwnerId {
    final auth = AuthController.instance;
    if (auth.userType.value == UserType.admin) {
      return 'admin_global';
    }
    return auth.currentClient.value?.id ?? "guest";
  }

  String get _storageKey => 'cached_transactions_v2_$_currentOwnerId';
  String get _ownerStampKey => 'cache_owner_stamp_$_currentOwnerId';

  static Future<void> initController() async {
    if (!Get.isRegistered<TransactionController>()) {
      Get.put(TransactionController(), permanent: true);
    }
    await TransactionController.instance._loadLocalDataAndSync();
  }

  Future<void> _loadLocalDataAndSync() async {
    final auth = AuthController.instance;
    final bool isAdmin = auth.userType.value == UserType.admin;
    final currentClient = auth.currentClient.value;

    // 1. Clear memory array immediately to prevent state carryover between roles/profiles
    transactions.clear();

    if (!isAdmin && (currentClient == null || currentClient.id.isEmpty)) {
      AppLogger.logInfo(
        "Skipping transaction synchronization: Unauthenticated context.",
      );
      return;
    }

    // 2. 🛡️ FOOLPROOF OWNER VALIDATION:
    // If the storage container was stamped by a different user/role, wipe it to prevent leaks.
    final String? cachedOwner = _storage.read(_ownerStampKey);
    if (cachedOwner != null && cachedOwner != _currentOwnerId) {
      debugPrint(
        "[CACHE SECURITY]: Owner mismatch detected! Purging cross-account cache collision.",
      );
      _storage.remove(_storageKey);
    }

    final List<dynamic>? cachedData = _storage.read(_storageKey);
    int highWatermarkTimestamp = 0;

    // 3. Load matching local cache context safely
    if (cachedData != null && cachedData.isNotEmpty) {
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

    // 4. Connect targeted real-time stream subscription
    _transactionSubscription?.cancel();
    _transactionSubscription = TransactionCloudDb.instance
        .watchTransactions(
          lastSyncTime: highWatermarkTimestamp,
          clientId: isAdmin ? null : currentClient?.id,
        )
        .listen(
          (incomingDeltas) {
            if (incomingDeltas.isNotEmpty) {
              if (highWatermarkTimestamp == 0) {
                transactions.assignAll(
                  incomingDeltas.map((tx) => tx.obs).toList(),
                );
              } else {
                for (var updatedTx in incomingDeltas) {
                  final existingIndex = indexof(updatedTx.id);

                  if (existingIndex != -1) {
                    transactions[existingIndex].value = updatedTx;
                  } else {
                    transactions.add(updatedTx.obs);
                  }
                }
              }

              transactions.refresh();
              _saveToLocalDisk();
            }
          },
          onError: (error) {
            AppLogger.logInfo("Transaction Delta Stream Error: $error");
          },
        );
  }

  void _saveToLocalDisk() {
    // Stamp the storage container with the active owner fingerprint
    _storage.write(_ownerStampKey, _currentOwnerId);

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
