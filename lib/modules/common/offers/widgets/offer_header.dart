import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/shared/edges/bottom_inward_curved.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';
import 'package:laundary_app/core/constants/colors.dart';

class OfferHeader {
  static Widget getHeader() {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: _buildFlexibleSpace(),
      // bottom: _buildBottomSearchBar(),
    );
  }

  static Widget _buildFlexibleSpace() {
    final double topHeight = CDeviceHelper.getScreenHeight() * 0.17;
    return SizedBox(
      height: topHeight,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: CBottomInwardCurvedEdge(),
              child: Container(color: CColors.primaryColor),
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            child: CBackButton(color: CColors.secondaryColor),
          ),
          Positioned(
            top: 60,
            left: 25,
            child: Text(
              'Offers and Info',
              style: Get.textTheme.headlineLarge!.copyWith(
                color: CColors.secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
