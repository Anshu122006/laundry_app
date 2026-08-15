import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/db_cloud/order_cloud_db.dart';
import 'package:laundary_app/data/db_cloud/transaction_cloud_db.dart';
import 'package:laundary_app/data/services/notification_service.dart';
import 'package:laundary_app/modules/employee/home/controller/home_controller.dart';
import 'package:laundary_app/modules/employee/home/widgets/home_current_orders.dart';
import 'package:laundary_app/modules/employee/home/widgets/home_header.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EmployeeHomeController());

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 1, right: 1),
                child: const EmployeeHomeHeader(),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "Current Orders",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: const EmployeeCurrentOrders(),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     await OrderCloudDb.instance.purgeClientOrders();
              //     await TransactionCloudDb.instance.purgeClientTransactions();
              //   },
              //   child: Text("Clean Up"),
              // ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
