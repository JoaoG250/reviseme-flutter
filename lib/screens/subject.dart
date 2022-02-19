import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/subject.dart';
import 'package:reviseme/widgets/subject/subject_revisions.dart';
import 'package:reviseme/widgets/subject/subject_topics.dart';
import 'package:reviseme/services/subject.dart';

class SubjectScreenArguments {
  final int subjectId;

  SubjectScreenArguments(this.subjectId);
}

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({Key? key}) : super(key: key);
  static const routeName = '/subject';

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  SubjectService get service => GetIt.I<SubjectService>();
  int _selectedIndex = 0;
  String _title = 'Subject Revisions';

  List<Widget> _screens(Subject subject) {
    return [
      SubjectRevisions(subject: subject),
      SubjectTopics(subject: subject),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        _title = 'Subject Revisions';
        break;
      case 1:
        _title = 'Subject Topics';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SubjectScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: FutureBuilder(
        future: service.getSubject(args.subjectId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final subject = snapshot.data as Subject;
            return _screens(subject)[_selectedIndex];
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
            icon: Icon(Icons.today),
            label: 'Subject Revisions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Subject Topics',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
