import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/core/utils/formatters/formatter_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/common/order_details/controller/order_details_controller.dart';
import 'package:laundary_app/modules/common/order_details/widgets/details_helper.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderDetailsController>();
    bool canEdit = AuthController.instance.userType.value != UserType.client;
    bool isCancelled = controller.order.value.status == OrderStatus.cancelled;
    bool isDelivered = controller.order.value.status == OrderStatus.delivered;

    return Container(
      width: CDeviceHelper.getScreenWidth() * 0.82,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CColors.white.withAlpha(230),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (canEdit)
              Obx(() {
                final status = controller.order.value.status;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Status:  ${status.toShortString().toUpperCase()}",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CColors.secondaryColor,
                      ),
                    ),
                  ],
                );
              }),
            if (!canEdit)
              Obx(() {
                final status = controller.order.value.status;
                return Text(
                  MessageHelper.getMessage(status),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CColors.secondaryColor,
                  ),
                );
              }),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (canEdit && !isCancelled && !isDelivered) {
                      DetailsHelper.showDatePicker();
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Estimated delivery date",
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(color: CColors.secondaryColor),
                      ),
                      Obx(
                        () => Text(
                          CFormatter.getNamedDate(
                                controller.order.value.deliveryDate,
                              ) ??
                              "To be updated soon",
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(color: CColors.secondaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 80),
                Transform.translate(
                  offset: Offset(0, -15),
                  child: Icon(
                    FontAwesomeIcons.clock,
                    size: 45,
                    color: CColors.secondaryColor,
                  ),
                ),
              ],
            ),
          ],
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
        return "Your is ready, it will be delivered soon";
      case OrderStatus.delivered:
        return "Your order has been delivered successfully";
      case OrderStatus.cancelled:
        return "Your order was cancelled, check the contacts page for help";
    }
  }
}
