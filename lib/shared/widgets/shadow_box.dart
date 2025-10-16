import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';

class CShadowBox extends StatelessWidget {
  const CShadowBox({
    super.key,
    required this.child,
    this.spread = 6,
    this.color,
  });
  final double spread;
  final Color? color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: spread,
            color: CColors.shadow,
            offset: Offset(spread * 0.75, spread),
            spreadRadius: spread * 0.75,
            blurStyle: BlurStyle.normal,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color:
            color ??
            (CDeviceHelper.isDarkMode() ? CColors.dark : CColors.light),
      ),
      child: child,
    );
  }
}
