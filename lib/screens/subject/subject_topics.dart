import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/subject.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/widgets/list.dart';
import 'package:reviseme/widgets/topic/topic_modify.dart';

class SubjectTopics extends StatefulWidget {
  final Subject subject;

  const SubjectTopics({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  _SubjectTopicsState createState() => _SubjectTopicsState();
}

class _SubjectTopicsState extends State<SubjectTopics> {
  TopicService get service => GetIt.I<TopicService>();
  List<Topic> _topics = [];
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    _fetchTopics();
  }

  Future<void> _fetchTopics() async {
    setState(() {
      _isLoading = true;
    });

    final topics = await service.getTopics({
      'subject': widget.subject.id.toString(),
    });
    setState(() {
      _topics = topics;
      _isLoading = false;
    });
  }

  Widget _buildTopicTile(
    BuildContext context,
    int index,
  ) {
    return PaddedListItem(
      child: ListTile(
        title: Text(_topics[index].name),
        subtitle: Text(_topics[index].description),
        leading: const ListLeadingIcon(icon: Icons.book),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TopicModify(
                subject: widget.subject,
                topicId: _topics[index].id,
              ),
            ));
            _fetchTopics();
          },
        ),
        onTap: () async {
          // Navigator.pushNamed(
          //   context,
          //   SubjectScreen.routeName,
          //   arguments: SubjectScreenArguments(_topics[index].id),
          // );
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Dismissible(
      key: ValueKey(_topics[index].id),
      child: _buildTopicTile(context, index),
      direction: DismissDirection.startToEnd,
      background: const DismissibleBackground(),
      confirmDismiss: (direction) async {
        final result = await showDialog(
          context: context,
          builder: (context) => const ListItemDeleteConfirm(),
        );

        if (result == true) {
          await service.deleteTopic(_topics[index].id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Topic deleted'),
            ),
          );
        }

        return result;
      },
    );
  }

  Widget _buildList() {
    return ListView.separated(
      itemBuilder: _buildListItem,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: _topics.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TopicModify(subject: widget.subject),
            ),
          );
          _fetchTopics();
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildList(),
    );
  }
}
