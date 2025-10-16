import 'package:flutter/widgets.dart';

class HDimensions {
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double statusHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }
}

class CDateHelper {
  CDateHelper._();

  static int getRemainingDays(DateTime? date) {
    if (date != null) {
      return date.difference(DateTime.now()).inDays;
    } else {
      return -1;
    }
  }

  static bool isToday(DateTime? date) {
    if (date != null) {
      DateTime now = DateTime.now();
      return date.day == now.day &&
          date.month == now.month &&
          date.year == now.year;
    } else {
      return false;
    }
  }
}
