// import 'package:firebase_messaging/firebase_messaging.dart';
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

      await OrderController.initController(clientId: client?.id ?? "");
      await TransactionController.initController(clientId: client?.id ?? "");

      // if (client != null) {
      //   final FirebaseMessaging messaging = FirebaseMessaging.instance;
      //   await messaging.requestPermission();

      //   final String? token = await messaging.getToken();
      //   final box = GetStorage();
      //   box.write("fcmToken", token);

      //   final List<String> fcmTokens = List<String>.from(client.fcmTokens);
      //   if (token != null && !fcmTokens.contains(token)) {
      //     fcmTokens.add(token);
      //     await ClientCloudDb.instance.updateClient(
      //       clientId: client.id,
      //       fcmTokens: fcmTokens,
      //     );
      //     // print("FCM TOKEN: $token");
      //   }
      // }
    } else {
      Employee? employee = await EmployeeCloudDb.instance.getEmployee(email);
      currentEmployee.value = employee;
      this.userType.value =
          employee?.role.toLowerCase() == "admin"
              ? UserType.admin
              : UserType.employee;

      await OrderController.initController();
      await ClientController.initController();

      if (this.userType.value == UserType.admin) {
        await EmployeeController.initController();
        await TransactionController.initController();
      }
    }

    await PricingController.initController();
    await OfferController.initController();
    await WashTypeController.initController();
    await ContactController.initController();
  }

  Future<void> onLogout() async {
    // final client = currentClient.value;
    // final box = GetStorage();
    // final token = box.read('fcmToken');

    // final fcmTokens = List<String>.from(client?.fcmTokens ?? []);
    // fcmTokens.remove(token);

    // if (client != null && token != null) {
    //   await ClientCloudDb.instance.updateClient(
    //     clientId: client.id,
    //     room: "210 B1",
    //     fcmTokens: fcmTokens,
    //   );
    // }

    currentClient.value = null;
    currentEmployee.value = null;
    userType.value = null;

    Get.deleteAll();
    await GetStorage().erase();
  }
}

enum UserType { client, employee, admin }
