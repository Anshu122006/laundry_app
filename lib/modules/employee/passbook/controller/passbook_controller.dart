import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/data/controllers/transaction_controller.dart';
import 'package:laundary_app/data/models/transaction.dart';

class PassbookScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    ever(OrderController.instance.orders, (_) => getTotalOrders());
    ever(TransactionController.instance.transactions, (_) => getTotalAdded());
    ever(
      TransactionController.instance.transactions,
      (_) => getRemovedUnordered(),
    );
    ever(TransactionController.instance.transactions, (_) => getRemovedOrdered());

    startDate.value = DateTime.now().subtract(Duration(days: 7));
    endDate.value = DateTime.now().add(Duration(days: 1));
    updateData();
  }

  RxInt orders = 0.obs;
  RxInt added = 0.obs;
  RxInt removedOrdered = 0.obs;
  RxInt removedUnordered = 0.obs;
  Rx<DateTime> startDate = DateTime.now().subtract(Duration(days: 7)).obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  RxString addValue = "".obs;
  RxString removedValue = "".obs;

  void updateData() {
    getTotalOrders();
    getTotalAdded();
    getRemovedUnordered();
    getRemovedOrdered();
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

  void getTotalAdded() {
    int start = startDate.value.millisecondsSinceEpoch;
    int end = endDate.value.add(Duration(days: 1)).millisecondsSinceEpoch;

    List<LaundryTransaction> transactions =
        TransactionController.instance.transactions
            .map((t) => t.value)
            .where(
              (t) =>
                  t.date.millisecondsSinceEpoch >= start &&
                  t.date.millisecondsSinceEpoch <= end,
            )
            .toList();
    int added = transactions
        .where((t) => t.type == "added")
        .fold(0, (sum, t) => sum + t.amount);

    this.added.value = added;
  }

  void getRemovedUnordered() {
    int start = startDate.value.millisecondsSinceEpoch;
    int end = endDate.value.add(Duration(days: 1)).millisecondsSinceEpoch;

    List<LaundryTransaction> transactions =
        TransactionController.instance.transactions
            .map((t) => t.value)
            .where(
              (t) =>
                  t.date.millisecondsSinceEpoch >= start &&
                  t.date.millisecondsSinceEpoch <= end,
            )
            .toList();
    int removedUnordered = transactions
        .where((t) => t.type == "remove" && t.orderType == "")
        .fold(0, (sum, t) => sum + t.amount);

    this.removedUnordered.value = removedUnordered;
  }

  void getRemovedOrdered() {
    int start = startDate.value.millisecondsSinceEpoch;
    int end = endDate.value.add(Duration(days: 1)).millisecondsSinceEpoch;

    List<LaundryTransaction> transactions =
        TransactionController.instance.transactions
            .map((t) => t.value)
            .where(
              (t) =>
                  t.date.millisecondsSinceEpoch >= start &&
                  t.date.millisecondsSinceEpoch <= end,
            )
            .toList();
    int removedOrdered = transactions
        .where((t) => t.type == "remove" && t.orderType != "")
        .fold(0, (sum, t) => sum + t.amount);

    this.removedOrdered.value = removedOrdered;
  }

  // Future addAmount(int amount) async {
  //   await TransactionCloudDb.instance.addTransaction(
  //     LaundryTransaction(
  //       id: "",
  //       type: amount >= 0 ? "added" : "removed",
  //       amount: amount,
  //       date: DateTime.now(),
  //       updatedAt: 0,
  //       deleted: false,
  //     ),
  //   );
  // }

  // Future addremoved() async {
  //   await TransactionCloudDb.instance.addTransaction(
  //     LaundryTransaction(
  //       id: "",
  //       type: "removed",
  //       amount: int.parse(addremovedValue.value),
  //       date: DateTime.now(),
  //       updatedAt: 0,
  //       deleted: false,
  //     ),
  //   );
  // }
}
