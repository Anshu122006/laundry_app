import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/shared/widgets/property.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, this.onTap, required this.order});

  final LaundryOrder order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Client? client;
    if (AuthController.instance.userType.value != UserType.client) {
      client = ClientController.instance.getClient(order.clientId);
    } else {
      client = AuthController.instance.currentClient.value;
    }

    return InkWell(
      onTap: onTap,
      splashColor: CColors.lightGrey,
      child: ListTile(
        leading: Icon(
          FontAwesomeIcons.basketShopping,
          color: CColors.brown,
          size: 25,
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: CDeviceHelper.getScreenWidth() * 0.7,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${client?.name ?? ""} (${client?.hostel ?? ""}, ${client?.room ?? ""})",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    order.type,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CProperty(
                name: "status",
                value: order.status.toShortString(),
                style: Theme.of(context).textTheme.labelMedium!,
              ),
              Text(
                DateFormat("dd/MM/yyyy, hh:mm a").format(order.placedDate),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
