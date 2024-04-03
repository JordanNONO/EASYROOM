import 'package:easyroom/models/House.dart';
import 'package:easyroom/models/User.dart';

class ReservationModel {
  final int id;
  final int houseId;
  final int userId;
  final String? visiteDate;
  final String createdAt;
  final String updatedAt;
  final User user;
  final House house;

  ReservationModel({
    required this.id,
    required this.houseId,
    required this.userId,
    this.visiteDate,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.house,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      houseId: json['house_id'],
      userId: json['user_id'],
      visiteDate: json['visite_date'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: User.fromJson(json['User']),
      house: House.fromJson(json['House']),
    );
  }


}
