import 'package:flutter/material.dart';
import 'package:laundary_app/shared/widgets/rounded_container.dart';

class CRoundedImage extends StatelessWidget {
  const CRoundedImage({
    super.key,
    required this.image,
    this.radius = 14,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.grey,
    this.showBorder = false,
    this.isCircle = false,
    this.fit = BoxFit.cover,
    this.onPressed,
    this.height,
    this.width,
    this.overlayColor = Colors.transparent,
    this.padding,
  });

  final String image;
  final double radius;
  final double? height;
  final double? width;
  final Color backgroundColor;
  final Color overlayColor;
  final Color borderColor;
  final bool showBorder;
  final bool isCircle;
  final EdgeInsetsGeometry? padding;
  final BoxFit fit;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CRoundedContainer(
        height: height,
        width: width,
        radius: radius,
        showBorder: showBorder,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        isCircle: isCircle,
        padding: padding,

        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image(
            image: AssetImage(image),
            color: overlayColor,
            colorBlendMode: BlendMode.srcATop,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
