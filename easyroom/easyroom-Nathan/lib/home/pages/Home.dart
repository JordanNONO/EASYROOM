import 'dart:convert';

import 'package:easyroom/Screens/Login/login_screen.dart';
import 'package:easyroom/home/pages/HouseDetail.dart';
import 'package:easyroom/models/House.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

class MainHomePage extends StatefulWidget {
  final User? user;
  const MainHomePage({super.key, this.user});

  @override
  State<StatefulWidget> createState() => _MainHomePage();
}

class _MainHomePage extends State<MainHomePage> {
  //late User user; // Define a single User object
  late List<House?> searchHouse=[];
  final List<House?> houses = [];
  Future<User?> _fetchUser() async {
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$BASE_URL/user/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    //print(response.statusCode);

    if (response.statusCode == 200) {
      final dynamic clientData = json.decode(response.body);
      final client = User.fromJson(clientData as Map<String, dynamic>);
      //print(clientData);
      return client;
    } else {
      // Handle HTTP error here
      print('HTTP Error: ${response.statusCode}');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
    }
    return null;
  }

  Future<List<House>?> _fetchHouse() async {
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$BASE_URL/house'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    //print(response.statusCode);

    if (response.statusCode == 200) {
      final List<dynamic> houseDataList = json.decode(response.body);
      final List<House> houses =
          houseDataList.map((houseData) => House.fromJson(houseData)).toList();
      //print(houses);

      return houses;
    } else {
      // Handle HTTP error here
      print('HTTP Error: ${response.statusCode}');
    }
    return null;
  }

  void _searchHouse(query) async {
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$BASE_URL/house/search?q=$query'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    //print(response.statusCode);

    if (response.statusCode == 200) {
      final List<dynamic> houseDataList = json.decode(response.body);
      final List<House> houses =
      houseDataList.map((houseData) => House.fromJson(houseData)).toList();
      //print(houses);
      setState(() {
        searchHouse = houses;
      });

    } else {
      // Handle HTTP error here
      print('HTTP Error: ${response.statusCode}');
    }

  }
  /*void _searchHouse(String query) {

    searchHouse = houses.where((house) => house!.label.contains(query)).toList();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                  future: _fetchUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const SnackBar(
                          content: Text("Une erreur s'est produite"));
                    } else if (snapshot.hasData) {
                      User user = snapshot.data!;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("${user.name} ${user.lastname}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 25)),
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/images/default.png'),
                          ),
                        ],
                      );
                    }

                    return const Text("No data");
                  }),
              const SizedBox(
                height: 35,
              ),
              SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    hintText: "Dis-moi, quelle maison tu veux...",
                    controller: controller,
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (value) {
                      print(controller.value);
                      if (value.isNotEmpty) {
                        _searchHouse(value);
                      } else {
                        searchHouse = []; // Réinitialisez searchHouse si le champ de recherche est vide
                      }
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                  );
                },
                suggestionsBuilder: (BuildContext context, SearchController controller) {
                  return  searchHouse.map((house) {
                    return ListTile(
                      title: Text(house!.label),
                      onTap: () {
                        setState(() {
                          controller.closeView(house.label);
                        });
                      },
                    );
                  }).toList();
                },
              ),

              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Recommander pour vous",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.blue),
                  ),
                  Text(
                    "Voir plus",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: FutureBuilder(future: _fetchHouse(), builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(color: Colors.blue,));
                    }else if(snapshot.connectionState ==ConnectionState.done){
                      if(snapshot.hasError){
                        return const SnackBar(content: Text("Une erreur s'est produite"));
                      }else if(snapshot.hasData){
                       final house = snapshot.data!;

                        return ListView.builder(
                            itemCount: house.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(house[index].label),
                                leading: Image.network(
                                  house[index].images.first.image,
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
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return  HomeRentDetailPage(house:house[index],user: widget.user,);
                                  },));
                                },
                                subtitle: Text(
                                  house[index].description,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: Text(
                                  "${house[index].price} F/mois",
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                              );
                            });
                      }
                    }
                    return const Center(
                      child: Image(image: AssetImage("assets/images/warning.png")),
                    ) ;
                  })
              )
            ],
          ),
        ),
      ),
    );
  }
}
