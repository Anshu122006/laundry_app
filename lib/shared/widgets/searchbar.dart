import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/constants/size_values.dart';

class CSearchbar extends StatelessWidget {
  const CSearchbar({
    super.key,
    this.filled = true,
    this.icon = Icons.search,
    this.borderColor,
    this.fillColor,
    this.height = 50,
    this.width,
    required this.labelText,
    required this.onChanged,
  });

  final bool filled;
  final String labelText;
  final double height;
  final double? width;
  final IconData icon;
  final Color? borderColor;
  final Color? fillColor;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? height * 7,
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: CPaddings.md,
        vertical: CPaddings.sm,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? CColors.grey),
        borderRadius: BorderRadius.circular(height * 0.5),
        color: filled ? fillColor ?? CColors.white : CColors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: CSizes.rowSpacingMid,
        children: [
          Expanded(
            flex: 1,
            child: Icon(icon, color: CColors.grey, size: height * 0.5),
          ),
          Expanded(
            flex: 9,
            child: TextField(
              onChanged: onChanged,
              cursorHeight: height * 0.4,
              cursorColor: CColors.grey,
              style: TextStyle(
                color: CColors.darkGrey,
                fontWeight: FontWeight.w300,
              ),
              decoration: InputDecoration(
                hintText: labelText,
                hintStyle: Theme.of(context).textTheme.labelLarge!.apply(
                  fontStyle: FontStyle.italic,
                  color: CColors.darkGrey,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
