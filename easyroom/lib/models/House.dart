import 'dart:convert';
import 'dart:developer';

import 'package:easyroom/models/User.dart';

class House {
  final int id;
  final String label;
  final String location;
  final String? mapLocation;
  final int hasBathroom;
  final int hasKitchen;
  final int? nbreBedroom;
  final int isRent;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  // Vous pouvez également ajouter des listes pour 'images' et 'options' si nécessaire

  House({
    required this.id,
    required this.label,
    required this.location,
    this.mapLocation,
    required this.hasBathroom,
    required this.hasKitchen,
    this.nbreBedroom,
    required this.isRent,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    // Ajoutez des listes pour 'images' et 'options' si nécessaire
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: json['id'],
      label: json['label'],
      location: json['location'],
      mapLocation: json['map_location'],
      hasBathroom: json['has_bathroom'],
      hasKitchen: json['has_kitchen'],
      nbreBedroom: json['nbre_bedroom'],
      isRent: json['is_rent'],
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
      } ),
      // Initialisez les listes pour 'images' et 'options' si nécessaire
    );
  }
}