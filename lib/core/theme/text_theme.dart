import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/constants/font_data.dart';

class CTextTheme {
  CTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: CFontSizes.headlineLarge,
      color: CColors.black,
      fontWeight: CFontWeights.extraBold,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: CFontSizes.headlineMedium,
      color: CColors.black,
      fontWeight: CFontWeights.extraBold,
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: CFontSizes.headlineSmall,
      color: CColors.black,
      fontWeight: CFontWeights.extraBold,
    ),

    titleLarge: TextStyle().copyWith(
      fontSize: CFontSizes.titleLarge,
      color: CColors.black,
      fontWeight: CFontWeights.bold,
    ),
    titleMedium: TextStyle().copyWith(
      fontSize: CFontSizes.titleMedium,
      color: CColors.black,
      fontWeight: CFontWeights.bold,
    ),
    titleSmall: TextStyle().copyWith(
      fontSize: CFontSizes.titelSmall,
      color: CColors.black,
      fontWeight: CFontWeights.bold,
    ),

    bodyLarge: TextStyle().copyWith(
      fontSize: CFontSizes.bodyLarge,
      color: CColors.black,
      fontWeight: CFontWeights.normal,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: CFontSizes.bodyMedium,
      color: CColors.black,
      fontWeight: CFontWeights.normal,
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: CFontSizes.bodySmall,
      color: CColors.black,
      fontWeight: CFontWeights.normal,
    ),

    labelLarge: TextStyle().copyWith(
      fontSize: CFontSizes.labelLarge,
      color: CColors.darkGrey,
      fontWeight: CFontWeights.normalThin,
    ),
    labelMedium: TextStyle().copyWith(
      fontSize: CFontSizes.labelMedium,
      color: CColors.darkGrey,
      fontWeight: CFontWeights.thin,
    ),
    labelSmall: TextStyle().copyWith(
      fontSize: CFontSizes.labelSmall,
      color: CColors.darkGrey,
      fontWeight: CFontWeights.thin,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: CFontSizes.headlineLarge,
      color: CColors.white,
      fontWeight: CFontWeights.extraBold,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: CFontSizes.headlineMedium,
      color: CColors.white,
      fontWeight: CFontWeights.extraBold,
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: CFontSizes.headlineSmall,
      color: CColors.white,
      fontWeight: CFontWeights.extraBold,
    ),

    titleLarge: TextStyle().copyWith(
      fontSize: CFontSizes.titleLarge,
      color: CColors.white,
      fontWeight: CFontWeights.bold,
    ),
    titleMedium: TextStyle().copyWith(
      fontSize: CFontSizes.titleMedium,
      color: CColors.white,
      fontWeight: CFontWeights.bold,
    ),
    titleSmall: TextStyle().copyWith(
      fontSize: CFontSizes.titelSmall,
      color: CColors.white,
      fontWeight: CFontWeights.bold,
    ),

    bodyLarge: TextStyle().copyWith(
      fontSize: CFontSizes.bodyLarge,
      color: CColors.white,
      fontWeight: CFontWeights.normal,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: CFontSizes.bodyMedium,
      color: CColors.white,
      fontWeight: CFontWeights.normal,
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: CFontSizes.bodySmall,
      color: CColors.white,
      fontWeight: CFontWeights.normal,
    ),

    labelLarge: TextStyle().copyWith(
      fontSize: CFontSizes.labelLarge,
      color: CColors.white,
      fontWeight: CFontWeights.normalThin,
    ),
    labelMedium: TextStyle().copyWith(
      fontSize: CFontSizes.labelMedium,
      color: CColors.white,
      fontWeight: CFontWeights.thin,
    ),
    labelSmall: TextStyle().copyWith(
      fontSize: CFontSizes.labelSmall,
      color: CColors.white,
      fontWeight: CFontWeights.thin,
    ),
  );
}
