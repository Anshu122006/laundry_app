import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/pricing_controller.dart';
import 'package:laundary_app/data/db_cloud/pricing_cloud_db.dart';
import 'package:laundary_app/data/models/pricing.dart';
import 'package:laundary_app/modules/common/pricing/widgets/inputs.dart';

class PricingTile extends StatelessWidget {
  const PricingTile({super.key, required this.pricing});

  final Pricing pricing;

  @override
  Widget build(BuildContext context) {
    bool canEdit = AuthController.instance.userType.value != UserType.client;

    return GestureDetector(
      onTap: () {
        if (canEdit) {
          Get.bottomSheet(
            PricingInputs.getUpdateInput(context, pricing),
            isScrollControlled: true,
            isDismissible: true,
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.shirt, color: CColors.grey, size: 23),
                  SizedBox(width: 25),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pricing.name,
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge!.copyWith(fontSize: 14),
                        ),
                        Text(
                          "₹${pricing.cost}",
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (canEdit)
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      try {
                        await PricingController.instance.decrementPriority(
                          pricing,
                        );
                      } catch (e) {
                        CDeviceHelper.showSnackbar(
                          "Error",
                          "Some error occured while trying to update the pricing",
                          CIcons.errorCross,
                        );
                      }
                    },
                    icon: Icon(
                      Icons.arrow_upward,
                      color: CColors.grey,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await PricingController.instance.incrementPriority(
                          pricing,
                        );
                      } catch (e) {
                        CDeviceHelper.showSnackbar(
                          "Error",
                          "Some error occured while trying to update the pricing",
                          CIcons.errorCross,
                        );
                      }
                    },
                    icon: Icon(
                      Icons.arrow_downward,
                      color: CColors.grey,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await PricingCloudDb.instance.deletePricing(pricing);
                      } catch (e) {
                        CDeviceHelper.showSnackbar(
                          "Error",
                          "Some error occured while trying to update the pricing",
                          CIcons.errorCross,
                        );
                      }
                    },
                    icon: Icon(Icons.delete, color: CColors.grey, size: 20),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
