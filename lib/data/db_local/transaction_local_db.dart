// import 'package:laundary_app/data/db_cloud/transaction_cloud_db.dart';
// import 'package:laundary_app/data/db_local/_main_local_db.dart';
// import 'package:laundary_app/data/models/transaction.dart';
// import 'package:sqflite/sqflite.dart';

// class TransactionLocalDb {
//   static TransactionLocalDb? _instance;
//   TransactionLocalDb._();
//   static TransactionLocalDb get instance {
//     _instance ??= TransactionLocalDb._();
//     return _instance!;
//   }

//   Future<void> upsertTransaction(LaundryTransaction transaction) async {
//     if (transaction.id.isEmpty) return;

//     final database = await LocalDb.instance.db;
//     await database.insert(
//       'transactions',
//       transaction.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<void> deleteTransaction(String id) async {
//     final database = await LocalDb.instance.db;
//     await database.delete('transactions', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<LaundryTransaction?> getTransactionById(String id) async {
//     final database = await LocalDb.instance.db;
//     final result = await database.query(
//       'transactions',
//       where: 'id = ? AND deleted = 0',
//       whereArgs: [id],
//     );

//     if (result.isNotEmpty) {
//       return LaundryTransaction.fromJson(result.first);
//     }

//     return null;
//   }

//   Future<List<LaundryTransaction>> getAllTransaction() async {
//     final database = await LocalDb.instance.db;
//     final result = await database.query(
//       'transactions',
//       where: 'deleted = ?',
//       whereArgs: [0],
//     );

//     return result.map((row) => LaundryTransaction.fromJson(row)).toList();
//   }

//   Future<void> syncWithCloud() async {
//     try {
//       final cloudTransactions = await TransactionCloudDb.instance.getAllTransactions();

//       for (final transaction in cloudTransactions) {
//         if (!transaction.deleted) {
//           await upsertTransaction(transaction);
//         }
//       }
//     } catch (e) {
//       // print("Failed to sync data: $e");
//     }
//   }
// }
