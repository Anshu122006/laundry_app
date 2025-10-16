import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';

class COptionTile extends StatelessWidget {
  const COptionTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onPressed,
  });

  final Icon leadingIcon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: CColors.lightGrey,
      child: ListTile(
        leading: leadingIcon,
        title: Text(title, style: Theme.of(context).textTheme.labelLarge),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        trailing: trailing,
      ),
    );
  }
}
