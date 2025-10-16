import 'package:flutter/material.dart';
import 'package:laundary_app/data/models/order.dart';
import 'package:laundary_app/modules/employee/client_history/widgets/client_history_background.dart';
import 'package:laundary_app/modules/employee/client_history/widgets/client_history_header.dart';
import 'package:laundary_app/modules/employee/client_history/widgets/client_history_card.dart';

class ClientHistoryScreen extends StatelessWidget {
  const ClientHistoryScreen({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Stack(
                children: [
                  Positioned.fill(child: ClientHistoryBackground()),

                  // Main content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      ClientHistoryHeader(clientId: clientId),
                      SizedBox(height: 30),
                      Center(child: ClientHistoryCard(clientId: clientId)),
                      SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StatusHelper {
  StatusHelper._();

  static String getButtonText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return "Set picked";
      case OrderStatus.picked:
        return "Set washing";
      case OrderStatus.washing:
        return "Set ready";
      case OrderStatus.ready:
        return "Set delivered";
      default:
        return "";
    }
  }
}
