import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/pricing_controller.dart';
import 'package:laundary_app/data/controllers/wash_type_controller.dart';
import 'package:laundary_app/data/db_cloud/wash_type_cloud_db.dart';
import 'package:laundary_app/data/models/pricing.dart';
import 'package:laundary_app/data/models/wash_type.dart';
import 'package:laundary_app/modules/common/pricing/widgets/inputs.dart';
import 'package:laundary_app/modules/common/pricing/widgets/pricing_header.dart';
import 'package:laundary_app/modules/common/pricing/widgets/pricing_tile.dart';
import 'package:laundary_app/core/constants/colors.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool canEdit = AuthController.instance.userType.value == UserType.admin;
    print(PricingController.instance.pricings);

    return Scaffold(
      body: LayoutBuilder(
        builder:
            (context, constraints) => ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight,
                maxWidth: constraints.maxWidth,
              ),
              child: CustomScrollView(
                slivers: [
                  PricingHeader.getHeader(context),
                  Obx(() {
                    final types = WashTypeController.instance.washTypes;
                    types.sort(
                      (a, b) => a.value.priority.compareTo(b.value.priority),
                    );
                    Set<String> usedTypes = {};
                    for (var p in PricingController.instance.pricings) {
                      usedTypes.add(p.value.type);
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: types.length,
                        (_, index) {
                          if (!canEdit &&
                              !usedTypes.contains(types[index].value.name)) {
                            return SizedBox();
                          }

                          return Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              bottom: 20,
                            ),
                            child: Obx(() {
                              List<Pricing> pricings =
                                  PricingController.instance.pricings
                                      .map((p) => p.value)
                                      .where(
                                        (p) =>
                                            p.type == types[index].value.name,
                                      )
                                      .toList();
                              pricings.sort(
                                (a, b) => a.priority.compareTo(b.priority),
                              );

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TypeHeader(
                                    washType: types[index].value,
                                    canEdit: canEdit,
                                  ),
                                  Column(
                                    children:
                                        pricings
                                            .map((p) => PricingTile(pricing: p))
                                            .toList(),
                                  ),
                                ],
                              );
                            }),
                          );
                        },
                      ),
                    );
                  }),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          canEdit
                              ? "Click on the price of a cloth\nto update it"
                              : "These are prices per piece for both\nmen and women",
                          style: Theme.of(context).textTheme.labelMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ),
      // floatingActionButton:
      //     canEdit
      //         ? ElevatedButton(
      //           onPressed:
      //               () => Get.bottomSheet(
      //                 PricingInputs.getAddInput(context, ""),
      //                 isDismissible: true,
      //                 isScrollControlled: true,
      //               ),
      //           style: ElevatedButton.styleFrom(
      //             fixedSize: Size.fromHeight(60),
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(20),
      //             ),
      //           ),
      //           child: Transform.scale(
      //             scale: 1.2,
      //             child: Icon(
      //               Icons.add,
      //               color: CColors.white,
      //               size: 24,
      //               weight: 1,
      //             ),
      //           ),
      //         )
      //         : null,
    );
  }
}

class TypeHeader extends StatelessWidget {
  const TypeHeader({super.key, required this.washType, required this.canEdit});

  final WashType washType;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            washType.name,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              // color: CColors.primaryColor,
            ),
          ),
        ),
        if (canEdit)
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  try {
                    await WashTypeCloudDb.instance.decrementPriority(washType);
                  } catch (e) {
                    CDeviceHelper.showSnackbar(
                      "Error",
                      "Some error occured while trying to update the pricing",
                      CIcons.errorCross,
                    );
                  }
                },
                icon: Icon(Icons.arrow_upward, size: 23, color: CColors.grey),
              ),
              IconButton(
                onPressed: () async {
                  try {
                    await WashTypeCloudDb.instance.incrementPriority(washType);
                  } catch (e) {
                    CDeviceHelper.showSnackbar(
                      "Error",
                      "Some error occured while trying to update the pricing",
                      CIcons.errorCross,
                    );
                  }
                },
                icon: Icon(Icons.arrow_downward, size: 23, color: CColors.grey),
              ),
              IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    PricingInputs.getAddInput(context, washType.name),
                    isDismissible: true,
                    isScrollControlled: true,
                  );
                },
                icon: Icon(Icons.add, size: 23, color: CColors.grey),
              ),
            ],
          ),
      ],
    );
  }
}
