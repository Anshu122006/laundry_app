import 'package:flutter/material.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder:
            (context, constraints) => ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Stack(
                children: [
                  Positioned(
                    top: 25,
                    left: 20,
                    child: Transform.scale(scale: 1.3, child: CBackButton()),
                  ),
                  Positioned(
                    top: 150,
                    left: 30,
                    child: Image(
                      image: AssetImage(
                        "assets/illustrations/placed_confirmation.png",
                      ),
                      height: 350,
                    ),
                  ),
                  Positioned(
                    bottom: 290,
                    left: 60,
                    child: Text(
                      "ORDER PLACED !!!",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Positioned(
                    bottom: 180,
                    left: 40,
                    child: SizedBox(
                      width: CDeviceHelper.getScreenWidth() * 0.8,
                      child: Text(
                        "Your order has been places successfully, don't forget to leave the bag at the hostel door, our agent will pick it as soon as possible",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
