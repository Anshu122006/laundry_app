import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/data/services/notification_service.dart';
import 'package:laundary_app/data/db_cloud/order_cloud_db.dart';

class OrderDetailsController extends GetxController {
  final String orderId;
  OrderDetailsController(this.orderId);

  // Screen-isolated loading state for button spinners
  final RxBool isLoading = false.obs;

  // ─── ALIGNED MASTER LOOKUPS ────────────────────────────────────────────────

  /// Dynamically extracts the exact reactive wrapper instance out of the master list.
  /// Reading this inside an Obx creates a direct reactive link to the master stream.
  Rx<LaundryOrder>? get rxOrder => OrderController.instance.orders
      .firstWhereOrNull((o) => o.value.id == orderId);

  /// Provides a safe fallback object for structural property builds.
  LaundryOrder get order => rxOrder?.value ?? LaundryOrder.empty();

  // ─── MUTATIONS THROUGH MASTER ENGINE ───────────────────────────────────────

  Future<void> setClothes(int count) async {
    final current = order;
    if (current.id.isNotEmpty) {
      current.clothes = count;
      await _applyMasterUpdate(current);
    }
  }

  Future<void> setCost(int cost) async {
    final current = order;
    if (current.id.isNotEmpty) {
      current.cost = cost;
      await _applyMasterUpdate(current);
    }
  }

  Future<void> setDiscount(int discount) async {
    final current = order;
    if (current.id.isNotEmpty) {
      current.discount = discount;
      await _applyMasterUpdate(current);
    }
  }

  Future<void> setDeliveryDate(DateTime date) async {
    final current = order;
    if (current.id.isNotEmpty) {
      current.deliveryDate = date;
      await _applyMasterUpdate(current);
    }
  }

  // Maps statuses that warrant a client push notification to their type string.
  // washing is intentionally excluded to avoid notification fatigue.
  static const _notifiableStatuses = {
    OrderStatus.picked: 'order_picked',
    OrderStatus.ready: 'order_ready',
    OrderStatus.delivered: 'order_delivered',
  };

  Future<void> updateStatus() async {
    final current = order;
    if (current.id.isEmpty) return;

    bool updateSuccessful = false;

    try {
      isLoading.value = true;

      // Determine next phase based on status progression helper
      final nextStatus = _getNextStatus(current.status);
      current.status = nextStatus;

      // Update local cache and cloud DB for order status
      await _applyMasterUpdate(current);
      updateSuccessful = true;
    } catch (e) {
      Get.snackbar(
        "Status Error",
        "Failed to update order phase on the cloud.",
      );
    } finally {
      isLoading.value = false;
    }

    // Attempt push notification in background after successful update
    if (updateSuccessful) {
      final notificationType = _notifiableStatuses[current.status];
      if (notificationType != null) {
        try {
          // Fetch client instance from ClientController by ID
          final client = ClientController.instance.getClient(current.clientId);

          await NotificationService.instance.sendNotification(
            current.clientId,
            notificationType,
            fcmTokens: client?.fcmTokens,
          );
        } catch (_) {
          // Non-blocking catch to prevent UI alerts if notification delivery fails
        }
      }
    }
  }

  Future<void> cancelOrder() async {
    final current = order;
    if (current.id.isEmpty) return;

    try {
      isLoading.value = true;
      current.status = OrderStatus.cancelled;

      await _applyMasterUpdate(current);
    } catch (e) {
      Get.snackbar(
        "Cancellation Error",
        "Failed to cancel order on the cloud.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Private helper that triggers the master controller's pipeline to update
  /// UI bindings, refresh listeners, and write to local disk cache automatically.
  Future<void> _applyMasterUpdate(LaundryOrder updatedOrder) async {
    OrderController.instance.updateOrder(updatedOrder);
    await _syncWithBackend(updatedOrder);
  }

  Future<void> _syncWithBackend(LaundryOrder updatedOrder) async {
    try {
      await OrderCloudDb.instance.updateOrder(updatedOrder);
    } catch (e) {
      Get.snackbar("Sync Warning", "Saved locally, but server sync failed.");
    }
  }

  OrderStatus _getNextStatus(OrderStatus current) {
    switch (current) {
      case OrderStatus.pending:
        return OrderStatus.picked;
      case OrderStatus.picked:
        return OrderStatus.washing;
      case OrderStatus.washing:
        return OrderStatus.ready;
      case OrderStatus.ready:
        return OrderStatus.delivered;
      default:
        return current;
    }
  }
}
