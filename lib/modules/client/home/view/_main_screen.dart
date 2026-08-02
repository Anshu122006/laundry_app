import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/modules/client/home/controller/home_controller.dart';
import 'package:laundary_app/modules/client/home/widgets/home_current_orders.dart';
import 'package:laundary_app/modules/client/home/widgets/home_header.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ClientHomeScreenController());

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 1, left: 1, right: 1),
                child: const ClientHomeHeader(),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const CurrentOrders(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
