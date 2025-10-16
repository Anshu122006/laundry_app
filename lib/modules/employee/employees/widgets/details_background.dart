import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';

class EmployeeDetailBackground extends StatelessWidget {
  const EmployeeDetailBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CDeviceHelper.getScreenHeight(),
      width: CDeviceHelper.getScreenWidth(),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(color: CColors.primaryColor),
          ),
          Positioned(
            top: -5,
            right: -90,
            child: Transform.rotate(
              angle: -0.6,
              child: Icon(
                Icons.local_laundry_service_outlined,
                size: 220,
                color: CColors.white.withAlpha(70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
