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
}
