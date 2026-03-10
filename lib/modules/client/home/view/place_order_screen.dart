import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/modules/client/home/controller/home_controller.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';

class PlaceOrderScreen extends StatelessWidget {
  const PlaceOrderScreen({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientHomeScreenController>();

    return Scaffold(
      body: LayoutBuilder(
        builder:
            (context, constraints) => ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Stack(
                children: [
                  Positioned(top: 15, left: 15, child: CBackButton()),
                  Positioned(
                    top: 65,
                    left: 25,
                    child: Text(
                      "New Order",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Positioned(
                    top: 130,
                    left: -15,
                    child: Image(
                      image: AssetImage(
                        "assets/illustrations/order_placing.png",
                      ),
                      height: 390,
                    ),
                  ),
                  Positioned(
                    bottom: 175,
                    left: 30,
                    right: 30,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!controller.isLoading.value) {
                          await controller.placeOrder(type);
                        }
                      },
                      child: Text("Place Order"),
                    ),
                  ),
                  Positioned(
                    bottom: 130,
                    left: 60,
                    right: 60,
                    child: CLineDivider(),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 40,
                    child: SizedBox(
                      width: CDeviceHelper.getScreenWidth() * 0.8,
                      child: Text(
                        "After placing the order you just need to put the bag at the hostel gate, our agent will pick it from there,\nitems will be updated before your\nclothes are washed",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),

                  // Obx(() {
                  //   return CLoadingOverlay(
                  //     isLoading: controller.isLoading.value,
                  //   );
                  // }),
                ],
              ),
            ),
      ),
    );
  }
}
