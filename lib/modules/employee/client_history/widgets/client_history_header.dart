import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';

class ClientHistoryHeader extends StatelessWidget {
  const ClientHistoryHeader({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: CBackButton(color: CColors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              "Past Transactions",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(color: CColors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Id",
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
                    text: clientId,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: CColors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
