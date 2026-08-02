import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/common/order_details/controller/order_details_controller.dart';
import 'details_helper.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key, required this.order});

  final LaundryOrder order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderDetailsController>();
    final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
    final bool isClient =
        AuthController.instance.userType.value == UserType.client;

    // Direct configuration settings based on order current lifecycle state
    final bool canEditOrder =
        !isClient &&
        order.status != OrderStatus.delivered &&
        order.status != OrderStatus.cancelled;

    final String shortId =
        order.id.length > 6 ? order.id.substring(0, 6) : order.id;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      elevation: 3,
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #$shortId",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: CColors.primaryColor.withAlpha(70),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status.name.toUpperCase(),
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

            // ─── CLOTHES COUNT FIELD ─────────────────────────────────────────
            InkWell(
              onTap:
                  canEditOrder
                      ? () => Get.bottomSheet(
                        NumericEditBottomSheet(
                          title: "Clothes",
                          hintText: "Enter clothes amount",
                          initialValue: order.clothes,
                          onConfirm: (val) {
                            final parsedVal =
                                int.tryParse(val.toString()) ?? order.clothes;
                            controller.setClothes(parsedVal);
                          },
                        ),
                      )
                      : null,
              child: _buildDetailRow(
                "Clothes Count:",
                "${order.clothes} pcs",
                isEditable: canEditOrder,
              ),
            ),

            _buildDetailRow("Service Type:", order.type),
            _buildDetailRow("Placed Date:", formatter.format(order.placedDate)),
            if (order.pickupDate != null)
              _buildDetailRow(
                "Picked Date:",
                formatter.format(order.pickupDate!),
              ),
            if (order.deliveryDate != null)
              _buildDetailRow(
                "Delivery Date:",
                formatter.format(order.deliveryDate!),
              ),
            const Divider(height: 24),

            // ─── BASE COST FIELD ─────────────────────────────────────────────
            InkWell(
              onTap:
                  canEditOrder
                      ? () => Get.bottomSheet(
                        NumericEditBottomSheet(
                          title: "Cost",
                          hintText: "Enter cost value",
                          initialValue: order.cost,
                          onConfirm: (val) {
                            final parsedVal =
                                int.tryParse(val.toString()) ??
                                order.cost.toInt();
                            controller.setCost(parsedVal);
                          },
                        ),
                      )
                      : null,
              child: _buildDetailRow(
                "Base Cost:",
                "₹${order.cost}",
                isEditable: canEditOrder,
              ),
            ),

            // ─── DISCOUNT FIELD ──────────────────────────────────────────────
            InkWell(
              onTap:
                  canEditOrder
                      ? () => Get.bottomSheet(
                        NumericEditBottomSheet(
                          title: "Discount",
                          hintText: "Enter discount value",
                          initialValue: order.discount,
                          onConfirm: (val) {
                            final parsedVal =
                                int.tryParse(val.toString()) ??
                                order.discount.toInt();
                            controller.setDiscount(parsedVal);
                          },
                        ),
                      )
                      : null,
              child: _buildDetailRow(
                "Discount:",
                "-₹${order.discount}",
                isEditable: canEditOrder,
              ),
            ),
            const Divider(height: 24),

            // ─── CALCULATED DYNAMIC TOTAL ────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Paid:",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  "₹${order.cost - order.discount}",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isEditable = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Label + Optional Edit Icon (Fixed)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isEditable) ...[
                const SizedBox(width: 4),
                const Icon(Icons.edit, size: 14, color: Colors.grey),
              ],
            ],
          ),
          // Buffer space between label and value
          const SizedBox(width: 16),

          // Right Side: Scrollable Value (Takes remaining space and pushes to right)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse:
                  true, // Automatically keeps the text right-aligned when short
              child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
