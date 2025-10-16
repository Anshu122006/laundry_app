import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/modules/common/auth/controller/employee_auth_controller.dart';
import 'package:laundary_app/shared/widgets/form_input.dart';
import 'package:laundary_app/core/constants/icons.dart';

class EmployeeSigninForm extends StatelessWidget {
  const EmployeeSigninForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeAuthController>();

    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CFormInputField(
            onChanged: (value) => controller.email.value = value,
            labelText: "E-mail",
            prefixIcon: CIcons.emailIcon,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10),
          Obx(
            () => CFormInputField(
              onChanged: (value) => controller.password.value = value,
              labelText: "password",
              prefixIcon: CIcons.password,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !controller.showPassword.value,
              suffixCallback: controller.toggleShowPassword,
              textInputAction: TextInputAction.done,
              suffixIcon: Icon(
                controller.showPassword.value
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye,
              ),
            ),
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                controller.initiateResetPassword();
              },
              child: Text(
                "forgot password",
                style: TextStyle(color: CColors.secondaryColor),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (!controller.isLoading.value) {
                  await controller.signin();
                }
              },
              child: Text("Signin"),
            ),
          ),
        ],
      ),
    );
  }
}
