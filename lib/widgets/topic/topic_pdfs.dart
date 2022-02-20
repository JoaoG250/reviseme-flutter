import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/widgets/list.dart';
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

  Widget _buildListTile(TopicFile file) {
    final fileName = file.file.split('/').last;
    final _updatedAt = DateTime.parse(file.updatedAt);
    return PaddedListItem(
      child: ListTile(
        title: Text(fileName),
        subtitle: Text(_updatedAt.toString().substring(0, 10)),
        leading: const ListLeadingIcon(icon: Icons.picture_as_pdf),
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
    );
  }

  Widget _buildListItem(TopicFile file) {
    return Dismissible(
      key: ValueKey(file.id),
      child: _buildListTile(file),
      direction: DismissDirection.startToEnd,
      background: const DismissibleBackground(),
      confirmDismiss: (direction) async {
        final result = await showDialog(
          context: context,
          builder: (context) => const ListItemDeleteConfirm(),
        );

        if (result == true) {
          await service.deleteTopicFile(file.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File deleted'),
            ),
          );
        }

        return result;
      },
    );
  }

  Widget _buildPDFList() {
    return ListView.separated(
      itemCount: _files.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return _buildListItem(_files[index]);
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
