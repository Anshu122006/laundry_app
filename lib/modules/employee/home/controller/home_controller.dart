import 'package:get/get.dart';
import 'package:laundary_app/core/utils/helpers/helpers.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/data/db_cloud/order_cloud_db.dart';
import 'package:laundary_app/data/models/order.dart';

class EmployeeHomeController extends GetxController {
  Rx<int> placed = 0.obs;
  Rx<int> toPick = 0.obs;
  Rx<int> toDeliver = 0.obs;
  final recentOrders = <Rx<LaundryOrder>>[].obs;

  @override
  void onInit() async {
    super.onInit();

    ever(OrderController.instance.orders, (callback) async {
      await updateData();
    });
    await updateData();
  }

  Future updateData() async {
    List<LaundryOrder> orders =
        OrderController.instance.orders.map((order) => order.value).toList();
    recentOrders.value =
        orders
            .where((order) => CDateHelper.isToday(order.placedDate))
            .map((order) => order.obs)
            .toList();

    placed.value = recentOrders.length;
    toPick.value =
        orders.where((order) => order.status == OrderStatus.pending).length;
    toDeliver.value =
        orders.where((order) => order.status == OrderStatus.ready).length;
  }

  Future placeOrder() async {
    LaundryOrder order = LaundryOrder(
      id: "",
      clientId: "TJ95lhvbvpvQbXuu3n3E",
      type: "Steam iron",
      placedDate: DateTime.now(),
      status: OrderStatus.pending,
      statusBeforeCancelled: OrderStatus.pending,
      clothes: 0,
      updatedAt: 0,
      deleted: false,
      discount: 0,
      cost: 0,
    );

    await OrderCloudDb.instance.addOrder(order);
  }
}
