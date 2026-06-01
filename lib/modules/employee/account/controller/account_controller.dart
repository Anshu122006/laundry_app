import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/employee_cloud_db.dart';
import 'package:laundary_app/data/models/employee.dart';
import 'package:laundary_app/data/services/auth_services.dart';

const String kSavedEmail = "savedEmail";
const String kSavedUserType = "savedUserType";

class EmployeeAccountController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    updateData();
  }

  RxString name = "".obs;
  RxString email = "".obs;
  RxString role = "".obs;
  RxString phone = "".obs;

  Rx<bool> showPassword = false.obs;

  void updateData() {
    Employee? employee = AuthController.instance.currentEmployee.value;
    name.value = employee?.name ?? "";
    email.value = employee?.email ?? "";
    role.value = employee?.role ?? "";
    phone.value = employee?.phone ?? "";
  }

  void toggleShowPassword() {
    showPassword.value = !showPassword.value;
  }

  Future<void> updateEmployeeData() async {
    try {
      final data = validateInputs();
      if (data["isvalid"]) {
        AuthController userdata = AuthController.instance;
        Employee employee = Employee(
          id: userdata.currentEmployee.value?.id ?? "",
          name: name.value,
          email: email.value,
          phone: phone.value,
          role: role.value,
          updatedAt: 0,
          deleted: false,
        );

        AuthController.instance.currentEmployee.value = employee;
        await EmployeeCloudDb.instance.updateEmployee(employee);
      } else {
        CDeviceHelper.showSnackbar("Error", data["error"], CIcons.errorCross);
      }
    } catch (e) {
      CDeviceHelper.showSnackbar(
        "Error",
        "unknown error occured",
        CIcons.errorCross,
      );
    }
  }

  Map<String, dynamic> validateInputs() {
    if (name.value == "") {
      return {"isvalid": false, "error": "Name can't be empty"};
    }
    if (email.value == "") {
      return {"isvalid": false, "error": "Email can't be empty"};
    }
    if (phone.value == "") {
      return {"isvalid": false, "error": "Phone number cant be empty "};
    }
    if (phone.value.length != 10) {
      return {"isvalid": false, "error": "Invalid phone number "};
    }

    return {"isvalid": true, "error": ""};
  }

  Future signout() async {
    try {
      await AuthServices.instance.signoutFromFirebase();
      await AuthController.instance.onLogout();

      final box = GetStorage();
      box.remove(kSavedEmail);
      box.remove(kSavedUserType);

      Get.offAllNamed(AppRoutes.signin, arguments: {"showMessage": true});
      await Future.delayed(Duration(seconds: 0));
    } catch (e) {
      // await Get.offAllNamed(AppRoutes.signin);
      await Future.delayed(Duration(seconds: 0));
      CDeviceHelper.showSnackbar("Error", e.toString(), CIcons.errorCross);
    }
  }
}
