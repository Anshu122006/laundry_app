import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/size_values.dart';
import 'package:laundary_app/modules/client/navigation_menu/controller/navigationmenu_controller.dart';

class ClientNavigationMenu extends StatelessWidget {
  const ClientNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientNaveMenuController>();

    return Scaffold(
      bottomNavigationBar: Obx(() {
        if (!Get.isRegistered<ClientNaveMenuController>()) return SizedBox();

        return NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.setCurrentPage,
          height: CSizes.navBarHeight,
          elevation: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.house),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.boxOpen),
              label: "Orders",
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
