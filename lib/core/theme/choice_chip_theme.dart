import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/constants/font_data.dart';

class CChoiceChipTheme {
  CChoiceChipTheme._();

  static ChipThemeData lightChoiceChipTheme = ChipThemeData(
    selectedColor: CColors.primaryColor,
    secondarySelectedColor: CColors.secondaryColor,
    backgroundColor: CColors.transparent,
    disabledColor: CColors.grey.withAlpha(50),
    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
    labelStyle: TextStyle(
      color: CColors.black,
      fontSize: CFontSizes.labelMedium,
    ),
    secondaryLabelStyle: TextStyle(
      color: CColors.white,
      fontSize: CFontSizes.labelMedium,
      fontWeight: CFontWeights.bold,
    ),
    checkmarkColor: CColors.white,
    brightness: Brightness.light,
  );

  static ChipThemeData darkChoiceChipTheme = ChipThemeData(
    selectedColor: CColors.primaryColor,
    secondarySelectedColor: CColors.secondaryColor,
    backgroundColor: CColors.transparent,
    disabledColor: CColors.grey.withAlpha(50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
    labelStyle: TextStyle(
      color: CColors.white,
      fontSize: CFontSizes.labelMedium,
    ),
    secondaryLabelStyle: TextStyle(
      color: CColors.black,
      fontSize: CFontSizes.labelMedium,
      fontWeight: CFontWeights.bold,
    ),
    checkmarkColor: CColors.black,
    brightness: Brightness.dark,
  );
}
