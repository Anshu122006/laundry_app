import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/modules/common/auth/controller/client_auth_controller.dart';
import 'package:laundary_app/modules/common/auth/controller/employee_auth_controller.dart';
import 'package:laundary_app/modules/common/auth/widgets/auth_background.dart';
import 'package:laundary_app/modules/common/auth/widgets/auth_header.dart';
import 'package:laundary_app/modules/common/auth/widgets/client_signin_button.dart';
import 'package:laundary_app/modules/common/auth/widgets/employee_signin_button.dart';
import 'package:laundary_app/shared/widgets/loading_overlay.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clientController = Get.find<ClientAuthController>();
    final employeeController = Get.find<EmployeeAuthController>();

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
