import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';

class CPopupMenuTheme {
  CPopupMenuTheme._();

  static PopupMenuThemeData lightPopupmenuTheme = PopupMenuThemeData(
    color: CColors.light,
    textStyle: TextStyle(color: CColors.black),
    elevation: 6,
    // menuPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    shadowColor: CColors.shadow,
  );

  static PopupMenuThemeData darkPopupmenuTheme = PopupMenuThemeData(
    color: CColors.dark,
    textStyle: TextStyle(color: CColors.white),
    elevation: 6,
    // menuPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    shadowColor: CColors.shadow,
  );
}
