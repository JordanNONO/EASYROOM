import 'package:easyroom/main.dart';
import 'package:easyroom/requests/requests.dart';
import 'package:flutter/material.dart';

Future<void> login(
  BuildContext context,
  TextEditingController contactController,
  TextEditingController passwordController,
) async {
  final username = contactController.text;
  final password = passwordController.text;

  // Show the progress indicator while performing the login operation.
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber,), // Display the CircularProgressIndicator
      );
    },
  );

  final success = await LoginRequest(username, password);

  if (!context.mounted) return;
  Navigator.pop(context);

  if (success) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyApp(),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Informations incorrects..."),
      ),
    );
  }
}