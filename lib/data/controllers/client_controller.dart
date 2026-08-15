import 'dart:async';
import 'package:get/get.dart';
import 'package:laundary_app/core/utils/logging/logger.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';

class ClientController extends GetxController {
  static ClientController get instance => Get.find<ClientController>();

  final clients = <Rx<Client>>[].obs;
  StreamSubscription<List<Client>>? _clientSubscription;

  static Future<void> initController() async {
    if (!Get.isRegistered<ClientController>()) {
      Get.put(ClientController(), permanent: true);
    }
    await ClientController.instance._loadLocalDataAndSync();
  }

  Future<void> _loadLocalDataAndSync() async {
    final auth = AuthController.instance;

    clients.clear();

    if (auth.userType.value != UserType.admin) {
      AppLogger.logInfo(
        "Skipping client directory sync: Unauthorized context.",
      );
      return;
    }

    _clientSubscription?.cancel();

    _clientSubscription = ClientCloudDb.instance
        .watchAllClients()
        .listen(
          (incomingClients) {
            // Update the clients list directly from the cloud
            clients.assignAll(incomingClients.map((c) => c.obs).toList());
          },
          onError: (error) {
            AppLogger.logInfo(
              "Can't subscribe to the client stream: $error",
            );
          },
        );
  }

  Client? getClient(String id) {
    return clients.firstWhereOrNull((c) => c.value.id == id)?.value;
  }

  int indexof(String id) {
    return clients.indexWhere((c) => c.value.id == id);
  }

  void addClient(Client client) {
    if (indexof(client.id) == -1) {
      clients.add(client.obs);
    }
  }

  void updateClient({
    required String clientId,
    String? name,
    String? email,
    String? phone,
    String? hostel,
    String? room,
    int? balance,
    int? updatedAt,
  }) {
    final int targetIndex = indexof(clientId);
    if (targetIndex != -1) {
      clients[targetIndex].value = clients[targetIndex].value.copyWith(
        name: name ?? clients[targetIndex].value.name,
        email: email ?? clients[targetIndex].value.email,
        phone: phone ?? clients[targetIndex].value.phone,
        hostel: hostel ?? clients[targetIndex].value.hostel,
        room: room ?? clients[targetIndex].value.room,
        balance: balance ?? clients[targetIndex].value.balance,
        updatedAt: updatedAt ?? clients[targetIndex].value.updatedAt,
      );
      clients.refresh();
    }
  }

  void deleteClient(Client client) {
    clients.removeWhere((e) => e.value.id == client.id);
  }

  @override
  void onClose() {
    _clientSubscription?.cancel();
    super.onClose();
  }
}
