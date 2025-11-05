import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/services/auth_services.dart';
import 'package:laundary_app/modules/common/auth/controller/client_auth_controller.dart';
import 'package:laundary_app/modules/common/auth/widgets/client_signup_form.dart';
import 'package:laundary_app/modules/common/auth/widgets/client_signup_header.dart';
import 'package:laundary_app/shared/widgets/loading_overlay.dart';

class ClientSignupScreen extends StatelessWidget {
  const ClientSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientAuthController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        } else {
          try {
            await AuthServices.instance.signoutFromGoogle();
            await AuthServices.instance.signoutFromFirebase();
            Get.back();
          } catch (e) {
            Get.back();
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            LayoutBuilder(
              builder:
                  (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, left: 15),
                            child: IconButton(
                              onPressed: () async {
                                await AuthServices.instance.signoutFromGoogle();
                                await AuthServices.instance
                                    .signoutFromFirebase();
                                Get.back();
                              },
                              icon: Icon(
                                FontAwesomeIcons.arrowLeft,
                                color:
                                    CDeviceHelper.isDarkMode()
                                        ? CColors.light
                                        : CColors.dark,
                                size: 22,
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(10, -30),
                            child: SignupHeader(),
                          ),
                          Transform.translate(
                            offset: Offset(0, -20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: SignupForm(),
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
            ),

            // Loading Overlay
            Obx(() {
              if (controller.isLoading.value) {
                return CLoadingOverlay();
              } else {
                return SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
