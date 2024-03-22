import 'package:easyroom/next_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main(){
  runApp(
    MaterialApp(
      home: MyApp(),
    )
  );
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int index = 1;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
           body: Container(
             margin: EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     Text("Jordan NONO", style: TextStyle(
                       fontSize: 18.0,
                       fontWeight: FontWeight.bold,
                       color: Colors.black,

                     ),),
                     Container(
                       width: 50.0,
                       height: 50.0,
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                        color: Colors.blue,
                        image: DecorationImage(image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2-6LFf4RA6G-oVz-3vYd9clN_jfnG1Ir0hEiAnm2gMg&s"), fit: BoxFit.cover)
                       ),
                     ),
                   ],
                 ),
                 SizedBox(
                   height: 20.0,
                 ),
                 Text("Discover", style: TextStyle(
                   color: Colors.black,
                   fontWeight: FontWeight.bold,
                   fontSize: 30.0,
                 ),),
                 SizedBox(
                   height: 10.0,
                 ),
                 Text("Suitable Home", style: TextStyle(
                   color: Colors.black,
                   fontSize: 30.0,

                 ),),
                 SizedBox(
                   height: 20.0,
                 ),

                 Row(
                   children: <Widget>[
                     Expanded(
                       child: Container(
                         decoration: BoxDecoration(
                           color: Colors.blue.withOpacity(.5),
                           borderRadius: BorderRadius.only(
                             topLeft: Radius.circular(30.0),
                             bottomLeft: Radius.circular(30.0),
                             bottomRight: Radius.circular(30.0),

                           )
                         ),
                         child: TextField(
                           decoration: InputDecoration(
                             prefixIcon: Icon(Icons.search),
                             hintText: "Find a good home",
                             border: InputBorder.none,
                           ),
                         ),
                       ),
                     ),
                     SizedBox(
                       width: 20.0,
                     ),
                       Stack(
                       children: <Widget>[
                     Icon(Icons.notifications_none),
                     Positioned(
                       top: 1,
                       right: 1,


                       child: Container(
                         padding: EdgeInsets.all(2.0),
                         child: Text("2", style: TextStyle(
                           color: Colors.white,
                           fontSize: 10.0
                         ),),
                         decoration: BoxDecoration(
                           color: Colors.orange,
                           shape: BoxShape.circle,
                         ),
                       ),
                     )
                   ],
                 )
               ],
             ),
                 SizedBox(height: 20.0,),
                 Container(
                   height: 400.0,
                   child: ListView(
                     scrollDirection: Axis.horizontal,
                     children: <Widget>[
                       homeWidget(),
                       homeWidget(),
                       homeWidget(),
                       homeWidget(),
                     ],
                   ),
                 )
                ],
             ),
           ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            index == 1? _selectedWidget(Icon(Icons.home), "Home"): IconButton(icon:Icon(Icons.home), onPressed: (){
              setState(() {
                index = 1;
              });
            },),
            index == 2? _selectedWidget(Icon(Icons.bookmark_border), "Bookmaker") : IconButton(icon: Icon(Icons.bookmark_border),onPressed: (){
              setState(() {
                index = 2;
              });
            },),

            index == 3? _selectedWidget(Icon(Icons.message), "Messages") : IconButton(icon: Icon(Icons.message),onPressed: (){
              setState(() {
                index = 3;
              });
            },),

            index == 4? _selectedWidget(Icon(Icons.person_outline), "Profile") : IconButton(icon: Icon(Icons.person_outline),onPressed: (){
              setState(() {
                index = 4;
              });
            },),

          ],
        ),
      ),
    );
  }
  Widget homeWidget(){
    return InkWell(
      onTap: (){
       Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
         return NextPage();
       }));
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        width: 250.0,
        height: 400.0,
        child: Stack(
          children: <Widget>[
            Hero(
              tag: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2-6LFf4RA6G-oVz-3vYd9clN_jfnG1Ir0hEiAnm2gMg&s",
              child: Container(
              
                width: 350.0,
                height: 400.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                    image: DecorationImage(
                        image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2-6LFf4RA6G-oVz-3vYd9clN_jfnG1Ir0hEiAnm2gMg&s"),
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
                child: Icon(Icons.chevron_right, color: Colors.white,), onPressed: (){

              },
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Family House", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on, color: Colors.white,),
                      Text("Yangor, Shwe Taung kyar", style: TextStyle(
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
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
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
