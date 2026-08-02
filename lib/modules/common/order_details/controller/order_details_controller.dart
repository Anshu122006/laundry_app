import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/data/models/order.dart';

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

  void setClothes(int count) {
    final current = order;
    if (current.id.isNotEmpty) {
      current.clothes = count;
      _applyMasterUpdate(current);
    }
  }

  void setCost(int cost) {
    final current = order;
    if (current.id.isNotEmpty) {
      current.cost = cost;
      _applyMasterUpdate(current);
    }
  }

  void setDiscount(int discount) {
    final current = order;
    if (current.id.isNotEmpty) {
      current.discount = discount;
      _applyMasterUpdate(current);
    }
  }

  void setDeliveryDate(DateTime date) {
    final current = order;
    if (current.id.isNotEmpty) {
      current.deliveryDate = date;
      _applyMasterUpdate(current);
    }
  }

  Future<void> updateStatus() async {
    final current = order;
    if (current.id.isEmpty) return;

    try {
      isLoading.value = true;

      // Determine next phase based on your status helper progression
      final nextStatus = _getNextStatus(current.status);
      current.status = nextStatus;

      // Leverage the master controller to handle UI refresh and cache updates instantly
      _applyMasterUpdate(current);
    } catch (e) {
      Get.snackbar(
        "Status Error",
        "Failed to update order phase on the cloud.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder() async {
    final current = order;
    if (current.id.isEmpty) return;

    try {
      isLoading.value = true;
      current.status = OrderStatus.cancelled;

      _applyMasterUpdate(current);
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
  void _applyMasterUpdate(LaundryOrder updatedOrder) {
    OrderController.instance.updateOrder(updatedOrder);
    _syncWithBackend(updatedOrder);
  }

  Future<void> _syncWithBackend(LaundryOrder updatedOrder) async {
    try {
      // await OrderCloudDb.instance.syncOrderDetails(updatedOrder.toMap());
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
