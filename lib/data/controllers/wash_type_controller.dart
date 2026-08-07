import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/data/db_cloud/wash_type_cloud_db.dart';
import 'package:laundary_app/data/models/wash_type.dart';

class WashTypeController extends GetxController {
  static WashTypeController get instance {
    return Get.find<WashTypeController>();
  }

  final washTypes = <Rx<WashType>>[].obs;
  static const String _storageKey = 'cached_wash_types_v1';

  static Future<void> initController() async {
    if (!Get.isRegistered<WashTypeController>()) {
      Get.put(WashTypeController(), permanent: true);
    }

    final storage = GetStorage();
    final List<dynamic>? cachedData = storage.read(_storageKey);

    if (cachedData != null && cachedData.isNotEmpty) {
      final cachedTypes = cachedData
          .map(
            (json) => WashType.fromJson(Map<String, dynamic>.from(json)).obs,
          )
          .toList();
      WashTypeController.instance.washTypes.value = cachedTypes;
    } else {
      await WashTypeController.instance.syncData();
    }
  }

  Future<void> syncData() async {
    List<WashType> types = await WashTypeCloudDb.instance.getAllWashTypes();
    WashTypeController.instance.washTypes.value =
        types.map((t) => t.obs).toList();
    _saveToDisk();
  }

  void _saveToDisk() {
    final storage = GetStorage();
    final rawList = washTypes.map((wt) => wt.value.toMap()).toList();
    storage.write(_storageKey, rawList);
  }

  Future<void> incrementPriority(WashType washType) async {
    if (washType.priority >= washTypes.length - 1) return;

    for (int i = 0; i < washTypes.length; i++) {
      if (washTypes[i].value.priority == washType.priority) {
        WashType o = washTypes[i].value;
        washTypes[i].value = o.copyWith(priority: o.priority + 1);
      } else if (washTypes[i].value.priority == washType.priority + 1) {
        WashType o = washTypes[i].value;
        washTypes[i].value = o.copyWith(priority: o.priority - 1);
        await WashTypeCloudDb.instance.updateWashType(washTypes[i].value);
      }
    }

    washTypes.refresh();
  }

  Future<void> decrementPriority(WashType washType) async {
    if (washType.priority <= 0) return;

    for (int i = 0; i < washTypes.length; i++) {
      if (washTypes[i].value.priority == washType.priority) {
        WashType o = washTypes[i].value;
        washTypes[i].value = o.copyWith(priority: o.priority - 1);
      } else if (washTypes[i].value.priority == washType.priority - 1) {
        WashType o = washTypes[i].value;
        washTypes[i].value = o.copyWith(priority: o.priority + 1);
        await WashTypeCloudDb.instance.updateWashType(washTypes[i].value);
      }
    }

    washTypes.refresh();
  }

  void updateWashType(WashType washType) {
    for (int i = 0; i < washTypes.length; i++) {
      if (washTypes[i].value.id == washType.id) {
        washTypes[i] = washType.obs;
        washTypes.refresh();
        break;
      }
    }
  }
}
