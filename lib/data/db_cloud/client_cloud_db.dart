import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundary_app/core/utils/logging/logger.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/models/client.dart';

class ClientCloudDb {
  static ClientCloudDb? _instance;
  ClientCloudDb._();
  static ClientCloudDb get instance {
    _instance ??= ClientCloudDb._();
    return _instance!;
  }

  final clients = FirebaseFirestore.instance.collection('clients');
  // StreamSubscription? _subscription;

  // Future<void> listenToChanges() async {
  //   final box = GetStorage();
  //   int lastSyncTime = box.read('client_last_sync_time') ?? 0;

  //   await _subscription?.cancel();
  //   _subscription = clients
  //       .where('updatedAt', isGreaterThan: lastSyncTime)
  //       .snapshots()
  //       .listen((querySnapshot) async {
  //         int latestUpdate = lastSyncTime;

  //         try {
  //           for (var docChange in querySnapshot.docChanges) {
  //             final data = docChange.doc.data();
  //             if (data == null) continue;

  //             final client = Client.fromJson(data);

  //             if (client.updatedAt > latestUpdate) {
  //               latestUpdate = client.updatedAt;
  //             }

  //             switch (docChange.type) {
  //               case DocumentChangeType.added:
  //               case DocumentChangeType.modified:
  //                 if (!client.deleted) {
  //                   await ClientLocalDb.instance.upsertClient(client);
  //                 } else {
  //                   await ClientLocalDb.instance.deleteClient(client.id);
  //                 }
  //                 break;
  //               case DocumentChangeType.removed:
  //                 await ClientLocalDb.instance.deleteClient(client.id);
  //                 break;
  //             }
  //           }

  //           ClientController.instance.scheduleUpdate();

  //           box.write('client_last_sync_time', latestUpdate);
  //         } catch (e) {
  //           // print('Error during client change listener: $e');
  //         }
  //       });
  // }

  // Future<void> removeListner() async {
  //   await _subscription?.cancel();
  //   _subscription = null;
  // }

  Future<String> addClient(Client client, bool isClient) async {
    // client = client.copyWith(
    //   updatedAt: DateTime.now().millisecondsSinceEpoch,
    //   deleted: false,
    // );
    final docRef = await clients.add(client.toMap());
    await clients.doc(docRef.id).update({"id": docRef.id});
    client = client.copyWith(id: docRef.id);
    if (!isClient) {
      ClientController.instance.addClient(client);
    }
    return docRef.id;
  }

  Future<void> updateClient({
    required String clientId,
    String? name,
    String? email,
    String? phone,
    String? hostel,
    String? room,
    int? balance,
    bool? deleted,
    List<String>? fcmTokens,
  }) async {
    final Map<String, dynamic> updateData = {};

    if (name != null) updateData['name'] = name;
    if (email != null) updateData['email'] = email;
    if (phone != null) updateData['phone'] = phone;
    if (hostel != null) updateData['hostel'] = hostel;
    if (room != null) updateData['room'] = room;
    if (balance != null) updateData['balance'] = balance;
    if (deleted != null) updateData['deleted'] = deleted;

    // if (fcmTokens != null) {
    //   updateData['fcmTokens'] = fcmTokens;
    // }

    // if (updateData.isEmpty) return;

    updateData['updatedAt'] = DateTime.now().millisecondsSinceEpoch;

    await clients.doc(clientId).update(updateData);

    final current = AuthController.instance.currentClient.value;
    if (current != null && current.id == clientId) {
      AuthController.instance.currentClient.value = current.copyWith(
        name: name ?? current.name,
        email: email ?? current.email,
        phone: phone ?? current.phone,
        hostel: hostel ?? current.hostel,
        room: room ?? current.room,
        balance: balance ?? current.balance,
        deleted: deleted ?? current.deleted,
        // fcmTokens: fcmTokens ?? current.fcmTokens,
        updatedAt: updateData['updatedAt'],
      );
    } else {
      AppLogger.logInfo("");
      ClientController.instance.updateClient(
        clientId: clientId,
        name: name,
        email: email,
        phone: phone,
        hostel: hostel,
        room: room,
        balance: balance,
        deleted: deleted,
      );
    }
  }

  Future<Client?> getClient(String email) async {
    final query = await clients.where("email", isEqualTo: email).get();
    if (query.docs.isNotEmpty) {
      return Client.fromJson(query.docs.first.data());
    } else {
      return null;
    }
  }

  Future<Client?> getClientById(String id) async {
    final query = await clients.where("id", isEqualTo: id).get();
    if (query.docs.isNotEmpty) {
      return Client.fromJson(query.docs.first.data());
    } else {
      return null;
    }
  }

  Future<List<Client>> getAllClients() async {
    final query = await clients.get();
    if (query.docs.isNotEmpty) {
      List<Client> client =
          query.docs.map((doc) => Client.fromJson(doc.data())).toList();
      return client;
    } else {
      return <Client>[];
    }
  }

  Future<void> deleteClient(Client client) async {
    // client = client.copyWith(
    //   updatedAt: DateTime.now().millisecondsSinceEpoch,
    //   deleted: true,
    // );
    // clients.doc(client.id).update(client.toMap());
    clients.doc(client.id).delete();
    ClientController.instance.deleteClient(client);
  }

  // Future<void> updateUserFCM(String userId, String fcmToken) {

  // }
}
