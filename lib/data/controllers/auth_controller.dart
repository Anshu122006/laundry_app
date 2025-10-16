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

  // Future<void> onLogin(UserType userType, String email) async {
  //   final isFresh = LocalDb.instance.isFreshDb;
  // String? clientId;

  //   if (userType == UserType.client) {
  // currentClient.value = await ClientCloudDb.instance.getClient(email);
  // this.userType.value = UserType.client;
  // clientId = currentClient.value?.id;
  //   } else if (userType == UserType.employee) {

  //     currentEmployee.value = await EmployeeCloudDb.instance.getEmployee(email);
  //     this.userType.value =
  //         currentEmployee.value?.role.toLowerCase() == "admin"
  //             ? UserType.admin
  //             : UserType.employee;

  //     if (isFresh) await ClientLocalDb.instance.syncWithCloud();

  //     await ClientController.initController();
  //     ClientCloudDb.instance.listenToChanges();

  //     if (currentEmployee.value?.role.toLowerCase() == "admin") {
  //       if (isFresh) await EmployeeLocalDb.instance.syncWithCloud();
  //       if (isFresh) await TransactionLocalDb.instance.syncWithCloud();

  //       await EmployeeController.initController();
  //       EmployeeCloudDb.instance.listenToChanges();

  //       await TransactionController.initController();
  //       TransactionCloudDb.instance.listenToChanges();
  //     }
  //   }
  //   if (isFresh) {
  //     await PricingLocalDb.instance.syncWithCloud();
  //     await OfferLocalDb.instance.syncWithCloud();
  //     await OrderLocalDb.instance.syncWithCloud(clientId: clientId);
  //   }

  //   await PricingController.initController();
  //   PricingCloudDb.instance.listenToChanges();

  //   await OfferController.initController();
  //   OfferCloudDb.instance.listenToChanges();

  //   await OrderController.initController();
  //   OrderCloudDb.instance.listenToChanges(clientId);

  //   await ContactController.initController();
  // }

  Future<void> onLogout() async {
    // await ClientCloudDb.instance.removeListner();
    // await EmployeeCloudDb.instance.removeListner();
    // await OrderCloudDb.instance.removeListner();
    // await OfferCloudDb.instance.removeListner();
    // await PricingCloudDb.instance.removeListner();
    // await TransactionCloudDb.instance.removeListner();

    // await LocalDb.instance.deleteDatabaseAndReinit();
    // await LocalDb.instance.ensureInitialized();

    Get.deleteAll();
    currentClient.value = null;
    currentEmployee.value = null;
    userType.value = null;

    await GetStorage().erase();
  }

  // Future<void> syncData() async {
  //   if (userType.value == null) return;

  //   final box = GetStorage();
  //   final int lastSyncTime = box.read("last_sync_time") ?? 0;
  //   final now = DateTime.now();
  //   final startOfToday =
  //       DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;

  //   if (lastSyncTime > startOfToday) return;

  //   if (userType.value == UserType.client) {
  //     await OrderLocalDb.instance.syncWithCloud(
  //       clientId: currentClient.value?.id ?? "",
  //     );
  //   } else if (userType.value == UserType.employee) {
  //     await OrderLocalDb.instance.syncWithCloud();
  //     await ClientLocalDb.instance.syncWithCloud();
  //   } else {
  //     await OrderLocalDb.instance.syncWithCloud();
  //     await ClientLocalDb.instance.syncWithCloud();
  //     await EmployeeLocalDb.instance.syncWithCloud();
  //   }

  //   await PricingLocalDb.instance.syncWithCloud();
  //   await OfferLocalDb.instance.syncWithCloud();

  //   await TransactionLocalDb.instance.syncWithCloud();

  //   box.write("last_sync_time", DateTime.now().millisecondsSinceEpoch);
  // }
}

enum UserType { client, employee, admin }
