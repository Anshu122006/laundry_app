import 'package:flutter/material.dart';
import 'package:laundary_app/data/models/employee.dart';
import 'package:laundary_app/modules/employee/employees/widgets/details_background.dart';
import 'package:laundary_app/modules/employee/employees/widgets/details_card.dart';
import 'package:laundary_app/modules/employee/employees/widgets/details_header.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  const EmployeeDetailsScreen({
    super.key,
    required this.employee,
    this.canRemove = true,
  });

  final Employee employee;
  final bool canRemove;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            EmployeeDetailBackground(),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  EmployeeDetailHeader(id: employee.id),
                  SizedBox(height: 100),
                  Center(
                    child: EmployeeDetailCard(
                      employee: employee,
                      canRemove: canRemove,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
