import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/core/utils/logging/logger.dart';
import 'package:laundary_app/data/db_cloud/order_cloud_db.dart';
import 'package:laundary_app/data/models/order.dart';

class OrderController extends GetxController {
  static OrderController get instance {
    return Get.find<OrderController>();
  }

  final orders = <Rx<LaundryOrder>>[].obs;
  StreamSubscription<List<LaundryOrder>>? _orderSubscription;

  final _storage = GetStorage();
  static const String _storageKey = 'cached_orders';

  static Future<void> initController() async {
    if (!Get.isRegistered<OrderController>()) {
      Get.put(OrderController(), permanent: true);
    }
    await OrderController.instance._loadLocalDataAndSync();
  }

  /// Synchronously bootstraps local data and hooks up the real-time delta stream
  Future<void> _loadLocalDataAndSync() async {
    final List<dynamic>? cachedData = _storage.read(_storageKey);
    int highWatermarkTimestamp = 0;

    // Step 1: Push cached data directly into memory for instant UI loading
    if (cachedData != null) {
      final loadedOrders =
          cachedData.map((json) {
            final order = LaundryOrder.fromJson(
              Map<String, dynamic>.from(json),
            );
            if (order.updatedAt > highWatermarkTimestamp) {
              highWatermarkTimestamp = order.updatedAt;
            }
            return order.obs;
          }).toList();

      orders.assignAll(loadedOrders);
    }

    // Step 2: Establish the real-time delta synchronization hook
    _orderSubscription?.cancel();
    _orderSubscription = OrderCloudDb.instance
        .watchOrders(lastSyncTime: highWatermarkTimestamp)
        .listen(
          (incomingDeltas) {
            if (incomingDeltas.isEmpty) return;

            for (var updatedOrder in incomingDeltas) {
              final existingIndex = indexof(updatedOrder.id);

              if (existingIndex != -1) {
                orders[existingIndex].value = updatedOrder;
              } else {
                orders.add(updatedOrder.obs);
              }
            }

            orders.refresh();
            _saveToLocalDisk();
          },
          onError: (error) {
            AppLogger.logInfo(
              "Can't subscribe to the order delta stream: $error",
            );
          },
        );
  }

  /// Flushes current memory items down to high speed local disk storage
  void _saveToLocalDisk() {
    final rawDataList = orders.map((o) => o.value.toMap()).toList();
    _storage.write(_storageKey, rawDataList);
  }

  LaundryOrder? getOrder(String id) {
    return orders.firstWhereOrNull((o) => o.value.id == id)?.value;
  }

  int indexof(String id) {
    return orders.indexWhere((o) => o.value.id == id);
  }

  void addOrder(LaundryOrder order) {
    if (indexof(order.id) == -1) {
      orders.add(order.obs);
      _saveToLocalDisk();
    }
  }

  void updateOrder(LaundryOrder order) {
    for (int i = 0; i < orders.length; i++) {
      if (orders[i].value.id == order.id) {
        orders[i].value = order;
        orders.refresh();
        _saveToLocalDisk();
        return;
      }
    }
  }

  void deleteOrder(LaundryOrder order) {
    orders.removeWhere((e) => e.value.id == order.id);
    _saveToLocalDisk();
  }

  @override
  void onClose() {
    _orderSubscription?.cancel();
    super.onClose();
  }
}
