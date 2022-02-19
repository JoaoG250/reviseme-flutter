import 'package:flutter/material.dart';
import 'package:reviseme/models/subject.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/utils/valitators.dart';

class TopicForm extends StatefulWidget {
  final Subject subject;
  final Topic? topic;
  final TopicService service;

  const TopicForm({
    Key? key,
    required this.subject,
    required this.service,
    this.topic,
  }) : super(key: key);

  @override
  _TopicFormState createState() => _TopicFormState();
}

class _TopicFormState extends State<TopicForm> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? description;

  void _submit(BuildContext context) async {
    final form = _formKey.currentState;

    // Check if form is valid
    if (form!.validate()) {
      // Call save event
      form.save();
      if (widget.topic != null) {
        // If topic is not null, it means we are editing a topic
        final input = UpdateTopicInput(
            subject: widget.topic!.subject.id,
            name: name!,
            description: description!);
        await widget.service.updateTopic(widget.topic!.id, input);
      } else {
        // If topic is null, it means we are creating a new topic
        final input = CreateTopicInput(
            subject: widget.subject.id, name: name!, description: description!);
        await widget.service.createTopic(input);
      }
      // Navigate back to subject topics page
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
            initialValue: widget.topic?.name,
            decoration: const InputDecoration(
              hintText: 'Topic Name',
              labelText: 'Name',
            ),
            validator: (value) => requiredValidator(value, 'Topic name'),
            onSaved: (value) => name = value,
          ),
          TextFormField(
            initialValue: widget.topic?.description,
            decoration: const InputDecoration(
              hintText: 'Topic Description',
              labelText: 'Description',
            ),
            validator: (value) => requiredValidator(value, 'Topic description'),
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
