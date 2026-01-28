import 'package:get/get.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/db_cloud/order_cloud_db.dart';
import 'package:laundary_app/data/db_cloud/transaction_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/data/models/transaction.dart';

class OrderDetailsController extends GetxController {
  OrderDetailsController(LaundryOrder initialOrder) : order = initialOrder.obs;

  Rx<LaundryOrder> order;
  final RxBool hasUpdated = false.obs;

  Future<void> updateOrder(bool back) async {
    try {
      await OrderCloudDb.instance.updateOrder(order.value);
    } catch (e) {
      CDeviceHelper.showSnackbar(
        "Error",
        "Some error occured while updating order",
        CIcons.errorCross,
      );
    }
    if (back) Get.back();
  }

  Future<void> updateStatus() async {
    String agentId = AuthController.instance.currentEmployee.value?.id ?? "";

    switch (order.value.status) {
      case OrderStatus.pending:
        order.value = order.value.copyWith(
          status: OrderStatus.picked,
          statusBeforeCancelled: OrderStatus.picked,
          pickupAgentId: agentId,
          pickupDate: DateTime.now(),
        );
        break;
      case OrderStatus.picked:
        order.value = order.value.copyWith(
          status: OrderStatus.washing,
          statusBeforeCancelled: OrderStatus.washing,
        );
        break;
      case OrderStatus.washing:
        order.value = order.value.copyWith(
          status: OrderStatus.ready,
          statusBeforeCancelled: OrderStatus.ready,
        );
        break;
      case OrderStatus.ready:
        order.value = order.value.copyWith(
          status: OrderStatus.delivered,
          statusBeforeCancelled: OrderStatus.delivered,
          deliveryDate: DateTime.now(),
          deliverAgentId: agentId,
        );
        break;
      default:
    }

    order.refresh();
    if (order.value.status == OrderStatus.delivered) {
      await updateOrder(true);
    } else {
      await updateOrder(false);
    }
  }

  Future<void> addDeliveryTransaction() async {
    Client? client = ClientController.instance.getClient(order.value.clientId);
    int amount = order.value.cost - order.value.discount;
    int bal = (client?.balance ?? 0) - amount;

    if (client != null) {
      await ClientCloudDb.instance.updateClient(
        clientId: client.id,
        balance: bal,
      );
    }

    await TransactionCloudDb.instance.addTransaction(
      LaundryTransaction(
        id: "",
        type: "removed",
        amount: amount.abs(),
        curBal: bal,
        client: client?.copyWith(balance: bal),
        date: DateTime.now(),
        updatedAt: 0,
        deleted: false,
      ),
    );
  }

  Future<void> cancelOrder() async {
    order.value = order.value.copyWith(
      status: OrderStatus.cancelled,
      statusBeforeCancelled: order.value.status,
    );

    Client? client;
    if (AuthController.instance.userType.value == UserType.client) {
      client = AuthController.instance.currentClient.value;
    } else {
      client = ClientController.instance.getClient(order.value.clientId);
    }
    int bal = client?.balance ?? 0;
    int amount = order.value.cost - order.value.discount;

    if (client != null) {
      await ClientCloudDb.instance.updateClient(
        clientId: client.id,
        balance: bal,
      );
    }

    await TransactionCloudDb.instance.addTransaction(
      LaundryTransaction(
        id: "",
        type: "cancelled",
        amount: amount.abs(),
        curBal: bal,
        client: client?.copyWith(balance: bal),
        date: DateTime.now(),
        updatedAt: 0,
        deleted: false,
      ),
    );
    await updateOrder(true);
  }

  Future<void> updateDeliveryDate(DateTime deliveryDate) async {
    order.value = order.value.copyWith(deliveryDate: deliveryDate);
    await updateOrder(false);
  }

  Future<void> setClothes(int clothes) async {
    order.value.clothes = clothes;
    await updateOrder(false);
  }

  Future<void> setCost(int cost) async {
    order.value.cost = cost;
    await updateOrder(false);
  }

  Future<void> setDiscount(int discount) async {
    if (order.value.cost - discount > 0) {
      order.value.discount = discount;
    } else {
      order.value.discount = order.value.cost;
    }
    await updateOrder(false);
  }

  // void updateItems(List<String> name, List<int> amount) {
  //   // final updatedItems = Map<String, int>.from(order.value.orderTypeCounts);

  //   for (int i = 0; i < name.length; i++) {
  //     if (amount[i] > 0) {
  //       updatedItems[name[i]] = amount[i];
  //     } else if (order.value.orderTypeCounts.containsKey(name[i])) {
  //       updatedItems.remove(name[i]);
  //     }
  //   }

  //   order.value = order.value.copyWith(orderTypeCounts: updatedItems);
  //   hasUpdated.value = true;
  // }
}
