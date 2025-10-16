import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/shared/widgets/rounded_image.dart';
import 'package:laundary_app/modules/employee/account/view/edit_screen.dart';
import 'package:laundary_app/core/constants/colors.dart';

class CEmployeeProfileTile extends StatelessWidget {
  const CEmployeeProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController userData = AuthController.instance;

    return ListTile(
      leading: FittedBox(
        child: CRoundedImage(
          isCircle: true,
          radius: 22,
          image: "assets/icons/user_icon.png",
        ),
      ),
      title: Obx(
        () => Text(
          userData.currentEmployee.value?.name ?? "",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.apply(color: CColors.secondaryColor),
        ),
      ),
      subtitle: Obx(
        () => Text(
          userData.currentEmployee.value?.email ?? "",
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.apply(color: CColors.secondaryColor),
        ),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: IconButton(
          onPressed: () => Get.to(() => AccountUpdateScreen()),
          icon: Icon(Icons.edit, color: CColors.secondaryColor, size: 22),
        ),
      ),
    );
  }
}
