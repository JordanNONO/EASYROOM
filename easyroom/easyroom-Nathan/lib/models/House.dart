import 'package:easyroom/models/HouseImage.dart';
import 'package:easyroom/models/User.dart';

class House {
  final int id;
  final String label;
  final String location;
  final String? mapLocation;
  final bool hasBathroom;
  final bool hasKitchen;
  final int? nbreBedroom;
  final bool isRent;
  final int price;
  final String description;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final List<HouseImage> images;
  // Vous pouvez également ajouter une liste pour 'options' si nécessaire

  House({
    required this.id,
    required this.label,
    required this.location,
    this.mapLocation,
    required this.hasBathroom,
    required this.hasKitchen,
    this.nbreBedroom,
    required this.isRent,
    required this.price,
    required this.description,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.images,
    // Ajoutez une liste pour 'options' si nécessaire
  });

  factory House.fromJson(Map<String, dynamic> json) {
    List<dynamic> imagesJson = json['images'] ?? [];
    return House(
      id: json['id'],
      label: json['label'],
      location: json['location'],
      mapLocation: json['map_location'],
      hasBathroom: json['has_bathroom'] ?? false,
      hasKitchen: json['has_kitchen'] ?? false,
      nbreBedroom: json['nbre_bedroom'],
      isRent: json['is_rent'] ?? false,
      price: json['price'],
      description: json['description'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson({
        'id': json['User.id'],
        'name': json['User.name'],
        'lastname': json['User.lastname'],
        'contact': json['User.contact'],
        'ren_house': json['User.ren_house'],
        'birthday': json['User.birthday'],
        'gender_id': json['User.gender_id'],
        'role_id': json['User.role_id'],
        'password': json['User.password'],
        'createdAt': json['User.createdAt'],
        'updatedAt': json['User.updatedAt'],
      }),
      images: imagesJson.map((imageJson) => HouseImage.fromJson(imageJson)).toList(),
      // Initialisez la liste pour 'options' si nécessaire
    );
  }
}