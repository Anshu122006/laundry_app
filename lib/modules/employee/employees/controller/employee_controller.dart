import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/controllers/employee_controller.dart';
import 'package:laundary_app/data/db_cloud/employee_cloud_db.dart';
import 'package:laundary_app/data/models/employee.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeScreenController extends GetxController {
  final filteredEmployees = <Rx<Employee>>[].obs;
  final RxString searchQuery = "".obs;
  final RxString sortBy = "email".obs;

  RxString name = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString role = "".obs;

  @override
  void onInit() {
    super.onInit();
    debounce(
      searchQuery,
      (_) => filterEmployees(),
      time: Duration(milliseconds: 300),
    );

    ever(EmployeeController.instance.employees, (_) => filterEmployees());
    filterEmployees();
  }

  void filterEmployees() {
    final query = searchQuery.value.toLowerCase();
    final sortKey = sortBy.value;
    final curId = AuthController.instance.currentEmployee.value?.id ?? "";
    final employees =
        EmployeeController.instance.employees
            .where((e) => e.value.id != curId)
            .toList();

    Iterable<Rx<Employee>> result;
    if (query.isEmpty) {
      result = employees;
    } else {
      result = employees.where((employee) {
        final value =
            sortKey == "name"
                ? employee.value.name.toLowerCase().replaceAll(
                  RegExp(r'\s+'),
                  '',
                )
                : sortKey == "email"
                ? employee.value.email.toLowerCase().replaceAll(
                  RegExp(r'\s+'),
                  '',
                )
                : employee.value.phone.toLowerCase().replaceAll(
                  RegExp(r'\s+'),
                  '',
                );
        return value.contains(query);
      });
    }

    final sortedList =
        result.toList()..sort((a, b) {
          final aValue =
              sortKey == "name"
                  ? a.value.name.toLowerCase()
                  : sortKey == "email"
                  ? a.value.email.toLowerCase()
                  : a.value.phone;
          final bValue =
              sortKey == "name"
                  ? b.value.name.toLowerCase()
                  : sortKey == "email"
                  ? b.value.email.toLowerCase()
                  : b.value.phone;
          return aValue.compareTo(bValue);
        });

    filteredEmployees.assignAll(sortedList);
    filteredEmployees.refresh();
  }

  Future addEmployee() async {
    try {
      Employee employee = Employee(
        id: "",
        name: name.value,
        email: email.value,
        phone: phone.value,
        role: "employee",
        updatedAt: 0,
        deleted: false,
      );
      await EmployeeCloudDb.instance.addEmployee(employee);
    } catch (e) {
      //
    }
  }

  Future removeEmployee(Employee employee) async {
    try {
      await EmployeeCloudDb.instance.deleteEmployee(employee);
      Future.delayed(Duration(milliseconds: 300), () {});
    } catch (e) {
      //
    }
  }

  Future<void> launchDialer(String phoneNumber) async {
    try {
      final Uri uri = Uri(scheme: 'tel', path: "+91$phoneNumber");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $phoneNumber';
      }
    } catch (e) {
      //
    }
  }
}
