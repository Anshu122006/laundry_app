import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/modules/employee/client_history/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/clients/widgets/update_balace.dart';
import 'package:laundary_app/shared/widgets/property.dart';

class ClientDetailsCard extends StatelessWidget {
  const ClientDetailsCard({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    // bool isAdmin = AuthController.instance.userType.value == UserType.admin;
    Client client = ClientController.instance.clients[index].value;
    TextStyle propertyStyle = Theme.of(
      context,
    ).textTheme.labelLarge!.copyWith(fontSize: 17, color: CColors.black);

    return Container(
      // height: CDeviceHelper.getScreenHeight() * 0.49,
      width: CDeviceHelper.getScreenWidth() * 0.87,
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: CColors.white.withAlpha(230),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Client Details",
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall!.copyWith(color: CColors.black),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.bottomSheet(
                        UpdateClientBalance(
                          client:
                              ClientController.instance.clients[index].value,
                          add: true,
                        ),
                        isScrollControlled: true,
                        isDismissible: true,
                      );
                    },
                    icon: Icon(Icons.add, color: CColors.darkGrey, size: 20),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.bottomSheet(
                        UpdateClientBalance(
                          client:
                              ClientController.instance.clients[index].value,
                          add: false,
                        ),
                        isScrollControlled: true,
                        isDismissible: true,
                      );
                    },
                    icon: Icon(Icons.remove, color: CColors.darkGrey, size: 20),
                  ),
                ],
              ),
            ],
          ),
          CProperty(name: "Name", value: client.name, style: propertyStyle),
          CProperty(name: "Email", value: client.email, style: propertyStyle),
          CProperty(name: "Hostel", value: client.hostel, style: propertyStyle),
          CProperty(name: "Room", value: client.room, style: propertyStyle),
          CProperty(
            name: "Phone",
            value:
                "+91 ${ClientController.instance.clients[index].value.phone}",
            style: propertyStyle,
          ),
          SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Wallet Balance: ",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: CColors.darkGrey,
                ),
              ),

              Obx(
                () => Text(
                  "₹${ClientController.instance.clients[index].value.balance}",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: CColors.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => ClientHistoryScreen(clientId: client.id));
                },
                child: Text("History"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
