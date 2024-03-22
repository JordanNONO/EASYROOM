import 'package:flutter/material.dart';


class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    
    return  Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(height: screenHeight * 0.4,child: Hero(
          tag: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2-6LFf4RA6G-oVz-3vYd9clN_jfnG1Ir0hEiAnm2gMg&s",
          child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2-6LFf4RA6G-oVz-3vYd9clN_jfnG1Ir0hEiAnm2gMg&s", fit: BoxFit.cover)),),
          Container(
            margin: EdgeInsets.only(top: screenHeight * 0.3),
            child: SingleChildScrollView(child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(100.0),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 30.0, top: 30.0, right: 10.0, bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("20.000 Fcfa", style: TextStyle(
                            color: Colors.blue,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),),
                          Icon(Icons.bookmark_border, color: Colors.blue,)
                        ]

                    ),
                    const SizedBox(height: 20.0,),
                    const Text("Family Home", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),),
                    const SizedBox(height: 20.0,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: <Widget>[
                            Icon(Icons.spa, size: 15.0,),
                            Text("2"),
                            Icon(Icons.room_service, size: 15.0),
                            Text("3"),
                            Icon(Icons.home, size: 15.0),
                            Text("2"),
                          ],
                        ),
                        Text("12,000 sq.ft"),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    const Divider(),
                    const SizedBox(height: 10.0,),
                    Text("Home Loan Calculator", style: TextStyle(
                      color: Colors.black.withOpacity(.8),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),),
                    const SizedBox(height: 10.0,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("25 000/mois"),
                        Icon(Icons.question_answer, color: Colors.blue,),
                      ],
                    ),
                    const SizedBox(height: 20.0,),
                    Text("You Home Loan", style: TextStyle(
                      color: Colors.black.withOpacity(.8),
                      fontSize: 18.0,
                    ),),
                    const SizedBox(height: 10.0,),
                    const Text("Apply for conditional approval"),
                    const SizedBox(height: 10.0,),
                    Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQObZpMkz19FeRlfRf--fO3xtms2A_niFL8w&usqp=CAU"),
                    const SizedBox(height: 10.0,),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                              ),
                              color: Colors.purple.withOpacity(.4),
                            ),
                            alignment: Alignment.center,
                            child: const Text("Ask a question"),
                          ),
                        ),
                        const SizedBox(width: 20.0,),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                ),
                                color: Colors.blue
                            ),
                            child: const Text("Express Interest", style: TextStyle(
                              color: Colors.white,
                            ),),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),)
          )
        ],
      ),
    );
  }
}
