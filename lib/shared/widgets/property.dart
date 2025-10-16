import 'package:flutter/widgets.dart';

class CProperty extends StatelessWidget {
  const CProperty({
    super.key,
    required this.name,
    required this.value,
    this.style,
    this.valueColor,
  });
  final String name;
  final String value;
  final TextStyle? style;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: "$name: ",
            style: style?.copyWith(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: value, style: style?.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}
