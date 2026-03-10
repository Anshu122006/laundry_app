import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/core/utils/logging/logger.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/services/auth_services.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';

const String kSavedEmail = "savedEmail";
const String kSavedUserType = "savedUserType";

class ClientAuthController extends GetxController {
  RxString name = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString hostel = "".obs;
  RxString room = "".obs;

  var isLoading = false.obs;

  Future<void> signin() async {
    isLoading.value = true;
    AppLogger.logInfo("Login started");
    try {
      await AuthServices.instance.signInWithGoogle();
      final user = AuthServices.instance.getCurrentUser();
      Client? client = await ClientCloudDb.instance.getClient(user.email);

      if (client == null) {
        email.value = user.email;
        name.value = user.displayName;
        isLoading.value = false;

        AppLogger.logInfo("Signup needed");
        await Get.toNamed(AppRoutes.signup);
        await Future.delayed(Duration(milliseconds: 300), () {
          CDeviceHelper.showSnackbar(
            "Welcome",
            "Welcome to Maa Laundry",
            CIcons.welcome,
          );
        });
      } else {
        final box = GetStorage();
        box.write(kSavedEmail, user.email);
        box.write(kSavedUserType, "client");
        AppLogger.logInfo("Stored credentials locally");

        await AuthController.instance.onLogin(UserType.client, user.email);
        AppLogger.logInfo("Auth controller initialized");

        await navigateToHomeScreen();
        await Future.delayed(Duration(milliseconds: 300), () {
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
          balance: 0,
          updatedAt: 0,
          deleted: false,
          // fcmTokens: [],
        );

        await ClientCloudDb.instance.addClient(client, true);

        final box = GetStorage();
        box.write(kSavedEmail, email.value);
        box.write(kSavedUserType, "client");

        await AuthController.instance.onLogin(UserType.client, email.value);

        await navigateToHomeScreen();
      } else {
        CDeviceHelper.showSnackbar("Error", data["error"], CIcons.errorCross);
      }
    } catch (e) {
      CDeviceHelper.showSnackbar(
        "Error",
        "Some error occured while trying to sign-up",
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
      return {"isvalid": false, "error": "Phone number cant be empty"};
    }
    if (phone.value.length != 10) {
      return {"isvalid": false, "error": "Invalid phone number"};
    }
    return {"isvalid": true, "error": ""};
  }

  Future<void> handleCurrentUser() async {
    isLoading.value = true;
    final box = GetStorage();
    final savedEmail = box.read(kSavedEmail);
    final savedType = box.read(kSavedUserType);

    try {
      if (savedEmail == null || savedType != "client") {
        isLoading.value = false;
        await Get.offAllNamed(AppRoutes.signin);
        return;
      }

      await Future.delayed(Duration(milliseconds: 300));
      final user = AuthServices.instance.getCurrentUser();

      bool firebaseOk = true;
      try {
        await user.getCurrentUser()?.reload();
      } catch (_) {
        firebaseOk = false;
      }

      if (!firebaseOk) {
        isLoading.value = false;

        CDeviceHelper.showSnackbar(
          "No Internet",
          "Waiting for connection...",
          CIcons.errorCross,
        );

        await Get.toNamed(AppRoutes.reloadScreen);
        return;
      }

      final refreshedUser = AuthServices.instance.getCurrentUser();

      if (refreshedUser == null) {
        box.remove(kSavedEmail);
        box.remove(kSavedUserType);

        isLoading.value = false;
        await Get.offAllNamed(AppRoutes.signin);

        CDeviceHelper.showSnackbar(
          "Error",
          "Your session expired. Please sign in again.",
          CIcons.errorCross,
        );
        return;
      }

      Client? client = await ClientCloudDb.instance.getClient(
        refreshedUser.email,
      );

      if (client == null) {
        box.remove(kSavedEmail);
        box.remove(kSavedUserType);

        await AuthServices.instance.signoutFromGoogle();
        await AuthServices.instance.signoutFromFirebase();

        isLoading.value = false;
        await Get.offAllNamed(AppRoutes.signin);
        return;
      }

      await AuthController.instance.onLogin(UserType.client, savedEmail);

      isLoading.value = false;
      await navigateToHomeScreen();
    } catch (e) {
      isLoading.value = false;

      await AuthServices.instance.signoutFromGoogle();
      await AuthServices.instance.signoutFromFirebase();

      box.remove(kSavedEmail);
      box.remove(kSavedUserType);

      Get.offAllNamed(AppRoutes.signin);

      Future.delayed(Duration(milliseconds: 300), () {
        CDeviceHelper.showSnackbar(
          "Error",
          "Some error occurred while trying to sign in",
          CIcons.errorCross,
        );
      });
    }
  }

  Future<void> navigateToHomeScreen() async {
    try {
      await ClientCloudDb.instance.addFcmToken();
      await Get.offAllNamed(AppRoutes.clientNav);
    } catch (e) {
      await Get.offAllNamed(AppRoutes.clientNav);
    }
  }
}
