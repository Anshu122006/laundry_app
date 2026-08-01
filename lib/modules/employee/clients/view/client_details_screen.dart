import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Make sure to import Get for Obx support
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/modules/employee/clients/widgets/details_background.dart';
import 'package:laundary_app/modules/employee/clients/widgets/details_card.dart';
import 'package:laundary_app/modules/employee/clients/widgets/details_header.dart';

class ClientDetailsScreen extends StatelessWidget {
  // Take clientId instead of the immutable client object structure
  const ClientDetailsScreen({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            const ClientDetailsBackground(),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  ClientDetailsHeader(id: clientId),
                  const SizedBox(height: 60),

                  // Wrap the target card inside an Obx widget to continuously
                  // monitor the index matching layout state inside the global store.
                  Center(
                    child: Obx(() {
                      final targetIndex = ClientController.instance.indexof(
                        clientId,
                      );

                      // Fallback handle safeguard if a client gets deleted while viewing the screen
                      if (targetIndex == -1) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("Client profile no longer available."),
                          ),
                        );
                      }

                      return ClientDetailsCard(index: targetIndex);
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
