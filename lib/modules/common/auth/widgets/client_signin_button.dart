import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/modules/common/auth/controller/client_auth_controller.dart';
import 'package:laundary_app/core/constants/colors.dart';

class ClientSigninButton extends StatelessWidget {
  const ClientSigninButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientAuthController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: CColors.transparent,
        border: Border.all(color: CColors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        splashColor: Colors.grey.withAlpha(100),
        onTap: () async {
          if (!controller.isLoading.value) await controller.signin();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 2,
                child: Image.asset(
                  "assets/icons/android_light_rd_na@3x.png",
                  height: 35,
                  width: 35,
                  fit: BoxFit.contain,
                ),
              ),
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 15,
                child: Text(
                  "Sign-in with Google",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
