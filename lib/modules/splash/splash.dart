import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundary_app/modules/splash/checker.dart';
import 'package:laundary_app/modules/splash/no_internet.dart';

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
    bool connected = await Checker.hasInternetConncted();
    if (connected) {
      await Checker.handleUser();
    } else {
      Get.to(() => NoInternetScreen());
    }
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
