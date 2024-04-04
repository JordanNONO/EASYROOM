class ReservationModel {
  final int id;
  final int houseId;
  final int userId;
  final String? visiteDate;
  final String createdAt;
  final String updatedAt;
  final RdvUser user;
  final RdvHouse house;

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
      user: RdvUser.fromJson(json['User']),
      house: RdvHouse.fromJson(json['House']),
    );
  }
}

class RdvUser {
  final int id;
  final String name;
  final String lastname;
  final String contact;
  final bool renHouse;
  final String? birthday;
  final int? genderId;
  final int roleId;
  final String password;
  final String createdAt;
  final String updatedAt;

  RdvUser({
    required this.id,
    required this.name,
    required this.lastname,
    required this.contact,
    required this.renHouse,
    this.birthday,
    this.genderId,
    required this.roleId,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RdvUser.fromJson(Map<String, dynamic> json) {
    return RdvUser(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      contact: json['contact'],
      renHouse: json['ren_house'],
      birthday: json['birthday'],
      genderId: json['gender_id'],
      roleId: json['role_id'],
      password: json['password'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class RdvHouse {
  final int id;
  final String label;
  final String location;
  final dynamic mapLocation;
  final bool hasBathroom;
  final bool hasKitchen;
  final int? nbreBedroom;
  final bool isRent;
  final int price;
  final String description;
  final int userId;
  final String createdAt;
  final String updatedAt;

  RdvHouse({
    required this.id,
    required this.label,
    required this.location,
    required this.mapLocation,
    required this.hasBathroom,
    required this.hasKitchen,
    required this.nbreBedroom,
    required this.isRent,
    required this.price,
    required this.description,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RdvHouse.fromJson(Map<String, dynamic> json) {
    return RdvHouse(
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
    );
  }
}
