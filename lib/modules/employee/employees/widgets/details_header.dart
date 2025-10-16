import 'package:flutter/material.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';
import 'package:laundary_app/core/constants/colors.dart';

class EmployeeDetailHeader extends StatelessWidget {
  const EmployeeDetailHeader({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CBackButton(color: CColors.white),
          Text(
            "Employee",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: CColors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: " ID",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: CColors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: " #",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: CColors.white),
                ),
                TextSpan(
                  text: id.substring(0),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: CColors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
