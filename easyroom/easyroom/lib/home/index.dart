import 'package:easyroom/Screens/Login/login_screen.dart';
import 'package:easyroom/constants.dart';
import 'package:easyroom/home/pages/Home.dart';
import 'package:easyroom/home/pages/House.dart';
import 'package:easyroom/home/pages/Profile.dart';
import 'package:easyroom/home/pages/Reservation.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/requests/ApiService.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePage();

}

class _HomePage extends State<HomePage>{
  int currentPageIndex = 0;
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUser();
  }

  Future<User?> _fetchUser() async {
    final user = await ApiService.fetchCurrentUser();
    if (user == null && mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
    }
    return user;
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
          indicatorColor: kAccentColor,
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
        body: FutureBuilder(future: _userFuture, builder: (builder,snapshot){
          if(snapshot.connectionState ==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: kAccentColor,),);
          }else if(snapshot.hasData){
            final user = snapshot.data!;
            return IndexedStack(
              index: currentPageIndex,
              children: <Widget>[
                MainHomePage(user: user,),
                HousePage(user:user),
                ReservationPage(user:user),
                const ProfilePage(),
              ],
            );
          }
          else{
            return const Center(
              child: Image(image: AssetImage("assets/images/warning.png")),
            );
          }
        })
    );
  }

}