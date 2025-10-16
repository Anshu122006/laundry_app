import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/constants/size_values.dart';

class CCheckboxTheme {
  CCheckboxTheme._();

  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: BorderSide(color: CColors.grey, width: CBorderWidths.normal),
    materialTapTargetSize: MaterialTapTargetSize.padded,
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return CColors.checkboxFillColor;
      }
      return CColors.transparent;
    }),
    checkColor: WidgetStateProperty.resolveWith((states) {
      return CColors.white;
    }),
  );

  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: BorderSide(color: CColors.grey, width: CBorderWidths.normal),
    materialTapTargetSize: MaterialTapTargetSize.padded,
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return CColors.checkboxFillColor;
      }
      return CColors.transparent;
    }),
    checkColor: WidgetStateProperty.resolveWith((states) {
      return CColors.white;
    }),
  );
}
