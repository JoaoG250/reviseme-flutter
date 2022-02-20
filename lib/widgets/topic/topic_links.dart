import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/widgets/list.dart';
import 'package:reviseme/widgets/topic/topic_link_create.dart';
import 'package:url_launcher/url_launcher.dart';

class TopicLinks extends StatefulWidget {
  final Topic topic;
  const TopicLinks({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  _TopicLinksState createState() => _TopicLinksState();
}

class _TopicLinksState extends State<TopicLinks> {
  TopicService get service => GetIt.I<TopicService>();
  List<TopicLink> _links = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTopicLinks();
  }

  Future<void> _fetchTopicLinks() async {
    setState(() {
      _isLoading = true;
    });

    final links = await service.getTopicLinks({
      'topic': widget.topic.id.toString(),
    });
    setState(() {
      _links = links;
      _isLoading = false;
    });
  }

  Widget _buildListTile(TopicLink link) {
    final _updatedAt = DateTime.parse(link.updatedAt);
    return PaddedListItem(
      child: ListTile(
        title: Text(link.title),
        subtitle: Text(link.url, style: const TextStyle(fontSize: 10)),
        leading: const ListLeadingIcon(icon: Icons.link),
        trailing: Text(_updatedAt.toString().substring(0, 10)),
        onTap: () async {
          final url = link.url;
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not open this link'),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildListItem(TopicLink link) {
    return Dismissible(
      key: ValueKey(link.id),
      child: _buildListTile(link),
      direction: DismissDirection.startToEnd,
      background: const DismissibleBackground(),
      confirmDismiss: (direction) async {
        final result = await showDialog(
          context: context,
          builder: (context) => const ListItemDeleteConfirm(),
        );

        if (result == true) {
          await service.deleteTopicLink(link.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Link deleted'),
            ),
          );
        }

        return result;
      },
    );
  }

  Widget _buildLinkList() {
    return ListView.separated(
      itemCount: _links.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return _buildListItem(_links[index]);
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
              builder: (context) => TopicLinkCreate(topic: widget.topic),
            ),
          );
          _fetchTopicLinks();
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildLinkList(),
    );
  }
}
