// import 'package:laundary_app/data/db_cloud/pricing_cloud_db.dart';
// import 'package:laundary_app/data/db_local/_main_local_db.dart';
// import 'package:laundary_app/data/models/pricing.dart';
// import 'package:sqflite/sqflite.dart';

// class PricingLocalDb{
//   static PricingLocalDb? _instance;
//   PricingLocalDb._();
//   static PricingLocalDb get instance {
//     _instance ??= PricingLocalDb._();
//     return _instance!;
//   }

//  Future<void> upsertPricing(Pricing pricing) async {
//     if (pricing.id.isEmpty) return;

//     final database = await LocalDb.instance.db;
//     await database.insert(
//       'pricings',
//       pricing.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<void> deletePricing(String id) async {
//     final database = await LocalDb.instance.db;
//     await database.delete('pricings', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<Pricing?> getPricingById(String id) async {
//     final database = await LocalDb.instance.db;
//     final result = await database.query(
//       'pricings',
//       where: 'id = ? AND deleted = 0',
//       whereArgs: [id],
//     );

//     if (result.isNotEmpty) {
//       return Pricing.fromJson(result.first);
//     }

//     return null;
//   }

//   Future<List<Pricing>> getAllPricing() async {
//     final database = await LocalDb.instance.db;
//     final result = await database.query(
//       'pricings',
//       where: 'deleted = ?',
//       whereArgs: [0],
//     );

//     return result.map((row) => Pricing.fromJson(row)).toList();
//   }

//   Future<void> syncWithCloud() async {
//     try {
//       final cloudPricings = await PricingCloudDb.instance.getAllPricings();

//       for (final pricing in cloudPricings) {
//         if (!pricing.deleted) {
//           await upsertPricing(pricing);
//         }
//       }
//     } catch (e) {
//       // print("Failed to sync data: $e");
//     }
//   }

// }