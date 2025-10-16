import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/modules/common/auth/controller/employee_auth_controller.dart';

class WorkerSigninButton extends StatelessWidget {
  const WorkerSigninButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeAuthController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: CColors.transparent,
        border: Border.all(color: CColors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () async {
          if (!controller.isLoading.value) await controller.handleCurrentUser();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 2,
                child: Image.asset(
                  "assets/icons/employee_icon.png",
                  height: 35,
                  width: 35,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 15,
                child: Text(
                  "Sign-in as employee",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
