import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyroom/constants.dart';
import 'package:easyroom/home/index.dart';
import 'package:easyroom/home/pages/addReservation.dart';
import 'package:easyroom/requests/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:easyroom/models/House.dart';
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
  final dynamic house;
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
              CachedNetworkImage(
                imageUrl: "${house.images.first.image}",
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/warning.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(house.label, style: Theme.of(context).textTheme.headlineSmall),
                  IconButton(
                    onPressed: () {
                      ApiService.setFavorite(house.id);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => const HomePage(),
                        ),
                      );

                    },
                    icon: house.isFavorite? const Icon(Icons.favorite,color: Colors.red, size: 40) : const Icon(Icons.favorite_border_outlined, color: Colors.red, size: 40),
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
                  Text(house.location, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.bathtub_outlined),
                  if (house.hasBathroom) const Text("wc+douche disponible") else const Text("wc+douche non disponible"),
                ],
              ),
              if (house.nearestStopDistanceMeters != null) ...[
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.directions_bus),
                    const SizedBox(width: 8.0),
                    Flexible(
                      child: Text(
                        "À ${(house.nearestStopDistanceMeters / 1000).toStringAsFixed(1)} km de ${house.nearestStopName}",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16.0),
              Text('Description:', style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 8.0),
              Text(
                house.description,
                style: Theme.of(context).textTheme.labelMedium,
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
                        CachedNetworkImage(
                          imageUrl: "${house.images[index].image}",
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/warning.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 30),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              if(user?.id == house.user.id)
                ElevatedButton(
                  onPressed: () {
                    // Action à effectuer lorsque le bouton est pressé
                    // Ajouter l'action de modification ici
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text("Modifier"),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    // Action à effectuer lorsque le bouton est pressé
                    _showAddReservationModal(context,house);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text('Réserver dès maintenant'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
