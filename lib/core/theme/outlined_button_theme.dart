import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/constants/font_data.dart';
import 'package:laundary_app/core/constants/size_values.dart';

class COutlinedButtonTheme {
  COutlinedButtonTheme._();

  static OutlinedButtonThemeData lightOutlinedButtonThemeData =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CColors.darkGrey,
          side: BorderSide(color: CColors.darkGrey, width: CBorderWidths.thick),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: TextStyle(
            fontSize: CFontSizes.bodyLarge,
            fontWeight: CFontWeights.bold,
          ),
        ),
      );

  static OutlinedButtonThemeData darkOutlinedButtonThemeData =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CColors.grey,
          side: BorderSide(color: CColors.grey, width: CBorderWidths.thick),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: TextStyle(
            fontSize: CFontSizes.bodyLarge,
            fontWeight: CFontWeights.bold,
          ),
        ),
      );
}
