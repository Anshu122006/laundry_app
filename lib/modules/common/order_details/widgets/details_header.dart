import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/data/models/order.dart';

class OrderDetailsHeader extends StatelessWidget {
  const OrderDetailsHeader({super.key, required this.order});

  final LaundryOrder order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Get.back(result: true),
            icon: Icon(Icons.arrow_back, color: CColors.white),
          ),
          Text(
            " Details About",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: CColors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: " #",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: CColors.white),
                ),
                TextSpan(
                  text: order.id,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: CColors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
