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

  //print("$contact,$email,$password");
  final user = await ApiService.registerRequest(contact, name,lastname, password);

  // Dismiss the progress indicator dialog
  print(user);
  if (user !=false ) {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(), // Replace MainPage with the destination page.
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