import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/modules/employee/passbook/controller/passbook_controller.dart';

class AddAmountBottomSheet extends StatelessWidget {
  const AddAmountBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PassbookScreenController>();
    double amount = 0.0;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
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
              "Add Expenditure",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
              decoration: InputDecoration(hintText: "Enter expenditure amount"),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.back();

                  await controller.addAmount(amount);
                },
                child: const Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
