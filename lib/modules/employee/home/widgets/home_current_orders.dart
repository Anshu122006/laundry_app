import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/modules/employee/home/controller/home_controller.dart';
import 'package:laundary_app/modules/employee/home/widgets/home_order_tile.dart';

class EmployeeCurrentOrders extends StatelessWidget {
  const EmployeeCurrentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<EmployeeHomeController>();
      final recentOrders = controller.recentOrders.map((o) => o.value).toList();

      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: recentOrders.length,
        itemBuilder: (_, index) {
          final order = recentOrders[index];
          return HomeOrderTile(order: order);
        },
      );
    });
  }
}
