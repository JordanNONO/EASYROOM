import 'package:easyroom/models/House.dart';
import 'package:flutter/material.dart';

class EditHousePage extends StatefulWidget{
  final House house;
  const EditHousePage({super.key, required this.house});
  @override
  State<StatefulWidget> createState()=>_EditHousePage();

}

class _EditHousePage extends State<EditHousePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: const Center(),
    );
  }
}