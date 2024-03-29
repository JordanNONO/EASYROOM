import 'dart:convert';

import 'package:easyroom/Screens/Login/login_screen.dart';
import 'package:easyroom/home/pages/AddHousePage.dart';
import 'package:easyroom/home/pages/profileEdit.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();
class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePage();

}

class _ProfilePage extends State<ProfilePage>{

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(future: _fetchUser(), builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: Colors.blue,),);
          }
          else if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              final user = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/default.png'),
                  ),
                  const SizedBox(height: 10),
                   Text(
                    "${user.lastname} ${user.name}",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const ProfileEditPage();
                          },
                        ),
                      );
                    },
                    child: const Text('Edit Profile'),
                  ),
                  const SizedBox(height: 20),
                  if(user.renHouse != null ) ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const AddHousePage();
                          },
                        ),
                      );
                    },
                    child: const Text('Ajouter une maison'),
                  ),
                  const SizedBox(height: 20),
                  const ListTile(
                    leading: Icon(Icons.email),
                    title: Text('Email'),
                    subtitle: Text('johndoe@example.com'),
                  ),
                   ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Contact'),
                    subtitle: Text(user.contact),
                  ),
                  const SizedBox(height: 20),
                  /*Text(
              'Posts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text((index + 1).toString()),
                  ),
                  title: Text('Post ${index + 1}'),
                  subtitle: Text('This is post number ${index + 1}'),
                );
              },
            ),*/
                ],
              );
            }else if(snapshot.hasError){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));

            }
          }
          else if(snapshot.connectionState ==ConnectionState.none){
            return const Center(
              child: Image(image: AssetImage("images/warning.png")),
            ) ;
          }
          return const Center(
            child: Image(image: AssetImage("images/warning.png")),
          ) ;
        })
      ),
    );
  }
}