import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/modules/employee/passbook/controller/passbook_controller.dart';
import 'package:laundary_app/modules/employee/passbook/widgets/add_amount_bottomsheet.dart';
import 'package:laundary_app/modules/employee/passbook/widgets/date_picker_helper.dart';
import 'package:laundary_app/modules/employee/passbook/widgets/transactionn_history.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';

class PassbookScreen extends StatelessWidget {
  const PassbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PassbookScreenController>();

    return Scaffold(
      body: LayoutBuilder(
        builder:
            (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 25,
                        left: 15,
                        right: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CBackButton(),
                          Transform.translate(
                            offset: Offset(0, 16),
                            child: IconButton(
                              onPressed: () {
                                DatePickerHelper.show();
                              },
                              icon: Icon(
                                Icons.calendar_month,
                                size: 32,
                                color:
                                    CDeviceHelper.isDarkMode()
                                        ? CColors.light
                                        : CColors.dark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Passbook",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    Center(
                      child: Image(
                        image: AssetImage("assets/illustrations/passbook.png"),
                        height: 350,
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Orders:   ",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Obx(
                                  () => Text(
                                    controller.orders.value.toString(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Added:   ",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Obx(
                                  () => Text(
                                    "₹${controller.added.value}",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Added",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                      ),
                                      TextSpan(
                                        text: " (Unregistered Users)",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium!.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color:
                                              CDeviceHelper.isDarkMode()
                                                  ? CColors.white
                                                  : CColors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " : ",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(AddAmountBottomSheet());
                                  },
                                  child: Obx(
                                    () => Text(
                                      "₹${controller.unregisteredAdded.value}",
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Removed:   ",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Obx(
                                  () => Text(
                                    "₹${controller.removed.value}",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Net Change:   ",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Obx(
                                  () => Text(
                                    "₹${controller.added.value - controller.removed.value}",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TransactionHistory(),
                    SizedBox(height: 40),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     int start =
                    //         controller.startDate.value.millisecondsSinceEpoch;
                    //     int end =
                    //         controller.endDate.value
                    //             .add(Duration(days: 1))
                    //             .millisecondsSinceEpoch;

                    //     List<LaundryTransaction> transactions =
                    //         TransactionController.instance.transactions
                    //             .map((t) => t.value)
                    //             .where(
                    //               (t) =>
                    //                   t.date.millisecondsSinceEpoch >= start &&
                    //                   t.date.millisecondsSinceEpoch <= end &&
                    //                   t.client == null,
                    //             )
                    //             .toList();
                    //     double unregisteredadded = transactions.fold(
                    //       0.0,
                    //       (sum, t) => sum + t.amount,
                    //     );
                    //     controller.getUnregisteredadded();
                    //     print(controller.unregisteredadded.value);
                    //   },
                    //   child: Text("Test"),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: CLineDivider(),
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: Text(
                        "Pick an interval from the calender and view the\ndata for that interval",
                        style: Theme.of(context).textTheme.labelMedium,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
