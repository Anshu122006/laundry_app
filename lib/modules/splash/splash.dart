import 'package:flutter/material.dart';
import 'package:laundary_app/modules/splash/checker.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onSplash();
    });
  }

  Future<void> _onSplash() async {
    await Checker.handleUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(image: AssetImage("assets/icons/app_icon.png")),
      ),
    );
  }
}
