import 'package:easyroom/models/House.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:flutter/material.dart';


class NextPage extends StatefulWidget {
  const NextPage({super.key, required this.house});
  final House house;
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
          tag: "$API_URL/${widget.house.images.last.image}",
          child: Image.network("$API_URL/${widget.house.images.first.image}", fit: BoxFit.cover)),),
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
                     Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${widget.house.price} FCFA", style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),),
                          const Icon(Icons.bookmark_border, color: Colors.blue,)
                        ]

                    ),
                    const SizedBox(height: 20.0,),
                     Text(widget.house.label, style: const TextStyle(
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
                    Text(widget.house.description, style: TextStyle(
                      color: Colors.black.withOpacity(.8),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),),
                    const SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${widget.house.price} /mois"),
                        const Icon(Icons.question_answer, color: Colors.blue,),
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
                    //Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQObZpMkz19FeRlfRf--fO3xtms2A_niFL8w&usqp=CAU"),
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
