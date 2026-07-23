import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/modules/common/order_details/controller/balance_controller.dart';

class UpdateClientBalance extends StatelessWidget {
  UpdateClientBalance({
    super.key,
    required this.client,
    required this.add,
  });

  final Client client;
  final bool add;

  final ClientBalanceController controller = Get.put(ClientBalanceController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
              "${add ? "Add" : "Remove"} Amount",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            // Obx wrapper to disable text field input while loading
            Obx(() => TextField(
                  controller: controller.balanceController,
                  enabled: !controller.isLoading.value,
                  decoration: InputDecoration(
                    hintText: "Enter amount to be ${add ? "added" : "removed"}",
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                )),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Obx(() {
                final loading = controller.isLoading.value;
                
                return ElevatedButton(
                  // Disables the button immediately upon click by returning null
                  onPressed: loading 
                      ? null 
                      : () => controller.updateBalance(client: client, add: add),
                  child: loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Confirm"),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}