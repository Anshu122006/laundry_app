import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/models/employee.dart';
import 'package:laundary_app/modules/employee/employees/controller/employee_controller.dart';
import 'package:laundary_app/shared/widgets/property.dart';

class EmployeeDetailCard extends StatelessWidget {
  const EmployeeDetailCard({
    super.key,
    required this.employee,
    required this.canRemove,
  });

  final Employee employee;
  final bool canRemove;

  @override
  Widget build(BuildContext context) {
    EmployeeScreenController? controller;
    if (canRemove) {
      controller = Get.find<EmployeeScreenController>();
    }

    return Container(
      // height: CDeviceHelper.getScreenHeight() * 0.38,
      width: CDeviceHelper.getScreenWidth() * 0.83,
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: CColors.white.withAlpha(230),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            "Employee Details",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium!.copyWith(color: CColors.black),
          ),
          CProperty(
            name: "Name",
            value: employee.name,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 17,
              color: CColors.black,
            ),
          ),
          CProperty(
            name: "Email",
            value: employee.email,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 17,
              color: CColors.black,
            ),
          ),
          CProperty(
            name: "Role",
            value: employee.role,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 17,
              color: CColors.black,
            ),
          ),
          CProperty(
            name: "Phone",
            value: "+91 ${employee.phone}",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 17,
              color: CColors.black,
            ),
          ),
          SizedBox(height: 5),
          if (controller != null)
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller!.removeEmployee(employee);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(),
                  child: Text("Remove"),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
