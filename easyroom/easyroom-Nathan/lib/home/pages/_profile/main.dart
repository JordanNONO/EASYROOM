
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:easyroom/Screens/Login/login_screen.dart';
import 'package:easyroom/home/pages/AddHousePage.dart';
import 'package:easyroom/home/pages/profileEdit.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/models/House.dart'; // Import du modèle House
import 'package:easyroom/requests/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();
class ProfileMain extends StatefulWidget {
  const ProfileMain({super.key}) ;

  @override
  State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  late List<House?> gethouses;

  Future<User?> _fetchUser() async {
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$BASE_URL/user/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final dynamic clientData = json.decode(response.body);
      final client = User.fromJson(clientData as Map<String, dynamic>);
      return client;
    } else {
      print('HTTP Error: ${response.statusCode}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
    return null;
  }

  Future<List<House>?> _fetchRecentHouses() async {
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$BASE_URL/house'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> houseDataList = json.decode(response.body);
      List<House> houses = houseDataList.map((data) => House.fromJson(data)).toList();

      gethouses = houses;

      return houses;
    } else {
      print('HTTP Error: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: Future.wait([_fetchUser(), _fetchRecentHouses()]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.blue));
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final user = snapshot.data![0] as User;
                final recentHouses = snapshot.data![1];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/default.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${user.lastname} ${user.name}",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ProfileEditPage();
                            },
                          ),
                        );
                      },
                      child: const Text('Edit Profile'),
                    ),
                    const SizedBox(height: 20),
                    if (user.renHouse != null)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const AddHousePage();
                              },
                            ),
                          );
                        },
                        child: const Text('Ajouter une maison'),
                      ),
                    const SizedBox(height: 20),
                    const ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Email'),
                      subtitle: Text('johndoe@example.com'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Contact'),
                      subtitle: Text(user.contact),
                    ),
                    const SizedBox(height: 20),
                    // Statistiques de l'utilisateur
                    const Text(
                      'Statistiques',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Nombre de maisons publiées: ${gethouses!.length}', // Remplacer par la vraie statistique
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    // Dernières maisons publiées
                    const Text(
                      'Dernières maisons publiées',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: recentHouses.length,
                      itemBuilder: (context, index) {
                        final house = recentHouses[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage('${BASE_URL}/${house.images.first.image}'),
                          ),
                          title: Text(house.label),
                          subtitle: Text(house.location),
                        );
                      },
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              }
            } else if (snapshot.connectionState == ConnectionState.none) {
              return const Center(
                child: Image(image: AssetImage("images/warning.png")),
              );
            }
            return const Center(
              child: Image(image: AssetImage("images/warning.png")),
            );
          },
        ),
      ),
    );
  }
}
