import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/common/order_details/controller/order_details_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DetailsHelper {
  DetailsHelper._();

  static Widget getTitle(BuildContext context) {
    return Text(
      "Order Details",
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.bold,
        color: CColors.black,
      ),
    );
  }

  static Widget getWashTypeHeader({
    required String name,
    required BuildContext context,
    required Icon icon,
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: CColors.darkGrey,
          ),
        ),
        IconButton(onPressed: onPressed, icon: icon),
      ],
    );
  }

  static Widget getItemTile({
    required int amount,
    required String name,
    required int price,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: amount.toString(),
                style: TextStyle(
                  color: CColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              TextSpan(
                text: " x ",
                style: TextStyle(
                  color: CColors.darkGrey,
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
              TextSpan(
                text: name,
                style: TextStyle(
                  color: CColors.darkGrey,
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Text(
          "₹${amount * price}",
          style: TextStyle(
            color: CColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  static Widget getPricingTile({
    required String name,
    required int value,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
            color: isTotal ? CColors.black : CColors.darkGrey,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w300,
            fontSize: isTotal ? 20 : 16,
          ),
        ),
        Text(
          value >= 0 ? "₹$value" : "-₹${value * -1}",
          style: TextStyle(
            color:
                isTotal
                    ? CColors.green
                    : (value >= 0 ? CColors.black : CColors.red),
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 22 : 18,
          ),
        ),
      ],
    );
  }

  // static Widget getItemPicker({required BuildContext context}) {
  //   final controller = Get.find<OrderDetailsController>();
  //   final orderItems = <Widget>[];
  //   List<String> names =
  //       WashTypeController.instance.washTypes.map((t) => t.value.name).toList();
  //   Map<String, int> orderTypesCounts = controller.order.value.orderTypeCounts;
  //   List<TextEditingController> textControllers = [];

  //   for (int i = 0; i < names.length; i++) {
  //     int a = orderTypesCounts[names[i]] ?? 0;
  //     textControllers.add(TextEditingController());
  //     textControllers[i].text = a.toString();
  //     orderItems.add(ItemTile(name: names[i], controller: textControllers[i]));
  //   }

  //   return SafeArea(
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(15),
  //           topRight: Radius.circular(15),
  //         ),
  //         color: Theme.of(context).scaffoldBackgroundColor,
  //       ),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(left: 10),
  //               child: Text(
  //                 "Add Order Items",
  //                 style: Theme.of(context).textTheme.headlineMedium,
  //               ),
  //             ),
  //             SizedBox(height: 10),
  //             Column(children: orderItems),
  //             SizedBox(height: 30),
  //             Align(
  //               alignment: Alignment.centerRight,
  //               child: SizedBox(
  //                 width: 150,
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     controller.updateItems(
  //                       names,
  //                       textControllers
  //                           .map((c) => int.tryParse(c.text) ?? 0)
  //                           .toList(),
  //                     );
  //                     Get.back();
  //                   },
  //                   child: Text("Confirm"),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  static Widget getClothesInput({required BuildContext context}) {
    final controller = Get.find<OrderDetailsController>();
    final TextEditingController clothes = TextEditingController();
    clothes.text = controller.order.value.clothes.toString();

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Clothes", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            TextField(
              controller: clothes,
              decoration: InputDecoration(hintText: "Enter clothes amount"),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.back();
                  controller.setClothes(int.tryParse(clothes.text) ?? 0);
                },
                child: Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget getDiscountInput({required BuildContext context}) {
    final controller = Get.find<OrderDetailsController>();
    final TextEditingController discount = TextEditingController();
    discount.text = controller.order.value.discount.toString();

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // <-- THIS is important
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Discount", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            TextField(
              controller: discount,
              decoration: InputDecoration(hintText: "Enter discount value"),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.back();
                  controller.setDiscount(int.tryParse(discount.text) ?? 0);
                },
                child: Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget getCostInput({required BuildContext context}) {
    final controller = Get.find<OrderDetailsController>();
    final TextEditingController cost = TextEditingController();
    cost.text = controller.order.value.cost.toString();

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Cost", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            TextField(
              controller: cost,
              decoration: InputDecoration(hintText: "Enter cost value"),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.back();
                  controller.setCost(int.tryParse(cost.text) ?? 0);
                },
                child: Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showDatePicker() {
    final controller = Get.find<OrderDetailsController>();
    DateTime? deliveryDate = controller.order.value.deliveryDate;

    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SfDateRangePicker(
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.single,
                rangeSelectionColor: CColors.primaryColor.withAlpha(75),
                startRangeSelectionColor: CColors.primaryColor,
                endRangeSelectionColor: CColors.primaryColor,
                todayHighlightColor: CColors.blue,

                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is DateTime) {
                    deliveryDate = args.value;
                  }
                },
                initialSelectedDate: deliveryDate ?? DateTime.now(),
                minDate: DateTime.now(),
                maxDate: DateTime.now().add(Duration(days: 120)),
              ),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (deliveryDate != null) {
                      controller.order.value = controller.order.value.copyWith(
                        deliveryDate: deliveryDate,
                      );
                      Get.back();
                      controller.hasUpdated.value = true;
                    }
                  },
                  child: const Text("Confirm"),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class ItemTile extends StatelessWidget {
  const ItemTile({super.key, required this.name, required this.controller});

  final String name;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Icon(FontAwesomeIcons.shirt, size: 24, color: CColors.grey),
          ),
          Expanded(
            flex: 4,
            child: SizedBox(
              width: 140,
              child: Text(name, style: Theme.of(context).textTheme.labelMedium),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: controller,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                cursorColor: CColors.grey,
                cursorHeight: 18,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CColors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CColors.darkGrey),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusTile extends StatelessWidget {
  const StatusTile({
    super.key,
    required this.status,
    required this.curStatus,
    required this.onSelect,
  });
  final OrderStatus status;
  final OrderStatus curStatus;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: curStatus.value < 3 && status.value > 2,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          splashColor: CColors.lightGrey,
          onTap: () => onSelect(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                status
                    .toShortString()
                    .toUpperCase(), // Custom string method or `.name`
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight:
                      status == curStatus ? FontWeight.w500 : FontWeight.w400,
                  color:
                      (curStatus.value < 3 && status.value > 2)
                          ? CColors.grey
                          : CColors.darkGrey,
                ),
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}
