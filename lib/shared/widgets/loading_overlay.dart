import 'package:flutter/material.dart';
import 'package:laundary_app/core/constants/colors.dart';

class CLoadingOverlay extends StatelessWidget {
  const CLoadingOverlay({super.key, });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: CColors.darkGrey.withAlpha(100),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

