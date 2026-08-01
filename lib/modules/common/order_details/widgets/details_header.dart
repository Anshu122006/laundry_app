import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/modules/common/order_details/controller/order_details_controller.dart';

class OrderDetailsHeader extends StatelessWidget {
  const OrderDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderDetailsController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: CColors.white),
          ),
          Text(
            " Details About",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: CColors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          Obx(() {
            final String fullId = controller.order.value.id;
            final String displayId =
                fullId.length > 6 ? fullId.substring(0, 6) : fullId;

            return RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: " Order",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: CColors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: " #",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(color: CColors.white),
                  ),
                  TextSpan(
                    text: displayId,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: CColors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
