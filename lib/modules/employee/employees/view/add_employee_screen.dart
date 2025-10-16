import 'package:flutter/material.dart';
import 'package:laundary_app/modules/employee/employees/widgets/add_employee_form.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';

class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: CBackButton(),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  "Add Employee",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: AddEmployeeForm(),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CLineDivider(),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  "Only the employees you add will be able to\nlogin to the app",
                  style: Theme.of(context).textTheme.labelMedium,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
