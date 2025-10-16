import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/common/order_details/controller/order_details_controller.dart';
import 'package:laundary_app/modules/common/order_details/widgets/details_helper.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool canEdit =
        AuthController.instance.userType.value != UserType.client;
    final controller = Get.find<OrderDetailsController>();

    return Container(
      height: CDeviceHelper.getScreenHeight() * 0.44,
      width: CDeviceHelper.getScreenWidth() * 0.82,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CColors.white.withAlpha(230),
      ),
      child: SingleChildScrollView(
        child: Obx(() {
          bool isCancelled =
              controller.order.value.status == OrderStatus.cancelled;
          bool isDelivered =
              controller.order.value.status == OrderStatus.delivered;
          bool isReady = controller.order.value.status == OrderStatus.ready;

          if (isReady || isCancelled || isDelivered) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Details",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: CColors.secondaryColor,
                  ),
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DetailTile(
                    name: "Order Type",
                    value: controller.order.value.type,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: GestureDetector(
                    onTap: () {
                      if (!canEdit) return;
                      Get.bottomSheet(
                        DetailsHelper.getClothesInput(context: context),
                        isScrollControlled: true,
                        isDismissible: true,
                      );
                    },
                    child: DetailTile(
                      name: "Clothes",
                      value: controller.order.value.clothes.toString(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: CLineDivider(isDashed: true),
                ),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      if (canEdit && !isCancelled && !isDelivered) {
                        Get.bottomSheet(
                          DetailsHelper.getCostInput(context: context),
                          isScrollControlled: true,
                          isDismissible: true,
                        );
                      }
                    },
                    child: DetailsHelper.getPricingTile(
                      name: "Subtotal",
                      value: controller.order.value.cost,
                    ),
                  ),
                ),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      if (canEdit && !isCancelled && !isDelivered) {
                        Get.bottomSheet(
                          DetailsHelper.getDiscountInput(context: context),
                          isScrollControlled: true,
                          isDismissible: true,
                        );
                      }
                    },
                    child: DetailsHelper.getPricingTile(
                      name: "Discount",
                      value: controller.order.value.discount,
                    ),
                  ),
                ),
                Obx(
                  () => DetailsHelper.getPricingTile(
                    name: "Total",
                    value:
                        controller.order.value.cost -
                        controller.order.value.discount,
                    isTotal: true,
                  ),
                ),
              ],
            );
          } else {
            String message =
                canEdit
                    ? "Update order details once the order is ready"
                    : "To be updated soon";
            return SizedBox(
              height: CDeviceHelper.getScreenHeight() * 0.4,
              width: CDeviceHelper.getScreenWidth() * 0.4,
              child: Center(
                child: Text(
                  message,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(color: CColors.black),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

class AddItemButton extends StatelessWidget {
  const AddItemButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          overlayColor: WidgetStateProperty.all(Colors.grey.withAlpha(50)),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: CColors.grey, width: 0.5),
            ),
          ),
        ),
        onPressed: () {
          // Get.bottomSheet(
          //   DetailsHelper.getItemPicker(context: context),
          //   isScrollControlled: true,
          //   isDismissible: true,
          // );
        },
        child: Text("Add Item", style: TextStyle(color: CColors.green)),
      ),
    );
  }
}

class DetailTile extends StatelessWidget {
  const DetailTile({super.key, required this.name, required this.value});

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: CDeviceHelper.getScreenWidth() * 0.74,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$name:",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 18,
              color: CColors.black,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: CColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemTypeTile extends StatelessWidget {
  const ItemTypeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Text("Name"), TextField()],
    );
  }
}

// class ListBuilder {
//   static List<Widget> getItemLists(
//     BuildContext context,
//     RxMap<String, Rx<bool>> types,
//     canEdit,
//   ) {
//     final items = <Widget>[];
//     for (var type in types.entries) {
//       if (canEdit) {
//         items.add(ItemsListEdit(type: type.key));
//       } else {
//         items.add(ItemsListStatic(type: type.key));
//       }
//     }

//     return items;
//   }
// }
