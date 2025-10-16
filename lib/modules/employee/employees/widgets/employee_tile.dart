import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/employee_controller.dart';
import 'package:laundary_app/modules/employee/employees/controller/employee_controller.dart';
import 'package:laundary_app/modules/employee/employees/view/employee_details_screen.dart';

class EmployeeTile extends StatelessWidget {
  const EmployeeTile({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeScreenController>();
    final userdata = EmployeeController.instance;

    return InkWell(
      onTap:
          () => Get.to(
            () => EmployeeDetailsScreen(
              employee: userdata.employees[index].value,
            ),
          ),
      splashColor: CColors.lightGrey,
      child: ListTile(
        leading: Icon(Icons.person, color: CColors.grey, size: 28),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            userdata.employees[index].value.name,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color:
                  CDeviceHelper.isDarkMode() ? CColors.white : CColors.darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            userdata.employees[index].value.email,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        trailing: IconButton(
          onPressed: () async {
            controller.launchDialer(userdata.employees[index].value.phone);
          },
          icon: Icon(Icons.phone, color: CColors.grey, size: 28),
        ),
      ),
    );
  }
}
