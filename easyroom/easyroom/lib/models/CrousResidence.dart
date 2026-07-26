class CrousResidence {
  final String id;
  final String title;
  final String? address;
  final double? lat;
  final double? lon;

  CrousResidence({
    required this.id,
    required this.title,
    this.address,
    this.lat,
    this.lon,
  });

  factory CrousResidence.fromJson(Map<String, dynamic> json) {
    return CrousResidence(
      id: json['id'].toString(),
      title: json['title'],
      address: json['address'],
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );
  }
}
