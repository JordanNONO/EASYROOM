import 'dart:convert';

import 'package:easyroom/home/pages/Home.dart';
import 'package:easyroom/home/pages/House.dart';
import 'package:easyroom/home/pages/Profile.dart';
import 'package:easyroom/home/pages/Reservation.dart';
import 'package:easyroom/models/House.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomePage();

}

class _HomePage extends State<HomePage>{

    int currentPageIndex = 0;


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
        body: <Widget>[
          const MainHomePage(),
          HousePage(),
          const ReservationPage(),
          ProfilePage()

        ][currentPageIndex],
      );
    }

}