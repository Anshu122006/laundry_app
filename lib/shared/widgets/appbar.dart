import 'package:flutter/material.dart';
import 'package:laundary_app/shared/widgets/line_divider.dart';
import 'package:laundary_app/core/constants/size_values.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CAppBar({
    super.key,
    required this.title,
    this.backgroundColor = Colors.transparent,
    this.leading,
    this.trailing,
    this.showDivider = false,
    this.height = 70,
    this.titleOffset = 60,
  });

  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final bool showDivider;
  final double titleOffset;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: CDeviceHelper.getStatusBarHeight(context)),
      child: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: SizedBox(
          width: double.infinity,
          height: height,
          child: Stack(
            children: [
              if (leading != null) Positioned(left: 5, child: leading!),
              Positioned(top: 5, left: titleOffset, child: title),
              if (trailing != null) Positioned(right: 5, child: trailing!),
              if (showDivider)
                Positioned(bottom: 5, left: 0, right: 0, child: CLineDivider()),
            ],
          ),
        ),
        // title:
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(CSizes.appBarHeight);
}
