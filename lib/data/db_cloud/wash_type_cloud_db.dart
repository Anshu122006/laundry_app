import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundary_app/data/controllers/wash_type_controller.dart';
import 'package:laundary_app/data/models/wash_type.dart';

class WashTypeCloudDb {
  static WashTypeCloudDb? _instance;
  WashTypeCloudDb._();
  static WashTypeCloudDb get instance {
    _instance ??= WashTypeCloudDb._();
    return _instance!;
  }

  final washTypes = FirebaseFirestore.instance.collection('wash_types');

  // Future<String> addWashType(WashType washType) async {
  //   final docRef = await washTypes.add(washType.toMap());
  //   await washTypes.doc(docRef.id).update({"id": docRef.id});
  //   return docRef.id;
  // }

  Future<void> updateWashType(WashType washType) async {
    await washTypes.doc(washType.id).update(washType.toMap());
    WashTypeController.instance.updateWashType(washType);
  }

  Future<void> incrementPriority(WashType washType) async {
    if (washType.priority >= WashTypeController.instance.washTypes.length - 1) {
      return;
    }

    WashType o = washType.copyWith(priority: washType.priority + 1);
    await washTypes.doc(washType.id).update(o.toMap());
    await WashTypeController.instance.incrementPriority(washType);
  }

  Future<void> decrementPriority(WashType washType) async {
    if (washType.priority <= 0) return;

    WashType o = washType.copyWith(priority: washType.priority - 1);
    await washTypes.doc(washType.id).update(o.toMap());
    await WashTypeController.instance.decrementPriority(washType);
  }

  Future<WashType?> getWashType(String id) async {
    final query = await washTypes.where("id", isEqualTo: id).get();
    if (query.docs.isNotEmpty) {
      return WashType.fromJson(query.docs.first.data());
    } else {
      return null;
    }
  }

  Future<List<WashType>> getAllWashTypes() async {
    final query = await washTypes.get();
    if (query.docs.isNotEmpty) {
      List<WashType> washTypes =
          query.docs.map((doc) => WashType.fromJson(doc.data())).toList();
      return washTypes;
    } else {
      return <WashType>[];
    }
  }

  // Future<void> deleteWashType(WashType washType) async {
  //   washTypes.doc(washType.id).delete();
  // }
}
