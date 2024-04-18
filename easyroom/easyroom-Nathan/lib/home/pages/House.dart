import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:easyroom/home/pages/HouseDetail.dart';
import 'package:easyroom/models/House.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/requests/constant.dart';

const storage = FlutterSecureStorage();

class HousePage extends StatefulWidget {
  final User? user;
  const HousePage({super.key, this.user});

  @override
  State<StatefulWidget> createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  Future<List<House>?> _fetchHouse() async {
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$BASE_URL/house'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> houseDataList = json.decode(response.body);
      final List<House> houses =
      houseDataList.map((houseData) => House.fromJson(houseData)).toList();
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
        automaticallyImplyLeading: false,
        title: const Text('Maisons'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher une maison...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _fetchHouse(),
                builder: (context, AsyncSnapshot<List<House>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Une erreur s'est produite: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final houseList = snapshot.data!;
                    return ListView.builder(
                      itemCount: houseList.length,
                      itemBuilder: (context, index) {
                        final house = houseList[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(house.label),
                            leading:Image.network(
                              house.images.first.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/warning.png', // Image de remplacement
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                            subtitle: Text(
                              house.description,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeRentDetailPage(
                                    house: house,
                                    user: widget.user,
                                  ),
                                ),
                              );
                            },
                            trailing: Text(
                              "${house.price} F/mois",
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("Aucune donnée disponible"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
