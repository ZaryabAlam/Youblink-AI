import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:youblink/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    final fadeTween = Tween<double>(begin: 0, end: 1);
    final shimmerTween = Tween<double>(begin: 1, end: 0);
    final fadeSequence = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: fadeTween,
          weight: 70,
        ),
        TweenSequenceItem<double>(
          tween: shimmerTween,
          weight: 30,
        ),
      ],
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => const HomeScreen());
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 230),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _controller.value, // Apply the fade-in effect
                  child: Transform.scale(
                    scale: 1 +
                        (_controller.value * 0.2), // Apply the shimmer effect
                    child: child,
                  ),
                );
              },
              child: Container(
                height: 180,
                width: 180,
                child: const Image(
                  image: AssetImage("assets/logo_full.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Spacer(),
            const Text("Developed by Zaryab Alam",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87)),
            const Text("Developed for Hashone Digital",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87)),
            const Text("© 2023 Copyright, All rights reserved",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                    color: Colors.black87)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
