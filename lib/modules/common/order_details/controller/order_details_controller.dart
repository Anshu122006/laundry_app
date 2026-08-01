import 'dart:async';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/db_cloud/order_cloud_db.dart';
import 'package:laundary_app/data/db_cloud/transaction_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/data/models/transaction.dart';
import 'package:laundary_app/data/services/notification_service.dart';

class OrderDetailsController extends GetxController {
  OrderDetailsController(LaundryOrder initialOrder) : order = initialOrder.obs;

  final Rx<LaundryOrder> order;
  final RxBool hasUpdated = false.obs;
  Worker? _globalOrderWorker;

  @override
  void onInit() {
    super.onInit();
    // Bind the detail screen to listen to real-time sync updates from the parent cache stream
    _globalOrderWorker = ever(OrderController.instance.orders, (_) {
      final updatedRemoteOrder = OrderController.instance.getOrder(
        order.value.id,
      );
      if (updatedRemoteOrder != null) {
        order.value = updatedRemoteOrder;
      }
    });
  }

  Future<void> _persistOrderUpdate() async {
    try {
      await OrderCloudDb.instance.updateOrder(order.value);
    } catch (e) {
      CDeviceHelper.showSnackbar(
        "Error",
        "Some error occurred while updating order",
        CIcons.errorCross,
      );
    }
  }

  Future<void> updateStatus() async {
    final String agentId =
        AuthController.instance.currentEmployee.value?.id ?? "";

    switch (order.value.status) {
      case OrderStatus.pending:
        order.value = order.value.copyWith(
          status: OrderStatus.picked,
          statusBeforeCancelled: OrderStatus.picked,
          pickupAgentId: agentId,
          pickupDate: DateTime.now(),
        );
        await NotificationService.instance.sendNotification(
          order.value.clientId,
          "picked",
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
        await NotificationService.instance.sendNotification(
          order.value.clientId,
          "ready",
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
        return;
    }

    await _persistOrderUpdate();
  }

  Future<void> addDeliveryTransaction() async {
    final Client? client = ClientController.instance.getClient(
      order.value.clientId,
    );
    final int amount = order.value.cost - order.value.discount;
    final int bal = (client?.balance ?? 0) - amount;

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
        orderType: order.value.type,
        amount: amount.abs(),
        curBal: bal,
        client: client?.copyWith(balance: bal),
        date: DateTime.now(),
        updatedAt: DateTime.now().millisecondsSinceEpoch,
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

    final int bal = client?.balance ?? 0;
    final int amount = order.value.cost - order.value.discount;

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
        orderType: order.value.type,
        amount: amount.abs(),
        curBal: bal,
        client: client?.copyWith(balance: bal),
        date: DateTime.now(),
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    await _persistOrderUpdate();
  }

  Future<void> updateDeliveryDate(DateTime deliveryDate) async {
    order.value = order.value.copyWith(deliveryDate: deliveryDate);
    await _persistOrderUpdate();
  }

  Future<void> setClothes(int clothes) async {
    order.value = order.value.copyWith(clothes: clothes);
    await _persistOrderUpdate();
  }

  Future<void> setCost(int cost) async {
    order.value = order.value.copyWith(cost: cost);
    await _persistOrderUpdate();
  }

  Future<void> setDiscount(int discount) async {
    final int calculatedDiscount =
        (order.value.cost - discount > 0) ? discount : order.value.cost;
    order.value = order.value.copyWith(discount: calculatedDiscount);
    await _persistOrderUpdate();
  }

  @override
  void onClose() {
    _globalOrderWorker?.dispose();
    super.onClose();
  }
}
