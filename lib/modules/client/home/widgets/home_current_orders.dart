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
      List<LaundryOrder> todayOrders =
          OrderController.instance.orders
              .where((order) => CDateHelper.isToday(order.value.placedDate))
              .map((order) => order.value)
              .toList();
      todayOrders.sort((a, b) => b.status.value.compareTo(a.status.value));

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Text(
            "Today's Orders (${todayOrders.length})",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Transform.translate(
            offset: Offset(0, -20),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: todayOrders.length,
              itemBuilder:
                  (_, index) => OrderTile(
                    onTap: () async {
                      await Get.to(
                        () => OrderStatusScreen(order: todayOrders[index]),
                      );
                    },
                    order: todayOrders[index],
                  ),
            ),
          ),
        ],
      );
    });
  }
}
