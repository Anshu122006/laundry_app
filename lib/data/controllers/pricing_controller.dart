import 'dart:async';

import 'package:get/get.dart';
import 'package:laundary_app/data/db_cloud/pricing_cloud_db.dart';
import 'package:laundary_app/data/models/pricing.dart';

class PricingController extends GetxController {
  static PricingController get instance {
    return Get.find<PricingController>();
  }

  final pricings = <Rx<Pricing>>[].obs;

  Timer? _debounce;

  static Future<void> initController() async {
    try {
      if (!Get.isRegistered<PricingController>()) {
        Get.put(PricingController(), permanent: true);
      }
      // List<Pricing> plist = await PricingLocalDb.instance.getAllPricing();
      List<Pricing> plist = await PricingCloudDb.instance.getAllPricings();
      PricingController.instance.pricings.assignAll(
        plist.map((pricing) => pricing.obs).toList(),
      );
    } catch (e) {
      // print(e);
    }
  }

  Future<void> updateData() async {
    // List<Pricing> plist = await PricingLocalDb.instance.getAllPricing();
    List<Pricing> plist = await PricingCloudDb.instance.getAllPricings();
    pricings.assignAll(plist.map((pricing) => pricing.obs).toList());
  }

  void scheduleUpdate() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        await updateData();
      } catch (e) {
        // print('Error during scheduleUpdate: $e');
      }
    });
  }

  Future<void> addPricing(Pricing pricing) async {
    int maxPriority = -1;
    for (int i = 0; i < pricings.length; i++) {
      if (pricings[i].value.type != pricing.type) continue;

      if (maxPriority < pricings[i].value.priority) {
        maxPriority = pricings[i].value.priority;
      }
    }

    pricing.priority = maxPriority + 1;
    pricings.add(pricing.obs);

    await PricingCloudDb.instance.updatePricing(pricing);
  }

  void updatePricing(Pricing pricing) {
    for (int i = 0; i < pricings.length; i++) {
      if (pricings[i].value.id == pricing.id) {
        pricings[i] = pricing.obs;
        pricings.refresh();
        break;
      }
    }
  }

  Future<void> incrementPriority(Pricing pricing) async {
    int maxPriority = 0;
    for (int i = 0; i < pricings.length; i++) {
      if (pricings[i].value.type != pricing.type) continue;

      if (maxPriority < pricings[i].value.priority) {
        maxPriority = pricings[i].value.priority;
      }
    }

    if (pricing.priority >= maxPriority) return;
    for (int i = 0; i < pricings.length; i++) {
      if (pricings[i].value.type != pricing.type) continue;

      if (pricings[i].value.priority == pricing.priority) {
        Pricing o = pricings[i].value;
        pricings[i].value = o.copyWith(priority: o.priority + 1);
         await PricingCloudDb.instance.updatePricing(pricings[i].value);
      } else if (pricings[i].value.priority == pricing.priority + 1) {
        Pricing o = pricings[i].value;
        pricings[i].value = o.copyWith(priority: o.priority - 1);
        await PricingCloudDb.instance.updatePricing(pricings[i].value);
      }
    }

    pricings.refresh();
  }

  Future<void> decrementPriority(Pricing pricing) async {
    if (pricing.priority <= 0) return;

    for (int i = 0; i < pricings.length; i++) {
      if (pricings[i].value.type != pricing.type) continue;

      if (pricings[i].value.priority == pricing.priority) {
        Pricing o = pricings[i].value;
        pricings[i].value = o.copyWith(priority: o.priority - 1);
        await PricingCloudDb.instance.updatePricing(pricings[i].value);
      } else if (pricings[i].value.priority == pricing.priority - 1) {
        Pricing o = pricings[i].value;
        pricings[i].value = o.copyWith(priority: o.priority + 1);
        await PricingCloudDb.instance.updatePricing(pricings[i].value);
      }
    }

    pricings.refresh();
  }

  Future<void> deletePricing(Pricing pricing) async {
    pricings.removeWhere((e) => e.value.id == pricing.id);
    for (int i = 0; i < pricings.length; i++) {
      if (pricings[i].value.type != pricing.type) continue;

      if (pricings[i].value.priority > pricing.priority) {
        Pricing o = pricings[i].value;
        pricings[i].value = o.copyWith(priority: o.priority - 1);
        await PricingCloudDb.instance.updatePricing(pricings[i].value);
      }
    }

    pricings.refresh();
  }
}
