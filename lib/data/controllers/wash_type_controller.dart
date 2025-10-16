import 'dart:async';

import 'package:get/get.dart';
import 'package:laundary_app/data/db_cloud/wash_type_cloud_db.dart';
import 'package:laundary_app/data/models/wash_type.dart';

class WashTypeController extends GetxController {
  static WashTypeController get instance {
    return Get.find<WashTypeController>();
  }

  final washTypes = <Rx<WashType>>[].obs;

  static Future<void> initController() async {
    if (!Get.isRegistered<WashTypeController>()) {
      Get.put(WashTypeController(), permanent: true);
    }

    List<WashType> types = await WashTypeCloudDb.instance.getAllWashTypes();
    WashTypeController.instance.washTypes.value =
        types.map((t) => t.obs).toList();
  }

  Future<void> syncData() async {
    List<WashType> types = await WashTypeCloudDb.instance.getAllWashTypes();
    WashTypeController.instance.washTypes.value =
        types.map((t) => t.obs).toList();
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
