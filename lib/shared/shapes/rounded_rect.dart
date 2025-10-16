import 'package:flutter/material.dart';

class CRoundedRect extends StatelessWidget {
  const CRoundedRect({
    super.key,
    this.height = 6,
    this.width = 45,
    this.radius = 4,
    this.sclae = 1,
    this.color = Colors.white,
  });

  final double height;
  final double width;
  final double radius;
  final double sclae;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: sclae,
      child: Container(
        height: height,
        width: width,
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius), color: color),
      ),
    );
  }
}
