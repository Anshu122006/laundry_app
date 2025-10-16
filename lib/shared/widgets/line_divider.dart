import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';
import 'package:laundary_app/core/utils/device/device_utility.dart';

class CLineDivider extends StatelessWidget {
  const CLineDivider({super.key, this.isDashed = false});

  final bool isDashed;

  @override
  Widget build(BuildContext context) {
    final Color color =
        CDeviceHelper.isDarkMode() ? Colors.grey : Colors.grey.shade700;
    final double size = 12;
    final double space = 4;
    return Padding(
      padding: const EdgeInsets.all(0),
      child:
          isDashed
              ? LayoutBuilder(
                builder:
                    (context, constraints) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: Helper.getDashedLines(
                        constraints.maxWidth,
                        size,
                        space,
                        CColors.darkGrey,
                      ),
                      // children: Helper.getDashedLines(constraints.maxWidth, 2),
                    ),
              )
              : Divider(color: color, thickness: 0.5, indent: 0, endIndent: 0),
    );
  }
}

class Helper {
  static List<Widget> getDashedLines(
    double width,
    double size,
    double space,
    Color color,
  ) {
    int n = (width / (size + (space - 2) * 2)).toInt();
    List<Widget> lines = [];
    for (int i = 0; i < n; i++) {
      lines.add(Container(height: 1, width: size, color: color));
      lines.add(SizedBox(width: space));
    }

    return lines;
  }

  static getItemTile({required int amount, required String name, required int price}) {}
}
