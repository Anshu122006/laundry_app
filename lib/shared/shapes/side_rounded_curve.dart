import 'package:flutter/material.dart';
import 'package:laundary_app/shared/edges/side_rounded_curve.dart';

class CSideRoundedCurve extends StatelessWidget {
  const CSideRoundedCurve({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: CSideRoundedCurveEdge(), child: child);
  }
}
