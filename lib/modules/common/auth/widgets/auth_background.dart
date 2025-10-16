import 'package:flutter/widgets.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -60,
          child: BubbleEffect(height: 180, width: 180),
        ),
        Positioned(
          top: 120,
          left: 0,
          child: BubbleEffect(height: 80, width: 80),
        ),
        Positioned(
          top: 100,
          left: 80,
          child: BubbleEffect(height: 60, width: 60),
        ),
        Positioned(
          top: 165,
          left: 85,
          child: BubbleEffect(height: 40, width: 40),
        ),

        Positioned(
          bottom: -40,
          left: -60,
          child: BubbleEffect(height: 200, width: 200),
        ),
        Positioned(
          bottom: 150,
          left: -5,
          child: BubbleEffect(height: 135, width: 135),
        ),

        Positioned(
          bottom: 0,
          right: 10,
          child: BubbleEffect(height: 80, width: 80),
        ),
        Positioned(
          bottom: 65,
          right: -45,
          child: BubbleEffect(height: 160, width: 160),
        ),

        Positioned(
          bottom: 360,
          right: -40,
          child: BubbleEffect(height: 150, width: 150),
        ),
        Positioned(
          bottom: 500,
          right: 25,
          child: BubbleEffect(height: 60, width: 60),
        ),
      ],
    );
  }
}

class BubbleEffect extends StatelessWidget {
  const BubbleEffect({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.1,
      child: Image(
        image: AssetImage("assets/decoration/bubble.png"),
        height: height,
        width: width,
      ),
    );
  }
}
