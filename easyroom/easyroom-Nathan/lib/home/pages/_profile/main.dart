import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:easyroom/Screens/Login/login_screen.dart';
import 'package:easyroom/home/pages/profileEdit.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/models/House.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

class ProfileMain extends StatefulWidget {
  const ProfileMain({Key? key});

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
      Uri.parse('$BASE_URL/house/me'),
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
      appBar: AppBar(
        title: const Text('Mon Profil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/default.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${user.lastname} ${user.name}",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProfileEditPage(userData: user);
                            },
                          ),
                        );
                      },
                      child: const Text('Modifier le Profil'),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(user.lastname),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Contact'),
                      subtitle: Text(user.contact),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Statistiques',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Nombre de maisons publiées: ${gethouses!.length}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Dernières maisons publiées',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (recentHouses != null && recentHouses.isNotEmpty)
                      Column(
                        children: recentHouses.map<Widget>((house) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage('${BASE_URL}/${house.images.first.image}'),
                            ),
                            title: Text(house.label),
                            subtitle: Text(house.location),
                          );
                        }).toList(),
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
