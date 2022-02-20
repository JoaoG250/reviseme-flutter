import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/widgets/image.dart';
import 'package:reviseme/widgets/list.dart';
import 'package:reviseme/widgets/topic/topic_image_create.dart';

class TopicImages extends StatefulWidget {
  final Topic topic;
  const TopicImages({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  _TopicImagesState createState() => _TopicImagesState();
}

class _TopicImagesState extends State<TopicImages> {
  TopicService get service => GetIt.I<TopicService>();
  List<TopicFile> _files = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTopicImages();
  }

  Future<void> _fetchTopicImages() async {
    setState(() {
      _isLoading = true;
    });

    final files = await service.getTopicFiles({
      'topic': widget.topic.id.toString(),
      'file_type': 'IMAGE',
    });
    setState(() {
      _files = files;
      _isLoading = false;
    });
  }

  Widget _buildListItem(int index) {
    final dismissDirection = index % 2 == 0
        ? DismissDirection.endToStart
        : DismissDirection.startToEnd;
    final file = _files[index];
    return GestureDetector(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => ImageDialog(imageUrl: file.file),
        );
      },
      child: Dismissible(
        key: ValueKey(file.id),
        direction: dismissDirection,
        child: Card(
          child: Image.network(file.file, fit: BoxFit.cover),
        ),
        confirmDismiss: (direction) async {
          final result = await showDialog(
            context: context,
            builder: (context) => const ListItemDeleteConfirm(),
          );

          if (result == true) {
            await service.deleteTopicFile(file.id);

            // Remove the item from _files
            setState(() {
              _files.removeAt(index);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File deleted'),
              ),
            );
          }

          return result;
        },
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(
        _files.length,
        (index) => _buildListItem(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TopicImageCreate(topic: widget.topic),
            ),
          );
          _fetchTopicImages();
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildGrid(),
      ),
    );
  }
}
