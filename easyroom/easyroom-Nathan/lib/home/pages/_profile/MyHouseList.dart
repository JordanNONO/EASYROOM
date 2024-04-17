import 'dart:convert';
import 'package:easyroom/home/pages/HouseDetail.dart';
import 'package:easyroom/models/User.dart';
import 'package:flutter/material.dart';
import 'package:easyroom/models/House.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

class MyHouseListPage extends StatefulWidget {
  const MyHouseListPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() => _MyHouseListPage();
}

class _MyHouseListPage extends State<MyHouseListPage> {
  Future<List<House>?> _fetchHouse() async {
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$BASE_URL/house/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> houseDataList = json.decode(response.body);
      final List<House> houses = houseDataList.map((houseData) => House.fromJson(houseData)).toList();
      return houses;
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Maisons'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _fetchHouse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Une erreur s'est produite"),
            );
          } else if (snapshot.hasData) {
            final List<House> houses = snapshot.data as List<House>;
            return ListView.builder(
              itemCount: houses.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeRentDetailPage(user: widget.user, house: houses[index]),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  houses[index].label,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${houses[index].price} F/mois',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "${API_URL}/${houses[index].images.first.image}",
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
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.bedroom_parent_outlined, color: Colors.grey, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  '${houses[index].nbreBedroom} Chambres',
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.bathroom_outlined, color: Colors.grey, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  houses[index].hasBathroom ? "1 Salle de bain" : "Aucune Salle de bain",
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              houses[index].description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Image(image: AssetImage("assets/images/warning.png")),
            );
          }
        },
      ),
    );
  }
}
