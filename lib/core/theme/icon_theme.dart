import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';

class CIconTheme {
  CIconTheme._();

  static IconThemeData lightIconTheme = IconThemeData(
    color: CColors.darkGrey,
    size: 25,
    opacity: 0.9,
  );

  static IconThemeData darkIconTheme = IconThemeData(
    color: CColors.white,
    size: 25,
    opacity: 0.9,
  );
}
