import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/modules/employee/clients/controller/client_screen_controller.dart';
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
              // Tab 1: All Clients
              Obx(() {
                final List<Rx<Client>> clients = controller.filteredClients;
                return Transform.translate(
                  offset: const Offset(0, -25),
                  child: ListView.builder(
                    itemCount: clients.length,
                    itemBuilder: (_, index) {
                      final currentId = clients[index].value.id;
                      return ClientTile(clientId: currentId, index: index);
                    },
                  ),
                );
              }),

              // Tab 2: Credit Balances
              Obx(() {
                final List<Rx<Client>> creditClients =
                    controller.filteredClients
                        .where((client) => client.value.balance > 0)
                        .toList();
                return Transform.translate(
                  offset: const Offset(0, -25),
                  child: ListView.builder(
                    itemCount: creditClients.length,
                    itemBuilder: (_, index) {
                      final currentId = creditClients[index].value.id;
                      return ClientTile(clientId: currentId, index: index);
                    },
                  ),
                );
              }),

              // Tab 3: Debit Balances
              Obx(() {
                final List<Rx<Client>> debitClients =
                    controller.filteredClients
                        .where((client) => client.value.balance < 0)
                        .toList();
                return Transform.translate(
                  offset: const Offset(0, -25),
                  child: ListView.builder(
                    itemCount: debitClients.length,
                    itemBuilder: (_, index) {
                      final currentId = debitClients[index].value.id;
                      return ClientTile(clientId: currentId, index: index);
                    },
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
