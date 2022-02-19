import 'package:flutter/material.dart';
import 'package:reviseme/models/topic.dart';

class TopicDescription extends StatelessWidget {
  final Topic topic;
  const TopicDescription({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          topic.name,
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          topic.description,
        ),
      ],
    );
  }
}
