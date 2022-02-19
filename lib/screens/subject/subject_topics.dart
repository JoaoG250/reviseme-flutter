import 'package:flutter/material.dart';
import 'package:reviseme/models/subject.dart';

class SubjectTopics extends StatefulWidget {
  final Subject subject;

  const SubjectTopics({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  _SubjectTopicsState createState() => _SubjectTopicsState();
}

class _SubjectTopicsState extends State<SubjectTopics> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Subject ID: ${widget.subject.id}'),
    );
  }
}
