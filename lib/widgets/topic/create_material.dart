import 'package:flutter/material.dart';
import 'package:reviseme/models/topic.dart';

class CreateMaterial extends StatefulWidget {
  final Topic topic;
  const CreateMaterial({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  _CreateMaterialState createState() => _CreateMaterialState();
}

class _CreateMaterialState extends State<CreateMaterial> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
