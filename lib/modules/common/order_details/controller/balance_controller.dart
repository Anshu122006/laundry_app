import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/db_cloud/atomic_query_manager.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/transaction.dart';

class ClientBalanceController extends GetxController {
  final TextEditingController balanceController = TextEditingController();

  // ─── REACTIVE LOAD DRIVER ──────────────────────────────────────────────────
  // Bind your buttons or circular loader indicators directly to the manager's state
  RxBool get isLoading => AtomicQueryManager.instance.isProcessing;

  @override
  void onClose() {
    balanceController.dispose();
    super.onClose();
  }

  Future<void> updateBalance({
    required Client client,
    required bool add,
  }) async {
    final cleanInput = balanceController.text.trim();
    if (cleanInput.isEmpty) return;

    final double amount =
        (double.tryParse(cleanInput) ?? 0.0) * (add ? 1.0 : -1.0);
    if (amount == 0) return;

    try {
      // Create the ledger model that will be pushed atomically alongside the balance change
      final transactionRecord = LaundryTransaction(
        id: "", // Managed internally by AtomicQueryManager
        type: add ? "added" : "removed",
        amount: amount.abs().toInt(),
        curBal: 0,
        date: DateTime.now(),
        orderType: null, // No order context here, pure manual balance adjustment
        client: client,
        updatedAt: DateTime.now().millisecondsSinceEpoch, // Fallback placeholder
      );

      // Execute safely via the manager (handles loading bounds & 10-second timeouts natively)
      await AtomicQueryManager.instance.adjustClientBalanceAndLogTransaction(
        clientId: client.id,
        balanceDelta: amount,
        transactionModel: transactionRecord,
      );

      // Dismiss the UI sheet overlay only after successful confirmation passes
      balanceController.clear();
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }
    } on TimeoutException catch (e) {
      CDeviceHelper.showSnackbar(
        "Connection Timeout",
        e.message ??
            "Network is too slow. Transaction cancelled safely without modifications.",
        CIcons.errorCross,
      );
    } catch (e) {
      CDeviceHelper.showSnackbar(
        "Transaction Aborted",
        "Failed to modify account balance. Please verify your connection status.",
        CIcons.errorCross,
      );
    }
  }
}
