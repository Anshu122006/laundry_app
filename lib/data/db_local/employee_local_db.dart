// import 'package:laundary_app/data/db_cloud/employee_cloud_db.dart';
// import 'package:laundary_app/data/db_local/_main_local_db.dart';
// import 'package:laundary_app/data/models/employee.dart';
// import 'package:sqflite/sqflite.dart';

// class EmployeeLocalDb {
//   static EmployeeLocalDb? _instance;
//   EmployeeLocalDb._();
//   static EmployeeLocalDb get instance {
//     _instance ??= EmployeeLocalDb._();
//     return _instance!;
//   }

//   Future<void> upsertEmployee(Employee employee) async {
//     if (employee.id.isEmpty) return;

//     final database = await LocalDb.instance.db;
//     await database.insert(
//       'employees',
//       employee.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<void> deleteEmployee(String id) async {
//     final database = await LocalDb.instance.db;
//     await database.delete('employees', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<Employee?> getEmployeeById(String id) async {
//     final database = await LocalDb.instance.db;
//     final result = await database.query(
//       'employees',
//       where: 'id = ? AND deleted = 0',
//       whereArgs: [id],
//     );

//     if (result.isNotEmpty) {
//       return Employee.fromJson(result.first);
//     }

//     return null;
//   }

//   Future<List<Employee>> getAllEmployee() async {
//     final database = await LocalDb.instance.db;
//     final result = await database.query(
//       'employees',
//       where: 'deleted = ?',
//       whereArgs: [0],
//     );

//     return result.map((row) => Employee.fromJson(row)).toList();
//   }

//   Future<void> syncWithCloud() async {
//     try {
//       final cloudEmployees = await EmployeeCloudDb.instance.getAllEmployees();

//       for (final employee in cloudEmployees) {
//         if (!employee.deleted) {
//           await upsertEmployee(employee);
//         }
//       }
//     } catch (e) {
//       // print("Failed to sync data: $e");
//     }
//   }
// }
