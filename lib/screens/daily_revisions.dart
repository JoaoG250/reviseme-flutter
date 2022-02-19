import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/widgets/topic_revision.dart';

class DailyRevisions extends StatefulWidget {
  const DailyRevisions({Key? key}) : super(key: key);

  @override
  _DailyRevisionsState createState() => _DailyRevisionsState();
}

class _DailyRevisionsState extends State<DailyRevisions> {
  TopicService get service => GetIt.I<TopicService>();
  List<TopicRevision> _revisions = [];
  double _progress = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTopicRevisions();
  }

  Future<void> _fetchTopicRevisions() async {
    setState(() {
      _isLoading = true;
    });

    final revisions = await service.getDailyTopicRevisions();
    final progress = await service.getTopicRevisionsProgress();
    setState(() {
      _revisions = revisions;
      _progress = progress;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                flex: 8,
                child: TopicRevisionList(revisions: _revisions),
              ),
              Expanded(
                flex: 2,
                child: TopicRevisionProgress(progress: _progress),
              ),
            ],
          );
  }
}
