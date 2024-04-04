import 'dart:convert';

import 'package:easyroom/Screens/Login/login_screen.dart';
import 'package:easyroom/home/pages/Home.dart';
import 'package:easyroom/home/pages/House.dart';
import 'package:easyroom/home/pages/Profile.dart';
import 'package:easyroom/home/pages/Reservation.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();
class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePage();

}

class _HomePage extends State<HomePage>{
    int currentPageIndex = 0;
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
    @override
     Widget build(BuildContext context) {
      final ThemeData theme = Theme.of(context);
      return Scaffold(

        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.blue,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Acceuil',
            ),
            NavigationDestination(
              icon: Badge(child: Icon(Icons.house_siding_rounded)),
              label: 'Maisons',
            ),
            NavigationDestination(
              icon: Badge(

                child: Icon(Icons.class_rounded),
              ),
              label: 'Reservations',
            ),
            NavigationDestination(
              icon: Badge(

                child: Icon(Icons.person),
              ),
              label: 'Profile',
            ),
          ],
        ),
        body: FutureBuilder(future: _fetchUser(), builder: (builder,snapshot){
          if(snapshot.connectionState ==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: Colors.blue,),);
          }else if(snapshot.hasData){
            final user = snapshot.data!;
            return <Widget>[
              MainHomePage(user: user,),
              HousePage(user:user),
              ReservationPage(user:user),
              const ProfilePage()

            ][currentPageIndex];
          }
          return const Center(
            child: Image(image: AssetImage("images/warning.png")),
          );
        })
      );
    }

}