import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/transaction.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.textColor});

  final LaundryTransaction transaction;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    Client? client = transaction.client;
    String title =
        client != null
            ? "${client.name}  ${client.hostel}, ${client.room}"
            : "Unregistered user";
    String orderType =
        transaction.orderType != null && transaction.orderType != ""
            ? transaction.orderType!
            : "Not Set";
    String amount = "₹${transaction.amount.abs()}";
    String balance = "₹${client?.balance ?? 0}";
    String date = DateFormat("dd/MM/yyyy hh:mm a").format(transaction.date);
    if (transaction.type == "removed") {
      amount = "- $amount";
    } else if (transaction.type == "added") {
      amount = "+ $amount";
    }

    return ListTile(
      leading: Icon(Icons.receipt, size: 32, weight: 10, color: textColor),
      title: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              orderType,
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(color: textColor, fontSize: 14),
            ),
            Text(
              "Closing Balance: $balance",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  amount,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: textColor,
                    decoration:
                        transaction.type == "cancelled"
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                    decorationColor: textColor,
                  ),
                ),
                Text(
                  date,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium!.copyWith(color: textColor),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
