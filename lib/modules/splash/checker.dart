import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/db_cloud/employee_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/employee.dart';
import 'package:laundary_app/data/services/auth_services.dart';

class Checker {
  static Future<void> handleUser() async {
    try {
      final user = AuthServices.instance.getCurrentUser();
      if (user != null) {
        Client? client = await ClientCloudDb.instance.getClient(user.email);
        if (client != null) {
          await AuthController.instance.onLogin(UserType.client, user.email);
          await Get.offAllNamed(AppRoutes.clientNav);
        } else {
          if (!user.emailVerified) {
            await Get.offAllNamed(AppRoutes.signin);
            return;
          }

          Employee? employee = await EmployeeCloudDb.instance.getEmployee(
            user.email,
          );
          if (employee != null) {
            await AuthController.instance.onLogin(
              UserType.employee,
              user.email,
            );
            await Get.offAllNamed(AppRoutes.employeeNav);
          } else {
            await AuthServices.instance.signoutFromGoogle();
            await AuthServices.instance.signoutFromFirebase();

            await Get.offAllNamed(AppRoutes.signin);
          }
        }
      } else {
        await Get.offAllNamed(AppRoutes.signin);
      }
    } catch (e) {
      await AuthServices.instance.signoutFromGoogle();
      await AuthServices.instance.signoutFromFirebase();

      Get.offAllNamed(AppRoutes.signin);
      Future.delayed(Duration(milliseconds: 300), () {
        CDeviceHelper.showSnackbar("Error", e.toString(), CIcons.errorCross);
      });
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
