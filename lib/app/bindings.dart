import 'package:get/get.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/client/navigation_menu/controller/navigationmenu_controller.dart';
import 'package:laundary_app/modules/client/wallet/controller/wallet_screen_controller.dart';
import 'package:laundary_app/modules/common/auth/controller/client_auth_controller.dart';
import 'package:laundary_app/modules/common/auth/controller/employee_auth_controller.dart';
import 'package:laundary_app/modules/common/order_details/controller/order_details_controller.dart';
import 'package:laundary_app/modules/common/orders/controller/orders_controller.dart';
import 'package:laundary_app/modules/common/pricing/controller/pricing_controller.dart';
import 'package:laundary_app/modules/employee/navigation_menu/controller/navigationmenu_controller.dart';
import 'package:laundary_app/modules/employee/passbook/controller/passbook_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientAuthController>(() => ClientAuthController());
    Get.lazyPut<EmployeeAuthController>(() => EmployeeAuthController());
  }
}

class ClientNavMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientNaveMenuController>(() => ClientNaveMenuController());
  }
}

class ClientWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletScreenController>(() => WalletScreenController());
  }
}

class EmployeeNavMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeNavMenuController>(() => EmployeeNavMenuController());
  }
}

class AdminPassbookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassbookScreenController>(() => PassbookScreenController());
  }
}

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderListController>(() => OrderListController());
  }
}

class PricingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PricingScreenController>(() => PricingScreenController());
  }
}

class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    final LaundryOrder order = Get.arguments as LaundryOrder;
    Get.lazyPut<OrderDetailsController>(() => OrderDetailsController(order));
  }
}

