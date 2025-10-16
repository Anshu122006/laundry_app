import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/data/controllers/employee_controller.dart';
import 'package:laundary_app/modules/employee/employees/controller/employee_controller.dart';
import 'package:laundary_app/modules/employee/employees/view/add_employee_screen.dart';
import 'package:laundary_app/modules/employee/employees/widgets/employee_header.dart';
import 'package:laundary_app/modules/employee/employees/widgets/employee_tile.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeScreenController>();

    return Scaffold(
      body: LayoutBuilder(
        builder:
            (context, constraints) => ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight,
                maxWidth: constraints.maxWidth,
              ),
              child: CustomScrollView(
                slivers: [
                  EmployeeListHeader.getHeader(context),
                  Obx(() {
                    final employees =
                        controller.filteredEmployees
                            .map((employee) => employee.value)
                            .toList();
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: employees.length,
                        (_, index) {
                          final i = EmployeeController.instance.employees
                              .indexWhere(
                                (e) => e.value.id == employees[index].id,
                              );
                          return EmployeeTile(index: i);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size.fromHeight(60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          Get.to(() => AddEmployeeScreen());
        },
        child: Transform.scale(
          scale: 1.2,
          child: Icon(Icons.add, color: CColors.white, size: 24, weight: 1),
        ),
      ),
    );
  }
}
