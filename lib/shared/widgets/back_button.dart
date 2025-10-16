import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';

class CBackButton extends StatelessWidget {
  const CBackButton({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Get.back(),
      icon: Icon(
        FontAwesomeIcons.arrowLeft,
        color:
            color ??
            (CDeviceHelper.isDarkMode() ? CColors.light : CColors.dark),
        size: 22,
      ),
    );
  }
}
