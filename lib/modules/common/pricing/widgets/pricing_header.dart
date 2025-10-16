import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/shared/edges/bottom_inward_curved.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';
import 'package:laundary_app/core/constants/colors.dart';

class PricingHeader {
  static Widget getHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final double topHeight = CDeviceHelper.getScreenHeight() * 0.14;

    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: topHeight,
      flexibleSpace: SizedBox(
        height: topHeight + topPadding,
        width: double.infinity,
        child: ClipPath(
          clipper: CBottomInwardCurvedEdge(),
          child: Stack(
            children: [
              Positioned.fill(child: Container(color: CColors.primaryColor)),
              Positioned(
                top: 15,
                left: 10,
                child: CBackButton(color: CColors.secondaryColor),
              ),
              Positioned(
                top: 60,
                left: 25,
                child: Text(
                  'Prices',
                  style: Get.textTheme.headlineLarge!.copyWith(
                    color: CColors.secondaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
