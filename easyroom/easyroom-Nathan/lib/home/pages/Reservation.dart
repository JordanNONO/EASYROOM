import 'package:easyroom/home/pages/Chat.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/requests/ApiService.dart';
import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  final User user;

  const ReservationPage({required this.user, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservations'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ApiService.fetchReservations(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final rdv = snapshot.data[index];
                return ListTile(
                  title: Text("Visite de ${rdv.house.label}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (rdv.visiteDate != null)
                        Text(rdv.visiteDate)
                      else
                        Text(
                          "Date non définie",
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      Text(rdv.house.description),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.chat),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            rdv: rdv,
                            user: widget.user,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(
              child: Image(
                image: AssetImage("assets/images/warning.png"),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
