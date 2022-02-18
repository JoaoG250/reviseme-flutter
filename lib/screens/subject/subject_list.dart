import 'package:flutter/material.dart';
import 'package:reviseme/models/subject.dart';
import 'package:reviseme/screens/subject/subject_delete.dart';
import 'package:reviseme/screens/subject/subject_modify.dart';

typedef FetchSujects = Future<void> Function();
typedef DeleteSubject = Future<void> Function(int subjectId);

class SubjectList extends StatelessWidget {
  final List<Subject> subjects;
  final FetchSujects fetchSubjects;
  final DeleteSubject deleteSubject;

  const SubjectList({
    Key? key,
    required this.subjects,
    required this.fetchSubjects,
    required this.deleteSubject,
  }) : super(key: key);

  Widget _buildSubjectTile(
    BuildContext context,
    int index,
  ) {
    return ListTile(
      title: Text(subjects[index].name),
      subtitle: Text(subjects[index].description),
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SubjectModify(
            subjectId: subjects[index].id,
          ),
        ));
        fetchSubjects();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(subjects[index].id),
          child: _buildSubjectTile(context, index),
          direction: DismissDirection.startToEnd,
          background: Container(
            color: Colors.red,
            child: const ListTile(
              leading: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          onDismissed: (direction) {},
          confirmDismiss: (direction) async {
            final result = await showDialog(
              context: context,
              builder: (context) => const SubjectDelete(),
            );

            if (result == true) {
              await deleteSubject(subjects[index].id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subject deleted'),
                ),
              );
            }

            return result;
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: subjects.length,
    );
  }
}
