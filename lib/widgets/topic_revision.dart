import 'package:flutter/material.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/styles/styles.dart';
import 'package:reviseme/widgets/list.dart';

class TopicRevisionList extends StatelessWidget {
  final List<TopicRevision> revisions;
  const TopicRevisionList({
    Key? key,
    required this.revisions,
  }) : super(key: key);

  Widget _buildRevisionTile(
    BuildContext context,
    int index,
  ) {
    return PaddedListItem(
      child: ListTile(
        title: Text(revisions[index].topic.name),
        subtitle: Text(revisions[index].revisionDate),
        leading: const ListLeadingIcon(icon: Icons.today),
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      itemBuilder: _buildRevisionTile,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: revisions.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildList();
  }
}

class TopicRevisionProgress extends StatelessWidget {
  final double progress;
  const TopicRevisionProgress({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            (progress).toStringAsFixed(2) + '%',
            style: Styles.header,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: LinearProgressIndicator(
            value: progress / 100,
          ),
        ),
        Center(
          child: Text(
            'Progress: ${(progress).toStringAsFixed(2)}%',
          ),
        )
      ],
    );
  }
}
