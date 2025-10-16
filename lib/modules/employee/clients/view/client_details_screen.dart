import 'package:flutter/material.dart';
import 'package:laundary_app/data/controllers/client_controller.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/modules/employee/clients/widgets/details_background.dart';
import 'package:laundary_app/modules/employee/clients/widgets/details_card.dart';
import 'package:laundary_app/modules/employee/clients/widgets/details_header.dart';

class ClientDetailsScreen extends StatelessWidget {
  const ClientDetailsScreen({super.key, required this.client});
  final Client client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            ClientDetailsBackground(),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  ClientDetailsHeader(id: client.id),
                  SizedBox(height: 60),
                  Center(child: ClientDetailsCard(index: ClientController.instance.indexof(client.id))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
