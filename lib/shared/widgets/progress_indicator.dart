import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';

class CProgressIndicator extends StatelessWidget {
  const CProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.curSteps,
    required this.radius,
    this.isCancelled = false,
    this.color,
    this.cancelledColor,
  });
  final int totalSteps;
  final int curSteps;
  final double radius;
  final bool isCancelled;
  final Color? color;
  final Color? cancelledColor;

  @override
  Widget build(BuildContext context) {
    double spacing = radius * 2.5;
    List<Widget> circles = [];
    List<Widget> lines = [];
    for (int i = 0; i < curSteps; i++) {
      circles.add(
        Container(
          height: radius * 2,
          width: radius * 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius * 2),
            color: color ?? CColors.progressNormalColor,
          ),
          child: Icon(
            Icons.check,
            size: radius * 1.6,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      );
      lines.add(
        Container(
          width: 2 * radius + spacing,
          height: 3,
          color: color ?? CColors.progressNormalColor,
        ),
      );
    }

    if (isCancelled) {
      circles.add(
        Container(
          height: radius * 2,
          width: radius * 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius * 2),
            color: cancelledColor ?? CColors.progressCancelledColor,
          ),
          child: Icon(
            Icons.close,
            size: radius * 1.6,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      );
      lines.add(
        Container(
          width: 2 * radius + spacing,
          height: 3,
          color: cancelledColor ?? CColors.progressCancelledColor,
        ),
      );
    }

    for (int i = curSteps + (isCancelled ? 1 : 0); i < totalSteps; i++) {
      circles.add(
        Container(
          height: radius * 2,
          width: radius * 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius * 2),
            border: Border.all(
              width: 2,
              color:
                  isCancelled
                      ? (cancelledColor ?? CColors.progressCancelledColor)
                      : (color ?? CColors.progressNormalColor),
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      );
      lines.add(
        Container(
          width: 2 * radius + spacing,
          height: 3,
          color:
              isCancelled
                  ? (cancelledColor ?? CColors.progressCancelledColor)
                  : (color ?? CColors.progressNormalColor),
        ),
      );
    }
    lines.removeLast();

    return SizedBox(
      height: radius * 2,
      width: circles.length * 2 * radius + lines.length * spacing,
      child: Stack(
        children: [
          SizedBox(
            height: radius * 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: lines,
            ),
          ),
          SizedBox(
            height: radius * 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacing,
              children: circles,
            ),
          ),
        ],
      ),
    );
  }
}
