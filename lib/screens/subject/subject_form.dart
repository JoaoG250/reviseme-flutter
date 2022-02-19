import 'package:flutter/material.dart';
import 'package:reviseme/models/subject.dart';
import 'package:reviseme/services/subject.dart';
import 'package:reviseme/utils/valitators.dart';

class SubjectForm extends StatefulWidget {
  final Subject? subject;
  final SubjectService service;
  const SubjectForm({
    Key? key,
    required this.service,
    this.subject,
  }) : super(key: key);

  @override
  _SubjectFormState createState() => _SubjectFormState();
}

class _SubjectFormState extends State<SubjectForm> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? description;

  void _submit(BuildContext context) async {
    final form = _formKey.currentState;

    // Check if form is valid
    if (form!.validate()) {
      // Call save event
      form.save();
      if (widget.subject != null) {
        // If subject is not null, it means we are editing
        final input =
            UpdateSubjectInput(name: name!, description: description!);
        await widget.service.updateSubject(widget.subject!.id, input);
      } else {
        // If subject is null, it means we are creating
        final input =
            CreateSubjectInput(name: name!, description: description!);
        await widget.service.createSubject(input);
      }
      // Navigate back to subjects page
      Navigator.of(context).pop();
    }
  }

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
            validator: (value) => requiredValidator(value, 'Subject name'),
            onSaved: (value) => name = value,
          ),
          TextFormField(
            initialValue: widget.subject?.description,
            decoration: const InputDecoration(
              hintText: 'Subject Description',
              labelText: 'Description',
            ),
            validator: (value) =>
                requiredValidator(value, 'Subject description'),
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
}
