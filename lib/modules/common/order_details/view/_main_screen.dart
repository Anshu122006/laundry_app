import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/common/order_details/controller/order_details_controller.dart';
import 'package:laundary_app/modules/common/order_details/widgets/details_background.dart';
import 'package:laundary_app/modules/common/order_details/widgets/details_card.dart';
import 'package:laundary_app/modules/common/order_details/widgets/details_header.dart';
import 'package:laundary_app/modules/common/order_details/widgets/details_message_card.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderDetailsController>();
    final bool canEdit =
        AuthController.instance.userType.value != UserType.client;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Positioned.fill(child: OrderDetailsBackground()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        OrderDetailsHeader(),
                        const SizedBox(height: 30),
                        Center(child: DetailsCard()),
                        const SizedBox(height: 20),
                        Center(child: MessageCard()),
                        const SizedBox(height: 15),
                        Obx(() {
                          final currentStatus = controller.order.value.status;
                          final isTerminalState =
                              currentStatus == OrderStatus.delivered ||
                              currentStatus == OrderStatus.cancelled;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: canEdit ? 10 : 160,
                            children: [
                              if (!isTerminalState && canEdit)
                                SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await controller.updateStatus();
                                      if (controller.order.value.status ==
                                          OrderStatus.delivered) {
                                        await controller
                                            .addDeliveryTransaction();
                                      }
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CColors.light,
                                    ),
                                    child: Text(
                                      StatusHelper.getButtonText(currentStatus),
                                      style: TextStyle(
                                        color: CColors.secondaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              if (!isTerminalState)
                                SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await controller.cancelOrder();
                                      Get.back();
                                    },
                                    child: const Text("Cancel Order"),
                                  ),
                                ),
                            ],
                          );
                        }),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class StatusHelper {
  StatusHelper._();

  static String getButtonText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return "Set picked";
      case OrderStatus.picked:
        return "Set washing";
      case OrderStatus.washing:
        return "Set ready";
      case OrderStatus.ready:
        return "Set delivered";
      default:
        return "";
    }
  }
}
