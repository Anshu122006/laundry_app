import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/modules/common/auth/controller/employee_auth_controller.dart';
import 'package:laundary_app/modules/common/auth/widgets/employee_signin_form.dart';
import 'package:laundary_app/modules/common/auth/widgets/employee_signin_header.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';
import 'package:laundary_app/shared/widgets/loading_overlay.dart';

class EmployeeSigninScreen extends StatelessWidget {
  const EmployeeSigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployeeAuthController());

    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: CBackButton(),
                      ),
                      const EmployeeSigninHeader(),
                      const SizedBox(height: 40),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: EmployeeSigninForm(),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35),
                        child: CLineDivider(),
                      ),
                      SizedBox(height: 5),
                      Center(
                        child: SizedBox(
                          width: CDeviceHelper.getScreenWidth() * 0.8,
                          child: Text(
                            "If you are signing in for the first time, the passsword you enter would become the password for your account",
                            style: Theme.of(context).textTheme.labelMedium,
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              );
            },
          ),

          // Loading overlay on top
          Obx(() {
            return controller.isLoading.value
                ? const CLoadingOverlay()
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
