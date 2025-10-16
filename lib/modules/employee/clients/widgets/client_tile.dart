import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/modules/employee/clients/controller/client_controller.dart';
import 'package:laundary_app/modules/employee/clients/view/client_details_screen.dart';

class ClientTile extends StatelessWidget {
  const ClientTile({super.key, required this.client, required this.index});

  final Client client;
  final int index;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientScreenController>();

    return InkWell(
      onTap: () => Get.to(() => ClientDetailsScreen(client: client)),
      child: ListTile(
        leading: Icon(Icons.person, color: CColors.grey, size: 28),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            client.name,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color:
                  CDeviceHelper.isDarkMode() ? CColors.white : CColors.darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "${client.hostel}     ${client.room}",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        trailing: IconButton(
          onPressed: () async {
            controller.launchDialer(client.phone);
          },
          icon: Icon(Icons.phone, color: CColors.grey, size: 28),
        ),
      ),
    );
  }
}
