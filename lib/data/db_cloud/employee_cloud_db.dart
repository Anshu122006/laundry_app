import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundary_app/data/controllers/employee_controller.dart';
import 'package:laundary_app/data/models/employee.dart';

class EmployeeCloudDb {
  static EmployeeCloudDb? _instance;
  EmployeeCloudDb._();
  static EmployeeCloudDb get instance {
    _instance ??= EmployeeCloudDb._();
    return _instance!;
  }

  final employees = FirebaseFirestore.instance.collection('employees');

  Future<String> addEmployee(Employee employee) async {
    final docRef = await employees.add(employee.toMap());
    await employees.doc(docRef.id).update({"id": docRef.id});
    employee = employee.copyWith(id: docRef.id);
    EmployeeController.instance.addEmployee(employee);
    return docRef.id;
  }

  Future<void> updateEmployee(Employee employee) async {
    employee = employee.copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      deleted: false,
    );
    await employees.doc(employee.id).update(employee.toMap());
    EmployeeController.instance.updateEmployee(employee);
  }

  Future<Employee?> getEmployee(String email) async {
    final query = await employees.where("email", isEqualTo: email).get();
    if (query.docs.isNotEmpty) {
      return Employee.fromJson(query.docs.first.data());
    } else {
      return null;
    }
  }

  Future<List<Employee>> getAllEmployees() async {
    final query = await employees.get();
    return query.docs.map((doc) => Employee.fromJson(doc.data())).toList();
  }

  Future<void> deleteEmployee(Employee employee) async {
    await employees.doc(employee.id).delete();
    EmployeeController.instance.deleteEmployee(employee);
  }
}
