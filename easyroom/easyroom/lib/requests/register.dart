import 'package:easyroom/Screens/Login/login_screen.dart';
import 'package:easyroom/requests/ApiService.dart';
import 'package:flutter/material.dart';

Future<void> register(BuildContext context,nameController,contactController,passwordController,lastNameController) async {
  final contact = contactController.text;
  final name = nameController.text;
  final lastname = lastNameController.text;
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
    success = await ApiService.registerRequest(contact, name, lastname, password);
  } finally {
    if (context.mounted) Navigator.pop(context);
  }

  if (!context.mounted) return;

  if (success) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(), // Replace MainPage with the destination page.
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Une erreur s'est produite..."),
      ),
    );
  }
}