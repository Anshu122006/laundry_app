import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    // Delays search processing while typing to maintain 60 FPS UI performance
    debounce(
      searchQuery,
      (_) => filterClients(),
      time: const Duration(milliseconds: 300),
    );

    // Watchers are great! Triggers the local filter query whenever the background stream delivers updates
    ever(ClientController.instance.clients, (_) => filterClients());

    // Also track changes to the sorting selector drop-down!
    ever(sortBy, (_) => filterClients());

    filterClients();
  }

  final filteredClients = <Rx<Client>>[].obs;
  final RxString searchQuery = "".obs;
  final RxString sortBy = "name".obs;

  void filterClients() {
    final query = searchQuery.value.toLowerCase().trim().replaceAll(
      RegExp(r'\s+'),
      '',
    );
    final sortKey = sortBy.value;
    final sourceClients = ClientController.instance.clients;

    Iterable<Rx<Client>> result;
    if (query.isEmpty) {
      result = sourceClients;
    } else {
      result = sourceClients.where((client) {
        // FIX: Evaluates fields cleanly regardless of search target structure
        final nameTarget = client.value.name.toLowerCase().replaceAll(
          RegExp(r'\s+'),
          '',
        );
        final roomTarget = "${client.value.hostel}${client.value.room}"
            .toLowerCase()
            .replaceAll(RegExp(r'\s+'), '');
        final phoneTarget = client.value.phone.replaceAll(RegExp(r'\s+'), '');

        // Search match strategy evaluates strings against all potential targets
        return nameTarget.contains(query) ||
            roomTarget.contains(query) ||
            phoneTarget.contains(query);
      });
    }

    final sortedList =
        result.toList()..sort((a, b) {
          if (sortKey == "room") {
            final aRoom =
                "${a.value.hostel.toLowerCase()}${a.value.room.toLowerCase()}";
            final bRoom =
                "${b.value.hostel.toLowerCase()}${b.value.room.toLowerCase()}";
            return aRoom.compareTo(bRoom);
          } else if (sortKey == "phone") {
            return a.value.phone.compareTo(b.value.phone);
          } else {
            return a.value.name.toLowerCase().compareTo(
              b.value.name.toLowerCase(),
            );
          }
        });

    filteredClients.assignAll(sortedList);
  }

  Future<void> launchDialer(String phoneNumber) async {
    try {
      final Uri uri = Uri(scheme: 'tel', path: "+91$phoneNumber");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      // Log failure safely
    }
  }

  Future<void> openWhattsapp(String phoneNumber) async {
    try {
      final Uri whatsappUri = Uri(
        scheme: 'https',
        host: 'wa.me',
        path: "+91$phoneNumber",
      );
      await launchUrl(whatsappUri, mode: LaunchMode.platformDefault);
    } catch (e) {
      // Log failure safely
    }
  }

  int indexof(Client client) {
    return ClientController.instance.indexof(client.id);
  }
}
