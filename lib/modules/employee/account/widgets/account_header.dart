import 'package:flutter/material.dart';
import 'package:laundary_app/shared/shapes/bottom_inward_curved.dart';
import 'package:laundary_app/shared/shapes/circle.dart';
import 'package:laundary_app/modules/employee/account/widgets/account_profile_tile.dart';
import 'package:laundary_app/core/constants/colors.dart';

class AccountHeader extends StatelessWidget {
  const AccountHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CBottomInwardCurved(
            child: Stack(
              children: [
                Container(color: Theme.of(context).primaryColor),
                Positioned(
                  top: -60,
                  right: -170,
                  child: CCircle(opacity: 0.15),
                ),
                Positioned(
                  top: 100,
                  right: -200,
                  child: CCircle(opacity: 0.15),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 25,
          child: Text(
            "Account",
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(color: CColors.secondaryColor),
          ),
        ),
        Positioned(top: 85, left: 0, right: 0, child: CEmployeeProfileTile()),
      ],
    );
  }
}
