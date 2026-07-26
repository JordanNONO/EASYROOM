import 'package:easyroom/home/index.dart';
import 'package:easyroom/requests/ApiService.dart';
import 'package:flutter/material.dart';

Future<void> login(BuildContext context,emailController,passwordController) async {
  final username = emailController.text;
  final password = passwordController.text;

  // Show the progress indicator while performing the login operation.
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blue,), // Display the CircularProgressIndicator
      );
    },
  );

  bool success = false;
  try {
    success = await ApiService.LoginRequest(username, password);
  } finally {
    if (context.mounted) Navigator.pop(context);
  }

  if (!context.mounted) return;

  if (success) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(), // Replace MainPage with the destination page.
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