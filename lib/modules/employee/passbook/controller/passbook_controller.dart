import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/data/controllers/transaction_controller.dart';
import 'package:laundary_app/data/db_cloud/transaction_cloud_db.dart';
import 'package:laundary_app/data/models/transaction.dart';

class PassbookScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    ever(OrderController.instance.orders, (_) => getTotalOrders());
    ever(TransactionController.instance.transactions, (_) => getTotalAdded());
    ever(
      TransactionController.instance.transactions,
      (_) => getUnregisteredAdded(),
    );
    ever(TransactionController.instance.transactions, (_) => getTotalRemoved());

    startDate.value = DateTime.now().subtract(Duration(days: 7));
    endDate.value = DateTime.now().add(Duration(days: 1));
    updateData();
  }

  RxInt orders = 0.obs;
  RxDouble added = 0.0.obs;
  RxDouble unregisteredAdded = 0.0.obs;
  RxDouble removed = 0.0.obs;
  Rx<DateTime> startDate = DateTime.now().subtract(Duration(days: 7)).obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  RxString addValue = "".obs;
  RxString removedValue = "".obs;

  void updateData() {
    getTotalOrders();
    getTotalAdded();
    getUnregisteredAdded();
    getTotalRemoved();
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
    double added = transactions
        .where((t) => t.type == "added")
        .fold(0.0, (sum, t) => sum + t.amount);

    this.added.value = added;
  }

  void getUnregisteredAdded() {
    int start = startDate.value.millisecondsSinceEpoch;
    int end = endDate.value.add(Duration(days: 1)).millisecondsSinceEpoch;

    List<LaundryTransaction> transactions =
        TransactionController.instance.transactions
            .map((t) => t.value)
            .where(
              (t) =>
                  t.date.millisecondsSinceEpoch >= start &&
                  t.date.millisecondsSinceEpoch <= end &&
                  t.client == null,
            )
            .toList();
    double unregisteredAdded = transactions.fold(
      0.0,
      (sum, t) => sum + t.amount,
    );

    this.unregisteredAdded.value = unregisteredAdded;
  }

  void getTotalRemoved() {
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
    double removed = transactions
        .where((t) => t.type == "removed")
        .fold(0.0, (sum, t) => sum + t.amount);

    this.removed.value = removed;
  }

  Future addAmount(double amount) async {
    await TransactionCloudDb.instance.addTransaction(
      LaundryTransaction(
        id: "",
        type: amount >= 0 ? "added" : "removed",
        amount: amount,
        date: DateTime.now(),
        updatedAt: 0,
        deleted: false,
      ),
    );
  }

  // Future addremoved() async {
  //   await TransactionCloudDb.instance.addTransaction(
  //     LaundryTransaction(
  //       id: "",
  //       type: "removed",
  //       amount: double.parse(addremovedValue.value),
  //       date: DateTime.now(),
  //       updatedAt: 0,
  //       deleted: false,
  //     ),
  //   );
  // }
}
