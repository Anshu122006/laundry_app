import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/constants/font_data.dart';
import 'package:laundary_app/core/constants/size_values.dart';

class CTabbarTheme {
  CTabbarTheme._();
  static TabBarThemeData lightTabbarTheme = TabBarThemeData(
    labelColor: CColors.secondaryColor,
    unselectedLabelColor: CColors.secondaryColor,
    labelStyle: TextStyle(
      fontSize: CFontSizes.labelLarge * 1.2,
      fontWeight: CFontWeights.bold,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: CFontSizes.labelLarge,
      fontWeight: CFontWeights.normal,
    ),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        width: CBorderWidths.thick,
        color: CColors.transparent,
      ),
    ),
    tabAlignment: TabAlignment.start,
    dividerColor: CColors.transparent,
  );

  static TabBarThemeData darkTabbarTheme = TabBarThemeData(
    labelColor: CColors.secondaryColor,
    unselectedLabelColor: CColors.secondaryColor,
    labelStyle: TextStyle(
      fontSize: CFontSizes.labelLarge * 1.2,
      fontWeight: CFontWeights.bold,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: CFontSizes.labelLarge,
      fontWeight: CFontWeights.normal,
    ),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        width: CBorderWidths.thick,
        color: CColors.transparent,
      ),
    ),
    tabAlignment: TabAlignment.start,
    dividerColor: CColors.transparent,
  );
}
