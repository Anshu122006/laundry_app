import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/modules/employee/passbook/controller/passbook_controller.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(), // Firm, rigid scroll style
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CBackButton(),
                    Transform.translate(
                      offset: const Offset(0, 16),
                      child: IconButton(
                        onPressed: () => DatePickerHelper.show(),
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
              const Center(
                child: Image(
                  image: AssetImage("assets/illustrations/passbook.png"),
                  height: 350,
                ),
              ),
              Center(
                child: SizedBox(
                  width: CDeviceHelper.getScreenWidth() * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Orders:   ",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Obx(
                            () => Text(
                              controller.totalOrders.toString(),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Added:   ",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Obx(
                            () => Text(
                              "₹${controller.totalAdded}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Removed (Ordered):   ",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Obx(
                            () => Text(
                              "₹${controller.totalRemovedOrdered}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Removed (Unordered):   ",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Obx(
                            () => Text(
                              "₹${controller.totalRemovedUnordered}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Net Change:   ",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Obx(
                            () => Text(
                              "₹${controller.netChange}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const TransactionHistory(),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: CLineDivider(),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  "Pick an interval from the calendar and view the\ndata for that interval",
                  style: Theme.of(context).textTheme.labelMedium,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
    );
  }
}
