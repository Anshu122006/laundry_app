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
    AuthController userdata = AuthController.instance;

    return Scaffold(
      body: LayoutBuilder(
        builder:
            (context, constraints) => ConstrainedBox(
              constraints: BoxConstraints(maxHeight: constraints.maxHeight),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: CBackButton(),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, 16),
                          child: IconButton(
                            onPressed: () {
                              ClientDatePickerHelper.show();
                            },
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
                    SizedBox(height: 10),
                    Image(image: AssetImage("assets/illustrations/wallet.png")),
                    SizedBox(height: 10),
                    Text(
                      "Curent Balace: ₹${userdata.currentClient.value?.balance ?? 0}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Obx(
                      () => Text(
                        "Orders Placed: ${controller.orders}",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    SizedBox(height: 20),
                    ClientTransactionHistory(),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: CLineDivider(),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "You must have a balance of above\n₹100 to place an order",
                      style: Theme.of(context).textTheme.labelLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
