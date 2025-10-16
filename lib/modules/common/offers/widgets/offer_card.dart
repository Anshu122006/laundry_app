import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/offer_cloud_db.dart';
import 'package:laundary_app/data/models/offer.dart';
import 'package:laundary_app/modules/common/offers/widgets/inputs.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key, required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    bool canEdit = AuthController.instance.userType.value != UserType.client;
    // bool canEdit = false;

    return GestureDetector(
      onTap: () {
        if (canEdit) {
          Get.bottomSheet(
            OfferInputs.getUpdateInput(context, offer),
            isScrollControlled: true,
            isDismissible: true,
          );
        }
      },
      child: Container(
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CColors.primaryColor,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      offer.desc,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            if (canEdit)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      try {
                        await OfferCloudDb.instance.decrementPriority(offer);
                      } catch (e) {
                        CDeviceHelper.showSnackbar(
                          "Error",
                          "Someerror occured while trying to update the offer",
                          CIcons.errorCross,
                        );
                      }
                    },
                    icon: Icon(
                      Icons.arrow_upward,
                      size: 20,
                      color: CColors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await OfferCloudDb.instance.incrementPriority(offer);
                      } catch (e) {
                        CDeviceHelper.showSnackbar(
                          "Error",
                          "Someerror occured while trying to update the offer",
                          CIcons.errorCross,
                        );
                      }
                    },
                    icon: Icon(
                      Icons.arrow_downward,
                      size: 20,
                      color: CColors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await OfferCloudDb.instance.deleteOffer(offer);
                      } catch (e) {
                        CDeviceHelper.showSnackbar(
                          "Error",
                          "Someerror occured while trying to update the offer",
                          CIcons.errorCross,
                        );
                      }
                    },
                    icon: Icon(Icons.delete, size: 20, color: CColors.grey),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
