import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/styles/styles.dart';
import 'package:reviseme/widgets/list.dart';

class TopicInformation extends StatefulWidget {
  final Topic topic;
  const TopicInformation({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  State<TopicInformation> createState() => _TopicInformationState();
}

class _TopicInformationState extends State<TopicInformation> {
  TopicService get service => GetIt.I<TopicService>();
  List<TopicRevision> _revisions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTopicRevisions();
  }

  Future<void> _fetchTopicRevisions() async {
    setState(() {
      isLoading = true;
    });

    final revisions = await service.getTopicRevisions({
      'topic': widget.topic.id.toString(),
    });

    // If revisions is not empty get the last revision
    if (revisions.isNotEmpty) {
      final revision = revisions.last;

      // Start generated list with the revisions
      List<TopicRevision> generatedRevisions = [
        ...revisions,
      ];

      // Get the next revision meta data
      final revisionDate = DateTime.parse(revision.revisionDate);
      Map<String, DateTime>? nextRevisionMeta;
      nextRevisionMeta = _getNextRevisionMeta(revision.phase, revisionDate);

      // Create next revision object and add it to the list
      while (nextRevisionMeta != null) {
        final nextRevisionPhase = nextRevisionMeta.keys.first;
        final nextRevisionDate = nextRevisionMeta[nextRevisionPhase];
        final nextRevision = TopicRevision(
          id: hashCode,
          phase: nextRevisionPhase,
          revisionDate: nextRevisionDate.toString().substring(0, 10),
          complete: false,
          topic: widget.topic,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        );
        generatedRevisions.add(nextRevision);
        nextRevisionMeta = _getNextRevisionMeta(
          nextRevisionPhase,
          nextRevisionDate!,
        );
      }

      setState(() {
        _revisions = generatedRevisions;
        isLoading = false;
      });
    }
  }

  Map<String, DateTime>? _getNextRevisionMeta(
    String phase,
    DateTime revisionDate,
  ) {
    DateTime? nextRevisionDate;
    String? nextPhase;
    if (phase == '1D') {
      nextPhase = '7D';
      nextRevisionDate = revisionDate.add(
        const Duration(days: 7),
      );
    } else if (phase == '7D') {
      nextPhase = '30D';
      nextRevisionDate = revisionDate.add(
        const Duration(days: 30),
      );
    } else if (phase == '30D') {
      nextPhase = '90D';
      nextRevisionDate = revisionDate.add(
        const Duration(days: 90),
      );
    } else if (phase == '90D') {
      return null;
    } else {
      throw Exception('Invalid phase');
    }

    return {
      nextPhase: nextRevisionDate,
    };
  }

  Widget _buildListItem(TopicRevision revision) {
    return PaddedListItem(
      child: ListTile(
        title: Text(revision.revisionDate),
        leading: const ListLeadingIcon(icon: Icons.today),
        trailing: Checkbox(
          value: revision.complete,
          onChanged: null,
        ),
      ),
    );
  }

  Widget _buildRevisionList() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return _buildListItem(_revisions[index]);
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: _revisions.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Complete'),
        icon: const Icon(Icons.check),
        onPressed: () async {
          await service.completeTopicRevision(widget.topic.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Revision marked as complete'),
            ),
          );
          await _fetchTopicRevisions();
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 26),
            child: Text(widget.topic.name, style: Styles.header),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(children: [
              Text(widget.topic.description),
              const SizedBox(height: 40),
              const Text(
                'Next Revisions',
                style: Styles.subHeader,
              ),
            ]),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(40),
                    child: _buildRevisionList(),
                  ),
          )
        ],
      ),
    );
  }
}
