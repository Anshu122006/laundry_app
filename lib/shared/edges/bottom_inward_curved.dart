import 'package:flutter/material.dart';

class CBottomInwardCurvedEdge extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    final List points = [
      Offset(0, size.height),
      Offset(30, size.height - 20),
      Offset(size.width - 30, size.height - 20),
      Offset(size.width, size.height),
      Offset(size.width, 0),
    ];

    final controlLeft = Offset(0, size.height - 20);
    final controlRight = Offset(size.width, size.height - 20);

    path.lineTo(points[0].dx, points[0].dy);
    path.quadraticBezierTo(controlLeft.dx, controlLeft.dy, points[1].dx, points[1].dy);
    path.lineTo(points[2].dx, points[2].dy);
    path.quadraticBezierTo(controlRight.dx, controlRight.dy, points[3].dx, points[3].dy);
    path.lineTo(points[4].dx, points[4].dy);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
