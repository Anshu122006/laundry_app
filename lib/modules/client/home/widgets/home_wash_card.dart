import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/core/utils/formatters/formatter_utility.dart';
import 'package:laundary_app/modules/client/home/view/place_order_screen.dart';

class WashCard extends StatelessWidget {
  const WashCard({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    String formattedType = CFormatter.getWashType(type);
    String imageLink = "assets/wash_types/$formattedType.png";

    return GestureDetector(
      onTap: () => Get.to(() => PlaceOrderScreen(type: type)),
      child: Container(
        width: 130,
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.only(left: 10, right: 10, top: 35),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                imageLink,
                height: 80,
                width: 80,
              ),
              SizedBox(height: 10),
              Text(
                type,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color:
                      CDeviceHelper.isDarkMode()
                          ? CColors.white
                          : CColors.darkGrey,
                ),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
