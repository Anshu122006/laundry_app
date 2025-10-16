import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/modules/client/account/controller/account_controller.dart';
import 'package:laundary_app/modules/client/account/view/_main_screen.dart';
import 'package:laundary_app/modules/client/home/controller/home_controller.dart';
import 'package:laundary_app/modules/client/home/view/_main_screen.dart';
import 'package:laundary_app/modules/common/orders/controller/orders_controller.dart';
import 'package:laundary_app/modules/common/orders/view/_main_screen.dart';

class ClientNaveMenuController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    setCurrentPage(0);
  }

  Rx<int> selectedIndex = 0.obs;
  List<Widget> screens = [
    ClientHomeScreen(),
    OrdersScreen(),
    ClientAccountScreen(),
  ];

  void setCurrentPage(int index) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        if (!Get.isRegistered<ClientHomeScreenController>()) {
          Get.lazyPut(() => ClientHomeScreenController(), fenix: true);
        }
        break;
      case 1:
      if (!Get.isRegistered<OrderListController>()) {
          Get.lazyPut(() => OrderListController(), fenix: true);
        }
        break;
      case 2:
        if (!Get.isRegistered<ClientAccountController>()) {
          Get.lazyPut(() => ClientAccountController(), fenix: true);
        }
        break;
    }
  }
}
