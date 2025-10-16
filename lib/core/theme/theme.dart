import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/theme/appbar_theme.dart';
import 'package:laundary_app/core/theme/bottom_sheet_theme.dart';
import 'package:laundary_app/core/theme/checkbox_theme.dart';
import 'package:laundary_app/core/theme/choice_chip_theme.dart';
import 'package:laundary_app/core/theme/elevated_button_theme.dart';
import 'package:laundary_app/core/theme/icon_theme.dart';
import 'package:laundary_app/core/theme/input_decoration_theme.dart';
import 'package:laundary_app/core/theme/navigationbar_theme.dart';
import 'package:laundary_app/core/theme/outlined_button_theme.dart';
import 'package:laundary_app/core/theme/popupmenu_theme.dart';
import 'package:laundary_app/core/theme/tabbar_theme.dart';
import 'package:laundary_app/core/theme/text_theme.dart';

class CAppTheme {
  CAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Robot",
    brightness: Brightness.light,
    primaryColor: CColors.primaryColor,
    scaffoldBackgroundColor: CColors.light,
    appBarTheme: CAppbarTheme.lightAppBarTheme,
    textTheme: CTextTheme.lightTextTheme,
    iconTheme: CIconTheme.lightIconTheme,
    checkboxTheme: CCheckboxTheme.lightCheckboxTheme,
    elevatedButtonTheme: CElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: COutlinedButtonTheme.lightOutlinedButtonThemeData,
    inputDecorationTheme: CInputDecorationTheme.lightInputDecorationTheme,
    bottomSheetTheme: CBottomSheetTheme.lightBottomSheetThemeData,
    tabBarTheme: CTabbarTheme.lightTabbarTheme,
    chipTheme: CChoiceChipTheme.lightChoiceChipTheme,
    popupMenuTheme: CPopupMenuTheme.lightPopupmenuTheme,
    navigationBarTheme: CNavigationbarTheme.lightNavbarTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Robot",
    brightness: Brightness.dark,
    primaryColor: CColors.primaryColor,
    scaffoldBackgroundColor: CColors.dark,
    appBarTheme: CAppbarTheme.darkAppBarTheme,
    textTheme: CTextTheme.darkTextTheme,
    iconTheme: CIconTheme.darkIconTheme,
    checkboxTheme: CCheckboxTheme.darkCheckboxTheme,
    elevatedButtonTheme: CElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: COutlinedButtonTheme.darkOutlinedButtonThemeData,
    inputDecorationTheme: CInputDecorationTheme.darkInputDecorationTheme,
    bottomSheetTheme: CBottomSheetTheme.darkBottomSheetThemeData,
    tabBarTheme: CTabbarTheme.darkTabbarTheme,
    chipTheme: CChoiceChipTheme.darkChoiceChipTheme,
    popupMenuTheme: CPopupMenuTheme.darkPopupmenuTheme,
    navigationBarTheme: CNavigationbarTheme.darkNavbarTheme,
  );
}
