import 'package:flutter/material.dart';

class CHeading extends StatelessWidget {
  const CHeading({
    super.key,
    required this.title,
    this.family,
    this.buttonText,
    this.onPressed,
    this.color,
  });

  final String title;
  final String? buttonText;
  final String? family;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall!.apply(
              color: color,
              fontFamily: family,
              letterSpacingFactor: 1.5,
            ),
          ),
          buttonText != null
              ? TextButton(
                onPressed: onPressed,
                child: Text(
                  buttonText!,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
              : SizedBox(),
        ],
      ),
    );
  }
}
