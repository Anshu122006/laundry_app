import 'package:flutter/material.dart';
import 'dart:async';
import 'package:laundary_app/modules/splash/checker.dart';

class ReloadScreen extends StatelessWidget {
  const ReloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> turns = ValueNotifier(0);
    final ValueNotifier<bool> isBusy = ValueNotifier(false);

    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "OPPS!!!",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 3),
            Text(
              "Something went wrong please try again!",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Image(
              image: AssetImage("assets/illustrations/error.png"),
              height: 330,
            ),
            const SizedBox(height: 60),
            ReloadButton(turns: turns, isBusy: isBusy),
          ],
        ),
      ),
    );
  }
}

class ReloadButton extends StatelessWidget {
  const ReloadButton({super.key, required this.turns, required this.isBusy});
  final ValueNotifier<double> turns;
  final ValueNotifier<bool> isBusy;

  Future<void> _handleReload() async {
    if (isBusy.value) return;
    isBusy.value = true;
    turns.value -= 1;
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      bool connected = await Checker.hasInternet();
      if (connected) {
        await Checker.handleUser();
      }
    } catch (e) {
      //
    }
    isBusy.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isBusy,
      builder: (context, busy, _) {
        return GestureDetector(
          onTap: busy ? null : _handleReload,
          child: ValueListenableBuilder<double>(
            valueListenable: turns,
            builder: (context, value, _) {
              return AnimatedRotation(
                turns: value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Icon(Icons.replay_outlined, size: 50),
              );
            },
          ),
        );
      },
    );
  }
}
