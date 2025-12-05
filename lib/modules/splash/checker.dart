import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/db_cloud/employee_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/employee.dart';
import 'package:laundary_app/data/services/auth_services.dart';

const String kSavedEmail = "savedEmail";
const String kSavedUserType = "savedUserType";

class Checker {
  static Future<void> handleUser() async {
    try {
      final box = GetStorage();
      final savedEmail = box.read(kSavedEmail);
      final savedUserType = box.read(kSavedUserType);

      // If we have a saved session locally, try restoring it first
      if (savedEmail != null && savedUserType != null) {
        await AuthController.instance.onLogin(
          savedUserType == "client" ? UserType.client : UserType.employee,
          savedEmail,
        );

        if (savedUserType == "client") {
          await Get.offAllNamed(AppRoutes.clientNav);
          return;
        } else {
          await Get.offAllNamed(AppRoutes.employeeNav);
          return;
        }
      }

      // If nothing is saved locally, fall back to Firebase current user
      await Future.delayed(Duration(milliseconds: 300));
      final user = AuthServices.instance.getCurrentUser();

      if (user == null) {
        await Get.offAllNamed(AppRoutes.signin);
        return;
      }

      // CLIENT CHECK
      Client? client = await ClientCloudDb.instance.getClient(user.email);
      if (client != null) {
        await AuthController.instance.onLogin(UserType.client, user.email);
        box.write(kSavedEmail, user.email);
        box.write(kSavedUserType, "client");
        await Get.offAllNamed(AppRoutes.clientNav);
        return;
      }

      // For employees, verify email unless it's your override
      if (user.email != "anshu2006dev@gmail.com" && !user.emailVerified) {
        await Get.offAllNamed(AppRoutes.signin);
        return;
      }

      // EMPLOYEE CHECK
      Employee? employee = await EmployeeCloudDb.instance.getEmployee(
        user.email,
      );
      if (employee != null) {
        await AuthController.instance.onLogin(UserType.employee, user.email);
        box.write(kSavedEmail, user.email);
        box.write(kSavedUserType, "employee");
        await Get.offAllNamed(AppRoutes.employeeNav);
        return;
      }

      // If nothing matches, sign out
      await AuthServices.instance.signoutFromGoogle();
      await AuthServices.instance.signoutFromFirebase();
      await Get.offAllNamed(AppRoutes.signin);
    } catch (e) {
      await AuthServices.instance.signoutFromGoogle();
      await AuthServices.instance.signoutFromFirebase();
      Get.offAllNamed(AppRoutes.signin);

      Future.delayed(
        const Duration(milliseconds: 300),
        () => CDeviceHelper.showSnackbar(
          "Error",
          e.toString(),
          CIcons.errorCross,
        ),
      );
    }
  }

  static Future<bool> hasInternetConncted() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      return !connectivityResult.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }
}
