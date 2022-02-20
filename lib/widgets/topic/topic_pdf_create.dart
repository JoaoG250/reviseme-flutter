import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';

class TopicPdfCreate extends StatefulWidget {
  final Topic topic;
  const TopicPdfCreate({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  _TopicPdfCreateState createState() => _TopicPdfCreateState();
}

class _TopicPdfCreateState extends State<TopicPdfCreate> {
  TopicService get service => GetIt.I<TopicService>();
  PlatformFile? _file;

  _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
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
      fileType: 'PDF',
      filePath: _file!.path!,
    );
    await service.createTopicFile(input);
    Navigator.of(context).pop();
  }

  Widget _buildPDFPreview() {
    if (_file != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: ListTile(
            title: Text('File: ${_file!.name}'),
            subtitle: Text(
              'Path: ${_file!.path}',
              style: const TextStyle(fontSize: 10),
            ),
            trailing: Text('Size: ${_file!.size} bytes'),
          ),
        ),
      );
    }

    return Column(
      children: [
        Icon(
          Icons.picture_as_pdf,
          size: MediaQuery.of(context).size.width * 0.75,
          color: Colors.grey,
        ),
        const Text(
          'No file selected',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildButtons() {
    return [
      ElevatedButton(
        child: _file == null
            ? const Text('Select PDF file')
            : const Text('Change file'),
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
        title: const Text('Upload PDF file'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPDFPreview(),
            const SizedBox(height: 30),
            ..._buildButtons(),
          ],
        ),
      ),
    );
  }
}
