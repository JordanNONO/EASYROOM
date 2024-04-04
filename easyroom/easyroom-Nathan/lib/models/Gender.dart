class Gender {
  final int id;
  final String label;
  final String createdAt;
  final String? updatedAt;

  Gender({
    required this.id,
    required this.label,
    required this.createdAt,
    this.updatedAt,
  });

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
      id: json['id'],
      label: json['label'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': this.id,
      'label': this.label,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
    };
    return data;
  }
}
