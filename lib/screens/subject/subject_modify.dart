import 'package:flutter/material.dart';

class SubjectModify extends StatelessWidget {
  final int? subjectId;
  bool get isEditing => subjectId != null;
  const SubjectModify({Key? key, this.subjectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Modify Subject' : 'Create Subject'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                hintText: 'Subject Name',
              ),
            ),
            Container(height: 10),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Subject Description',
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (isEditing) {
                    // TODO: Update subject
                  } else {
                    // TODO: Create subject
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Submit'))
          ]),
        ));
  }
}
