// import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
// import 'package:laundary_app/data/db_local/_main_local_db.dart';
// import 'package:laundary_app/data/models/client.dart';
// import 'package:sqflite/sqflite.dart';

// class ClientLocalDb{
//   static ClientLocalDb? _instance;
//   ClientLocalDb._();
//   static ClientLocalDb get instance {
//     _instance ??= ClientLocalDb._();
//     return _instance!;
//   }

//  Future<void> upsertClient(Client client) async {
//     if (client.id.isEmpty) return;

//     final database = await LocalDb.instance.db;
//     await database.insert(
//       'clients',
//       client.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<void> deleteClient(String id) async {
//     final database = await LocalDb.instance.db;
//     await database.delete('clients', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<Client?> getClientById(String id) async {
//     final database = await LocalDb.instance.db;
//     final result = await database.query(
//       'clients',
//       where: 'id = ? AND deleted = 0',
//       whereArgs: [id],
//     );

//     if (result.isNotEmpty) {
//       return Client.fromJson(result.first);
//     }

//     return null;
//   }

//   Future<List<Client>> getAllClient() async {
//     final database = await LocalDb.instance.db;
//     final result = await database.query(
//       'clients',
//       where: 'deleted = ?',
//       whereArgs: [0],
//     );

//     return result.map((row) => Client.fromJson(row)).toList();
//   }

//   Future<void> syncWithCloud() async {
//     try {
//       final cloudClients = await ClientCloudDb.instance.getAllClients();

//       for (final client in cloudClients) {
//         if (!client.deleted) {
//           await upsertClient(client);
//         }
//       }
//     } catch (e) {
//       // print("Failed to sync data: $e");
//     }
//   }
// }