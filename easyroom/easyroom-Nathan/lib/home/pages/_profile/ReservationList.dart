

import 'package:flutter/material.dart';

class ReservationList extends StatefulWidget{
  const ReservationList({super.key});

  @override
  State<StatefulWidget> createState() => _ReservationList();
}

class _ReservationList extends State<ReservationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Reservation"),
    );
  }

}