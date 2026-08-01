import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/order.dart';

class OrderListController extends GetxController {
  final RxString searchQuery = "".obs;
  final RxString sortBy = "type".obs;

  List<LaundryOrder> getFilteredOrders(List<Rx<LaundryOrder>> liveOrders) {
    final query = searchQuery.value.toLowerCase().replaceAll(
      RegExp(r'\s+'),
      '',
    );
    final sortKey = sortBy.value;

    // 1. Resolve Auth user scope parameters safely
    final currentClient = AuthController.instance.currentClient.value;
    final isClient = AuthController.instance.userType.value == UserType.client;

    // 2. Build Client Lookup Map safely
    Map<String, Client> clients = {};
    if (isClient) {
      if (currentClient != null) {
        clients[currentClient.id] = currentClient;
      }
    } else {
      clients = Map.fromEntries(
        ClientController.instance.clients.map(
          (c) => MapEntry(c.value.id, c.value),
        ),
      );
    }

    // 3. Extract, scope filter, and map real-time instances
    Iterable<LaundryOrder> result = liveOrders.map((o) => o.value);

    // Hard constraint: If Client, restrict visibility strictly to their own orders
    if (isClient && currentClient != null) {
      result = result.where((order) => order.clientId == currentClient.id);
    }

    // 4. Apply text search query predicates
    if (query.isNotEmpty) {
      result = result.where((order) {
        final client = clients[order.clientId];
        if (client == null) return false;

        String matchTarget = "";
        if (sortKey == "name") {
          matchTarget = client.name;
        } else if (sortKey == "phone") {
          matchTarget = client.phone;
        } else {
          matchTarget = "${client.hostel}${client.room}";
        }

        return matchTarget
            .toLowerCase()
            .replaceAll(RegExp(r'\s+'), '')
            .contains(query);
      });
    }

    // 5. Perform Chronological Sort (Newest updates appear first)
    final sortedList =
        result.toList()..sort((a, b) {
          final aDate = (a.deliveryDate ?? a.pickupDate) ?? a.placedDate;
          final bDate = (b.deliveryDate ?? b.pickupDate) ?? b.placedDate;
          return bDate.compareTo(aDate);
        });

    return sortedList;
  }
}
