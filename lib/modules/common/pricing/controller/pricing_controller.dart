import 'package:get/get.dart';
import 'package:laundary_app/data/models/pricing.dart';

class PricingScreenController extends GetxController {
  final filteredPricings = <Rx<Pricing>>[].obs;
  final RxString searchQuery = "".obs;
  final RxString sortBy = "name".obs;

  List<Pricing> getFilteredPricings(List<Pricing> pricings) {
    final query = searchQuery.value.toLowerCase().replaceAll(
      RegExp(r'\s+'),
      '',
    );
    final sortKey = sortBy.value;

    Iterable<Pricing> result;
    if (query.isEmpty) {
      result = pricings;
    } else {
      result = pricings.where((pricing) {
        final value =
            sortKey == "name"
                ? pricing.name.toLowerCase().replaceAll(RegExp(r'\s+'), '')
                : sortKey == "type"
                ? pricing.type.toLowerCase().replaceAll(RegExp(r'\s+'), '')
                : pricing.cost.toString();
        return value.contains(query);
      });
    }

    final sortedList =
        result.toList()..sort((a, b) {
          final aValue =
              sortKey == "name"
                  ? a.name.toLowerCase()
                  : sortKey == "type"
                  ? a.type.toLowerCase()
                  : a.cost.toString();
          final bValue =
              sortKey == "name"
                  ? b.name.toLowerCase()
                  : sortKey == "type"
                  ? b.type.toLowerCase()
                  : b.cost.toString();
          return aValue.compareTo(bValue);
        });

    return sortedList;
  }
}
