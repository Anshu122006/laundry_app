import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/employee_cloud_db.dart';
import 'package:laundary_app/data/models/employee.dart';

class EmployeeController extends GetxController {
  static EmployeeController get instance {
    return Get.find<EmployeeController>();
  }

  final employees = <Rx<Employee>>[].obs;
  static const String _storageKey = 'cached_employees_v1';

  static Future<void> initController() async {
    try {
      if (!Get.isRegistered<EmployeeController>()) {
        Get.put(EmployeeController(), permanent: true);
      }
      final storage = GetStorage();
      final List<dynamic>? cachedData = storage.read(_storageKey);

      if (cachedData != null && cachedData.isNotEmpty) {
        final cachedEmployees = cachedData
            .map((json) => Employee.fromJson(Map<String, dynamic>.from(json)))
            .where(
              (employee) =>
                  employee.id !=
                  AuthController.instance.currentEmployee.value?.id,
            )
            .map((employee) => employee.obs)
            .toList();
        EmployeeController.instance.employees.assignAll(cachedEmployees);
      } else {
        await EmployeeController.instance.syncData();
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> syncData() async {
    List<Employee> elist = await EmployeeCloudDb.instance.getAllEmployees();
    EmployeeController.instance.employees.assignAll(
      elist
          .where(
            (employee) =>
                employee.id !=
                AuthController.instance.currentEmployee.value?.id,
          )
          .map((employee) => employee.obs)
          .toList(),
    );
    _saveToDisk();
  }

  void _saveToDisk() {
    final storage = GetStorage();
    final rawList = employees.map((e) => e.value.toMap()).toList();
    storage.write(_storageKey, rawList);
  }

  // Future<void> updateData() async {
  //   List<Employee> plist = await EmployeeLocalDb.instance.getAllEmployee();
  //   employees.assignAll(plist.map((employee) => employee.obs).toList());
  // }

  // void scheduleUpdate() {
  //   _debounce?.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 300), () async {
  //     try {
  //       await updateData();
  //     } catch (e) {
  //       print('Error during scheduleUpdate: $e');
  //     }
  //   });
  // }

  Employee? getEmployee(String id) {
    Employee? employee =
        employees.firstWhereOrNull((e) => e.value.id == id)?.value;
    return employee;
  }

  void addEmployee(Employee employee) {
    employees.add(employee.obs);
  }

  void updateEmployee(Employee employee) {
    for (int i = 0; i < employees.length; i++) {
      if (employees[i].value.id == employee.id) {
        employees[i] = employee.obs;
        employees.refresh();
        break;
      }
    }
  }

  void deleteEmployee(Employee employee) {
    employees.removeWhere((e) => e.value.id == employee.id);
  }
}
