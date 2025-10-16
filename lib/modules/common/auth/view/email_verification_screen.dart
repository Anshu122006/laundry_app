import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/modules/common/auth/controller/employee_auth_controller.dart';
import 'package:laundary_app/shared/widgets/appbar.dart';
import 'package:laundary_app/shared/widgets/loading_overlay.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeAuthController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) exit(0);
      },
      child: Scaffold(
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          CAppBar(
                            title: const SizedBox(),
                            leading: IconButton(
                              onPressed: () async {
                                await controller.abortVerification();
                                exit(0);
                              },
                              icon: Icon(
                                FontAwesomeIcons.arrowLeft,
                                color: CColors.dark,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Image.asset(
                            "assets/illustrations/email_verification.png",
                            height: 300,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "Verify your email address",
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "Verification email has been sent to ",
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  TextSpan(
                                    text: controller.email.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        ". Please verify the email by clicking on the link sent to your email before the timer runs out.",
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Obx(
                            () => Text(
                              'Time left: ${controller.remainingSeconds ~/ 60}:${(controller.remainingSeconds % 60).toString().padLeft(2, '0')}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed:
                                controller.isLoading.value
                                    ? null
                                    : () async =>
                                        await controller.verifyEmail(),
                            child: const Text("Continue"),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed:
                                controller.isLoading.value
                                    ? null
                                    : () async =>
                                        await controller.resendEmail(),
                            child: const Text("Resend Email"),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Loading Overlay
            Obx(
              () =>
                  controller.isLoading.value
                      ? const CLoadingOverlay()
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
