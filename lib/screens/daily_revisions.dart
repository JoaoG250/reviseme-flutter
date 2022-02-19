import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/styles/styles.dart';
import 'package:reviseme/widgets/list.dart';

class DailyRevisions extends StatefulWidget {
  const DailyRevisions({Key? key}) : super(key: key);

  @override
  _DailyRevisionsState createState() => _DailyRevisionsState();
}

class _DailyRevisionsState extends State<DailyRevisions> {
  TopicService get service => GetIt.I<TopicService>();
  List<TopicRevision> _revisions = [];
  double _progress = 0.0;
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

    final revisions = await service.getDailyTopicRevisions();
    final progress = await service.getTopicRevisionsProgress();
    setState(() {
      _revisions = revisions;
      _progress = progress;
      _isLoading = false;
    });
  }

  Widget _buildRevisionTile(
    BuildContext context,
    int index,
  ) {
    return PaddedListItem(
      child: ListTile(
        title: Text(_revisions[index].topic.name),
        subtitle: Text(_revisions[index].revisionDate),
        leading: const ListLeadingIcon(icon: Icons.today),
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      itemBuilder: _buildRevisionTile,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: _revisions.length,
    );
  }

  Widget _buildProgress() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            (_progress).toStringAsFixed(2) + '%',
            style: Styles.header,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: LinearProgressIndicator(
            value: _progress / 100,
          ),
        ),
        Center(
          child: Text(
            'Progress: ${(_progress).toStringAsFixed(2)}%',
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                flex: 8,
                child: _buildList(),
              ),
              Expanded(
                flex: 2,
                child: _buildProgress(),
              ),
            ],
          );
  }
}
