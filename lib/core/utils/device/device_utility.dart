import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';

class CDeviceHelper {
  CDeviceHelper._();

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void setStatusbarColor(BuildContext context, Color color) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color),
    );
  }

  static bool isLandscapeOriented(BuildContext context) {
    final viewInsets = View.of(context).viewInsets;

    return viewInsets.bottom == 0;
  }

  static bool isPotraitOriented(BuildContext context) {
    final viewInsets = View.of(context).viewInsets;

    return viewInsets.bottom != 0;
  }

  static void setFullScreen(bool enable) {
    SystemChrome.setEnabledSystemUIMode(
      enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }

  static double getScreenHeight() {
    return Get.height;
  }

  static double getScreenWidth() {
    return Get.width;
  }

  static double getPixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  static double statusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static bool isPhysicalDevice() {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  static bool isDarkMode() {
    return Get.isDarkMode;
  }

  static void vibrate() {
    HapticFeedback.vibrate();
    Future.delayed(Duration(seconds: 0), () => HapticFeedback.vibrate());
  }

  static Future<void> setPreferredOrientations(
    List<DeviceOrientation> orientations,
  ) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getKeyboardHeight() {
    final viewInsets = MediaQuery.of(Get.context!).viewInsets;
    return viewInsets.bottom;
  }

  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup("example.com");
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      // ignore: unused_catch_clause
    } on SocketException catch (e) {
      return false;
    }
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool isIOS() {
    return Platform.isIOS;
  }

  static void showSnackbar(String title, String message, Icon icon) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color.fromARGB(255, 245, 250, 255),
      colorText: CColors.secondaryColor,
      borderRadius: 12,
      margin: EdgeInsets.all(12),
      icon: icon,
      shouldIconPulse: false,
      duration: Duration(seconds: 3),
      overlayBlur: 0.1,
      snackStyle: SnackStyle.FLOATING,
      isDismissible: true,
      forwardAnimationCurve: Curves.linear,
    );
  }

  static void showDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    // bool isDark = Get.isDarkMode;
    Get.dialog(
      Center(
        child: Container(
          width: Get.width * 0.75,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Text(title, style: Get.textTheme.titleMedium),
              Text(
                message,
                style: Get.textTheme.labelLarge,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text("Ok", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showBottomSheet(Widget bottomsheet) {
    Get.bottomSheet(bottomsheet, isDismissible: true, isScrollControlled: true);
  }
}
