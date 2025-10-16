import 'package:flutter/material.dart';
import 'package:laundary_app/shared/widgets/appbar.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';

class OrderStatusHeader extends StatelessWidget {
  const OrderStatusHeader({
    super.key,
    required this.orderId,
    required this.date,
  });
  final String orderId;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CAppBar(
          leading: CBackButton(),
          title: Column(
            children: [
              Text(
                "Order Status",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                "#$orderId. $date",
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.copyWith(fontSize: 14),
              ),
            ],
          ),
          titleOffset: 65,
          showDivider: true,
          height: 90,
        ),
      ],
    );
  }
}
