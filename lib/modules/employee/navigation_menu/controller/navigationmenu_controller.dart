import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/modules/common/orders/controller/orders_controller.dart';
import 'package:laundary_app/modules/employee/account/controller/account_controller.dart';
import 'package:laundary_app/modules/employee/account/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/clients/controller/client_controller.dart';
import 'package:laundary_app/modules/employee/clients/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/employees/controller/employee_controller.dart';
import 'package:laundary_app/modules/employee/employees/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/home/controller/home_controller.dart';
import 'package:laundary_app/modules/employee/home/view/_main_screen.dart';
import 'package:laundary_app/modules/common/orders/view/_main_screen.dart';

class EmployeeNavMenuController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    bool isAdmin = AuthController.instance.userType.value == UserType.admin;
    if (isAdmin) screens.add(EmployeeListScreen());
    screens.add(EmployeeAccountScreen());
    setCurrentPage(0);
  }

  Rx<int> selectedIndex = 0.obs;
  List<Widget> screens = [
    EmployeeHomeScreen(),
    OrdersScreen(),
    ClientsListScreen(),
  ];

  void setCurrentPage(int index) {
    selectedIndex.value = index;
    bool isAdmin = AuthController.instance.userType.value == UserType.admin;

    switch (index) {
      case 0:
        if (!Get.isRegistered<EmployeeHomeController>()) {
          Get.lazyPut(() => EmployeeHomeController(), fenix: true);
        }
        break;
      case 1:
        if (!Get.isRegistered<OrderListController>()) {
          Get.lazyPut(() => OrderListController(), fenix: true);
        }
        break;
      case 2:
        if (!Get.isRegistered<ClientScreenController>()) {
          Get.lazyPut(() => ClientScreenController(), fenix: true);
        }
        break;
      case 3:
        if (!Get.isRegistered<EmployeeScreenController>()) {
          if (isAdmin) {
            Get.lazyPut(() => EmployeeScreenController(), fenix: true);
          } else {
            Get.lazyPut(() => EmployeeAccountController(), fenix: true);
          }
        }
        break;
      case 4:
        if (!Get.isRegistered<EmployeeAccountController>() && isAdmin) {
          Get.lazyPut(() => EmployeeAccountController(), fenix: true);
        }
        break;
    }
  }
}
