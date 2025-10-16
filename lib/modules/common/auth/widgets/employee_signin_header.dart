import 'package:flutter/material.dart';

class EmployeeSigninHeader extends StatelessWidget {
  const EmployeeSigninHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 5),
          Transform.translate(
            offset: Offset(-45, 0),
            child: Image(
              image: AssetImage(
                "assets/illustrations/employee_form_illustration.png",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
