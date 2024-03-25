import 'package:flutter/material.dart';

class CardPlanetData {
  final Color backgroundColor;
  final Color subtitleColor;
  final Widget? background;
  final String subtitle;

  CardPlanetData({
    required this.backgroundColor,
    required this.subtitleColor,
    required this.subtitle,
    this.background,
  });
}

class CardPlanet extends StatelessWidget {
  const CardPlanet({
    required this.data,
    Key? key,
  }) : super(key: key);

  final CardPlanetData data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (data.background != null) data.background!,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.subtitle.toUpperCase(),
                style: TextStyle(
                  color: data.subtitleColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
