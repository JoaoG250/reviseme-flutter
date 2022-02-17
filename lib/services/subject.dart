import 'dart:convert';

import 'package:reviseme/models/http.dart';
import 'package:reviseme/models/subject.dart';

class SubjectService {
  final HttpClient client;

  SubjectService(this.client);

  Future<List<Subject>> getSubjects() async {
    final response = await client.get('subjects/');
    final jsonData = json.decode(response.body);
    final subjects = <Subject>[];
    for (final item in jsonData) {
      subjects.add(Subject.fromJson(item));
    }
    return subjects;
  }

  Future<Subject> getSubject(int subjectId) async {
    final response = await client.get('subjects/$subjectId/');
    final jsonData = json.decode(response.body);
    return Subject.fromJson(jsonData);
  }
}
