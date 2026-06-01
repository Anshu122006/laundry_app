import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/core/constants/icons.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/services/url_service.dart';
import 'package:laundary_app/modules/client/account/controller/account_controller.dart';
import 'package:laundary_app/modules/client/account/widgets/account_header.dart';
import 'package:laundary_app/modules/client/account/widgets/account_option_tile.dart';
import 'package:laundary_app/modules/common/attributions/view/_main_screen.dart';
import 'package:laundary_app/shared/widgets/heading.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';

class ClientAccountScreen extends StatelessWidget {
  const ClientAccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    AuthController userdata = AuthController.instance;
    final controller = Get.find<ClientAccountController>();

    return Scaffold(
      body: LayoutBuilder(
        builder:
            (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    SizedBox(height: 200, child: CAccountHeader()),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: CHeading(title: "Account Settings"),
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => COptionTile(
                        onPressed: () {},
                        leadingIcon: CIcons.hostelIcon,
                        title: userdata.currentClient.value?.hostel ?? "",
                        subtitle: "Your current hostel",
                      ),
                    ),
                    Obx(
                      () => COptionTile(
                        onPressed: () {},
                        leadingIcon: CIcons.roomIcon,
                        title: userdata.currentClient.value?.room ?? "",
                        subtitle: "Your current room",
                      ),
                    ),
                    Obx(
                      () => COptionTile(
                        onPressed: () {},
                        leadingIcon: CIcons.phoneIcon,
                        title: userdata.currentClient.value?.phone ?? "",
                        subtitle: "Your current contact",
                      ),
                    ),
                    COptionTile(
                      onPressed: () {
                        Get.toNamed(AppRoutes.pricing);
                      },
                      leadingIcon: CIcons.prices,
                      title: "Prices",
                      subtitle: "Check item prices",
                    ),
                    COptionTile(
                      onPressed: () => Get.toNamed(AppRoutes.clientWallet),
                      leadingIcon: CIcons.wallet,
                      title: "Wallet",
                      subtitle: "Check your wallet balance",
                    ),
                    COptionTile(
                      onPressed:
                          () async => await UrlService.joinWhatsAppGroup(),
                      leadingIcon: CIcons.whattsapp,
                      title: "Group",
                      subtitle: "Join our whattsapp group",
                    ),
                    COptionTile(
                      onPressed: () async => await UrlService.openReviewPage(),
                      leadingIcon: CIcons.review,
                      title: "Rate-us",
                      subtitle: "Review the app on playstore",
                    ),
                    COptionTile(
                      onPressed: () {
                        Get.toNamed(AppRoutes.contacts);
                      },
                      leadingIcon: CIcons.contactus,
                      title: "Contact-us",
                      subtitle: "Need help? contact us",
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: OutlinedButton(
                        onPressed: () {
                          controller.signOut();
                        },
                        child: Text("Logout"),
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: CLineDivider(),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => AttributionsScreen());
                        },
                        child: Text(
                          "atttibutions",
                          style: Theme.of(context).textTheme.labelMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
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
