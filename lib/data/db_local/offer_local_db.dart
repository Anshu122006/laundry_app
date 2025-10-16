// import 'package:laundary_app/data/db_cloud/offer_cloud_db.dart';
// import 'package:laundary_app/data/db_local/_main_local_db.dart';
// import 'package:laundary_app/data/models/offer.dart';
// import 'package:sqflite/sqflite.dart';

// class OfferLocalDb{
//   static OfferLocalDb? _instance;
//   OfferLocalDb._();
//   static OfferLocalDb get instance {
//     _instance ??= OfferLocalDb._();
//     return _instance!;
//   }

//  Future<void> upsertOffer(Offer offer) async {
//     if (offer.id.isEmpty) return;

//     final database = await LocalDb.instance.db;
//     await database.insert(
//       'offers',
//       offer.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<void> deleteOffer(String id) async {
//     final database = await LocalDb.instance.db;
//     await database.delete('offers', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<Offer?> getOfferById(String id) async {
//     final database = await LocalDb.instance.db;
//     final result = await database.query(
//       'offers',
//       where: 'id = ? AND deleted = 0',
//       whereArgs: [id],
//     );

//     if (result.isNotEmpty) {
//       return Offer.fromJson(result.first);
//     }

//     return null;
//   }

//   Future<List<Offer>> getAllOffer() async {
//     final database = await LocalDb.instance.db;
//     final result = await database.query(
//       'offers',
//       where: 'deleted = ?',
//       whereArgs: [0],
//     );

//     return result.map((row) => Offer.fromJson(row)).toList();
//   }

//   Future<void> syncWithCloud() async {
//     try {
//       final cloudOffers = await OfferCloudDb.instance.getAllOffers();

//       for (final offer in cloudOffers) {
//         if (!offer.deleted) {
//           await upsertOffer(offer);
//         }
//       }
//     } catch (e) {
//       // print("Failed to sync data: $e");
//     }
//   }
// }