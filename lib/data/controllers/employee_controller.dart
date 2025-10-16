import 'dart:async';

import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/employee_cloud_db.dart';
import 'package:laundary_app/data/models/employee.dart';

class EmployeeController extends GetxController {
  static EmployeeController get instance {
    return Get.find<EmployeeController>();
  }

  final employees = <Rx<Employee>>[].obs;

  // Timer? _debounce;

  static Future<void> initController() async {
    try {
      if (!Get.isRegistered<EmployeeController>()) {
        Get.put(EmployeeController(), permanent: true);
      }
      // List<Employee> elist = await EmployeeLocalDb.instance.getAllEmployee();
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
    } catch (e) {
      // print(e);
    }
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
