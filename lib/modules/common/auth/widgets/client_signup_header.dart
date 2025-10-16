import 'package:flutter/material.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: Offset(-18, 0),
            child: Image(
              image: AssetImage("assets/images/signup_image.png"),
              height: 300,
              width: 300,
              fit: BoxFit.contain,
            ),
          ),
          Transform.translate(
            offset: Offset(5, -20),
            child: Text(
              "Welcome to Maa Laundry",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Transform.translate(
            offset: Offset(5, -20),
            child: Text(
              "New here? Lets get your account ready!",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
