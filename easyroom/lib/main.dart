import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:easyroom/models/House.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:http/http.dart' as http;
import 'package:easyroom/auth/Login.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/next_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();
void main(){
  runApp(
     MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const LoginPage(),
    )
  );
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late User user;// Define a single User object

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
      final List<House> houses = houseDataList.map((houseData) => House.fromJson(houseData)).toList();
      print(houses);
      return houses;
    } else {
      // Handle HTTP error here
      print('HTTP Error: ${response.statusCode}');
    }
    return null;
  }


  @override
  void initState() {
    super.initState();


  }

  int index = 1;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
           body: Container(
             margin: const EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
             child: SingleChildScrollView(child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 FutureBuilder(future: _fetchUser(), builder: (context,snapshot) {
                   User user = snapshot.data!;

                  return Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       Text("${user.name} ${user.lastname}", style: const TextStyle(
                         fontSize: 18.0,
                         fontWeight: FontWeight.bold,
                         color: Colors.black,

                       ),),
                       Container(
                         width: 50.0,
                         height: 50.0,
                         decoration: const BoxDecoration(
                             shape: BoxShape.circle,
                             color: Colors.blue,
                             image: DecorationImage(image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2-6LFf4RA6G-oVz-3vYd9clN_jfnG1Ir0hEiAnm2gMg&s"), fit: BoxFit.cover)
                         ),
                       ),
                     ],
                   );
                 }),
                 const SizedBox(
                   height: 20.0,
                 ),
                 const Text("Discover", style: TextStyle(
                   color: Colors.black,
                   fontWeight: FontWeight.bold,
                   fontSize: 30.0,
                 ),),
                 const SizedBox(
                   height: 10.0,
                 ),
                 const Text("Suitable Home", style: TextStyle(
                   color: Colors.black,
                   fontSize: 30.0,

                 ),),
                 const SizedBox(
                   height: 20.0,
                 ),

                 Row(
                   children: <Widget>[
                     Expanded(
                       child: Container(
                         decoration: BoxDecoration(
                             color: Colors.blue.withOpacity(.5),
                             borderRadius: const BorderRadius.only(
                               topLeft: Radius.circular(30.0),
                               bottomLeft: Radius.circular(30.0),
                               bottomRight: Radius.circular(30.0),

                             )
                         ),
                         child: const TextField(
                           decoration: InputDecoration(
                             prefixIcon: Icon(Icons.search),
                             hintText: "Find a good home",
                             border: InputBorder.none,
                           ),
                         ),
                       ),
                     ),
                     const SizedBox(
                       width: 20.0,
                     ),
                     Stack(
                       children: <Widget>[
                         const Icon(Icons.notifications_none),
                         Positioned(
                           top: 1,
                           right: 1,


                           child: Container(
                             padding: const EdgeInsets.all(2.0),
                             decoration: const BoxDecoration(
                               color: Colors.orange,
                               shape: BoxShape.circle,
                             ),
                             child: const Text("2", style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 10.0
                             ),),
                           ),
                         )
                       ],
                     )
                   ],
                 ),
                 const SizedBox(height: 20.0,),
                 SizedBox(
                   height: 400.0,
                   child:

                       FutureBuilder(future: _fetchHouse(), builder: (context,snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Erreur : ${snapshot
                              .error}'));
                        }else
                         if(snapshot.hasData){
                           return ListView.builder(itemCount: snapshot.data!.length, scrollDirection: Axis.horizontal,  itemBuilder: (context,index){
                             return homeWidget(snapshot.data![index]);

                           });
                         }
                         return const Text("No data");
                       })



                 )
               ],
             ),)
           ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            index == 1? _selectedWidget(const Icon(Icons.home), "Home"): IconButton(icon:const Icon(Icons.home), onPressed: (){
              setState(() {
                index = 1;
              });
            },),
            index == 2? _selectedWidget(const Icon(Icons.bookmark_border), "Bookmaker") : IconButton(icon: const Icon(Icons.bookmark_border),onPressed: (){
              setState(() {
                index = 2;
              });
            },),

            index == 3? _selectedWidget(const Icon(Icons.message), "Messages") : IconButton(icon: const Icon(Icons.message),onPressed: (){
              setState(() {
                index = 3;
              });
            },),

            index == 4? _selectedWidget(const Icon(Icons.person_outline), "Profile") : IconButton(icon: const Icon(Icons.person_outline),onPressed: (){
              setState(() {
                index = 4;
              });
            },),

          ],
        ),
      ),
    );
  }
  Widget homeWidget(House house){
    return InkWell(
      onTap: (){
       Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
         return NextPage( house: house,);
       }));
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: 250.0,
        height: 400.0,
        child: Stack(
          children: <Widget>[
            Hero(
              tag: "$API_URL/${house.images.first.image}",
              child: Container(

                width: 350.0,
                height: 400.0,
                decoration: BoxDecoration(

                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                    image: DecorationImage(
                        image: NetworkImage("$API_URL/${house.images.first.image}"),
                        fit: BoxFit.cover
                    )
                ),
              ),
            ),
            Positioned(
              bottom: 1,
              right: 15.0,
              child: FloatingActionButton(
                heroTag: null,
                mini: true,
                backgroundColor: Colors.orange,
                child: const Icon(Icons.chevron_right, color: Colors.white,), onPressed: (){

              },
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              child:  Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(house.label, style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.location_on, color: Colors.white,),
                        Text(house.location, style: const TextStyle(
                            color: Colors.white
                        ),)
                      ],
                    )
                  ],
                ),
              )

          ],
        ),
      ),
    );
  }


  Widget _selectedWidget(Icon icon, String str){
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
        color: Colors.purple.withOpacity(.4),
      ),
      child: Row(
        children: <Widget>[
          icon,
          Text(str),
        ],
      ),
    );
  }
}
