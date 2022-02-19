import 'package:flutter/material.dart';
import 'package:reviseme/models/subject.dart';

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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Subject ID: ${widget.subject.id}'),
    );
  }
}
