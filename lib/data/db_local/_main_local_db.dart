// import 'dart:async';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class LocalDb {
//   LocalDb._();
//   static LocalDb? _instance = LocalDb._();
//   static LocalDb get instance {
//     _instance ??= LocalDb._();
//     return _instance!;
//   }

//   Database? _db;

//   Future<Database> get db async {
//     if (_db != null && _db!.isOpen) return _db!;
//     _db = await _initDb();
//     return _db!;
//   }

//   static const _dbName = 'laundry.db';
//   static const _dbVersion = 1;
//   bool _isFreshDb = false;

//   bool get isFreshDb => _isFreshDb;

//   Future<Database> _initDb() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, _dbName);

//     _isFreshDb = false;

//     return await openDatabase(
//       path,
//       version: _dbVersion,
//       onCreate: (db, version) async {
//         _isFreshDb = true;
//         await _onCreate(db, version);
//       },
//       onUpgrade: _onUpgrade,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE clients (
//         id TEXT PRIMARY KEY,
//         name TEXT,
//         email TEXT,
//         phone TEXT,
//         hostel TEXT,
//         room TEXT,
//         balance INTEGER,
//         deleted INTEGER DEFAULT 0,
//         updatedAt INTEGER
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE employees (
//         id TEXT PRIMARY KEY,
//         name TEXT,
//         email TEXT,
//         phone TEXT,
//         role TEXT,
//         deleted INTEGER DEFAULT 0,
//         updatedAt INTEGER
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE offers (
//         id TEXT PRIMARY KEY,
//         title TEXT,
//         desc TEXT,
//         isMain INTEGER,
//         deleted INTEGER DEFAULT 0,
//         updatedAt INTEGER
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE pricings (
//         id TEXT PRIMARY KEY,
//         name TEXT,
//         type TEXT,
//         cost TEXT,
//         deleted INTEGER DEFAULT 0,
//         updatedAt INTEGER
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE orders (
//         id TEXT PRIMARY KEY,
//         clientId TEXT,
//         placedDate INTEGER,
//         status TEXT,
//         statusBeforeCancelled TEXT,
//         items TEXT,
//         pickupAgentId TEXT,
//         deliverAgentId TEXT,
//         pickupDate INTEGER,
//         deliveryDate INTEGER,
//         deleted INTEGER DEFAULT 0,
//         updatedAt INTEGER,
//         discount REAL,
//         cost REAL
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE transactions (
//         id TEXT PRIMARY KEY,
//         type TEXT,
//         amount REAL,
//         timestamp INTEGER,
//         updatedAt INTEGER,
//         deleted INTEGER
//       )
//     ''');
//   }

//   Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
//     // Future-proof for schema changes (if needed)
//     // Example: if (oldVersion < 2) { await db.execute("ALTER TABLE ..."); }
//   }

//   /// Delete all records from all tables
//   Future<void> deleteAll() async {
//     final database = await db;
//     await database.transaction((txn) async {
//       await txn.delete("clients");
//       await txn.delete("employees");
//       await txn.delete("orders");
//       await txn.delete("pricings");
//       await txn.delete("offers");
//       await txn.delete("transactions");
//     });
//   }

//   /// Deletes the entire database file and resets the instance
//   Future<void> deleteDatabaseAndReinit() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, _dbName);
//     await deleteDatabase(path);
//     _db = null;
//   }

//   Future<void> ensureInitialized() async {
//     await db;
//   }
// }
