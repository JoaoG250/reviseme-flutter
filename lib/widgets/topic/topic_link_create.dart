import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/utils/valitators.dart';

class TopicLinkCreate extends StatefulWidget {
  final Topic topic;
  const TopicLinkCreate({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  State<TopicLinkCreate> createState() => _TopicLinkCreateState();
}

class _TopicLinkCreateState extends State<TopicLinkCreate> {
  TopicService get service => GetIt.I<TopicService>();
  final _formKey = GlobalKey<FormState>();
  String? title;
  String? url;

  void _submit(BuildContext context) async {
    final form = _formKey.currentState;

    // Check if form is valid
    if (form!.validate()) {
      // Call save event
      form.save();

      final input = CreateTopicLinkInput(
        topic: widget.topic.id,
        title: title!,
        url: url!,
      );
      await service.createTopicLink(input);

      // Navigate back
      Navigator.of(context).pop();
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Link title',
              labelText: 'Title',
            ),
            validator: (value) => requiredValidator(value, 'Link title'),
            onSaved: (value) => title = value,
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Link URL',
              labelText: 'URL',
            ),
            validator: (value) => urlValidator(value, 'Link URL'),
            onSaved: (value) => url = value,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create link'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: _buildForm(),
      ),
    );
  }
}
