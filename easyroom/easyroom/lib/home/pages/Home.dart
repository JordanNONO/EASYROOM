import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyroom/constants.dart';
import 'package:easyroom/home/pages/CrousResidences.dart';
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
  late List<House?> searchHouse=[];
  final List<House?> houses = [];
  late final Future<List<House>?> _houseFuture;

  @override
  void initState() {
    super.initState();
    _houseFuture = _fetchHouse();
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
              if (widget.user != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${widget.user!.name} ${widget.user!.lastname}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 25)),
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage('assets/images/default.png'),
                    ),
                  ],
                )
              else
                const Text("No data"),
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
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const CrousResidencesPage();
                  }));
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: kAccentLightColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Voir les résidences CROUS à Limoges →",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: kAccentColor),
                      ),
                    ],
                  ),
                ),
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
                        color: kAccentColor),
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
                  child: FutureBuilder(future: _houseFuture, builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(color: kAccentColor,));
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
                                leading: CachedNetworkImage(
                                  imageUrl: house[index].images.first.image,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  ),
                                  errorWidget: (context, url, error) => Image.asset(
                                    'assets/images/warning.png',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return  HomeRentDetailPage(house:house[index],user: widget.user,);
                                  },));
                                },
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      house[index].description,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    if (house[index].nearestStopDistanceMeters != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.directions_bus, size: 14, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                "À ${(house[index].nearestStopDistanceMeters! / 1000).toStringAsFixed(1)} km de ${house[index].nearestStopName}",
                                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
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
