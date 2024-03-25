import 'package:easyroom/auth/Login.dart';
import 'package:easyroom/requests/register.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget{
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController lastnameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController contactController= TextEditingController();
    return Scaffold(
        body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Form(
                      key: formKey,
                      child: Container(
                        padding: const EdgeInsets.all(20),
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
                                child:const Center(  child: Text("Bienvenue",style: TextStyle(
                                  fontSize: 30,
                                ),),
                                )
                            ),
                            const SizedBox(height: 20),

                                TextFormField(
                                  controller: nameController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: 'Nom',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue)
                                    ),

                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Le nom est requis';
                                    }
                                    return null;
                                  },
                                ),
                            const SizedBox(height: 20),
                                TextFormField(
                                  controller: lastnameController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: 'Prenom',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.teal)
                                    ),

                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Le prenom est requis';
                                    }
                                    return null;
                                  },
                                ),

                            const SizedBox(height: 20),
                            TextFormField(
                              controller: contactController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                hintText: 'Entrer votre numero de téléphone',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Numéro est requis';
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
                                hintText: 'Créer un mot de passe',
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
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              obscuringCharacter: "*",
                              decoration: const InputDecoration(
                                hintText: 'Repéter le mot de passe',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal)
                                ),

                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty || value != passwordController.text) {
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
                                    register(context, nameController, contactController, passwordController, lastnameController);
                                  }else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Veuillez remplir les champs"))
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),


                                ),

                                child: const Text('Créer un compte',style: TextStyle(color: Colors.white),),
                              ),


                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Text("Avez-vous déjà un compte?"),
                                TextButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder:(context)=>const LoginPage()));
                                }, child: const Text("connectez-vous"))
                              ],
                            )
                          ],
                        ),
                      )
                  ),
                )
              ],
            )
        )
    );
  }

}