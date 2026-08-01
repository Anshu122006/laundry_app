import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/data/controllers/transaction_controller.dart';
import 'package:laundary_app/data/models/transaction.dart';

class PassbookScreenController extends GetxController {
  // Configurable date boundaries
  final Rx<DateTime> startDate =
      DateTime.now().subtract(const Duration(days: 7)).obs;
  final Rx<DateTime> endDate = DateTime.now().obs;

  // Track user input values safely
  final RxString addValue = "".obs;
  final RxString removedValue = "".obs;

  // Internal helper to get normalized timestamps for range comparisons
  int get _startTimestamp => startDate.value.millisecondsSinceEpoch;
  int get _endTimestamp =>
      endDate.value.add(const Duration(days: 1)).millisecondsSinceEpoch;

  // ─── REALTIME CALCULATED GETTERS ──────────────────────────────────────────

  /// Realtime reactive count of orders inside the selected date interval
  int get totalOrders {
    return OrderController.instance.orders.where((o) {
      final orderTime = o.value.placedDate.millisecondsSinceEpoch;
      return orderTime >= _startTimestamp && orderTime <= _endTimestamp;
    }).length;
  }

  /// Realtime filter for all transactions within the selected date interval
  List<LaundryTransaction> get _filteredTransactions {
    return TransactionController.instance.transactions
        .map((t) => t.value)
        .where((t) {
          final txnTime = t.date.millisecondsSinceEpoch;
          return txnTime >= _startTimestamp && txnTime <= _endTimestamp;
        })
        .toList();
  }

  /// Realtime summation of added funds
  int get totalAdded {
    return _filteredTransactions
        .where((t) => t.type == "added")
        .fold(0, (sum, t) => sum + t.amount);
  }

  /// Realtime summation of unordered deductions
  int get totalRemovedUnordered {
    return _filteredTransactions
        .where(
          (t) =>
              t.type == "removed" && (t.orderType == null || t.orderType == ""),
        )
        .fold(0, (sum, t) => sum + t.amount);
  }

  /// Realtime summation of ordered deductions
  int get totalRemovedOrdered {
    return _filteredTransactions
        .where(
          (t) =>
              t.type == "removed" && t.orderType != null && t.orderType != "",
        )
        .fold(0, (sum, t) => sum + t.amount);
  }

  /// Realtime balance generation
  int get netChange => totalAdded - totalRemovedOrdered - totalRemovedUnordered;
}
