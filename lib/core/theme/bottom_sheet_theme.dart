import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';

class CBottomSheetTheme {
  CBottomSheetTheme._();

  static BottomSheetThemeData lightBottomSheetThemeData = BottomSheetThemeData(
    backgroundColor: CColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    elevation: 5,
    modalBackgroundColor: CColors.white,
  );

  static BottomSheetThemeData darkBottomSheetThemeData = BottomSheetThemeData(
    backgroundColor: CColors.black,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    elevation: 5,
    modalBackgroundColor: CColors.black,
  );
}
