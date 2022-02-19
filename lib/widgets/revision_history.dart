import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/widgets/list.dart';

class RevisionHistory extends StatefulWidget {
  const RevisionHistory({Key? key}) : super(key: key);

  @override
  State<RevisionHistory> createState() => _RevisionHistoryState();
}

class _RevisionHistoryState extends State<RevisionHistory> {
  TopicService get service => GetIt.I<TopicService>();
  List<TopicRevision> _revisions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTopicRevisions();
  }

  Future<void> _fetchTopicRevisions() async {
    setState(() {
      _isLoading = true;
    });

    final revisions = await service.getTopicRevisionHistory();
    setState(() {
      _revisions = revisions;
      _isLoading = false;
    });
  }

  Widget _buildRevisionTile(
    BuildContext context,
    int index,
  ) {
    final _updatedAt = DateTime.parse(_revisions[index].updatedAt);
    return PaddedListItem(
      child: ListTile(
        title: Text(_revisions[index].topic.name),
        subtitle: Text(_updatedAt.toString().substring(0, 10)),
        leading: const ListLeadingIcon(icon: Icons.history),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
            itemBuilder: _buildRevisionTile,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemCount: _revisions.length,
          );
  }
}
