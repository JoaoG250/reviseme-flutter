import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/subject.dart';
import 'package:reviseme/screens/subject/subject_form.dart';
import 'package:reviseme/services/subject.dart';

class SubjectModify extends StatefulWidget {
  final int? subjectId;
  const SubjectModify({Key? key, this.subjectId}) : super(key: key);

  @override
  State<SubjectModify> createState() => _SubjectModifyState();
}

class _SubjectModifyState extends State<SubjectModify> {
  SubjectService get service => GetIt.I<SubjectService>();
  bool get isEditing => widget.subjectId != null;
  Subject? _subject;
  bool _isLoading = false;

  @override
  void initState() {
    _fetchSubject();
    super.initState();
  }

  void _fetchSubject() async {
    if (isEditing) {
      setState(() {
        _isLoading = true;
      });

      final subject = await service.getSubject(widget.subjectId!);
      setState(() {
        _subject = subject;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Modify Subject' : 'Create Subject'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(15),
                child: SubjectForm(subject: _subject)));
  }
}
