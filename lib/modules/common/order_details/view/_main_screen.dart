import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
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
    final detailsController = Get.find<OrderDetailsController>();
    final orderController = Get.find<OrderController>();

    // Extract the orderId passed from the previous screen
    final String orderId = Get.arguments as String;

    final bool canEdit =
        AuthController.instance.userType.value != UserType.client;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(() {
            // Read index and stream updates directly from the global OrderController
            final index = orderController.indexof(orderId);

            if (index == -1) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            final order = orderController.orders[index].value;
            final processing = detailsController.isLoading.value;
            final isTerminalState =
                order.status == OrderStatus.delivered ||
                order.status == OrderStatus.cancelled;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      const Positioned.fill(child: OrderDetailsBackground()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          OrderDetailsHeader(order: order),
                          const SizedBox(height: 30),
                          Center(child: DetailsCard(order: order)),
                          const SizedBox(height: 20),
                          Center(child: MessageCard(order: order)),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (!isTerminalState && canEdit)
                                SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed:
                                        processing
                                            ? null
                                            : () async {
                                              await detailsController
                                                  .updateStatus();
                                              if (!detailsController
                                                  .isLoading
                                                  .value) {
                                                Get.back();
                                              }
                                            },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CColors.light,
                                    ),
                                    child:
                                        processing
                                            ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(CColors.secondaryColor),
                                              ),
                                            )
                                            : Text(
                                              StatusHelper.getButtonText(
                                                order.status,
                                              ),
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
                                    onPressed:
                                        processing
                                            ? null
                                            : () async {
                                              await detailsController
                                                  .cancelOrder();
                                              if (!detailsController
                                                  .isLoading
                                                  .value) {
                                                Get.back();
                                              }
                                            },
                                    child:
                                        processing
                                            ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                            : const Text("Cancel Order"),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
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
