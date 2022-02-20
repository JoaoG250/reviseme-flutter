import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';

class TopicImageCreate extends StatefulWidget {
  final Topic topic;
  const TopicImageCreate({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  _TopicImageCreateState createState() => _TopicImageCreateState();
}

class _TopicImageCreateState extends State<TopicImageCreate> {
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
    await service.createTopicFile(input);
    Navigator.of(context).pop();
  }

  List<Widget> _buildImagePreview() {
    if (_file != null) {
      return [Image.file(File(_file!.path!))];
    }

    return [
      Icon(
        Icons.image_outlined,
        size: MediaQuery.of(context).size.width * 0.75,
        color: Colors.grey,
      ),
      const Text(
        'No image selected',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }

  List<Widget> _buildButtons() {
    return [
      ElevatedButton(
        child: _file == null
            ? const Text('Select Image')
            : const Text('Change Image'),
        onPressed: _pickFile,
      ),
      _file != null
          ? ElevatedButton(
              child: const Text('Submit'),
              onPressed: _submit,
            )
          : Container(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ..._buildImagePreview(),
            const SizedBox(height: 30),
            ..._buildButtons(),
          ],
        ),
      ),
    );
  }
}
