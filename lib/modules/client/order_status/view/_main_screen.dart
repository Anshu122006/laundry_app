import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/core/utils/formatters/formatter_utility.dart';
import 'package:laundary_app/core/utils/helpers/helpers.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/client/order_status/widgets/status_body.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';
import 'package:laundary_app/modules/client/order_status/widgets/status_header.dart';
import 'package:laundary_app/core/constants/colors.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({super.key, required this.order});
  final LaundryOrder order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OrderStatusHeader(
                orderId: order.id,
                date: CFormatter.getNamedDate(order.placedDate)!,
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap:
                    () => Get.toNamed(AppRoutes.orderDetails, arguments: order),
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
              SizedBox(height: 10),
              CLineDivider(),
              SizedBox(height: 30),
              OrderStatusBody(
                status: order.status,
                statusBeforeCancelled: order.statusBeforeCancelled,
                daysLeft: CDateHelper.getRemainingDays(order.deliveryDate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
