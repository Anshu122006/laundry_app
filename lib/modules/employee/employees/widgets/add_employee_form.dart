import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/modules/employee/employees/controller/employee_controller.dart';
import 'package:laundary_app/shared/widgets/form_input.dart';
import 'package:laundary_app/core/constants/icons.dart';

class AddEmployeeForm extends StatelessWidget {
  const AddEmployeeForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeScreenController>();

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
          ),
          CFormInputField(
            onChanged: (value) => controller.phone.value = value,
            labelText: "Phone",
            prefixIcon: CIcons.phoneIcon,
            keyboardType: TextInputType.phone,
          ),
          CFormInputField(
            onChanged: (value) => controller.email.value = value,
            labelText: "E-mail",
            prefixIcon: CIcons.emailIcon,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 15),
          CFormInputField(
            onChanged: (value) => controller.role.value = value,
            labelText: "Role",
            prefixIcon: CIcons.roomIcon,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await controller.addEmployee();
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
