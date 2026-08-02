import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/formatters/formatter_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/common/order_details/controller/order_details_controller.dart';
import 'package:laundary_app/modules/common/order_details/widgets/details_helper.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.order});

  final LaundryOrder order;

  @override
  Widget build(BuildContext context) {
    // Locate the active detail coordinator
    final controller = Get.find<OrderDetailsController>();
    
    final bool canEdit =
        AuthController.instance.userType.value != UserType.client;
    final bool isCancelled = order.status == OrderStatus.cancelled;
    final bool isDelivered = order.status == OrderStatus.delivered;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      elevation: 3,
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (canEdit)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Status:  ${order.status.name.toUpperCase()}",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: CColors.secondaryColor,
                          ),
                    ),
                  ],
                ),
              if (!canEdit)
                Text(
                  MessageHelper.getMessage(order.status),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CColors.secondaryColor,
                      ),
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (canEdit && !isCancelled && !isDelivered) {
                        // Trigger the updated utility using master architectural bindings
                        await DetailsHelper.selectDeliveryDate(
                          context: context,
                          initialDate: order.deliveryDate ?? DateTime.now(),
                          onDateSelected: (selectedDate) {
                            controller.setDeliveryDate(selectedDate);
                          },
                        );
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Estimated delivery date",
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(color: CColors.secondaryColor),
                            ),
                            if (canEdit && !isCancelled && !isDelivered) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.edit, size: 12, color: Colors.grey),
                            ]
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CFormatter.getNamedDate(order.deliveryDate) ??
                              "To be updated soon",
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(color: CColors.secondaryColor),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -4),
                    child: Icon(
                      FontAwesomeIcons.clock,
                      size: 40,
                      color: CColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageHelper {
  MessageHelper._();

  static String getMessage(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return "Your order has been placed, our agent will pick it soon";
      case OrderStatus.picked:
        return "Your order has been picked, please stand by";
      case OrderStatus.washing:
        return "Your order is now washing";
      case OrderStatus.ready:
        return "Your order is ready, it will be delivered soon";
      case OrderStatus.delivered:
        return "Your order has been delivered successfully";
      case OrderStatus.cancelled:
        return "Your order was cancelled, check the contacts page for help";
    }
  }
}