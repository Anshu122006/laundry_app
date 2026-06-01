import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/modules/common/auth/controller/client_auth_controller.dart';
import 'package:laundary_app/modules/common/auth/controller/employee_auth_controller.dart';
import 'package:laundary_app/modules/common/auth/widgets/auth_background.dart';
import 'package:laundary_app/modules/common/auth/widgets/auth_header.dart';
import 'package:laundary_app/modules/common/auth/widgets/client_signin_button.dart';
import 'package:laundary_app/modules/common/auth/widgets/employee_signin_button.dart';
import 'package:laundary_app/shared/widgets/loading_overlay.dart';

class SigninScreen extends HookWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clientController = Get.find<ClientAuthController>();
    final employeeController = Get.find<EmployeeAuthController>();

    useEffect(() {
      FirebaseMessaging.instance.requestPermission();

      if (Get.arguments?["showMessage"] == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CDeviceHelper.showSnackbar(
            "Success",
            "Signed out successfully",
            CIcons.successCheck,
          );
        });
      }
      return null;
    }, []);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Stack(
                children: [
                  // Background layer
                  Positioned.fill(child: AuthBackground()),

                  // Main content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 120),
                      SigninHeader(),
                      SizedBox(height: 110),
                      ClientSigninButton(),
                      SizedBox(height: 10),
                      WorkerSigninButton(),
                    ],
                  ),

                  // Loader overlay
                  Obx(() {
                    if (clientController.isLoading.value ||
                        employeeController.isLoading.value) {
                      return CLoadingOverlay();
                    } else {
                      return SizedBox();
                    }
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
