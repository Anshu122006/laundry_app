import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.message,
    required this.count,
    this.backgroundColor,
    this.textColor,
  });
  final String message;
  final int count;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            softWrap: true,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: textColor,
              fontWeight: FontWeight.w400,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            count.toString(),
            softWrap: true,
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(color: textColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
