import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/size_values.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/modules/employee/navigation_menu/controller/navigationmenu_controller.dart';

class EmployeeNavigationMenu extends StatelessWidget {
  const EmployeeNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeNavMenuController>();
    final userdata = AuthController.instance;

    return Scaffold(
      bottomNavigationBar: Obx(() {
        if (!Get.isRegistered<EmployeeNavMenuController>()) return SizedBox();

        return NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.setCurrentPage,
          height: CSizes.navBarHeight,
          elevation: 0,
          destinations: [
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.house),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.boxOpen),
              label: "Orders",
            ),
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.userTag),
              label: "Clients",
            ),
            if (userdata.userType.value == UserType.admin)
              NavigationDestination(
                icon: Icon(FontAwesomeIcons.userTie),
                label: "Employees",
              ),
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.userGear),
              label: "Account",
            ),
          ],
        );
      }),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}
