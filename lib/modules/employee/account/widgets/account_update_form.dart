import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/modules/employee/account/controller/account_controller.dart';
import 'package:laundary_app/shared/widgets/form_input.dart';
import 'package:laundary_app/core/constants/icons.dart';

class EmployeeAccountUpdateForm extends StatelessWidget {
  const EmployeeAccountUpdateForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeAccountController>();

    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 7,
        children: [
          CFormInputField(
            onChanged: (value) => controller.name.value = value,
            labelText: "Name",
            prefixIcon: CIcons.userIcon,
            keyboardType: TextInputType.name,
            initialValue: controller.name.value,
          ),
          CFormInputField(
            onChanged: (value) => controller.phone.value = value,
            labelText: "Phone",
            prefixIcon: CIcons.phoneIcon,
            keyboardType: TextInputType.phone,
            initialValue: controller.phone.value,
          ),
          CFormInputField(
            onChanged: (value) => controller.email.value = value,
            labelText: "E-mail",
            prefixIcon: CIcons.emailIcon,
            enabled: false,
            initialValue: controller.email.value,
          ),
          SizedBox(height: 15),
          CFormInputField(
            onChanged: (value) => controller.role.value = value,
            labelText: "Role",
            prefixIcon: CIcons.roomIcon,
            enabled: false,
            initialValue: controller.role.value,
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await controller.updateEmployeeData();
                Get.back();
              },
              child: Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }
}
