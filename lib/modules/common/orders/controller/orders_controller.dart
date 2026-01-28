import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/order.dart';

class OrderListController extends GetxController {
  final RxString searchQuery = "".obs;
  final RxString sortBy = "type".obs;

  List<LaundryOrder> getFilteredOrders(List<LaundryOrder> orders) {
    final query = searchQuery.value.toLowerCase().replaceAll(
      RegExp(r'\s+'),
      '',
    );
    final sortKey = sortBy.value;
    Map<String, Client> clients = {};
    if (AuthController.instance.userType.value == UserType.client) {
      Client? client = AuthController.instance.currentClient.value;
      if (client != null) {
        clients[client.id] = client;
      }
    } else {
      clients = Map.fromEntries(
        ClientController.instance.clients.map(
          (client) => MapEntry(client.value.id, client.value),
        ),
      );
    }

    Iterable<LaundryOrder> result;
    if (query.isEmpty) {
      result = orders;
    } else {
      result = orders.where((order) {
        final value =
            sortKey == "name"
                ? clients[order.clientId]?.name.toLowerCase().replaceAll(
                      RegExp(r'\s+'),
                      '',
                    ) ??
                    ""
                : sortKey == "phone"
                ? clients[order.clientId]?.phone.toLowerCase().replaceAll(
                      RegExp(r'\s+'),
                      '',
                    ) ??
                    ""
                : "${clients[order.clientId]?.hostel ?? ""}${clients[order.clientId]?.room ?? ""}"
                    .toLowerCase()
                    .replaceAll(RegExp(r'\s+'), '');
        return value.contains(query);
      });
    }

    final sortedList =
        result.toList()..sort((a, b) {
          // if (sortKey == "date") {
          final aDate = (a.deliveryDate ?? a.pickupDate) ?? a.placedDate;
          final bDate = (b.deliveryDate ?? b.pickupDate) ?? b.placedDate;

          return (bDate).compareTo(aDate);
          // }
          // final aValue =
          //     sortKey == "name"
          //         ? clients[a.clientId]?.name.toLowerCase() ?? ""
          //         : sortKey == "phone"
          //         ? clients[a.clientId]?.phone.toLowerCase() ?? ""
          //         : "${clients[a.clientId]?.hostel ?? ""}${clients[a.clientId]?.room ?? ""}"
          //             .toLowerCase();
          // final bValue =
          //     sortKey == "name"
          //         ? clients[b.clientId]?.name.toLowerCase() ?? ""
          //         : sortKey == "phone"
          //         ? clients[b.clientId]?.phone.toLowerCase() ?? ""
          //         : "${clients[b.clientId]?.hostel ?? ""}${clients[b.clientId]?.room ?? ""}"
          //             .toLowerCase();
          // return aValue.compareTo(bValue);
        });

    return sortedList;
  }
}
