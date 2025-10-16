import 'package:intl/intl.dart';

class CFormatter {
  CFormatter._();

  static String? getNamedDate(DateTime? date) {
    if (date == null) {
      return null;
    }
    return DateFormat.yMMMMd().format(date);
  }
}
