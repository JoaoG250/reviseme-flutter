import 'package:reviseme/models/iserializable.dart';

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
}

class CreateSubjectInput implements ISerializable {
  final String name;
  final String description;
  final String? image;

  CreateSubjectInput({
    required this.name,
    required this.description,
    this.image,
  });

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        if (image != null) 'image': image,
      };
}

class UpdateSubjectInput extends CreateSubjectInput {
  UpdateSubjectInput({
    required String name,
    required String description,
    String? image,
  }) : super(
          name: name,
          description: description,
          image: image,
        );
}
