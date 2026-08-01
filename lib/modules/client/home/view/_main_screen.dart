import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/modules/client/home/controller/home_controller.dart';
import 'package:laundary_app/modules/client/home/widgets/home_current_orders.dart';
import 'package:laundary_app/modules/client/home/widgets/home_header.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate our home screen controller inside GetX memory context
    final controller = Get.put(ClientHomeScreenController());

    return Scaffold(
      body: LayoutBuilder(
        builder:
            (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Obx(() {
                    // If the controller status signals a remote update/write lock, show visual overlay block
                    return Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                top: 1,
                                left: 1,
                                right: 1,
                              ),
                              child: const ClientHomeHeader(),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child:
                                  const CurrentOrders(), // Inside this widget, wrap elements in an Obx for live syncing
                            ),
                          ],
                        ),
                        if (controller.isLoading.value)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.15),
                              child: const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),
      ),
    );
  }
}
