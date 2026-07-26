import 'package:easyroom/Screens/Login/login_screen.dart';
import 'package:easyroom/constants.dart';
import 'package:easyroom/home/pages/AddHousePage.dart';
import 'package:easyroom/home/pages/_profile/MyHouseList.dart';
import 'package:easyroom/home/pages/_profile/ReservationList.dart';
import 'package:easyroom/home/pages/_profile/main.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/requests/ApiService.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late final Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUser();
  }

  Future<User?> _fetchUser() async {
    final user = await ApiService.fetchCurrentUser();
    if (user == null && mounted) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
              indicatorColor: kAccentColor,
              labelColor: kAccentColor,
              isScrollable: true,
            ),
          ),
          body: FutureBuilder(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                      color: kAccentColor,
                    ));
              } else if (snapshot.hasData) {
                final user = snapshot.data!;
                return TabBarView(
                  children: [
                    const ProfileMain(),
                    ReservationList(user: user,),
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
    );
  }
}