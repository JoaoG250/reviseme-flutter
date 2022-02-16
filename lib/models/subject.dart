class Subject {
  final int id;
  final String name;
  final String description;
  final String? image;
  final String createdAt;
  final String updatedAt;

  Subject({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  Subject.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        image = json['image'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
