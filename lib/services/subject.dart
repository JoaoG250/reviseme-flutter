import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:reviseme/models/http.dart';
import 'package:reviseme/models/subject.dart';

class SubjectService {
  HttpClient get client => GetIt.I<HttpClient>();

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

  Future<Subject> createSubject(CreateSubjectInput data) async {
    final response = await client.post('subjects/', data.toJson());
    final jsonData = json.decode(response.body);
    return Subject.fromJson(jsonData);
  }

  Future<Subject> updateSubject(int subjectId, UpdateSubjectInput data) async {
    final response = await client.put('subjects/$subjectId/', data.toJson());
    final jsonData = json.decode(response.body);
    return Subject.fromJson(jsonData);
  }

  Future<void> deleteSubject(int subjectId) async {
    await client.delete('subjects/$subjectId/');
  }

  Future<double> getSubjectRevisionProgress(int subjectId) async {
    final response = await client.get('subjects/$subjectId/revision_progress/');
    final jsonData = json.decode(response.body);
    return jsonData['progress'];
  }
}
