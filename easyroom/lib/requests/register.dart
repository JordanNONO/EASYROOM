import 'package:easyroom/auth/Login.dart';
import 'package:easyroom/requests/requests.dart';
import 'package:flutter/material.dart';

Future<void> register(BuildContext context,nameController,contactController,passwordController,lastNameController) async {
  final contact = contactController.text;
  final name = nameController.text;
  final lastname = lastNameController;
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

  //print("$contact,$email,$password");
  final user = await registerRequest(contact, name,lastname, password);

  // Dismiss the progress indicator dialog
  print(user);
  if (user !=false ) {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(), // Replace MainPage with the destination page.
      ),
    );

  } else {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Une erreur s'est produite..."),
      ),
    );
  }
}