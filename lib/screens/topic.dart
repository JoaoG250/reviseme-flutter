import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/topic.dart';
import 'package:reviseme/services/topic.dart';
import 'package:reviseme/widgets/topic/create_material.dart';
import 'package:reviseme/widgets/topic/topic_description.dart';

class TopicScreenArguments {
  final int topicId;

  TopicScreenArguments(this.topicId);
}

class TopicScreen extends StatefulWidget {
  const TopicScreen({Key? key}) : super(key: key);
  static const routeName = '/topic';

  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  TopicService get service => GetIt.I<TopicService>();
  int _selectedIndex = 0;
  String _title = 'Topic';

  List<Widget> _screens(Topic topic) {
    return [
      TopicDescription(topic: topic),
      CreateMaterial(topic: topic),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        _title = 'Topic Description';
        break;
      case 1:
        _title = 'Create Study Material';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TopicScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: FutureBuilder(
        future: service.getTopic(args.topicId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final topic = snapshot.data as Topic;
            return _screens(topic)[_selectedIndex];
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Description',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create Study Material',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
