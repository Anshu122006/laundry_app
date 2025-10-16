import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';

class WalletScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    ever(OrderController.instance.orders, (_) => getTotalOrders());

    startDate.value = DateTime.now().subtract(Duration(days: 7));
    endDate.value = DateTime.now().add(Duration(days: 1));
    updateData();
  }

  RxInt orders = 0.obs;
  Rx<DateTime> startDate = DateTime.now().subtract(Duration(days: 7)).obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  RxString addIncomeValue = "".obs;
  RxString addExpenseValue = "".obs;

  void updateData() {
    getTotalOrders();
  }

  void getTotalOrders() {
    int start = startDate.value.millisecondsSinceEpoch;
    int end = endDate.value.add(Duration(days: 1)).millisecondsSinceEpoch;

    int orders =
        OrderController.instance.orders
            .where(
              (o) =>
                  o.value.placedDate.millisecondsSinceEpoch >= start &&
                  o.value.placedDate.millisecondsSinceEpoch <= end,
            )
            .length;
    this.orders.value = orders;
  }
}
