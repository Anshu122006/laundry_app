import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/modules/client/wallet/controller/wallet_screen_controller.dart';
import 'package:laundary_app/modules/client/wallet/widgets/date_picker_helper.dart';
import 'package:laundary_app/modules/client/wallet/widgets/transactionn_history.dart';
import 'package:laundary_app/shared/widgets/back_button.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WalletScreenController>();
    final userdata = AuthController.instance;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: CBackButton(),
                    ),
                    Transform.translate(
                      offset: const Offset(0, 16),
                      child: IconButton(
                        onPressed: () => ClientDatePickerHelper.show(),
                        icon: Icon(
                          Icons.calendar_month,
                          size: 32,
                          color:
                              CDeviceHelper.isDarkMode()
                                  ? CColors.light
                                  : CColors.dark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Wallet",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Image(
                image: AssetImage("assets/illustrations/wallet.png"),
                height:
                    300, // Explicit sizing helps structure scroll views accurately
              ),
              const SizedBox(height: 10),

              // Reactive Client Balance Output
              Obx(
                () => Text(
                  "Current Balance: ₹${userdata.currentClient.value?.balance ?? 0}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              // Real-time Order Filtering Metric Output
              Obx(
                () => Text(
                  "Orders Placed: ${controller.totalOrders}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),

              const SizedBox(height: 20),
              const ClientTransactionHistory(),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: CLineDivider(),
              ),
              const SizedBox(height: 5),
              Text(
                "You must have a balance of above\n₹100 to place an order",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
