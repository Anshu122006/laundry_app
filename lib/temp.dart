import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:laundary_app/core/utils/logging/logger.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/transaction.dart';

class Temp{
  static Temp? _instance;
  Temp._();

  static Temp get instance {
    _instance ??= Temp._();
    return _instance!;
  }

  final dummy1 = FirebaseFirestore.instance.collection("dummy1");
  final dummy2 = FirebaseFirestore.instance.collection("dummy2");
  final dummy3 = FirebaseFirestore.instance.collection("dummy3");

  Future<void> initDb() async{
    await dummy1.add({"key":1, "val":0});
    await dummy1.add({"key":2, "val":0});
  }

  // Future<void> executeTransfer(){
  // }

}