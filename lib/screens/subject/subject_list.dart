import 'package:flutter/material.dart';
import 'package:reviseme/models/subject.dart';
import 'package:reviseme/screens/subject/subject_delete.dart';
import 'package:reviseme/screens/subject/subject_modify.dart';

class SubjectList extends StatelessWidget {
  const SubjectList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Testing data for subjects
    final subjects = [
      Subject(
        id: 1,
        name: 'English',
        description: 'English is the language of the world',
        createdAt: '2020-01-01',
        updatedAt: '2020-01-01',
      ),
      Subject(
        id: 2,
        name: 'Math',
        description: 'Math is the science of numbers',
        createdAt: '2020-01-01',
        updatedAt: '2020-01-01',
      ),
      Subject(
        id: 3,
        name: 'Science',
        description: 'Science is the study of the universe',
        createdAt: '2020-01-01',
        updatedAt: '2020-01-01',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SubjectModify()));
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return Dismissible(
                key: ValueKey(subjects[index].id),
                child: _buildSubjectTile(context, index, subjects),
                direction: DismissDirection.startToEnd,
                background: Container(
                  color: Colors.red,
                  child: const ListTile(
                    leading: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                onDismissed: (direction) {},
                confirmDismiss: (direction) {
                  return showDialog(
                      context: context,
                      builder: (context) => const SubjectDelete());
                });
          },
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemCount: subjects.length),
    );
  }

  Widget _buildSubjectTile(
    BuildContext context,
    int index,
    List<Subject> subjects,
  ) {
    return ListTile(
      title: Text(subjects[index].name),
      subtitle: Text(subjects[index].description),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SubjectModify(
                  subjectId: subjects[index].id,
                )));
      },
    );
  }
}
