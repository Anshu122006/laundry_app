import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/modules/employee/home/controller/home_controller.dart';
import 'package:laundary_app/modules/employee/home/widgets/home_order_card.dart';
import 'package:laundary_app/shared/shapes/side_rounded_curve.dart';

class EmployeeHomeHeader extends StatelessWidget {
  const EmployeeHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController userdata = AuthController.instance;
    final controller = Get.find<EmployeeHomeController>();

    return CSideRoundedCurve(
      child: Container(
        height: 380,
        color: CColors.primaryColor,
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi,",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: CColors.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Obx(
                    () => Text(
                      userdata.currentEmployee.value?.name ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(color: CColors.secondaryColor),
                    ),
                  ),
                  Text(
                    "Check all current orders and their status,\neverything in one place!",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: CColors.secondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 160,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    SizedBox(width: 20),
                    Obx(
                      () => OrderCard(
                        message: "Orders Placed\nToday",
                        count: controller.placed.value,
                        backgroundColor: CColors.secondaryColor,
                        textColor: CColors.white,
                      ),
                    ),
                    Obx(
                      () => OrderCard(
                        message: "Orders To\nPick",
                        count: controller.toPick.value,
                        backgroundColor: CColors.white,
                        textColor: CColors.secondaryColor,
                      ),
                    ),
                    Obx(
                      () => OrderCard(
                        message: "Orders To\nDeliver",
                        count: controller.toDeliver.value,
                        backgroundColor: CColors.secondaryColor,
                        textColor: CColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
