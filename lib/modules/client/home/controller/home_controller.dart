import 'package:get/get.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/order_cloud_db.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/client/home/view/confirmation_screen.dart';

class ClientHomeScreenController extends GetxController {
  final isLoading = false.obs;
  Future placeOrder(String type) async {
    isLoading.value = true;
    try {
      if ((AuthController.instance.currentClient.value?.balance ?? 0) < 100) {
        CDeviceHelper.showDialog(
          title: "Error",
          message: "Insufficient balance",
          onConfirm: () {
            Get.back();
            Get.back();
          },
        );
        return;
      }
      LaundryOrder order = LaundryOrder(
        id: "",
        clientId: AuthController.instance.currentClient.value?.id ?? "",
        type: type,
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
      Get.off(() => OrderConfirmationScreen());
    } catch (e) {
      CDeviceHelper.showDialog(
        title: "Error",
        message: "Unexpected error occured",
        onConfirm: () {
          Get.back();
          Get.back();
        },
      );
    } finally {
      isLoading.value = false;
    }
  }
}
