import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/employee/home/controller/home_controller.dart';
import 'package:laundary_app/modules/employee/home/widgets/home_order_tile.dart';

class EmployeeCurrentOrders extends StatelessWidget {
  const EmployeeCurrentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    // Locate the lifecycle instance outside the builder loop for better performance
    final controller = Get.find<EmployeeHomeController>();

    return Obx(() {
      // Retain the live List<Rx<LaundryOrder>> reference so individual tiles can safely bind streams
      final List<Rx<LaundryOrder>> liveOrders = controller.recentOrders;

      if (liveOrders.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "No active orders for today.",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: liveOrders.length,
        itemBuilder: (_, index) {
          // Pass the dynamic rx variable directly into the tile implementation
          final rxOrder = liveOrders[index];

          // Inside HomeOrderTile, ensure fields are wrapped in Obx() to capture changes
          return HomeOrderTile(order: rxOrder.value);
        },
      );
    });
  }
}
