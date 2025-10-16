import 'package:flutter/material.dart';

class SigninHeader extends StatelessWidget {
  const SigninHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            height: 120,
            width: 120,
            image: AssetImage("assets/logos/washing_machine.png"),
          ),
          SizedBox(height: 20),
          Text(
            "MAA LAUNDRY &\nDRY-CLEANERS",
            style: Theme.of(context).textTheme.headlineLarge,
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            "Sign in to continue",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
