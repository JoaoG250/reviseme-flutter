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

  Future<TopicRevision> completeTopicRevision(int topicId) async {
    final response = await client.get('topics/$topicId/complete_revision/');
    final jsonData = json.decode(response.body);
    return TopicRevision.fromJson(jsonData);
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

  Future<List<TopicFile>> getTopicFiles(Map<String, String>? params) async {
    final response = await client.get('topic-files/', params: params);
    final jsonData = json.decode(response.body);
    final List<TopicFile> topicFiles = [];
    for (final topicFile in jsonData) {
      topicFiles.add(TopicFile.fromJson(topicFile));
    }
    return topicFiles;
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

  Future<void> deleteTopicFile(int topicFileId) async {
    await client.delete('topic-files/$topicFileId/');
  }

  Future<List<TopicLink>> getTopicLinks(Map<String, String>? params) async {
    final response = await client.get('topic-links/', params: params);
    final jsonData = json.decode(response.body);
    final List<TopicLink> topicLinks = [];
    for (final topicLink in jsonData) {
      topicLinks.add(TopicLink.fromJson(topicLink));
    }
    return topicLinks;
  }

  Future<TopicLink> createTopicLink(CreateTopicLinkInput data) async {
    final response = await client.post('topic-links/', data.toJson());
    final jsonData = json.decode(response.body);
    return TopicLink.fromJson(jsonData);
  }

  Future<void> deleteTopicLink(int topicLinkId) async {
    await client.delete('topic-links/$topicLinkId/');
  }
}
