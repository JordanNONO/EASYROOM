import 'package:easyroom/auth/Register.dart';
import 'package:easyroom/requests/login.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget{
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController contactController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
        body: SafeArea(
          child: Form(
              key: formKey,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 50),
                          const Center(
                            child: Text("EASYROOM",style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700
                            ),),
                          ),
                          const SizedBox(height: 50),
                          Container(
                              padding: const EdgeInsets.all(5),
                              child:const Center(  child: Text("Veuillez vous connecter",style: TextStyle(
                                fontSize: 30,
                              ),),
                              )
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: contactController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              fillColor: Colors.teal,
                              hintText: 'Votre contact',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)
                              ),

                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Le contact est requis';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            obscuringCharacter: "*",
                            decoration: const InputDecoration(
                              hintText: 'Votre mot de passe',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal)
                              ),

                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Un code secret est requis';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Add your login logic here
                                // Typically, you would validate user input and authenticate the user.
                                if(formKey.currentState!.validate()){
                                  login(context, contactController, passwordController);
                                }else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Veuillez remplir les champs",))
                                  );
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue.shade700),
                                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),

                              ),

                              child: const Text('Se connecter',style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text("Vous n'avez pas de compte"),
                              TextButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder:(context)=> const RegisterPage()));
                              }, child: Text("Créer un compte"))
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
          ),
        )
    );
  }

}