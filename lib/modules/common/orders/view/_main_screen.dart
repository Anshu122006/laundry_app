import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/client/order_status/view/_main_screen.dart';
import 'package:laundary_app/modules/common/orders/controller/orders_controller.dart';
import 'package:laundary_app/modules/common/orders/widgets/orders_header.dart';
import 'package:laundary_app/shared/widgets/order_tile.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderListController>();
    final liveOrders = OrderController.instance.orders;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return OrderListHeader.getHeader(context);
          },
          body: TabBarView(
            children: [
              // Tab 1: Pending Orders
              Obx(() {
                final filtered =
                    controller
                        .getFilteredOrders(liveOrders)
                        .where((order) => order.status == OrderStatus.pending)
                        .toList();
                return OrdersList(orders: filtered);
              }),

              // Tab 2: In-Progress Orders (Picked, Washing, Ready)
              Obx(() {
                final filtered =
                    controller.getFilteredOrders(liveOrders).where((order) {
                      // Direct enum index boundaries check safely handling runtime states
                      return order.status.index > OrderStatus.pending.index &&
                          order.status.index < OrderStatus.delivered.index;
                    }).toList();
                return OrdersList(orders: filtered);
              }),

              // Tab 3: Delivered Orders
              Obx(() {
                final filtered =
                    controller
                        .getFilteredOrders(liveOrders)
                        .where((order) => order.status == OrderStatus.delivered)
                        .toList();
                return OrdersList(orders: filtered);
              }),

              // Tab 4: Cancelled Orders
              Obx(() {
                final filtered =
                    controller
                        .getFilteredOrders(liveOrders)
                        .where((order) => order.status == OrderStatus.cancelled)
                        .toList();
                return OrdersList(orders: filtered);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  const OrdersList({super.key, required this.orders});

  final List<LaundryOrder> orders;

  @override
  Widget build(BuildContext context) {
    final isClient = AuthController.instance.currentClient.value != null;

    return Transform.translate(
      offset: const Offset(0, 0),
      child: ListView.builder(
        itemCount: orders.length,
        padding: const EdgeInsets.only(bottom: 30),
        itemBuilder: (_, index) {
          final targetOrder = orders[index];

          return OrderTile(
            order: targetOrder,
            onTap:
                isClient
                    ? () => Get.to(() => OrderStatusScreen(orderId: targetOrder.id))
                    : () => Get.toNamed(
                      AppRoutes.orderDetails,
                      arguments: targetOrder,
                    ),
          );
        },
      ),
    );
  }
}
