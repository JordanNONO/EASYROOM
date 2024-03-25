import 'package:concentric_transition/page_view.dart';
import 'package:easyroom/Screens/Welcome/welcome_screen.dart';
import 'package:easyroom/home.dart';
import 'package:easyroom/widget/cardPlanet.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({Key? key}) : super(key: key);

  final data = [
    CardPlanetData(
      subtitle:
          "Votre nid étudiant, à portée de clic !",
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      subtitleColor: const Color.fromARGB(255, 34, 67, 124),
      background: LottieBuilder.asset("assets/Lottie/etudiant.json"),
    ),
    CardPlanetData(
      subtitle: "Préparez votre succès, réservez votre espace d'étude !",
      backgroundColor: Color.fromARGB(255, 250, 184, 184),
      subtitleColor: const Color.fromRGBO(0, 10, 56, 1),
      background: LottieBuilder.asset("assets/Lottie/diplome.json"),
    ),
    CardPlanetData(
      subtitle: "Un foyer loin de chez vous, là où les rêves prennent vie !",
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      subtitleColor: Colors.blueAccent,
      background: LottieBuilder.asset("assets/Lottie/building.json"),
    ),
  ];

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: ConcentricPageView(
      colors: data.map((e) => e.backgroundColor).toList(),
      itemCount: data.length,
      itemBuilder: (int index) { // Réglez la signature de la fonction itemBuilder
        return CardPlanet(data: data[index]);
      },
      onFinish: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      },
    ),
  );
}
}