import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/modules/common/auth/controller/client_auth_controller.dart';
import 'package:laundary_app/shared/widgets/form_input.dart';
import 'package:laundary_app/core/constants/icons.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientAuthController>();

    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          CFormInputField(
            onChanged: (value) => controller.name.value = value,
            labelText: "Name",
            prefixIcon: CIcons.userIcon,
            keyboardType: TextInputType.name,
            initialValue: controller.name.value,
          ),
          CFormInputField(
            onChanged: (value) => controller.email.value = value,
            labelText: "E-mail",
            prefixIcon: CIcons.emailIcon,
            enabled: false,
            initialValue: controller.email.value,
          ),
          Row(
            spacing: 10,
            children: [
              Flexible(
                flex: 1,
                child: CFormInputField(
                  onChanged: (value) => controller.hostel.value = value,
                  labelText: "Hostel",
                  prefixIcon: CIcons.hostelIcon,
                  keyboardType: TextInputType.text,
                ),
              ),
              Flexible(
                flex: 1,
                child: CFormInputField(
                  onChanged: (value) => controller.room.value = value,
                  labelText: "Room",
                  prefixIcon: CIcons.roomIcon,
                  keyboardType: TextInputType.text,
                ),
              ),
            ],
          ),
          CFormInputField(
            onChanged: (value) => controller.phone.value = value,
            labelText: "Phone",
            prefixIcon: CIcons.phoneIcon,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (!controller.isLoading.value) await controller.signup();
              },
              child: Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }
}
