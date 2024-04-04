

import 'package:easyroom/home/pages/Chat.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/requests/ApiService.dart';
import 'package:flutter/material.dart';

class ReservationList extends StatefulWidget{
  final User user;
  const ReservationList({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => _ReservationList();
}

class _ReservationList extends State<ReservationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: ApiService.fetchMyReservations(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(itemCount: snapshot.data.length, itemBuilder: (context,index){
                final rdv = snapshot.data[index];
                return ListTile(
                  title: Text("Visite de ${rdv.house.label}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(rdv.visiteDate!=null)Text(rdv.visiteDate)else  Text("Date non défini",style: TextStyle(color: Colors.grey.shade500),),
                      Text(rdv.house.description),

                    ],
                  ),
                  trailing: IconButton(icon: const Icon(Icons.chat), onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=> ChatScreen(rdv:rdv,user:widget.user)));
                  },),
                );
              });
            } else if (snapshot.hasError) {
              return const Center(
                child: Image(image: AssetImage("assets/images/warning.png")),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue,),
              );
            }
          }),
    );
  }

}