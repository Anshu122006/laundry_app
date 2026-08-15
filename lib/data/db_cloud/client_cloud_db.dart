import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:laundary_app/core/utils/logging/logger.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/models/client.dart';
// import 'package:laundary_app/data/models/transaction.dart';

class ClientCloudDb {
  static ClientCloudDb? _instance;
  ClientCloudDb._();
  static ClientCloudDb get instance {
    _instance ??= ClientCloudDb._();
    return _instance!;
  }

  final clients = FirebaseFirestore.instance.collection('clients');
  // final transactions = FirebaseFirestore.instance.collection('transactions');

  Future<String> addClient(Client client, bool isClient) async {
    final docRef = clients.doc();
    final newClient = client.copyWith(id: docRef.id);
    await docRef.set(newClient.toMap());
    if (!isClient) {
      ClientController.instance.addClient(newClient);
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
        updatedAt: updateData['updatedAt'],
      );
    } else {
      ClientController.instance.updateClient(
        clientId: clientId,
        name: name,
        email: email,
        phone: phone,
        hostel: hostel,
        room: room,
        balance: balance,
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

  /// OPTIMIZED: Fetches document directly by its reference ID instead of scanning indexes
  Future<Client?> getClientById(String id) async {
    final docSnap = await clients.doc(id).get();
    if (docSnap.exists && docSnap.data() != null) {
      return Client.fromJson(docSnap.data()!);
    }
    return null;
  }

  Stream<List<Client>> watchAllClients() {
    return FirebaseFirestore.instance
        .collection('clients')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Client.fromJson(doc.data())).toList(),
        );
  }

  Future<List<Client>> getAllClients() async {
    final query = await clients.get();
    if (query.docs.isNotEmpty) {
      return query.docs.map((doc) => Client.fromJson(doc.data())).toList();
    } else {
      return <Client>[];
    }
  }

  Future<void> deleteClient(Client client) async {
    await clients.doc(client.id).delete();
    ClientController.instance.deleteClient(client);
  }

  Future<void> addFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final clientId = AuthController.instance.currentClient.value?.id;
    final token = await messaging.getToken();
    if (clientId == null || token == null) return;

    try {
      await clients.doc(clientId).update({
        'fcmTokens': FieldValue.arrayUnion([token]),
      });
    } catch (e) {
      AppLogger.logInfo("Error adding FCM token: $e");
    }
  }

  Future<void> removeFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final clientId = AuthController.instance.currentClient.value?.id;
    final token = await messaging.getToken();
    if (clientId == null || token == null) return;

    try {
      await clients.doc(clientId).update({
        'fcmTokens': FieldValue.arrayRemove([token]),
      });
    } catch (e) {
      AppLogger.logInfo("Error removing FCM token: $e");
    }
  }

  // Future<void> cleanUpDatabaseDeletedField() async {
  //   final collection = FirebaseFirestore.instance.collection('clients');

  //   // Fetch documents that still contain the deprecated property
  //   final snapshot = await collection.where('deleted', isNull: false).get();

  //   final batch = FirebaseFirestore.instance.batch();
  //   for (var doc in snapshot.docs) {
  //     batch.update(doc.reference, {
  //       'deleted':
  //           FieldValue.delete(), // Completely purges the key from Firestore
  //     });
  //   }

  //   await batch.commit();
  // }
}
