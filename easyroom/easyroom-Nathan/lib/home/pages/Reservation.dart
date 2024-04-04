import 'package:easyroom/home/pages/Chat.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/requests/ApiService.dart';
import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  final User user;
  const ReservationPage({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => _ReservationPage();
}

class _ReservationPage extends State<ReservationPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: FutureBuilder(
            future: ApiService.fetchReservations(),
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
                return const Center(child: CircularProgressIndicator(),);
              }
            }));
  }
}

