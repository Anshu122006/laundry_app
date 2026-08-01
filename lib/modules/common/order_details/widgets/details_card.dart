import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/modules/common/order_details/controller/order_details_controller.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderDetailsController>();

    return Obx(() {
      final currentOrder = controller.order.value;
      final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');

      // Safely manage short ID generation
      final String shortId =
          currentOrder.id.length > 6
              ? currentOrder.id.substring(0, 6)
              : currentOrder.id;

      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order #$shortId",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: CColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      currentOrder.status.name.toUpperCase(),
                      style: TextStyle(
                        color: CColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildDetailRow("Clothes Count:", "${currentOrder.clothes} pcs"),
              _buildDetailRow("Service Type:", currentOrder.type),
              _buildDetailRow(
                "Placed Date:",
                formatter.format(currentOrder.placedDate),
              ),
              if (currentOrder.pickupDate != null)
                _buildDetailRow(
                  "Picked Date:",
                  formatter.format(currentOrder.pickupDate!),
                ),
              if (currentOrder.deliveryDate != null)
                _buildDetailRow(
                  "Delivery Date:",
                  formatter.format(currentOrder.deliveryDate!),
                ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Paid:",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    "\$${currentOrder.cost - currentOrder.discount}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: CColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
