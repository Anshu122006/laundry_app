import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/modules/employee/clients/controller/client_controller.dart';
import 'package:laundary_app/modules/employee/clients/widgets/client_tile.dart';
import 'package:laundary_app/modules/employee/clients/widgets/clients_header.dart';

class ClientsListScreen extends StatelessWidget {
  const ClientsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientScreenController>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => ClientListHeader.getHeader(context),
          body: TabBarView(
            children: [
              Obx(() {
                List<Client> clients =
                    controller.filteredClients
                        .map((client) => client.value)
                        .toList();
                return Transform.translate(
                  offset: Offset(0, -25),
                  child: ListView.builder(
                    itemCount: clients.length,
                    itemBuilder:
                        (_, index) =>
                            ClientTile(client: clients[index], index: controller.indexof(clients[index])),
                  ),
                );
              }),

              Obx(() {
                List<Client> clients =
                    controller.filteredClients
                        .map((client) => client.value)
                        .where((client) => client.balance > 0)
                        .toList();
                return Transform.translate(
                  offset: Offset(0, -25),
                  child: ListView.builder(
                    itemCount: clients.length,
                    itemBuilder:
                        (_, index) =>
                            ClientTile(client: clients[index], index: controller.indexof(clients[index]),
                        ),
                  ),
                );
              }),

              Obx(() {
                List<Client> clients =
                    controller.filteredClients
                        .map((client) => client.value)
                        .where((client) => client.balance < 0)
                        .toList();
                return Transform.translate(
                  offset: Offset(0, -25),
                  child: ListView.builder(
                    itemCount: clients.length,
                    itemBuilder:
                        (_, index) =>
                            ClientTile(client: clients[index], index: controller.indexof(clients[index]),
                        ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
