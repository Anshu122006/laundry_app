import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/modules/client/account/controller/account_controller.dart';
import 'package:laundary_app/shared/widgets/rounded_image.dart';
import 'package:laundary_app/modules/client/account/view/edit_screen.dart';
import 'package:laundary_app/core/constants/colors.dart';

class CUserProfileTile extends StatelessWidget {
  const CUserProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController userdata = AuthController.instance;

    return ListTile(
      leading: FittedBox(
        child: CRoundedImage(
          isCircle: true,
          radius: 26,
          image: "assets/icons/user_icon.png",
        ),
      ),
      title: Obx(
        () => Text(
          userdata.currentClient.value?.name ?? "",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.apply(color: CColors.secondaryColor),
        ),
      ),
      subtitle: Obx(
        () => Text(
          userdata.currentClient.value?.email ?? "",
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.apply(color: CColors.secondaryColor),
        ),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: IconButton(
          onPressed: () {
            final controller = Get.find<ClientAccountController>();
            controller.updateData();
            Get.to(() => AccountUpdateScreen());
          },
          icon: Icon(Icons.edit, color: CColors.secondaryColor),
        ),
      ),
    );
  }
}
