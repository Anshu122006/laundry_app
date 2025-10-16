import 'package:get/get.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/services/auth_services.dart';

class ClientAccountController extends GetxController {
  RxString name = "".obs;
  RxString email = "".obs;
  RxString hostel = "".obs;
  RxString room = "".obs;
  RxString phone = "".obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    updateData();
  }

  void updateData() {
    Client? client = AuthController.instance.currentClient.value;
    name.value = client?.name ?? "";
    email.value = client?.email ?? "";
    hostel.value = client?.hostel ?? "";
    room.value = client?.room ?? "";
    phone.value = client?.phone ?? "";
  }

  Future<void> updateClientData() async {
    try {
      final data = validateInputs();
      if (data["isvalid"]) {
        AuthController userdata = AuthController.instance;
        Client client = Client(
          id: userdata.currentClient.value?.id ?? "",
          name: name.value,
          email: email.value,
          phone: phone.value,
          hostel: hostel.value,
          room: room.value,
          balance: userdata.currentClient.value?.balance ?? 0,
          updatedAt: 0,
          deleted: false,
        );

        userdata.currentClient.value = client;
        await ClientCloudDb.instance.updateClient(client);
      } else {
        CDeviceHelper.showSnackbar("Error", data["error"], CIcons.errorCross);
      }
    } catch (e) {
      CDeviceHelper.showSnackbar("Error", e.toString(), CIcons.errorCross);
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

  // Sign out from account
  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await AuthServices.instance.signoutFromGoogle();
      await AuthServices.instance.signoutFromFirebase();

      await AuthController.instance.onLogout();

      Get.offAllNamed(AppRoutes.signin);
      Future.delayed(
        Duration(milliseconds: 0),
        () => CDeviceHelper.showSnackbar(
          "Success",
          "Signed out sucessfully",
          CIcons.successCheck,
        ),
      );
    } catch (e) {
      await Get.offAllNamed(AppRoutes.signin);
      await Future.delayed(Duration(seconds: 0));
      CDeviceHelper.showSnackbar("Error", e.toString(), CIcons.errorCross);
    } finally {
      isLoading.value = false;
    }
  }
}
