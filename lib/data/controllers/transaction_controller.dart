import 'dart:async';

import 'package:get/get.dart';
import 'package:laundary_app/data/db_cloud/transaction_cloud_db.dart';
import 'package:laundary_app/data/models/transaction.dart';

class TransactionController extends GetxController {
  static TransactionController get instance {
    return Get.find<TransactionController>();
  }

  final transactions = <Rx<LaundryTransaction>>[].obs;

  Timer? _debounce;

  static Future<void> initController({String? clientId}) async {
    try {
      if (!Get.isRegistered<TransactionController>()) {
        Get.put(TransactionController(), permanent: true);
      }
      List<LaundryTransaction> tlist =
          await TransactionCloudDb.instance.getAllTransactions();

      if (clientId != null) {
        TransactionController.instance.transactions.assignAll(
          tlist
              .where((transaction) => transaction.client?.id == clientId)
              .map((transaction) => transaction.obs)
              .toList(),
        );
      } else {
        TransactionController.instance.transactions.assignAll(
          tlist.map((transaction) => transaction.obs).toList(),
        );
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> updateData() async {
    // List<LaundryTransaction> tlist = await TransactionLocalDb.instance.getAllTransaction();
    List<LaundryTransaction> tlist =
        await TransactionCloudDb.instance.getAllTransactions();
    transactions.assignAll(
      tlist.map((transaction) => transaction.obs).toList(),
    );
  }

  void scheduleUpdate() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        await updateData();
      } catch (e) {
        // print('Error during scheduleUpdate: $e');
      }
    });
  }

  void addTransaction(LaundryTransaction transaction) {
    transactions.add(transaction.obs);
  }

  void updateTransaction(LaundryTransaction transaction) {
    for (int i = 0; i < transactions.length; i++) {
      if (transactions[i].value.id == transaction.id) {
        transactions[i] = transaction.obs;
        transactions.refresh();
        break;
      }
    }
  }

  void deleteTransaction(LaundryTransaction transaction) {
    transactions.removeWhere((e) => e.value.id == transaction.id);
  }
}
