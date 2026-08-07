import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/core/utils/logging/logger.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/order_cloud_db.dart';
import 'package:laundary_app/data/models/order.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find<OrderController>();

  final orders = <Rx<LaundryOrder>>[].obs;
  StreamSubscription<List<LaundryOrder>>? _orderSubscription;

  final _storage = GetStorage();

  // Unique identifier string representing the current owner of this session
  String get _currentOwnerId {
    final auth = AuthController.instance;
    if (auth.userType.value == UserType.admin) {
      return 'admin_global';
    }
    if (auth.userType.value == UserType.employee) {
      return 'employee_global';
    }
    return auth.currentClient.value?.id ?? "guest";
  }

  String get _storageKey => 'cached_orders_v2_$_currentOwnerId';
  String get _ownerStampKey => 'cache_owner_stamp_orders_$_currentOwnerId';

  static Future<void> initController() async {
    if (!Get.isRegistered<OrderController>()) {
      Get.put(OrderController(), permanent: true);
    }
    await OrderController.instance._loadLocalDataAndSync();
  }

  /// Synchronously bootstraps local data and hooks up the real-time delta stream
  Future<void> _loadLocalDataAndSync() async {
    final auth = AuthController.instance;
    final bool isAdmin = auth.userType.value == UserType.admin;
    final bool isEmployee = auth.userType.value == UserType.employee;
    final bool isStaff = isAdmin || isEmployee;
    final currentClient = auth.currentClient.value;

    // 1. Clear memory array immediately to prevent state carryover between profiles
    orders.clear();

    if (!isStaff && (currentClient == null || currentClient.id.isEmpty)) {
      AppLogger.logInfo(
        "Skipping order synchronization: Unauthenticated context.",
      );
      return;
    }

    // 2. 🛡️ FOOLPROOF OWNER VALIDATION: Purge cross-account collisions if detected
    final String? cachedOwner = _storage.read(_ownerStampKey);
    if (cachedOwner != null && cachedOwner != _currentOwnerId) {
      debugPrint(
        "[CACHE SECURITY]: Order owner mismatch detected! Purging cross-account cache collision.",
      );
      _storage.remove(_storageKey);
    }

    final List<dynamic>? cachedData = _storage.read(_storageKey);
    int highWatermarkTimestamp = 0;

    // Step 3: Push cached data directly into memory for instant UI loading
    if (cachedData != null && cachedData.isNotEmpty) {
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

    // Step 4: Establish the real-time delta synchronization hook
    _orderSubscription?.cancel();
    _orderSubscription = OrderCloudDb.instance
        .watchOrders(
          lastSyncTime: highWatermarkTimestamp,
          clientId: isStaff ? null : currentClient?.id,
        )
        .listen(
          (incomingDeltas) {
            if (incomingDeltas.isNotEmpty) {
              if (highWatermarkTimestamp == 0) {
                orders.assignAll(
                  incomingDeltas.map((order) => order.obs).toList(),
                );
              } else {
                for (var updatedOrder in incomingDeltas) {
                  final existingIndex = indexof(updatedOrder.id);

                  if (existingIndex != -1) {
                    orders[existingIndex].value = updatedOrder;
                  } else {
                    orders.add(updatedOrder.obs);
                  }
                }
              }

              orders.refresh();
              _saveToLocalDisk();
            }
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
    _storage.write(_ownerStampKey, _currentOwnerId);
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
