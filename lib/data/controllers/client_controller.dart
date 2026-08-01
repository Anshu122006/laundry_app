import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Make sure this is added to pubspec.yaml
import 'package:laundary_app/core/utils/logging/logger.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';

class ClientController extends GetxController {
  static ClientController get instance {
    return Get.find<ClientController>();
  }

  final clients = <Rx<Client>>[].obs;

  // Track active stream subscription so we can cancel it on close
  StreamSubscription<List<Client>>? _clientSubscription;

  // Storage variables for lightning fast local disk cache mirrors
  final _storage = GetStorage();
  static const String _storageKey = 'cached_clients';

  static Future<void> initController() async {
    if (!Get.isRegistered<ClientController>()) {
      Get.put(ClientController(), permanent: true);
    }

    // Load disk records immediately to build UI with zero layout flickering,
    // then establish our targeted delta cloud sync hook.
    await ClientController.instance._loadLocalDataAndSync();
  }

  /// Synchronously bootstraps local data and hooks up the downstream delta query
  Future<void> _loadLocalDataAndSync() async {
    final List<dynamic>? cachedData = _storage.read(_storageKey);
    int highWatermarkTimestamp = 0;

    // Step 1: Push cache data directly into the active UI state array
    if (cachedData != null) {
      final loadedClients =
          cachedData.map((json) {
            final client = Client.fromJson(Map<String, dynamic>.from(json));

            // Track the absolute newest modification value on local storage
            if (client.updatedAt > highWatermarkTimestamp) {
              highWatermarkTimestamp = client.updatedAt;
            }
            return client.obs;
          }).toList();

      clients.assignAll(loadedClients);
    }

    // Step 2: Establish our lightweight delta synchronization hook
    _clientSubscription?.cancel();

    // Note: Update your ClientCloudDb instance to accept a lastSyncTime integer
    // inside the watchAllClients query method (e.g. using .where('updatedAt', isGreaterThan: lastSyncTime))
    _clientSubscription = ClientCloudDb.instance
        .watchAllClients(lastSyncTime: highWatermarkTimestamp)
        .listen(
          (incomingDeltas) {
            if (incomingDeltas.isEmpty) return;

            for (var updatedClient in incomingDeltas) {
              final existingIndex = indexof(updatedClient.id);

              if (existingIndex != -1) {
                // Update the existing reactive element directly
                clients[existingIndex].value = updatedClient;
              } else {
                // Drop completely new registrations into our list model tracking
                clients.add(updatedClient.obs);
              }
            }

            // Finalize state modifications and write back directly down to flash storage cache
            clients.refresh();
            _saveToLocalDisk();
          },
          onError: (error) {
            AppLogger.logInfo(
              "Can't subscribe to the client delta stream: $error",
            );
          },
        );
  }

  /// Flushes current memory items down to high speed local flash storage
  void _saveToLocalDisk() {
    final rawDataList = clients.map((c) => c.value.toMap()).toList();
    _storage.write(_storageKey, rawDataList);
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
      _saveToLocalDisk();
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
      _saveToLocalDisk();
    }
  }

  void deleteClient(Client client) {
    clients.removeWhere((e) => e.value.id == client.id);
    _saveToLocalDisk();
  }

  @override
  void onClose() {
    _clientSubscription?.cancel(); // Clear connection leaks
    super.onClose();
  }
}
