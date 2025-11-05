import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    debounce(
      searchQuery,
      (_) => filterClients(),
      time: Duration(milliseconds: 300),
    );

    ever(ClientController.instance.clients, (_) => filterClients());
    filterClients();
  }

  final filteredClients = <Rx<Client>>[].obs;
  final RxString searchQuery = "".obs;
  final RxString sortBy = "name".obs;

  void filterClients() {
    final query = searchQuery.value.toLowerCase();
    final sortKey = sortBy.value;
    final clients = ClientController.instance.clients;

    Iterable<Rx<Client>> result;
    if (query.isEmpty) {
      result = clients;
    } else {
      result = clients.where((client) {
        final value =
            sortKey == "name"
                ? client.value.name.toLowerCase().replaceAll(RegExp(r'\s+'), '')
                : sortKey == "room"
                ? "${client.value.hostel}${client.value.room}"
                    .toLowerCase()
                    .replaceAll(RegExp(r'\s+'), '')
                : client.value.phone.replaceAll(RegExp(r'\s+'), '');
        return value.contains(query);
      });
    }

    final sortedList =
        result.toList()..sort((a, b) {
          final aValue =
              sortKey == "name"
                  ? a.value.name.toLowerCase()
                  : sortKey == "room"
                  ? "${a.value.hostel.toLowerCase()}${a.value.room.toLowerCase()}"
                  : a.value.phone;
          final bValue =
              sortKey == "name"
                  ? b.value.name
                  : sortKey == "room"
                  ? "${b.value.hostel.toLowerCase()}${b.value.room.toLowerCase()}"
                  : b.value.phone;
          return aValue.compareTo(bValue);
        });

    filteredClients.assignAll(sortedList);
    filteredClients.refresh();
  }

  Future<void> launchDialer(String phoneNumber) async {
    try {
      final Uri uri = Uri(scheme: 'tel', path: "+91$phoneNumber");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $phoneNumber';
      }
    } catch (e) {
      //
    }
  }

  Future<void> openWhattsapp(String phoneNumber) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: phoneNumber,
    );
    await launchUrl(whatsappUri, mode: LaunchMode.platformDefault);
  }

  int indexof(Client client) {
    List<Client> clients =
        ClientController.instance.clients.map((c) => c.value).toList();

    for (int i = 0; i < clients.length; i++) {
      if (clients[i].id == client.id) {
        return i;
      }
    }
    return -1;
  }
}
