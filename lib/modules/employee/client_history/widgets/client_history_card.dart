import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/modules/employee/client_history/controller/client_history_controller.dart'; // Adjust path
import 'package:laundary_app/shared/widgets/transaction_tile.dart';

class ClientHistoryCard extends StatelessWidget {
  const ClientHistoryCard({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context) {
    // Dynamically inject the controller instance specific to this clientId tag
    final controller = Get.put(
      ClientHistoryController(clientId: clientId),
      tag: clientId, // Unique tag prevents multi-client profile conflicts
    );

    return Container(
      width: CDeviceHelper.getScreenWidth() * 0.95,
      padding: const EdgeInsets.only(bottom: 20, left: 3, right: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: CColors.white.withAlpha(230),
      ),
      child: Obx(() {
        // Safe check using the controller's reactive properties
        if (controller.hasNoHistory) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text(
                "No transaction history found.",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: CColors.darkGrey),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              controller.clientTransactions.length,
              (index) => TransactionTile(
                transaction: controller.clientTransactions[index],
                textColor: CColors.darkGrey,
              ),
            ),
          ),
        );
      }),
    );
  }
}
