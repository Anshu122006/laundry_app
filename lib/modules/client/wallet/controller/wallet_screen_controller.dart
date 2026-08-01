import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';

class WalletScreenController extends GetxController {
  // Configurable date boundaries
  final Rx<DateTime> startDate =
      DateTime.now().subtract(const Duration(days: 7)).obs;
  final Rx<DateTime> endDate = DateTime.now().obs;

  // Track user input values safely
  final RxString addIncomeValue = "".obs;
  final RxString addExpenseValue = "".obs;

  // Internal helper properties to get normalized timestamps for range comparisons
  int get _startTimestamp => startDate.value.millisecondsSinceEpoch;
  int get _endTimestamp =>
      endDate.value.add(const Duration(days: 1)).millisecondsSinceEpoch;

  /// Realtime reactive count of orders inside the selected date interval.
  /// This automatically recalculates when the date range or order collection updates.
  int get totalOrders {
    return OrderController.instance.orders.where((o) {
      final orderTime = o.value.placedDate.millisecondsSinceEpoch;
      return orderTime >= _startTimestamp && orderTime <= _endTimestamp;
    }).length;
  }
}
