import 'dart:io';

import 'package:reviseme/models/subject.dart';

class Topic {
  final int id;
  final Subject subject;
  final String name;
  final String description;
  final String? image;
  final bool active;
  final String createdAt;
  final String updatedAt;

  Topic({
    required this.id,
    required this.subject,
    required this.name,
    required this.description,
    this.image,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  Topic.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        subject = Subject.fromJson(json['subject']),
        name = json['name'],
        description = json['description'],
        image = json['image'],
        active = json['active'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];
}

class CreateTopicInput {
  final int subject;
  final String name;
  final String description;
  final String? image;

  CreateTopicInput({
    required this.subject,
    required this.name,
    required this.description,
    this.image,
  });

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'name': name,
        'description': description,
        if (image != null) 'image': image,
      };
}

class UpdateTopicInput extends CreateTopicInput {
  UpdateTopicInput({
    required int subject,
    required String name,
    required String description,
    String? image,
  }) : super(
          subject: subject,
          name: name,
          description: description,
          image: image,
        );
}

class CreateTopicFileInput {
  final int topic;
  final String fileType;
  final String filePath;
  late File file;

  CreateTopicFileInput({
    required this.topic,
    required this.fileType,
    required this.filePath,
  }) {
    file = File(filePath);
  }

  Map<String, String> toJson() => {
        'topic': topic.toString(),
        'fileType': fileType,
      };

  Map<String, File> getFiles() => {
        'file': file,
      };
}

class TopicRevision {
  final int id;
  final Topic topic;
  final String phase;
  final String revisionDate;
  final bool complete;
  final String createdAt;
  final String updatedAt;

  TopicRevision({
    required this.id,
    required this.topic,
    required this.phase,
    required this.revisionDate,
    required this.complete,
    required this.createdAt,
    required this.updatedAt,
  });

  TopicRevision.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        topic = Topic.fromJson(json['topic']),
        phase = json['phase'],
        revisionDate = json['revisionDate'],
        complete = json['complete'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];
}

class TopicFile {
  final int id;
  final Topic topic;
  final String fileType;
  final String file;

  TopicFile({
    required this.id,
    required this.topic,
    required this.fileType,
    required this.file,
  });

  TopicFile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        topic = Topic.fromJson(json['topic']),
        fileType = json['fileType'],
        file = json['file'];
}
