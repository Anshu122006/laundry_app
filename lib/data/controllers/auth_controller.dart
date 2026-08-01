import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/controllers/contact_controller.dart';
import 'package:laundary_app/data/controllers/employee_controller.dart';
import 'package:laundary_app/data/controllers/offer_controller.dart';
import 'package:laundary_app/data/controllers/order_controller.dart';
import 'package:laundary_app/data/controllers/pricing_controller.dart';
import 'package:laundary_app/data/controllers/transaction_controller.dart';
import 'package:laundary_app/data/controllers/wash_type_controller.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/db_cloud/employee_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/employee.dart';

class AuthController extends GetxController {
  static AuthController get instance {
    return Get.find<AuthController>();
  }

  final Rxn<UserType> userType = Rxn<UserType>();
  final Rxn<Client> currentClient = Rxn<Client>();
  final Rxn<Employee> currentEmployee = Rxn<Employee>();

  Future<void> onLogin(UserType userType, String email) async {
    if (userType == UserType.client) {
      Client? client = await ClientCloudDb.instance.getClient(email);
      currentClient.value = client;
      this.userType.value = UserType.client;

      // Spin up the Delta Sync streams for client scopes
      await Future.wait([
        OrderController.initController(),
        TransactionController.initController(),
      ]);
    } else {
      Employee? employee = await EmployeeCloudDb.instance.getEmployee(email);
      currentEmployee.value = employee;

      final determinatedType =
          employee?.role.toLowerCase() == "admin"
              ? UserType.admin
              : UserType.employee;

      this.userType.value = determinatedType;

      await Future.wait([
        OrderController.initController(),
        ClientController.initController(),
      ]);

      if (determinatedType == UserType.admin) {
        await Future.wait([
          EmployeeController.initController(),
          TransactionController.initController(),
        ]);
      }
    }

    // Initialize static configuration systems
    await Future.wait([
      PricingController.initController(),
      OfferController.initController(),
      WashTypeController.initController(),
      ContactController.initController(),
    ]);
  }

  Future<void> onLogout() async {
    // 1. Terminate push notifications cleanly
    final client = currentClient.value;
    if (client != null) {
      try {
        await ClientCloudDb.instance.removeFcmToken();
      } catch (_) {
        // Suppress network errors during logout flow to avoid hard locks
      }
    }

    // 2. Clear out state parameters
    currentClient.value = null;
    currentEmployee.value = null;
    userType.value = null;

    // 3. Delete dependencies (Triggers internal StreamSubscription cancels safely)
    Get.deleteAll();

    // 4. Wipe high-speed Delta Sync storage caches
    await GetStorage().erase();
  }
}

enum UserType { client, employee, admin }
