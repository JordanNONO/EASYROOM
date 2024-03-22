import 'package:easyroom/main.dart';
import 'package:easyroom/requests/requests.dart';
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
        child: CircularProgressIndicator(color: Colors.teal,), // Display the CircularProgressIndicator
      );
    },
  );

  final user = await LoginRequest(username, password);

  // Dismiss the progress indicator dialog
  print(user);
  if (user !=false ) {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyApp(), // Replace MainPage with the destination page.
      ),
    );

  } else {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Informations incorrects..."),
      ),
    );
  }
}