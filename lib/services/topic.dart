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
}
