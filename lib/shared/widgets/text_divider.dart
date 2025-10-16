import 'package:flutter/material.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';

class CTextDivider extends StatelessWidget {
  const CTextDivider({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    final bool isDark = CDeviceHelper.isDarkMode();

    // if(text != null){
    //   Widget divider =
    // }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Divider(
                  color: isDark ? Colors.grey : Colors.grey.shade700,
                  thickness: 0.5,
                  indent: text != null ? 20 : 0,
                  endIndent: text != null ? 10 : 0,
                ),
              ),
              Text(text ?? "", style: Theme.of(context).textTheme.bodySmall),
              Expanded(
                child: Divider(
                  color: isDark ? Colors.grey : Colors.grey.shade700,
                  thickness: 0.5,
                  indent: text != null ? 10 : 0,
                  endIndent: text != null ? 20 : 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
