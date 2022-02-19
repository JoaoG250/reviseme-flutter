import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:reviseme/models/http.dart';
import 'package:reviseme/models/topic.dart';

class TopicService {
  HttpClient get client => GetIt.I<HttpClient>();

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
}
