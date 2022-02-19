import 'package:flutter/material.dart';

class SubjectRevisionsScreenArguments {
  final int subjectId;

  SubjectRevisionsScreenArguments(this.subjectId);
}

class SubjectRevisionsScreen extends StatefulWidget {
  const SubjectRevisionsScreen({Key? key}) : super(key: key);
  static const routeName = '/subject-revisions';

  @override
  _SubjectRevisionsScreenState createState() => _SubjectRevisionsScreenState();
}

class _SubjectRevisionsScreenState extends State<SubjectRevisionsScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as SubjectRevisionsScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject Revisions'),
      ),
      body: Center(
        child: Text('Subject ID: ${args.subjectId}'),
      ),
    );
  }
}
