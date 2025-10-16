import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/transaction_controller.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/models/transaction.dart';
import 'package:laundary_app/shared/widgets/transaction_tile.dart';

class ClientHistoryCard extends StatelessWidget {
  const ClientHistoryCard({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CDeviceHelper.getScreenWidth() * 0.95,
      padding: EdgeInsets.only(bottom: 40, left: 3, right: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: CColors.white.withAlpha(230),
      ),
      child: Obx(() {
        List<LaundryTransaction> transactions =
            TransactionController.instance.transactions
                .map((t) => t.value)
                .where((t) => t.client?.id == clientId)
                .toList();
        transactions.sort((a, b) => b.date.compareTo(a.date));

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder:
                (context, index) => TransactionTile(
                  transaction: transactions[index],
                  textColor: CColors.darkGrey,
                ),
          ),
        );
      }),
    );
  }
}
