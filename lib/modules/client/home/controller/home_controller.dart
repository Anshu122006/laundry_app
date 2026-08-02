import 'package:get/get.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/order_cloud_db.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/client/home/view/confirmation_screen.dart';

class ClientHomeScreenController extends GetxController {
  final RxBool isLoading = false.obs;

  Future<void> placeOrder(String type) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      final currentClient = AuthController.instance.currentClient.value;
      final int balance = currentClient?.balance ?? 0;

      if (balance < 100) {
        CDeviceHelper.showDialog(
          title: "Error",
          message: "Insufficient balance to place a new laundry request.",
          onConfirm: () => Get.back(),
        );
        return;
      }

      final LaundryOrder order = LaundryOrder(
        id: "",
        clientId: currentClient?.id ?? "",
        type: type,
        placedDate: DateTime.now(),
        status: OrderStatus.pending,
        statusBeforeCancelled: OrderStatus.pending,
        clothes: 0,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        discount: 0,
        cost: 0,
      );

      await OrderCloudDb.instance.addOrder(order);
      Get.off(() => const OrderConfirmationScreen());
    } catch (e) {
      CDeviceHelper.showDialog(
        title: "Order Failed",
        message: "An unexpected error occurred while placing your order. Please try again.",
        onConfirm: () => Get.back(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
