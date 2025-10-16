import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/modules/employee/employees/controller/employee_controller.dart';
import 'package:laundary_app/shared/edges/bottom_inward_curved.dart';
import 'package:laundary_app/shared/widgets/searchbar.dart';

class EmployeeListHeader {
  static Widget getHeader(BuildContext context) {
    final controller = Get.find<EmployeeScreenController>();
    final topPadding = MediaQuery.of(context).padding.top;
    final double topHeight = CDeviceHelper.getScreenHeight() * 0.08;
    final double bottomHeight = CDeviceHelper.getScreenHeight() * 0.14;

    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      expandedHeight: topHeight + bottomHeight,
      flexibleSpace: SizedBox(
        height: topHeight + topPadding,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: CColors.primaryColor)),
            Positioned(
              top: 40,
              left: 25,
              child: Text(
                'Employees',
                style: Get.textTheme.headlineLarge!.copyWith(
                  color: CColors.secondaryColor,
                ),
              ),
            ),
            Positioned(top: 38, right: 20, child: SortBy()),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(bottomHeight),
        child: ClipPath(
          clipper: CBottomInwardCurvedEdge(),
          child: Container(
            height: bottomHeight,
            width: double.infinity,
            color: CColors.primaryColor,
            child: Column(
              children: [
                SizedBox(height: 18),
                CSearchbar(
                  onChanged: (value) => controller.searchQuery.value = value,
                  labelText: "Search for employees",
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SortBy extends StatelessWidget {
  const SortBy({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeScreenController>();

    return Row(
      spacing: 10,
      children: [
        SizedBox(width: 20),
        Text("Sort By: "),
        Obx(
          () => DropdownButton<String>(
            elevation: 3,
            underline: SizedBox(),
            value: controller.sortBy.value,
            onChanged: (value) {
              if (value != null) {
                controller.sortBy.value = value;
              }
            },
            items: [
              DropdownMenuItem(
                value: 'email',
                child: Text(
                  'Email',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              DropdownMenuItem(
                value: 'name',
                child: Text(
                  'Name',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              DropdownMenuItem(
                value: 'phone',
                child: Text(
                  'Phone',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
