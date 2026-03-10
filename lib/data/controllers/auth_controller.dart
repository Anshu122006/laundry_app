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

  Rxn<UserType> userType = Rxn<UserType>();
  Rxn<Client> currentClient = Rxn<Client>();
  Rxn<Employee> currentEmployee = Rxn<Employee>();

  Future<void> onLogin(UserType userType, String email) async {
    if (userType == UserType.client) {
      Client? client = await ClientCloudDb.instance.getClient(email);
      currentClient.value = client;
      this.userType.value = UserType.client;

      await Future.wait([
        OrderController.initController(clientId: client?.id ?? ""),
        TransactionController.initController(clientId: client?.id ?? ""),
      ]);
    } else {
      Employee? employee = await EmployeeCloudDb.instance.getEmployee(email);
      currentEmployee.value = employee;
      this.userType.value =
          employee?.role.toLowerCase() == "admin"
              ? UserType.admin
              : UserType.employee;

      await Future.wait([
        OrderController.initController(),
        ClientController.initController(),
      ]);
      if (this.userType.value == UserType.admin) {
        await Future.wait([
          EmployeeController.initController(),
          TransactionController.initController(),
        ]);
      }
    }

    await Future.wait([
      PricingController.initController(),
      OfferController.initController(),
      WashTypeController.initController(),
      ContactController.initController(),
    ]);
  }

  Future<void> onLogout() async {
    final client = currentClient.value;
    if (client != null) {
      await ClientCloudDb.instance.removeFcmToken();
    }

    currentClient.value = null;
    currentEmployee.value = null;
    userType.value = null;

    Get.deleteAll();
    await GetStorage().erase();
  }
}

enum UserType { client, employee, admin }
