// ignore: file_names
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:easyroom/onboardingscreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: LottieBuilder.asset("assets/Lottie/Room.json"),
            ),
          ),
          const SizedBox(height: 20), // Espacement entre l'image et le texte
          const Text(
            "EASYROOM",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
      nextScreen: OnboardingPage(),
      splashIconSize: 400,
      backgroundColor: const Color.fromARGB(255, 239, 244, 253),
    );
  }
}

