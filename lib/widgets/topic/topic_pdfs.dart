import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/widgets/topic/topic_pdf_create.dart';
import 'package:url_launcher/url_launcher.dart';

class TopicPdfs extends StatefulWidget {
  final Topic topic;
  const TopicPdfs({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  _TopicPdfsState createState() => _TopicPdfsState();
}

class _TopicPdfsState extends State<TopicPdfs> {
  TopicService get service => GetIt.I<TopicService>();
  List<TopicFile> _files = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTopicPDFs();
  }

  Future<void> _fetchTopicPDFs() async {
    setState(() {
      _isLoading = true;
    });

    final files = await service.getTopicFiles({
      'topic': widget.topic.id.toString(),
      'file_type': 'PDF',
    });
    setState(() {
      _files = files;
      _isLoading = false;
    });
  }

  Widget _buildPDFList() {
    return ListView.builder(
      itemCount: _files.length,
      itemBuilder: (context, index) {
        final file = _files[index];
        final fileName = file.file.split('/').last;
        final _updatedAt = DateTime.parse(file.updatedAt);
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 5,
          ),
          child: Card(
            child: ListTile(
              title: Text(fileName),
              subtitle: Text(
                file.file,
                style: const TextStyle(fontSize: 10),
              ),
              trailing: Text(_updatedAt.toString().substring(0, 10)),
              onTap: () async {
                final url = file.file;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not open this file'),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TopicPdfCreate(topic: widget.topic),
            ),
          );
          _fetchTopicPDFs();
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildPDFList(),
    );
  }
}
