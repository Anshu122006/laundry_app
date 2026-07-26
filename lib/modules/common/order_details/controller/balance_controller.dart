import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';

class ClientBalanceController extends GetxController {
  final TextEditingController balanceController = TextEditingController();
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    balanceController.dispose();
    super.onClose();
  }

  Future<void> updateBalance({
    required Client client,
    required bool add,
  }) async {
    if (balanceController.text.trim().isEmpty) return;

    isLoading.value = true;

    try {
      int amount = (int.tryParse(balanceController.text) ?? 0) * (add ? 1 : -1);
      int newBalance = client.balance + amount;

      // 1. THE SAFETY GATE: Pre-flight network check.
      // Forces a read from the server. If offline, throws TimeoutException BEFORE queuing writes.
      await FirebaseFirestore.instance
          .collection('clients')
          .doc(client.id)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 3));

      // 2. Execute the atomic batch 
      // ignore: unused_local_variable
      final completedTx = await ClientCloudDb.instance.updateBalanceAtomic(
        client: client,
        amount: amount,
        newBalance: newBalance,
      );

      // 3. Only dismiss sheet after successful updates
      if (Get.isBottomSheetOpen ?? false) Get.back();
    } on TimeoutException catch (_) {
      CDeviceHelper.showSnackbar(
        "Connection Timeout",
        "Network is too slow. Transaction cancelled safely.",
        CIcons.errorCross
      );
    } catch (e) {
      CDeviceHelper.showSnackbar(
        "Error",
        "Transaction failed. Check your connection.",
        CIcons.errorCross
      );
    } finally {
      isLoading.value = false;
    }
  }
}
