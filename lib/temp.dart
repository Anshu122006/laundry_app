import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

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