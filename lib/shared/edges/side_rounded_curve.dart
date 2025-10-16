import 'package:flutter/material.dart';

class CSideRoundedCurveEdge extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // final double sidelineHeight = 185;
    // final double sidelineWidth = 3;
    // final double sidelineRadius = 3;
    // final double sidelineOffset = 35;

    final List points = [
      Offset(0, size.height),
      Offset(0, size.height - 60),
      Offset(50, size.height),
      Offset(size.width, size.height),
      // Offset(size.width, size.height - sidelineOffset),
      // Offset(
      //   size.width - sidelineWidth,
      //   size.height - (sidelineOffset + sidelineRadius),
      // ),
      // Offset(
      //   size.width - sidelineWidth,
      //   size.height - (sidelineOffset + sidelineRadius + sidelineHeight),
      // ),
      // Offset(
      //   size.width,
      //   size.height - (sidelineOffset + 2 * sidelineRadius + sidelineHeight),
      // ),
      Offset(size.width, 0),
    ];

    final controlOne = Offset(10, size.height - 10);
    // final controlTwo = Offset(size.width, size.height - sidelineOffset);
    // final controlThree = Offset(
    //   size.width,
    //   size.height - (sidelineOffset + 2 * sidelineRadius + sidelineHeight),
    // );

    path.lineTo(points[0].dx, points[0].dy);
    path.lineTo(points[1].dx, points[1].dy);
    path.quadraticBezierTo(
      controlOne.dx,
      controlOne.dy,
      points[2].dx,
      points[2].dy,
    );
    path.lineTo(points[3].dx, points[3].dy);
    // path.lineTo(points[4].dx, points[4].dy);
    // path.quadraticBezierTo(
    //   controlTwo.dx,
    //   controlTwo.dy,
    //   points[5].dx,
    //   points[5].dy,
    // );
    // path.lineTo(points[6].dx, points[6].dy);
    // path.quadraticBezierTo(
    //   controlThree.dx,
    //   controlThree.dy,
    //   points[7].dx,
    //   points[7].dy,
    // );
    path.lineTo(points[4].dx, points[4].dy);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
