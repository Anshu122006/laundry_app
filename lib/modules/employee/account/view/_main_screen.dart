import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/modules/common/attributions/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/account/controller/account_controller.dart';
import 'package:laundary_app/modules/employee/account/widgets/account_header.dart';
import 'package:laundary_app/modules/employee/account/widgets/account_option_tile.dart';
import 'package:laundary_app/shared/widgets/heading.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';

class EmployeeAccountScreen extends StatelessWidget {
  const EmployeeAccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    AuthController employeedata = AuthController.instance;
    final controller = Get.find<EmployeeAccountController>();

    return Scaffold(
      body: LayoutBuilder(
        builder:
            (context, constraints) => ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight,
                maxWidth: constraints.maxWidth,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 200, child: AccountHeader()),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: CHeading(title: "Account Settings"),
                    ),
                    Obx(
                      () => COptionTile(
                        onPressed: () {},
                        leadingIcon: CIcons.phoneIcon,
                        title: employeedata.currentEmployee.value?.phone ?? "",
                        subtitle: "Your current phone number",
                      ),
                    ),
                    COptionTile(
                      onPressed: () {
                        Get.toNamed(AppRoutes.offers);
                      },
                      leadingIcon: CIcons.offers,
                      title:
                          employeedata.currentEmployee.value?.role == "admin"
                              ? "Update Offers/Info"
                              : "Check Offers/Info",
                      subtitle:
                          employeedata.currentEmployee.value?.role == "admin"
                              ? "Click to update Offers"
                              : "Click to check Offers",
                    ),
                    COptionTile(
                      onPressed: () {
                        Get.toNamed(AppRoutes.pricing);
                      },
                      leadingIcon: CIcons.prices,
                      title:
                          employeedata.currentEmployee.value?.role == "admin"
                              ? "Update Pricing"
                              : "Check Pricing",
                      subtitle:
                          employeedata.currentEmployee.value?.role == "admin"
                              ? "Click to update pricing"
                              : "Click to check pricing",
                    ),
                    COptionTile(
                      onPressed: () {
                        Get.toNamed(AppRoutes.contacts);
                      },
                      leadingIcon: CIcons.contactus,
                      title: "Contact-us",
                      subtitle: "Update contact details",
                    ),
                    Obx(
                      () => COptionTile(
                        onPressed: () {},
                        leadingIcon: CIcons.role,
                        title: employeedata.currentEmployee.value?.role ?? "",
                        subtitle: "Your role",
                      ),
                    ),
                    if (employeedata.currentEmployee.value?.role == "admin")
                      COptionTile(
                        onPressed: () async {
                          await Get.toNamed(AppRoutes.adminPassbook);
                        },
                        leadingIcon: CIcons.passbook,
                        title: "Passbook",
                        subtitle: "Check passbook",
                      ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: OutlinedButton(
                        onPressed: () async {
                          await controller.signout();
                        },
                        child: Text("Logout"),
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: CLineDivider(),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => AttributionsScreen());
                        },
                        child: Text(
                          "atttibutions",
                          style: Theme.of(context).textTheme.labelMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
