import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/subject.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/widgets/topic/topic_form.dart';

class TopicModify extends StatefulWidget {
  final Subject subject;
  final int? topicId;
  const TopicModify({
    Key? key,
    required this.subject,
    this.topicId,
  }) : super(key: key);

  @override
  State<TopicModify> createState() => _TopicModifyState();
}

class _TopicModifyState extends State<TopicModify> {
  TopicService get service => GetIt.I<TopicService>();
  bool get isEditing => widget.topicId != null;
  Topic? _topic;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTopic();
  }

  void _fetchTopic() async {
    if (isEditing) {
      setState(() {
        _isLoading = true;
      });

      final topic = await service.getTopic(widget.topicId!);
      setState(() {
        _topic = topic;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modify Topic' : 'Create Topic'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15),
              child: TopicForm(
                subject: widget.subject,
                service: service,
                topic: _topic,
              ),
            ),
    );
  }
}
