import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundary_app/data/controllers/pricing_controller.dart';
import 'package:laundary_app/data/models/pricing.dart';

class PricingCloudDb {
  static PricingCloudDb? _instance;
  PricingCloudDb._();
  static PricingCloudDb get instance {
    _instance ??= PricingCloudDb._();
    return _instance!;
  }

  final pricings = FirebaseFirestore.instance.collection('pricings');

  Future<String> addPricing(Pricing pricing) async {
    final docRef = await pricings.add(pricing.toMap());
    await pricings.doc(docRef.id).update({"id": docRef.id});
    pricing = pricing.copyWith(id: docRef.id);
    await PricingController.instance.addPricing(pricing);
    return docRef.id;
  }

  Future<void> updatePricing(Pricing pricing) async {
    pricing = pricing.copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      deleted: false,
    );
    await pricings.doc(pricing.id).update(pricing.toMap());
    PricingController.instance.updatePricing(pricing);
  }

  // Future<void> incrementPriority(Pricing pricing) async {
  //   if (pricing.priority >= PricingController.instance.pricings.length - 1) return;

  //   Pricing o = pricing.copyWith(priority: pricing.priority + 1);
  //   await pricings.doc(pricing.id).update(o.toMap());
  //   await PricingController.instance.incrementPriority(pricing);
  // }

  // Future<void> decrementPriority(Pricing pricing) async {
  //   if (pricing.priority <= 0) return;

  //   Pricing o = pricing.copyWith(priority: pricing.priority - 1);
  //   await pricings.doc(pricing.id).update(o.toMap());
  //   await PricingController.instance.decrementPriority(pricing);
  // }

  Future<List<Pricing>> getAllPricings() async {
    final query = await pricings.get();
    return query.docs.map((doc) => Pricing.fromJson(doc.data())).toList();
  }

  Future<void> deletePricing(Pricing pricing) async {
    await pricings.doc(pricing.id).delete();
    await PricingController.instance.deletePricing(pricing);
  }
}
