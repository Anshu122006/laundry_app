import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundary_app/data/controllers/offer_controller.dart';
import 'package:laundary_app/data/models/offer.dart';

class OfferCloudDb {
  static OfferCloudDb? _instance;
  OfferCloudDb._();
  static OfferCloudDb get instance {
    _instance ??= OfferCloudDb._();
    return _instance!;
  }

  final offers = FirebaseFirestore.instance.collection('offers');
  // StreamSubscription? _subscription;

  // Future<void> listenToChanges() async {
  //   final box = GetStorage();
  //   int lastSyncTime = box.read('offer_last_sync_time') ?? 0;

  //   await _subscription?.cancel();
  //   _subscription = offers
  //       .where('updatedAt', isGreaterThan: lastSyncTime)
  //       .snapshots()
  //       .listen((querySnapshot) async {
  //         int latestUpdate = lastSyncTime;

  //         try {
  //           for (var docChange in querySnapshot.docChanges) {
  //             final data = docChange.doc.data();
  //             if (data == null) continue;

  //             final offer = Offer.fromJson(data);

  //             if (offer.updatedAt > latestUpdate) {
  //               latestUpdate = offer.updatedAt;
  //             }

  //             switch (docChange.type) {
  //               case DocumentChangeType.added:
  //               case DocumentChangeType.modified:
  //                 if (!offer.deleted) {
  //                   await OfferLocalDb.instance.upsertOffer(offer);
  //                 } else {
  //                   await OfferLocalDb.instance.deleteOffer(offer.id);
  //                 }
  //                 break;
  //               case DocumentChangeType.removed:
  //                 await OfferLocalDb.instance.deleteOffer(offer.id);
  //                 break;
  //             }
  //           }

  //           OfferController.instance.scheduleUpdate();

  //           box.write('offer_last_sync_time', latestUpdate);
  //         } catch (e) {
  //           // print('Error during offer change listener: $e');
  //         }
  //       });
  // }

  // Future<void> removeListner() async {
  //   await _subscription?.cancel();
  //   _subscription = null;
  // }

  // Offer CRUD Functions

  Future<String> addOffer(Offer offer) async {
    final docRef = await offers.add(offer.toMap());
    await offers.doc(docRef.id).update({"id": docRef.id});
    offer = offer.copyWith(id: docRef.id);
    await OfferController.instance.addOffer(offer);
    return docRef.id;
  }

  Future<void> updateOffer(Offer offer) async {
    await offers.doc(offer.id).update(offer.toMap());
    OfferController.instance.updateOffer(offer);
  }

  Future<void> incrementPriority(Offer offer) async {
    if (offer.priority >= OfferController.instance.offers.length - 1) return;

    Offer o = offer.copyWith(priority: offer.priority + 1);
    await offers.doc(offer.id).update(o.toMap());
    await OfferController.instance.incrementPriority(offer);
  }

  Future<void> decrementPriority(Offer offer) async {
    if (offer.priority <= 0) return;

    Offer o = offer.copyWith(priority: offer.priority - 1);
    await offers.doc(offer.id).update(o.toMap());
    await OfferController.instance.decrementPriority(offer);
  }

  Future<List<Offer>> getAllOffers() async {
    final query = await offers.get();
    return query.docs.map((doc) => Offer.fromJson(doc.data())).toList();
  }

  Future<void> deleteOffer(Offer offer) async {
    await offers.doc(offer.id).delete();
    await OfferController.instance.deleteOffer(offer);
  }
}
