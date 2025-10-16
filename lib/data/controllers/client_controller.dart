import 'dart:async';

import 'package:get/get.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';

class ClientController extends GetxController {
  static ClientController get instance {
    return Get.find<ClientController>();
  }

  final clients = <Rx<Client>>[].obs;

  // Timer? _debounce;

  static Future<void> initController() async {
    if (!Get.isRegistered<ClientController>()) {
      Get.put(ClientController(), permanent: true);
    }
    List<Client> clist = await ClientCloudDb.instance.getAllClients();
    // List<Client> clist = await ClientLocalDb.instance.getAllClient();

    ClientController.instance.clients.assignAll(
      clist.map((client) => client.obs).toList(),
    );
  }

  // Future<void> updateData() async {
  //   try {
  //     List<Client> clist = await ClientLocalDb.instance.getAllClient();
  //     clients.assignAll(clist.map((client) => client.obs).toList());
  //   } catch (e) {
  //     // print(e);
  //   }
  // }

  // void scheduleUpdate() {
  //   _debounce?.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 300), () async {
  //     try {
  //       await updateData();
  //     } catch (e) {
  //       // print('Error during scheduleUpdate: $e');
  //     }
  //   });
  // }

  Client? getClient(String id) {
    Client? client = clients.firstWhereOrNull((c) => c.value.id == id)?.value;
    return client;
  }

  int indexof(String id) {
    int index = clients.indexWhere((c) => c.value.id == id);
    return index;
  }

  void addClient(Client client) {
    clients.add(client.obs);
  }

  void updateClient(Client client) {
    for (int i = 0; i < clients.length; i++) {
      if (clients[i].value.id == client.id) {
        clients[i] = client.obs;
        clients.refresh();
        break;
      }
    }
  }

  void deleteClient(Client client) {
    clients.removeWhere((e) => e.value.id == client.id);
  }
}
