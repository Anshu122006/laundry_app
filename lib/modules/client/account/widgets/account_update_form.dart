import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/shared/widgets/form_input.dart';
import 'package:laundary_app/modules/client/account/controller/account_controller.dart';
import 'package:laundary_app/core/constants/icons.dart';

class AccountUpdateForm extends StatelessWidget {
  const AccountUpdateForm({super.key});

  @override
  Widget build(BuildContext context) {
    ClientAccountController controller = Get.find<ClientAccountController>();

    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
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
                  initialValue: controller.hostel.value,
                ),
              ),
              Flexible(
                flex: 1,
                child: CFormInputField(
                  onChanged: (value) => controller.room.value = value,
                  labelText: "Room",
                  prefixIcon: CIcons.roomIcon,
                  keyboardType: TextInputType.text,
                  initialValue: controller.room.value,
                ),
              ),
            ],
          ),
          CFormInputField(
            onChanged: (value) => controller.phone.value = value,
            labelText: "Phone",
            prefixIcon: CIcons.phoneIcon,
            keyboardType: TextInputType.phone,
            initialValue: controller.phone.value,
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Get.back();
                await controller.updateClientData();
              },
              child: Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }
}
