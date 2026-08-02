import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/core/utils/formatters/formatter_utility.dart';
import 'package:laundary_app/core/utils/helpers/helpers.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/modules/client/order_status/widgets/status_body.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';
import 'package:laundary_app/modules/client/order_status/widgets/status_header.dart';
import 'package:laundary_app/core/constants/colors.dart';

class OrderStatusScreen extends StatelessWidget {
  OrderStatusScreen({super.key, required this.orderId});
  final String orderId;
  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Obx(() {
            final int existingIndex = orderController.indexof(orderId);

            if (existingIndex == -1) {
              return const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }

            final liveOrder = orderController.orders[existingIndex].value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 3),
                OrderStatusHeader(
                  orderId: liveOrder.id,
                  date: CFormatter.getNamedDate(liveOrder.placedDate) ?? '',
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    // Await the route completion to see if changes occurred
                    final result = await Get.toNamed(
                      AppRoutes.orderDetails,
                      arguments: liveOrder.id,
                    );

                    // If your controller requires an explicit data refresh call when coming back:
                    if (result == true) {
                      // orderController.refreshOrder(orderId); // Uncomment if manual fetch is required
                    }
                  },
                  child: Text(
                    "ORDER DETAILS",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      color:
                          CDeviceHelper.isDarkMode()
                              ? CColors.white
                              : CColors.secondaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CLineDivider(),
                const SizedBox(height: 30),
                OrderStatusBody(
                  status: liveOrder.status,
                  statusBeforeCancelled: liveOrder.statusBeforeCancelled,
                  daysLeft: CDateHelper.getRemainingDays(
                    liveOrder.deliveryDate,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
