import 'dart:convert';

import 'package:easyroom/home/pages/HouseDetail.dart';
import 'package:easyroom/models/User.dart';
import 'package:flutter/material.dart';
import 'package:easyroom/models/House.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();
class MyHouseListPage extends StatefulWidget{
  const MyHouseListPage( {super.key, required this.user});
  final User user;

  @override
  State<StatefulWidget> createState() => _MyHouseListPage();

}

class _MyHouseListPage extends State<MyHouseListPage>{
  Future<List<House>?> _fetchHouse() async {
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$BASE_URL/house/me'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _fetchHouse(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ));
            } else if (snapshot.connectionState ==
                ConnectionState.done) {
              if (snapshot.hasError) {
                return const SnackBar(
                    content: Text("Une erreur s'est produite"));
              } else if (snapshot.hasData) {
                final house = snapshot.data!;
                return ListView.builder(
                    itemCount: house.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(house[index].label),
                        leading: Image.network(
                            "${API_URL}/${house[index].images.first.image}"),
                        subtitle: Text(
                          house[index].description,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return HomeRentDetailPage(
                                  user: widget.user,
                                  house: house[index]);
                            },
                          ));
                        },
                        trailing: Text(
                          "${house[index].price} F/mois",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700),
                        ),
                      );
                    });
              }
            }
            return const Center(
              child: Image(image: AssetImage("assets/images/warning.png")),
            );
          }),
    );
  }
}