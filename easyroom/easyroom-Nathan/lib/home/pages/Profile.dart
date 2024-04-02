import 'dart:convert';

import 'package:easyroom/Screens/Login/login_screen.dart';
import 'package:easyroom/constants.dart';
import 'package:easyroom/home/pages/AddHousePage.dart';
import 'package:easyroom/home/pages/_profile/MyHouseList.dart';
import 'package:easyroom/home/pages/_profile/ReservationList.dart';
import 'package:easyroom/home/pages/_profile/main.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
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
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              foregroundColor: Colors.white,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.person),
                    text: "Profile",
                  ),
                  Tab(
                    icon: Icon(Icons.task),
                    text: "Rendez-vous",
                  ),
                  Tab(
                    icon: Icon(Icons.add_home_work_outlined),
                    text: "Ajouter une maison",
                  ),
                  Tab(
                    icon: Icon(Icons.home_outlined),
                    text: "Mes maisons",
                  )
                ],
                indicatorColor: Colors.blue,
                labelColor: Colors.blue,
                isScrollable: true,
              ),
            ),
            body: FutureBuilder(
              future: _fetchUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  const Center(
                      child: CircularProgressIndicator(
                    color: Colors.blue,
                  ));
                } else if (snapshot.hasError) {
                  const Center(
                    child:
                        Image(image: AssetImage("assets/images/warning.png")),
                  );
                } else if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return TabBarView(
                    children: [
                      const ProfileMain(),
                      const ReservationList(),
                      const AddHousePage(),
                      MyHouseListPage(user:user),
                    ],
                  );
                }
                return const Center(
                  child: Image(image: AssetImage("assets/images/warning.png")),
                );
              },
            )),
      ),
    );
  }
}
