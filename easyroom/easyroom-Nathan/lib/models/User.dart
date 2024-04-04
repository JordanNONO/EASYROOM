class User {
  final int id;
  final String name;
  final String lastname;
  final String contact;
  final dynamic renHouse;
  final String? birthday;
  final int? genderId;
  final int roleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.contact,
    this.renHouse,
    this.birthday,
    this.genderId,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      contact: json['contact'],
      renHouse: json['ren_house'] is bool ? json['ren_house'] : json['ren_house'] as int?,
      birthday: json['birthday'],
      genderId: json['gender_id'],
      roleId: json['role_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
