import 'dart:async';

import 'package:get/get.dart';
import 'package:laundary_app/data/db_cloud/order_cloud_db.dart';
import 'package:laundary_app/data/models/order.dart';

class OrderController extends GetxController {
  static OrderController get instance {
    return Get.find<OrderController>();
  }

  final orders = <Rx<LaundryOrder>>[].obs;

  Timer? _debounce;

  static Future<void> initController({String? clientId}) async {
    try {
      if (!Get.isRegistered<OrderController>()) {
        Get.put(OrderController(), permanent: true);
      }
      List<LaundryOrder> olist = [];
      if (clientId != null) {
        olist = await OrderCloudDb.instance.getAllOrders(clientId: clientId);
      } else {
        olist = await OrderCloudDb.instance.getAllOrders();
      }

      OrderController.instance.orders.assignAll(
        olist.map((order) => order.obs).toList(),
      );
    } catch (e) {
      // print(e);
    }
  }

  Future<void> updateData({String? clientId}) async {
    List<LaundryOrder> olist = [];
    if (clientId != null) {
      olist = await OrderCloudDb.instance.getAllOrders(clientId: clientId);
    } else {
      olist = await OrderCloudDb.instance.getAllOrders();
    }

    OrderController.instance.orders.assignAll(
      olist.map((order) => order.obs).toList(),
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

  LaundryOrder? getOrder(String id) {
    LaundryOrder? order =
        orders.firstWhereOrNull((o) => o.value.id == id)?.value;
    return order;
  }

  void addOrder(LaundryOrder order) {
    orders.add(order.obs);
  }

  void updateOrder(LaundryOrder order) {
    for (int i = 0; i < orders.length; i++) {
      if (orders[i].value.id == order.id) {
        orders[i] = order.obs;
        orders.refresh();
        return;
      }
    }
  }

  void deleteOrder(LaundryOrder order) {
    orders.removeWhere((e) => e.value.id == order.id);
  }
}
