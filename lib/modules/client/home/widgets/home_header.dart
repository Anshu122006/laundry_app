import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/constants/font_data.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/wash_type_controller.dart';
import 'package:laundary_app/modules/client/home/widgets/home_wash_card.dart';
import 'package:laundary_app/shared/shapes/side_rounded_curve.dart';

class ClientHomeHeader extends StatelessWidget {
  const ClientHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController userdata = AuthController.instance;
    final washTypes =
        WashTypeController.instance.washTypes().map((t) => t.value).toList();

    return CSideRoundedCurve(
      child: Container(
        height: 380,
        color: CColors.primaryColor,
        child: Stack(
          children: [
            Positioned(
              right: 10,
              top: 30,
              child: TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.offers);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent, 
                ),
                child: Text(
                  "Offers/Info",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontFamily: CFontFamily.dynaPuff,
                    color: CColors.darkGrey,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome,",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: CColors.secondaryColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: CFontFamily.poppins
                    ),
                  ),
                  Obx(
                    () => Text(
                      userdata.currentClient.value?.name ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: CColors.secondaryColor,
                            fontFamily: CFontFamily.poppins,
                      ),
                    ),
                  ),
                  Text(
                    "Just choose a wash type and place\nyour order, it is that simple!",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: CColors.secondaryColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: CFontFamily.poppins
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 160,
              left: 25,
              right: 0,
              child: SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: washTypes.length,
                  itemBuilder:
                      (context, index) => WashCard(type: washTypes[index].name),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
