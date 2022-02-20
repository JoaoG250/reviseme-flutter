import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:reviseme/models/http.dart';
import 'package:reviseme/models/topic.dart';

class TopicService {
  HttpClient get client => GetIt.I<HttpClient>();

  Future<Topic> getTopic(int topicId) async {
    final response = await client.get('topics/$topicId/');
    final jsonData = json.decode(response.body);
    return Topic.fromJson(jsonData);
  }

  Future<Topic> createTopic(CreateTopicInput data) async {
    final response = await client.post('topics/', data.toJson());
    final jsonData = json.decode(response.body);
    return Topic.fromJson(jsonData);
  }

  Future<Topic> updateTopic(int topicId, UpdateTopicInput data) async {
    final response = await client.put('topics/$topicId/', data.toJson());
    final jsonData = json.decode(response.body);
    return Topic.fromJson(jsonData);
  }

  Future<void> deleteTopic(int topicId) async {
    await client.delete('topics/$topicId/');
  }

  Future<TopicFile> createTopicFile(CreateTopicFileInput data) async {
    final response = await client.sendFiles(
      'topic-files/',
      data.toJson(),
      data.getFiles(),
    );
    final jsonData = json.decode(response.body);
    return TopicFile.fromJson(jsonData);
  }

  Future<List<Topic>> getTopics(Map<String, String>? params) async {
    final response = await client.get('topics/', params: params);
    final jsonData = json.decode(response.body);
    final List<Topic> topics = [];
    for (final topic in jsonData) {
      topics.add(Topic.fromJson(topic));
    }
    return topics;
  }

  Future<List<TopicRevision>> getTopicRevisions(
      Map<String, String>? params) async {
    final response = await client.get('topic-revisions/', params: params);
    final jsonData = json.decode(response.body);
    final List<TopicRevision> topicRevisions = [];
    for (final topicRevision in jsonData) {
      topicRevisions.add(TopicRevision.fromJson(topicRevision));
    }
    return topicRevisions;
  }

  Future<List<TopicRevision>> getTopicRevisionHistory() async {
    final response = await client.get(
      'topic-revisions/',
      params: {
        'complete': 'true',
      },
    );
    final jsonData = json.decode(response.body);
    final List<TopicRevision> topicRevisionHistory = [];
    for (final topicRevision in jsonData) {
      topicRevisionHistory.add(TopicRevision.fromJson(topicRevision));
    }
    return topicRevisionHistory;
  }

  Future<List<TopicRevision>> getDailyTopicRevisions() async {
    // Get the current date in the format YYYY-MM-DD
    final currentDate = DateTime.now().toString().substring(0, 10);
    final response = await client.get(
      'topic-revisions/',
      params: {
        'revision_date__lte': currentDate,
        'complete': 'false',
      },
    );
    final jsonData = json.decode(response.body);
    final List<TopicRevision> dailyTopicRevisions = [];
    for (final topicRevision in jsonData) {
      dailyTopicRevisions.add(TopicRevision.fromJson(topicRevision));
    }
    return dailyTopicRevisions;
  }

  Future<double> getTopicRevisionsProgress() async {
    final response = await client.get('topics/revision_progress/');
    final jsonData = json.decode(response.body);
    return jsonData['progress'];
  }

  Future<List<TopicFile>> getTopicImages(int topicId) async {
    final response = await client.get(
      'topic-files/',
      params: {
        'topic': topicId.toString(),
        'file_type': 'IMAGE',
      },
    );
    final jsonData = json.decode(response.body);
    final List<TopicFile> topicFiles = [];
    for (final topicFile in jsonData) {
      topicFiles.add(TopicFile.fromJson(topicFile));
    }
    return topicFiles;
  }
}
