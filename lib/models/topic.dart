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
