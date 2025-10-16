import 'package:flutter/material.dart';

class CCircle extends StatelessWidget {
  const CCircle({
    super.key,
    this.radius = 150,
    this.opacity = 1,
    this.color = Colors.white,
    this.border,
  });
  final double radius;
  final double opacity;
  final Color color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final Widget circle = Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
    );

    return Opacity(
      opacity: opacity > 1 ? 1 : opacity,
      child: LayoutBuilder(
        builder: (context, constraint) {
          final bool scaleDown =
              (radius * 2) > constraint.maxWidth || (radius * 2) > constraint.maxHeight;

          return scaleDown ? FittedBox(child: circle) : UnconstrainedBox(child: circle);
        },
      ),
    );
  }
}
