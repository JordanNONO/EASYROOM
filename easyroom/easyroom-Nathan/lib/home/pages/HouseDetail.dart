import 'package:easyroom/home/pages/addReservation.dart';
import 'package:flutter/material.dart';
import 'package:easyroom/models/House.dart';
import 'package:easyroom/requests/constant.dart';

import '../../models/User.dart';

void _showAddReservationModal(BuildContext context, House house) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return AddReservationModal(house: house,);
    },
  );
}

class HomeRentDetailPage extends StatelessWidget {
  final House house;
  final User? user;

  const HomeRentDetailPage({super.key, required this.house, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                "${API_URL}/${house.images.first.image}",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(house.label, style: Theme.of(context).textTheme.headline6),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border_outlined, color: Colors.red, size: 40),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.kitchen),
                  if (house.hasKitchen) const Text("Cuisine disponible") else const Text("Cuisine non disponible"),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.bed),
                  Text(house.nbreBedroom! > 1 ? "${house.nbreBedroom} chambres" : "${house.nbreBedroom} chambre"),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.location_pin),
                  Text(house.location, style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.bathtub_outlined),
                  if (house.hasBathroom) const Text("wc+douche disponible") else const Text("wc+douche non disponible"),
                ],
              ),
              const SizedBox(height: 16.0),
              Text('Description:', style: Theme.of(context).textTheme.subtitle1),
              const SizedBox(height: 8.0),
              Text(
                house.description,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: house.images.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Image.network(
                          "${API_URL}/${house.images[index].image}",
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 30),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
             if(user?.id == house.user.id)
                 ElevatedButton(onPressed: (){

                 },style: const ButtonStyle(
                     backgroundColor: MaterialStatePropertyAll(Colors.amber)
                 ), child: const Text("Modifier"),)

              else ElevatedButton(
               onPressed: () {
                 // Action à effectuer lorsque le bouton est pressé
                 _showAddReservationModal(context,house);
               },
               child: const Text('Reserver dès maintenant'),
             ),
            ],
          ),
        ),
      ),
    );
  }
}
