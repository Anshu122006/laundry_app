import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/modules/employee/passbook/controller/passbook_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerHelper {
  static void show() {
    final controller = Get.find<PassbookScreenController>();

    // Track local changes inside the bottom sheet picker before confirmation
    DateTime localStartDate = controller.startDate.value;
    DateTime localEndDate = controller.endDate.value;

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
                initialSelectedRange: PickerDateRange(
                  localStartDate,
                  localEndDate,
                ),
                minDate: DateTime(2020),
                maxDate: DateTime.now(),
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is PickerDateRange) {
                    if (args.value.startDate != null) {
                      localStartDate = args.value.startDate!;
                      // Fallback: If user selects only 1 day, treat it as both start and end
                      localEndDate =
                          args.value.endDate ?? args.value.startDate!;
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // 1. Assign values to reactive controller fields
                    // (This instantly triggers all realtime calculated properties in the UI)
                    controller.startDate.value = localStartDate;
                    controller.endDate.value = localEndDate;

                    // 2. Dismiss the picker sheet
                    Get.back();
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
