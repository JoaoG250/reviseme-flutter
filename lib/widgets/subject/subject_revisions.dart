import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/subject.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/subject.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/widgets/topic_revision.dart';

class SubjectRevisions extends StatefulWidget {
  final Subject subject;

  const SubjectRevisions({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  _SubjectRevisionsState createState() => _SubjectRevisionsState();
}

class _SubjectRevisionsState extends State<SubjectRevisions> {
  TopicService get topicService => GetIt.I<TopicService>();
  SubjectService get subjectService => GetIt.I<SubjectService>();
  List<TopicRevision> _revisions = [];
  double _progress = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final revisions = await topicService.getTopicRevisions({
      'subject': widget.subject.id.toString(),
    });
    final progress = await subjectService.getSubjectRevisionProgress(
      widget.subject.id,
    );

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
