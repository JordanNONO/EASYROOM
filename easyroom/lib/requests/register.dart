import 'package:easyroom/auth/Login.dart';
import 'package:easyroom/requests/requests.dart';
import 'package:flutter/material.dart';

Future<void> register(
  BuildContext context,
  TextEditingController nameController,
  TextEditingController contactController,
  TextEditingController passwordController,
  TextEditingController lastNameController,
) async {
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
        child: CircularProgressIndicator(color: Colors.teal,), // Display the CircularProgressIndicator
      );
    },
  );

  final success = await registerRequest(contact, name, lastname, password);

  if (!context.mounted) return;
  Navigator.pop(context);

  if (success) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
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