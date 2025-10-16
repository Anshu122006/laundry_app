import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/modules/client/wallet/controller/wallet_screen_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ClientDatePickerHelper {
  static void show() {
    final controller = Get.find<WalletScreenController>();
    DateTime? startDate = controller.startDate.value;
    DateTime? endDate = controller.endDate.value;
    DateTime.now();

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
                selectionMode: DateRangePickerSelectionMode.range,
                rangeSelectionColor: CColors.primaryColor.withAlpha(75),
                startRangeSelectionColor: CColors.primaryColor,
                endRangeSelectionColor: CColors.primaryColor,
                todayHighlightColor: CColors.blue,

                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is PickerDateRange) {
                    startDate = args.value.startDate;
                    endDate = args.value.endDate;
                  }
                },
                initialSelectedRange: PickerDateRange(startDate, endDate),
                minDate: DateTime(2020),
                maxDate: DateTime.now(),
              ),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (startDate != null && endDate != null) {
                      controller.startDate.value = startDate!;
                      controller.endDate.value = endDate!;
                      Get.back();
                      controller.updateData();
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
