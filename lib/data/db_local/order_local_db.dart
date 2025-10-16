// import 'package:laundary_app/data/db_cloud/order_cloud_db.dart';
// import 'package:laundary_app/data/db_local/_main_local_db.dart';
// import 'package:laundary_app/data/models/order.dart';
// import 'package:sqflite/sqflite.dart';

// class OrderLocalDb {
//   static OrderLocalDb? _instance;
//   OrderLocalDb._();
//   static OrderLocalDb get instance {
//     _instance ??= OrderLocalDb._();
//     return _instance!;
//   }

//   Future<void> upsertOrder(LaundryOrder order) async {
//     if (order.id.isEmpty) return;

//     final database = await LocalDb.instance.db;
//     await database.insert(
//       'orders',
//       order.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<void> deleteOrder(String id) async {
//     final database = await LocalDb.instance.db;
//     await database.delete('orders', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<LaundryOrder?> getOrderById(String id) async {
//     final database = await LocalDb.instance.db;
//     final result = await database.query(
//       'orders',
//       where: 'id = ? AND deleted = 0',
//       whereArgs: [id],
//     );

//     if (result.isNotEmpty) {
//       return LaundryOrder.fromJson(result.first);
//     }

//     return null;
//   }

//   Future<List<LaundryOrder>> getAllOrder() async {
//     final database = await LocalDb.instance.db;
//     final result = await database.query(
//       'orders',
//       where: 'deleted = ?',
//       whereArgs: [0],
//     );

//     return result.map((row) => LaundryOrder.fromJson(row)).toList();
//   }

//   Future<void> syncWithCloud({String? clientId}) async {
//     try {
//       final cloudOrders = await OrderCloudDb.instance.getAllOrders();

//       for (final order in cloudOrders) {
//         if (clientId != null) {
//           if (!order.deleted && order.clientId == clientId) {
//             await upsertOrder(order);
//           }
//         } else {
//           if (!order.deleted) {
//             await upsertOrder(order);
//           }
//         }
//       }
//     } catch (e) {
//       // print("Failed to sync data: $e");
//     }
//   }
// }
