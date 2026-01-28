import 'package:flutter/material.dart';
// import 'package:laundary_app/modules/employee/home/controller/home_controller.dart';
import 'package:laundary_app/modules/employee/home/widgets/home_current_orders.dart';
import 'package:laundary_app/modules/employee/home/widgets/home_header.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder:
            (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 1, left: 1, right: 1),
                      child: EmployeeHomeHeader(),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Current Orders",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: EmployeeCurrentOrders(),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     EmployeeHomeController controller =
                    //         EmployeeHomeController();
                    //     controller.placeOrder();
                    //   },
                    //   child: Text("Test"),
                    // ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
