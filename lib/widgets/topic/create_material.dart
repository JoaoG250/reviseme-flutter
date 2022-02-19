import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';

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
  TopicService get service => GetIt.I<TopicService>();
  PlatformFile? _file;

  _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    // If user cancels the file picker, result will be null.
    if (result == null) return;

    PlatformFile file = result.files.first;
    setState(() {
      _file = file;
    });
  }

  Future<void> _submit() async {
    if (_file == null) return;

    final input = CreateTopicFileInput(
      topic: widget.topic.id,
      fileType: 'IMAGE',
      filePath: _file!.path!,
    );
    final response = service.createTopicFile(input);
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        child: const Icon(Icons.add),
      ),
      body: Center(
          child: _file == null
              ? const Text('No file selected.')
              : Column(
                  children: [
                    Image.file(
                      File(_file!.path!),
                      width: 400,
                      height: 400,
                    ),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Submit'),
                    )
                  ],
                )),
    );
  }
}
