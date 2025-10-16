import 'package:get/get.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/services/auth_services.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';

class ClientAuthController extends GetxController {
  RxString name = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString hostel = "".obs;
  RxString room = "".obs;

  var isLoading = false.obs;

  // sign in to account
  Future<void> signin() async {
    isLoading.value = true;
    try {
      await AuthServices.instance.signInWithGoogle();
      final user = AuthServices.instance.getCurrentUser();
      Client? client = await ClientCloudDb.instance.getClient(user.email);

      if (client == null) {
        email.value = user.email;
        name.value = user.displayName;
        isLoading.value = false;

        Get.toNamed(AppRoutes.signup);
        Future.delayed(Duration(milliseconds: 300), () {
          CDeviceHelper.showSnackbar(
            "Welcome",
            "Welcome to Maa Laundry",
            CIcons.welcome,
          );
        });
      } else {
        await AuthController.instance.onLogin(UserType.client, user.email);

        Get.offAllNamed(AppRoutes.clientNav);
        Future.delayed(Duration(milliseconds: 300), () {
          CDeviceHelper.showSnackbar(
            "Success",
            "Signed in successfully",
            CIcons.successCheck,
          );
        });
      }
    } catch (e) {
      CDeviceHelper.showSnackbar(
        "Error",
        "Some error occured while trying to sign-in",
        // e.toString(),
        CIcons.errorCross,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future signup() async {
    isLoading.value = true;
    try {
      final data = validateInputs();
      if (data["isvalid"]) {
        final client = Client(
          id: "",
          name: name.value,
          email: email.value,
          phone: phone.value,
          hostel: hostel.value,
          room: room.value,
          balance: 0.0,
          updatedAt: 0,
          deleted: false,
        );

        await ClientCloudDb.instance.addClient(client, true);
        await AuthController.instance.onLogin(UserType.client, email.value);

        Get.offAllNamed(AppRoutes.clientNav);
      } else {
        CDeviceHelper.showSnackbar("Error", data["error"], CIcons.errorCross);
      }
    } catch (e) {
      CDeviceHelper.showSnackbar(
        "Error",
        "Some error occured while trying to sign-up",
        // e.toString(),
        CIcons.errorCross,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> validateInputs() {
    if (name.value == "") {
      return {"isvalid": false, "error": "Name can't be empty"};
    }
    if (email.value == "") {
      return {"isvalid": false, "error": "Email can't be empty"};
    }
    if (hostel.value == "") {
      return {"isvalid": false, "error": "Hostel name can't be empty"};
    }
    if (room.value == "") {
      return {"isvalid": false, "error": "Room number can't be empty"};
    }
    if (phone.value == "") {
      return {"isvalid": false, "error": "Phone number cant be empty "};
    }
    if (phone.value.length != 10) {
      return {"isvalid": false, "error": "Invalid phone number "};
    }

    return {"isvalid": true, "error": ""};
  }

  // Future<void> handleCurrentUser() async {
  //   final user = AuthServices.instance.getCurrentUser();
  //   if (user != null) {
  //     Client? client = await ClientCloudDb.instance.getClient(user.email);
  //     if (client != null) {
  //       await AuthController.instance.onLogin(UserType.client, user.email);
  //       await Get.offAllNamed(AppRoutes.clientNav);
  //     } else {
  //       await AuthServices.instance.signoutFromGoogle();
  //       await AuthServices.instance.signoutFromFirebase();

  //       final employeeController = Get.find<EmployeeAuthController>();
  //       await employeeController.handleCurrentUser();

  //       return;
  //       // await Get.offAllNamed(AppRoutes.signin);
  //     }
  //   } else {
  //     await Get.offAllNamed(AppRoutes.signin);
  //   }
  // }
}
