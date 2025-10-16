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

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return OrderListHeader.getHeader(context);
          },
          body: TabBarView(
            children: [
              Obx(() {
                final allOrders =
                    OrderController.instance.orders
                        .map((o) => o.value)
                        .toList();
                final orders =
                    controller
                        .getFilteredPricings(allOrders)
                        .where((order) => order.status == OrderStatus.pending)
                        .map((order) => order)
                        .toList();

                return OrdersList(orders: orders);
              }),
              Obx(() {
                final allOrders =
                    OrderController.instance.orders
                        .map((o) => o.value)
                        .toList();
                final orders =
                    controller
                        .getFilteredPricings(allOrders)
                        .where(
                          (order) =>
                              order.status.value > 1 && order.status.value < 5,
                        )
                        .map((order) => order)
                        .toList();

                return OrdersList(orders: orders);
              }),
              Obx(() {
                final allOrders =
                    OrderController.instance.orders
                        .map((o) => o.value)
                        .toList();
                final orders =
                    controller
                        .getFilteredPricings(allOrders)
                        .where((order) => order.status == OrderStatus.delivered)
                        .map((order) => order)
                        .toList();

                return OrdersList(orders: orders);
              }),
              Obx(() {
                final allOrders =
                    OrderController.instance.orders
                        .map((o) => o.value)
                        .toList();
                final orders =
                    controller
                        .getFilteredPricings(allOrders)
                        .where((order) => order.status == OrderStatus.cancelled)
                        .map((order) => order)
                        .toList();

                return OrdersList(orders: orders);
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
    bool isClient = AuthController.instance.currentClient.value != null;

    return Transform.translate(
      offset: Offset(0, -25),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (_, index) {
          return OrderTile(
            onTap:
                isClient
                    ? () =>
                        Get.to(() => OrderStatusScreen(order: orders[index]))
                    : () => Get.toNamed(
                      AppRoutes.orderDetails,
                      arguments: orders[index],
                    ),
            order: orders[index],
          );
        },
      ),
    );
  }
}
