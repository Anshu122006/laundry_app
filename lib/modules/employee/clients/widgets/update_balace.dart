import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/db_cloud/transaction_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/transaction.dart';

class UpdateClientBalance extends StatelessWidget {
  const UpdateClientBalance({
    super.key,
    required this.client,
    required this.add,
  });

  final Client client;
  final bool add;

  @override
  Widget build(BuildContext context) {
    TextEditingController balance = TextEditingController();
    balance.text = "";

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${add ? "Add" : "Remove"} Amount",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: balance,
              decoration: InputDecoration(
                hintText: "Enter amount to be ${add ? "added" : "removed"}",
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  int amount =
                      (int.tryParse(balance.text) ?? 0) * (add ? 1 : -1);
                  int newBalance = client.balance + amount;

                  Get.back();
                  await ClientCloudDb.instance.updateClient(
                    client.copyWith(balance: newBalance),
                  );
                  await TransactionCloudDb.instance.addTransaction(
                    LaundryTransaction(
                      id: "",
                      type: amount >= 0 ? "added" : "removed",
                      amount: amount.abs(),
                      curBal: newBalance,
                      client: client.copyWith(balance: newBalance),
                      date: DateTime.now(),
                      updatedAt: 0,
                      deleted: false,
                    ),
                  );
                },
                child: Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
