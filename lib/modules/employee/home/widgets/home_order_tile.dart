import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/employee/clients/view/client_details_screen.dart';

class HomeOrderTile extends StatelessWidget {
  const HomeOrderTile({super.key, required this.order});
  final LaundryOrder order;

  @override
  Widget build(BuildContext context) {
    Client? client = ClientController.instance.getClient(order.clientId);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: CColors.lightGrey, width: 1),
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Expanded(
            flex: 2,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "#${order.id.substring(0, 4)}...\n",
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
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                Get.to(()=>ClientDetailsScreen(client: client!,));
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${client?.name ?? ""}\n",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "(${client?.hostel ?? ""}  ${client?.room ?? ""})\n",
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
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: ElevatedButton(
                onPressed:
                    () => Get.toNamed(AppRoutes.orderDetails, arguments: order),
                child: Text("Check\nStatus"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
