import 'package:flutter/material.dart';
import 'package:laundary_app/modules/client/home/widgets/home_current_orders.dart';
import 'package:laundary_app/modules/client/home/widgets/home_header.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

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
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 1, left: 1, right: 1),
                      child: ClientHomeHeader(),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: CurrentOrders(),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
