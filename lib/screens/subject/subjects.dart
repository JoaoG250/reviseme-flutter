import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/subject.dart';
import 'package:reviseme/screens/revision_history.dart';
import 'package:reviseme/screens/subject/subject_list.dart';
import 'package:reviseme/screens/subject/subject_modify.dart';
import 'package:reviseme/services/subject.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Subjects extends StatefulWidget {
  const Subjects({Key? key}) : super(key: key);

  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  SubjectService get service => GetIt.I<SubjectService>();
  List<Subject> _subjects = [];
  bool _isLoading = false;
  int _selectedIndex = 0;
  String _title = 'Subjects';

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    setState(() {
      _isLoading = true;
    });

    final subjects = await service.getSubjects();
    setState(() {
      _subjects = subjects;
      _isLoading = false;
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
  }

  List<Widget> _subjectScreens() {
    return [
      SubjectList(
        subjects: _subjects,
        fetchSubjects: _fetchSubjects,
        deleteSubject: service.deleteSubject,
      ),
      const RevisionHistory(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        _title = 'Subjects';
        break;
      case 1:
        _title = 'Revision History';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SubjectModify(),
            ),
          );
          _fetchSubjects();
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _subjectScreens()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Revision History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
