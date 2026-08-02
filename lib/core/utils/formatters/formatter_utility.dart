import 'package:intl/intl.dart';

class CFormatter {
  CFormatter._();

  static String? getNamedDate(DateTime? date) {
    if (date == null) {
      return null;
    }
    return DateFormat.yMMMMd().format(date);
  }

  static DateTime? getDateTime(String? dateName) {
    if (dateName == null || dateName.isEmpty) return null;
    try {
      final cleaned = dateName.replaceFirst(' at ', ' ');
      final withoutUtc = cleaned.split(' UTC').first;
      return DateTime.parse(withoutUtc);
    } catch (e) {
      return null;
    }
  }

  static String getWashType(String type) {
    return type.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
  }
}
