import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/core/utils/logging/logger.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';

class ClientController extends GetxController {
  static ClientController get instance => Get.find<ClientController>();

  final clients = <Rx<Client>>[].obs;
  StreamSubscription<List<Client>>? _clientSubscription;

  final _storage = GetStorage();
  static const String _storageKey = 'cached_clients_admin_v2';
  static const String _ownerStampKey = 'cache_owner_stamp_clients_admin';

  static Future<void> initController() async {
    if (!Get.isRegistered<ClientController>()) {
      Get.put(ClientController(), permanent: true);
    }
    await ClientController.instance._loadLocalDataAndSync();
  }

  /// Synchronously bootstraps local data and hooks up the downstream delta query
  Future<void> _loadLocalDataAndSync() async {
    final auth = AuthController.instance;

    // 1. Clear memory array immediately to prevent state carryover
    clients.clear();

    // Security Gate check: Only Admin profiles should load the global client list directory
    if (auth.userType.value != UserType.admin) {
      AppLogger.logInfo(
        "Skipping client directory sync: Unauthorized context.",
      );
      return;
    }

    // 2. Owner validation: Stamp integrity check
    final String? cachedOwner = _storage.read(_ownerStampKey);
    if (cachedOwner != null && cachedOwner != 'admin_global') {
      debugPrint(
        "[CACHE SECURITY]: Client directory owner mismatch! Purging collision cache.",
      );
      _storage.remove(_storageKey);
    }

    final List<dynamic>? cachedData = _storage.read(_storageKey);
    int highWatermarkTimestamp = 0;

    // Step 3: Push cache data directly into the active UI state array
    if (cachedData != null && cachedData.isNotEmpty) {
      final loadedClients =
          cachedData.map((json) {
            final client = Client.fromJson(Map<String, dynamic>.from(json));

            if (client.updatedAt > highWatermarkTimestamp) {
              highWatermarkTimestamp = client.updatedAt;
            }
            return client.obs;
          }).toList();

      clients.assignAll(loadedClients);
    }

    // Step 4: Establish our lightweight delta synchronization hook
    _clientSubscription?.cancel();

    // Apply a 5-second buffer (5000 ms) to guard against clock skew and race conditions
    final int safeSyncTime =
        highWatermarkTimestamp > 5000 ? highWatermarkTimestamp - 5000 : 0;

    _clientSubscription = ClientCloudDb.instance
        .watchAllClients(lastSyncTime: safeSyncTime)
        .listen(
          (incomingDeltas) {
            if (incomingDeltas.isNotEmpty) {
              // Uniformly upsert incoming updates without wiping existing memory state
              for (var updatedClient in incomingDeltas) {
                final existingIndex = indexof(updatedClient.id);

                if (existingIndex != -1) {
                  clients[existingIndex].value = updatedClient;
                } else {
                  clients.add(updatedClient.obs);
                }
              }

              clients.refresh();
              _saveToLocalDisk();
            }
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
    _storage.write(_ownerStampKey, 'admin_global');
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
    _clientSubscription?.cancel();
    super.onClose();
  }
}
