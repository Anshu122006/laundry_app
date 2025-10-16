import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';

class ContactRow extends StatelessWidget {
  const ContactRow({
    super.key,
    required this.icon,
    required this.name,
    required this.value,
    required this.onTap,
    required this.onEdit,
  });
  final IconData icon;
  final String name;
  final String value;
  final Future<void> Function() onTap;
  final void Function() onEdit;

  @override
  Widget build(BuildContext context) {
    bool isAdmin = AuthController.instance.userType.value == UserType.admin;
    bool isDark = CDeviceHelper.isDarkMode();
    double width = CDeviceHelper.getScreenWidth();
    double height = 35;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: width * 0.1,
            child: Icon(
              icon,
              color: isDark ? CColors.white : CColors.black,
              size: 26,
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: width * 0.25,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                "$name:   ",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),

          SizedBox(
            width: width * (isAdmin ? 0.45 : 0.55),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: GestureDetector(
                onTap: () async {
                  await onTap();
                },
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w200,
                    fontStyle: FontStyle.italic,
                    fontSize: 19,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),

          if (isAdmin)
            SizedBox(
              width: width * 0.1,
              child: IconButton(
                onPressed: onEdit,
                icon: Icon(
                  Icons.edit,
                  color:
                      CDeviceHelper.isDarkMode()
                          ? CColors.white
                          : CColors.black,
                  size: 26,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
