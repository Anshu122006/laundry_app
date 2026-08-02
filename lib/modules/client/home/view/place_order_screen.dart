import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/modules/client/home/controller/home_controller.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';
import 'package:laundary_app/core/constants/colors.dart';

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
              constraints: const BoxConstraints.expand(),
              child: Stack(
                children: [
                  Positioned(top: 15, left: 15, child: const CBackButton()),
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
                    child: const Image(
                      image: AssetImage(
                        "assets/illustrations/order_placing.png",
                      ),
                      height: 390,
                    ),
                  ),

                  // ─── REACTIVE ELEVATED BUTTON MIGRATION ────────────────────────
                  Positioned(
                    bottom: 240,
                    left: 30,
                    right: 30,
                    child: Obx(() {
                      final bool processing = controller.isLoading.value;

                      return ElevatedButton(
                        // Passing null completely disables the button behaviorally
                        onPressed: processing ? null : () => controller.placeOrder(type),
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: CColors.primaryColor.withAlpha(120),
                        ),
                        child:
                            processing
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Text("Place Order"),
                      );
                    }),
                  ),

                  Positioned(
                    bottom: 180,
                    left: 60,
                    right: 60,
                    child: const CLineDivider(),
                  ),
                  Positioned(
                    bottom: 100,
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
                ],
              ),
            ),
      ),
    );
  }
}
