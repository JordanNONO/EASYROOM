import 'package:easyroom/models/HouseImage.dart';
import 'package:easyroom/models/User.dart';

class HouseRecommanded {
  final int id;
  final String label;
  final String location;
  final String? mapLocation;
  final bool hasBathroom;
  final bool hasKitchen;
  final int nbreBedroom;
  final bool isRent;
  final int price;
  final String description;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final int favoritesCount;
  final User user;
  final List<HouseImage> images;
  final List<Option> options;
  final bool isFavorite;

  HouseRecommanded({
    required this.id,
    required this.label,
    required this.location,
    this.mapLocation,
    required this.hasBathroom,
    required this.hasKitchen,
    required this.nbreBedroom,
    required this.isRent,
    required this.price,
    required this.description,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.favoritesCount,
    required this.user,
    required this.images,
    required this.options,
    required this.isFavorite,
  });

  factory HouseRecommanded.fromJson(Map<String, dynamic> json) {
    return HouseRecommanded(
      id: json['id'],
      label: json['label'],
      location: json['location'],
      mapLocation: json['map_location'],
      hasBathroom: json['has_bathroom'],
      hasKitchen: json['has_kitchen'],
      nbreBedroom: json['nbre_bedroom'],
      isRent: json['is_rent'],
      price: json['price'],
      description: json['description'],
      userId: json['user_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      favoritesCount: json['favorites_count'],
      user: User.fromJson(json['User']),
      images: (json['images'] as List).map((i) => HouseImage.fromJson(i)).toList(),
      options: (json['options'] as List).map((i) => Option.fromJson(i)).toList(),
      isFavorite: json['favorite'],
    );
  }
}



class Option {
  final String label;
  final int houseId;

  Option({
    required this.label,
    required this.houseId,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      label: json['label'],
      houseId: json['house_id'],
    );
  }
}
