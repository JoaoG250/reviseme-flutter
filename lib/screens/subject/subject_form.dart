import 'package:flutter/material.dart';
import 'package:reviseme/models/subject.dart';

class SubjectForm extends StatefulWidget {
  final Subject? subject;
  const SubjectForm({Key? key, this.subject}) : super(key: key);

  @override
  _SubjectFormState createState() => _SubjectFormState();
}

class _SubjectFormState extends State<SubjectForm> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? description;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: widget.subject?.name,
            decoration: const InputDecoration(
              hintText: 'Subject Name',
              labelText: 'Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Subject name is required';
              }
              return null;
            },
            onSaved: (value) => name = value,
          ),
          TextFormField(
            initialValue: widget.subject?.description,
            decoration: const InputDecoration(
              hintText: 'Subject Description',
              labelText: 'Description',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Subject description is required';
              }
              return null;
            },
            onSaved: (value) => description = value,
          ),
          ElevatedButton(
            onPressed: () {
              _submit(context);
            },
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }

  void _submit(BuildContext context) {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (widget.subject != null) {
        // TODO: Update subject
      } else {
        // TODO: Create subject
      }
      Navigator.of(context).pop();
    }
  }
}
