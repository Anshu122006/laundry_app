import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/employee/clients/view/client_details_screen.dart';

class HomeOrderTile extends StatelessWidget {
  const HomeOrderTile({super.key, required this.order});
  final LaundryOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: CColors.lightGrey, width: 1),
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "#${order.id.length > 4 ? order.id.substring(0, 4) : order.id}...\n",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: order.status.toShortString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                Get.to(() => ClientDetailsScreen(clientId: order.clientId));
              },
              // Wrap with Obx so the profile properties (like name changes or corrections)
              // render in real-time inside the order history list.
              child: Obx(() {
                final clientIndex = ClientController.instance.indexof(
                  order.clientId,
                );
                final client =
                    clientIndex != -1
                        ? ClientController.instance.clients[clientIndex].value
                        : null;

                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${client?.name ?? "Loading..."}\n",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text:
                            "(${client?.hostel ?? ""}  ${client?.room ?? ""})\n",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Today\n${DateFormat("hh:mm a").format(order.placedDate)}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                onPressed:
                    () => Get.toNamed(AppRoutes.orderDetails, arguments: order),
                child: const Text("Check\nStatus", textAlign: TextAlign.center),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
