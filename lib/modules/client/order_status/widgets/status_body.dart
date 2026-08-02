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

  /// Pure mapping function to translate states to explicit 1-5 step counts
  int _getLiveStepCount() {
    // Only look at historical cancellation state if the order is currently cancelled
    final activeStatus =
        (status == OrderStatus.cancelled)
            ? (statusBeforeCancelled ?? OrderStatus.pending)
            : status;

    switch (activeStatus) {
      case OrderStatus.pending:
        return 1;
      case OrderStatus.picked:
        return 2;
      case OrderStatus.washing:
        return 3;
      case OrderStatus.ready:
        return 4;
      case OrderStatus.delivered:
        return 5;
      case OrderStatus.cancelled:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CProgressIndicator(
          totalSteps: 5,
          curSteps:
              _getLiveStepCount(),
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
        const SizedBox(height: 5),
        Text(
          StatusHelper.getMessageSubtitle(status),
          style: Theme.of(
            context,
          ).textTheme.labelLarge!.copyWith(color: CColors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.timelapse, color: CColors.grey),
            const SizedBox(width: 10),
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
        const SizedBox(height: 60),
      ],
    );
  }
}
