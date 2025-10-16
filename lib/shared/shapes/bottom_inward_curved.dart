import 'package:flutter/material.dart';
import 'package:laundary_app/shared/edges/bottom_inward_curved.dart';

class CBottomInwardCurved extends StatelessWidget {
  const CBottomInwardCurved({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CBottomInwardCurvedEdge(),
      child: child,
    );
  }
}