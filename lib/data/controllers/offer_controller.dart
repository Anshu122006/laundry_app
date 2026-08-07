import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/data/db_cloud/offer_cloud_db.dart';
import 'package:laundary_app/data/models/offer.dart';

class OfferController extends GetxController {
  static OfferController get instance {
    return Get.find<OfferController>();
  }

  final offers = <Rx<Offer>>[].obs;
  static const String _storageKey = 'cached_offers_v1';

  Timer? _debounce;

  static Future<void> initController() async {
    try {
      if (!Get.isRegistered<OfferController>()) {
        Get.put(OfferController(), permanent: true);
      }
      final storage = GetStorage();
      final List<dynamic>? cachedData = storage.read(_storageKey);

      if (cachedData != null && cachedData.isNotEmpty) {
        final cachedOffers = cachedData
            .map((json) => Offer.fromJson(Map<String, dynamic>.from(json)).obs)
            .toList();
        OfferController.instance.offers.assignAll(cachedOffers);
      } else {
        await OfferController.instance.updateData();
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> updateData() async {
    List<Offer> olist = await OfferCloudDb.instance.getAllOffers();
    OfferController.instance.offers.assignAll(
      olist.map((offer) => offer.obs).toList(),
    );
    _saveToDisk();
  }

  void _saveToDisk() {
    final storage = GetStorage();
    final rawList = offers.map((o) => o.value.toMap()).toList();
    storage.write(_storageKey, rawList);
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

  Future<void> addOffer(Offer offer) async {
    offer.priority = offers.length;
    offers.add(offer.obs);

    await OfferCloudDb.instance.updateOffer(offer);
  }

  void updateOffer(Offer offer) {
    for (int i = 0; i < offers.length; i++) {
      if (offers[i].value.id == offer.id) {
        offers[i] = offer.obs;
        offers.refresh();
        break;
      }
    }
  }

  Future<void> incrementPriority(Offer offer) async {
    if (offer.priority >= offers.length - 1) return;

    for (int i = 0; i < offers.length; i++) {
      if (offers[i].value.priority == offer.priority) {
        Offer o = offers[i].value;
        offers[i].value = o.copyWith(priority: o.priority + 1);
      } else if (offers[i].value.priority == offer.priority + 1) {
        Offer o = offers[i].value;
        offers[i].value = o.copyWith(priority: o.priority - 1);
        await OfferCloudDb.instance.updateOffer(offers[i].value);
      }
    }

    offers.refresh();
  }

  Future<void> decrementPriority(Offer offer) async {
    if (offer.priority <= 0) return;

    for (int i = 0; i < offers.length; i++) {
      if (offers[i].value.priority == offer.priority) {
        Offer o = offers[i].value;
        offers[i].value = o.copyWith(priority: o.priority - 1);
      } else if (offers[i].value.priority == offer.priority - 1) {
        Offer o = offers[i].value;
        offers[i].value = o.copyWith(priority: o.priority + 1);
        await OfferCloudDb.instance.updateOffer(offers[i].value);
      }
    }

    offers.refresh();
  }

  Future<void> deleteOffer(Offer offer) async {
    offers.removeWhere((e) => e.value.id == offer.id);
    for (int i = 0; i < offers.length; i++) {
      if (offers[i].value.priority > offer.priority) {
        Offer o = offers[i].value;
        offers[i].value = o.copyWith(priority: o.priority - 1);
        await OfferCloudDb.instance.updateOffer(offers[i].value);
      }
    }

    offers.refresh();
  }
}
