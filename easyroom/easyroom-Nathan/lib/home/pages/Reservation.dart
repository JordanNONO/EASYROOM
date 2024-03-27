import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<StatefulWidget> createState() => _ReservationPage();
}

class _ReservationPage extends State<ReservationPage> {
  List<Reservation> reservations = [
    Reservation(
      date: '2022-04-01',
      time: '10:00 AM',
      name: 'John Doe',
      phone: '+1 234 5678',
      email: 'johndoe@example.com',
    ),
    Reservation(
      date: '2022-04-02',
      time: '11:00 AM',
      name: 'Jane Doe',
      phone: '+1 345 6789',
      email: 'janedoe@example.com',
    ),
    Reservation(
      date: '2022-04-03',
      time: '12:00 PM',
      name: 'Alice Smith',
      phone: '+1 456 7890',
      email: 'alicesmith@example.com',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation List'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: const Offset(0, 3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                      'Date: ${reservations[index].date} | Time: ${reservations[index].time}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${reservations[index].name}'),
                      Text('Phone: ${reservations[index].phone}'),
                      Text('Email: ${reservations[index].email}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          );
        },
      ),
    );
  }
}

class Reservation {
  final String date;
  final String time;
  final String name;
  final String phone;
  final String email;

  Reservation({
    required this.date,
    required this.time,
    required this.name,
    required this.phone,
    required this.email,
  });
}
