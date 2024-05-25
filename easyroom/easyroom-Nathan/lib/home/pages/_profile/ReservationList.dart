import 'package:easyroom/home/pages/Chat.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/requests/ApiService.dart';
import 'package:flutter/material.dart';

class ReservationList extends StatefulWidget {
  final User user;
  const ReservationList({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Réservations'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ApiService.fetchMyReservations(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Image(image: AssetImage("assets/images/warning.png")),
            );
          } else if (snapshot.hasData) {
            final List<dynamic> reservations = snapshot.data;
            return ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final rdv = reservations[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
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
                          Text(
                            rdv.house.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.chat),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => ChatScreen(rdv: rdv, user: widget.user),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }
        },
      ),
    );
  }
}
