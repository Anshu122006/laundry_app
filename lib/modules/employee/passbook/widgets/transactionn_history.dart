import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/transaction_controller.dart';
import 'package:laundary_app/data/models/transaction.dart';
import 'package:laundary_app/modules/employee/passbook/controller/passbook_controller.dart';
import 'package:laundary_app/shared/widgets/transaction_tile.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            "Transaction History",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Obx(() {
          final controller = Get.find<PassbookScreenController>();
          int start = controller.startDate.value.millisecondsSinceEpoch;
          int end =
              controller.endDate.value
                  .add(Duration(days: 1))
                  .millisecondsSinceEpoch;
          Iterable<LaundryTransaction> transactions = TransactionController
              .instance
              .transactions
              .map((t) => t.value);
          List<LaundryTransaction> transactionsInRange =
              transactions
                  .where(
                    (t) =>
                        t.date.millisecondsSinceEpoch >= start &&
                        t.date.millisecondsSinceEpoch <= end,
                  )
                  .toList();
          transactionsInRange.sort((a, b) => b.date.compareTo(a.date));

          return Transform.translate(
            offset: Offset(0, -10),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: transactionsInRange.length,
              itemBuilder:
                  (_, index) =>
                      TransactionTile(transaction: transactionsInRange[index]),
            ),
          );
        }),
      ],
    );
  }
}
