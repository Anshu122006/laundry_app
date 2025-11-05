import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/employee_cloud_db.dart';
import 'package:laundary_app/data/services/auth_services.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';

class EmployeeAuthController extends GetxController {
  RxString email = "".obs;
  RxString password = "".obs;

  Rx<bool> showPassword = false.obs;
  Rx<bool> isLoading = false.obs;
  Rx<int> remainingSeconds = 0.obs;
  Timer? _timer;
  int verifyDuration = 600; // in seconds

  @override
  void onClose() {
    if (_timer?.isActive ?? false) _timer?.cancel();
    super.onClose();
  }

  // To toggle password
  void toggleShowPassword() {
    showPassword.value = !showPassword.value;
  }

  // Timer for email verification
  void startTimer() {
    if (_timer?.isActive ?? false) _timer!.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        try {
          await AuthServices.instance.deleteCurrentUser();

          Get.offAllNamed(AppRoutes.signin);
          Future.delayed(Duration(milliseconds: 300), () {
            CDeviceHelper.showSnackbar(
              "Error",
              "Verification time-out",
              CIcons.errorCross,
            );
          });
        } catch (e) {
          CDeviceHelper.showSnackbar("Error", e.toString(), CIcons.errorCross);
        }
        timer.cancel();
      }
    });
  }

  // The main signin function
  Future signin() async {
    isLoading.value = true;
    try {
      UserCredential credential = await AuthServices.instance.signinEmployee(
        email.value,
        password.value,
      );

      final employee = await EmployeeCloudDb.instance.getEmployee(email.value);
      if (employee == null) {
        await AuthServices.instance.deleteCurrentUser();
        CDeviceHelper.showSnackbar(
          "Error",
          "Unauthorised User",
          CIcons.errorCross,
        );
        return;
      }

      if (!credential.user!.emailVerified) {
        // --- Bypass verification for Play Console test account ---
        if (email.value.trim().toLowerCase() == "anshu2006dev@gmail.com" &&
            password.value.trim() == "testuser123") {
          // Skip verification and continue directly to app
          await AuthController.instance.onLogin(UserType.employee, email.value);
          await Get.offAllNamed(AppRoutes.employeeNav);
          isLoading.value = false;
          return;
        }
        // ---------------------------------------------------------

        final box = GetStorage();
        int sentAt = box.read("sentAt") ?? 0;

        final timePassed = DateTime.now().millisecondsSinceEpoch - sentAt;
        if (timePassed < Duration(seconds: verifyDuration).inMilliseconds) {
          remainingSeconds.value = verifyDuration - timePassed ~/ 1000;
          startTimer();
          await Get.offAllNamed(AppRoutes.emailVerification);
          return;
        } else {
          await AuthServices.instance.deleteCurrentUser();
          await Get.offAllNamed(AppRoutes.signin);
          throw "Email not verified";
        }
      }

      await AuthController.instance.onLogin(UserType.employee, email.value);
      await Get.offAllNamed(AppRoutes.employeeNav);
    } on FirebaseAuthException {
      try {
        await AuthServices.instance.signupEmployee(email.value, password.value);
        final employee = await EmployeeCloudDb.instance.getEmployee(
          email.value,
        );

        if (employee == null) {
          await AuthServices.instance.deleteCurrentUser();
          CDeviceHelper.showSnackbar(
            "Error",
            "Unauthorised User",
            CIcons.errorCross,
          );
          return;
        }

        await AuthServices.instance.sendEmailVerification();
        final box = GetStorage();
        box.write('sentAt', DateTime.now().millisecondsSinceEpoch);

        remainingSeconds.value = verifyDuration;
        startTimer();
        isLoading.value = false;
        await Get.toNamed(AppRoutes.emailVerification);
      } on FirebaseAuthException catch (e) {
        String message =
            'Can\'t sign you in, make sure the email and password you entered are correct';

        if (e.code == 'weak-password') {
          message = 'The entered password isn\'t strong enough';
        }

        CDeviceHelper.showSnackbar("Error", message, CIcons.errorCross);
      } catch (e) {
        CDeviceHelper.showSnackbar("Error", e.toString(), CIcons.errorCross);
      }
    } catch (e) {
      CDeviceHelper.showSnackbar("Error", e.toString(), CIcons.errorCross);
    } finally {
      isLoading.value = false;
    }
  }

  // To handle current user if not signed out
  Future handleCurrentUser() async {
    isLoading.value = true;
    try {
      final user = AuthServices.instance.getCurrentUser();
      if (user != null) {
        if (!user.emailVerified) {
          final box = GetStorage();
          int sentAt = box.read("sentAt") ?? 0;
          int timePassed = DateTime.now().millisecondsSinceEpoch - sentAt;
          if (timePassed < Duration(minutes: 1).inMilliseconds) {
            remainingSeconds.value = verifyDuration * 1000 - timePassed;
            startTimer();

            await Get.offAllNamed(AppRoutes.emailVerification);
          } else {
            await AuthServices.instance.deleteCurrentUser();

            isLoading.value = false;
            await Get.offAllNamed(AppRoutes.signin);
          }
        } else {
          await AuthController.instance.onLogin(UserType.employee, user.email);
          await Get.offAllNamed(AppRoutes.employeeNav);
        }
      } else {
        isLoading.value = false;
        await Get.toNamed(AppRoutes.employeeSigninForm);
      }
    } catch (e) {
      await AuthServices.instance.signoutFromFirebase();

      Get.offAllNamed(AppRoutes.signin);
      Future.delayed(Duration(milliseconds: 300), () {
        CDeviceHelper.showSnackbar(
          "Error",
          "Some error occured while trying to sign-in",
          CIcons.errorCross,
        );
      });
    }
  }

  // To abort the verification process
  Future abortVerification() async {
    try {
      await AuthServices.instance.deleteCurrentUser();
      remainingSeconds.value = 0;
      if (_timer?.isActive ?? false) _timer!.cancel();

      Get.offAllNamed(AppRoutes.signin);
      Future.delayed(Duration(milliseconds: 300), () {
        CDeviceHelper.showSnackbar(
          "Error",
          "Email verification aborted",
          CIcons.errorCross,
        );
      });
    } catch (e) {
      Get.offAllNamed(AppRoutes.signin);
      Future.delayed(Duration(milliseconds: 300), () {
        CDeviceHelper.showSnackbar("Error", e.toString(), CIcons.errorCross);
      });
    }
  }

  // To resend the verification email
  Future resendEmail() async {
    try {
      await AuthServices.instance.sendEmailVerification();
      final box = GetStorage();
      box.write('sentAt', DateTime.now().millisecondsSinceEpoch);

      remainingSeconds.value = verifyDuration;
      startTimer();
    } catch (e) {
      CDeviceHelper.showSnackbar(
        "Error",
        "Some error occured",
        CIcons.errorCross,
      );
    }
  }

  // To send the verification email
  Future verifyEmail() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        if (user.emailVerified) {
          await AuthController.instance.onLogin(
            UserType.employee,
            user.email ?? "",
          );
          Get.offAllNamed(AppRoutes.employeeNav);
        } else {
          CDeviceHelper.showSnackbar(
            "Error",
            "Please verify your email first",
            CIcons.errorCross,
          );
        }
      }
    } catch (e) {
      CDeviceHelper.showSnackbar("Error", e.toString(), CIcons.errorCross);
    }
  }

  // To send reset password
  Future initiateResetPassword() async {
    try {
      await AuthServices.instance.sendResetPasswordEmail(email.value);

      Get.offAllNamed(AppRoutes.signin);
      Future.delayed(Duration(milliseconds: 300), () {
        CDeviceHelper.showSnackbar(
          "Success",
          "password reset email sent",
          CIcons.successCheck,
        );
      });
    } catch (e) {
      CDeviceHelper.showSnackbar("Error", e.toString(), CIcons.errorCross);
    }
  }
}
