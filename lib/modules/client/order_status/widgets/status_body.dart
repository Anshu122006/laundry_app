import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/client/order_status/widgets/status_helper.dart';
import 'package:laundary_app/shared/widgets/progress_indicator.dart';

class OrderStatusBody extends StatelessWidget {
  const OrderStatusBody({
    super.key,
    required this.status,
    this.statusBeforeCancelled,
    required this.daysLeft,
  });
  final OrderStatus status;
  final OrderStatus? statusBeforeCancelled;
  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CProgressIndicator(
          totalSteps: 5,
          curSteps: (statusBeforeCancelled ?? status).value,
          radius: 14,
          isCancelled: status == OrderStatus.cancelled,
        ),
        Image(
          image: AssetImage(StatusHelper.getStatusImage(status)),
          height: 350,
          width: 350,
        ),
        Text(
          StatusHelper.getMessageTitle(status),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 5),
        Text(
          StatusHelper.getMessageSubtitle(status),
          style: Theme.of(
            context,
          ).textTheme.labelLarge!.copyWith(color: CColors.grey),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Icon(Icons.timelapse, color: CColors.grey),
            Text(
              daysLeft > 0
                  ? "finish in $daysLeft days"
                  : "delivery date will be updated soon",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.w300,
                color: CColors.grey,
              ),
            ),
          ],
        ),
        SizedBox(height: 60),
      ],
    );
  }
}
