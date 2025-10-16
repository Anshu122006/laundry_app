import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/constants/font_data.dart';

class CAppbarTheme {
  CAppbarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: CColors.appBarBackColorLight,
    foregroundColor: CColors.appBarFrontColorLight,
    elevation: 0,
    scrolledUnderElevation: 0,

    titleTextStyle: TextStyle(
      fontSize: CFontSizes.headlineSmall,
      fontWeight: CFontWeights.bold,
      color: CColors.black,
      // fontFamily: CFontFamily.robot,
    ),
    iconTheme: IconThemeData(
      color: CColors.iconColorLight,
      size: CFontSizes.headlineSmall,
    ),
  );

  static AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: CColors.appBarBackColorDark,
    foregroundColor: CColors.appBarFrontColorDark,
    elevation: 0,
    scrolledUnderElevation: 0,

    titleTextStyle: TextStyle(
      fontSize: CFontSizes.headlineSmall,
      fontWeight: CFontWeights.bold,
      color: CColors.white,
      // fontFamily: CFontFamily.robotMono,
    ),
    iconTheme: IconThemeData(
      color: CColors.iconColorDark,
      size: CFontSizes.headlineSmall,
    ),
  );
}
