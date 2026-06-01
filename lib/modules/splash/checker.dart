import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/db_cloud/employee_cloud_db.dart';
import 'package:laundary_app/data/services/auth_services.dart';

const String kSavedEmail = "savedEmail";
const String kSavedUserType = "savedUserType";

class Checker {
  static final GetStorage box = GetStorage();

  static Future<void> handleUser() async {
    final savedEmail = box.read(kSavedEmail);
    final savedUserType = box.read(kSavedUserType);

    if (savedEmail == null || savedUserType == null) {
      Get.offAllNamed(AppRoutes.signin);
      return;
    }

    final user = AuthServices.instance.getCurrentUser();

    if (user == null) {
      await _forceLogout();
      return;
    }

    if (savedUserType == "client") {
      await _loginClient(user.email, true);
    } else {
      await _loginEmployee(user.email, true);
    }

    // Internet verification AFTER navigation
    hasInternet().then((online) async {
      if (online) {
        try {
          await user.reload();
        } catch (_) {}
      }
    });
  }

  // ---------------------------------------------------------
  // CLIENT LOGIN
  // ---------------------------------------------------------

  static Future<void> _loginClient(String email, bool online) async {
    try {
      await AuthController.instance.onLogin(UserType.client, email);

      box.write(kSavedEmail, email);
      box.write(kSavedUserType, "client");

      // Navigate immediately
      await Get.offAllNamed(AppRoutes.clientNav);

      // Refresh DB in background
      if (online) {
        ClientCloudDb.instance.getClient(email);
      }
    } on FirebaseException catch (e) {
      if (e.code == "permission-denied") {
        await _forceLogout();
      }
    }
  }

  // ---------------------------------------------------------
  // EMPLOYEE LOGIN
  // ---------------------------------------------------------

  static Future<void> _loginEmployee(String email, bool online) async {
    try {
      await AuthController.instance.onLogin(UserType.employee, email);

      box.write(kSavedEmail, email);
      box.write(kSavedUserType, "employee");

      await Get.offAllNamed(AppRoutes.employeeNav);

      if (online) {
        EmployeeCloudDb.instance.getEmployee(email);
      }
    } on FirebaseException catch (e) {
      if (e.code == "permission-denied") {
        await _forceLogout();
      }
    }
  }

  // ---------------------------------------------------------
  // FORCE LOGOUT
  // ---------------------------------------------------------

  static Future<void> _forceLogout() async {
    try {
      await AuthServices.instance.signoutFromFirebase();
      await box.erase();

      await Get.offAllNamed(AppRoutes.signin);
    } catch (_) {
      await Get.offAllNamed(AppRoutes.signin);
    }
  }

  // ---------------------------------------------------------
  // INTERNET CHECK
  // ---------------------------------------------------------

  static Future<bool> hasInternet() async {
    final connectivity = await Connectivity().checkConnectivity();
    return !connectivity.contains(ConnectivityResult.none);
  }
}
