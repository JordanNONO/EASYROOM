class HouseImage {
  final int id;
  final String? label;
  final String image;
  final int houseId;
  final DateTime createdAt;
  final DateTime updatedAt;

  HouseImage({
    required this.id,
    this.label,
    required this.image,
    required this.houseId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HouseImage.fromJson(Map<String, dynamic> json) {
    return HouseImage(
      id: json['id'],
      label: json['label'],
      image: json['image'],
      houseId: json['house_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}