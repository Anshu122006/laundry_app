import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/constants/font_data.dart';

class CTextTheme {
  CTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: CFontSizes.headlineLarge,
      color: CColors.black,
      fontWeight: CFontWeights.extraBold,
      fontFamily: CFontFamily.poppins,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: CFontSizes.headlineMedium,
      color: CColors.black,
      fontWeight: CFontWeights.extraBold,
      fontFamily: CFontFamily.poppins,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: CFontSizes.headlineSmall,
      color: CColors.black,
      fontWeight: CFontWeights.extraBold,
      fontFamily: CFontFamily.poppins,
    ),

    titleLarge: const TextStyle().copyWith(
      fontSize: CFontSizes.titleLarge,
      color: CColors.black,
      fontWeight: CFontWeights.bold,
      fontFamily: CFontFamily.poppins,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: CFontSizes.titleMedium,
      color: CColors.black,
      fontWeight: CFontWeights.bold,
      fontFamily: CFontFamily.poppins,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: CFontSizes.titelSmall,
      color: CColors.black,
      fontWeight: CFontWeights.bold,
      fontFamily: CFontFamily.poppins,
    ),

    bodyLarge: const TextStyle().copyWith(
      fontSize: CFontSizes.bodyLarge,
      color: CColors.black,
      fontWeight: CFontWeights.normal,
      fontFamily: CFontFamily.poppins,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: CFontSizes.bodyMedium,
      color: CColors.black,
      fontWeight: CFontWeights.normal,
      fontFamily: CFontFamily.poppins,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: CFontSizes.bodySmall,
      color: CColors.black,
      fontWeight: CFontWeights.normal,
      fontFamily: CFontFamily.poppins,
    ),

    labelLarge: const TextStyle().copyWith(
      fontSize: CFontSizes.labelLarge,
      color: CColors.darkGrey,
      fontWeight: CFontWeights.normalThin,
      fontFamily: CFontFamily.poppins,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: CFontSizes.labelMedium,
      color: CColors.darkGrey,
      fontWeight: CFontWeights.thin,
      fontFamily: CFontFamily.poppins,
    ),
    labelSmall: const TextStyle().copyWith(
      fontSize: CFontSizes.labelSmall,
      color: CColors.darkGrey,
      fontWeight: CFontWeights.thin,
      fontFamily: CFontFamily.poppins,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: CFontSizes.headlineLarge,
      color: CColors.white,
      fontWeight: CFontWeights.extraBold,
      fontFamily: CFontFamily.poppins,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: CFontSizes.headlineMedium,
      color: CColors.white,
      fontWeight: CFontWeights.extraBold,
      fontFamily: CFontFamily.poppins,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: CFontSizes.headlineSmall,
      color: CColors.white,
      fontWeight: CFontWeights.extraBold,
      fontFamily: CFontFamily.poppins,
    ),

    titleLarge: const TextStyle().copyWith(
      fontSize: CFontSizes.titleLarge,
      color: CColors.white,
      fontWeight: CFontWeights.bold,
      fontFamily: CFontFamily.poppins,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: CFontSizes.titleMedium,
      color: CColors.white,
      fontWeight: CFontWeights.bold,
      fontFamily: CFontFamily.poppins,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: CFontSizes.titelSmall,
      color: CColors.white,
      fontWeight: CFontWeights.bold,
      fontFamily: CFontFamily.poppins,
    ),

    bodyLarge: const TextStyle().copyWith(
      fontSize: CFontSizes.bodyLarge,
      color: CColors.white,
      fontWeight: CFontWeights.normal,
      fontFamily: CFontFamily.poppins,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: CFontSizes.bodyMedium,
      color: CColors.white,
      fontWeight: CFontWeights.normal,
      fontFamily: CFontFamily.poppins,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: CFontSizes.bodySmall,
      color: CColors.white,
      fontWeight: CFontWeights.normal,
      fontFamily: CFontFamily.poppins,
    ),

    labelLarge: const TextStyle().copyWith(
      fontSize: CFontSizes.labelLarge,
      color: CColors.white,
      fontWeight: CFontWeights.normalThin,
      fontFamily: CFontFamily.poppins,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: CFontSizes.labelMedium,
      color: CColors.white,
      fontWeight: CFontWeights.thin,
      fontFamily: CFontFamily.poppins,
    ),
    labelSmall: const TextStyle().copyWith(
      fontSize: CFontSizes.labelSmall,
      color: CColors.white,
      fontWeight: CFontWeights.thin,
      fontFamily: CFontFamily.poppins,
    ),
  );
}
