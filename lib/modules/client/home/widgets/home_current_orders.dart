import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/utils/helpers/helpers.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/client/order_status/view/_main_screen.dart';
import 'package:laundary_app/shared/widgets/order_tile.dart';

class CurrentOrders extends StatelessWidget {
  const CurrentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 1. Maintain a list of Rx<LaundryOrder> wrappers to keep the nodes reactive
      final List<Rx<LaundryOrder>> todayRxOrders =
          OrderController.instance.orders
              .where((order) => CDateHelper.isToday(order.value.placedDate))
              .toList();

      // 2. Sort safely reading values on the fly
      todayRxOrders.sort(
        (a, b) => b.value.status.value.compareTo(a.value.status.value),
      );

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Text(
            "Today's Orders (${todayRxOrders.length})",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: todayRxOrders.length,
              itemBuilder: (_, index) {
                final rxOrder = todayRxOrders[index];

                // 3. Wrap the OrderTile in Obx so it updates when this specific order modifies
                return Obx(
                  () => OrderTile(
                    onTap:
                        () => Get.to(
                          () => OrderStatusScreen(orderId: rxOrder.value.id),
                        ),
                    order: rxOrder.value, // Pass down the inner state safely
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
