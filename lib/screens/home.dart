import 'package:flutter/material.dart';
import 'package:reviseme/screens/revision_history.dart';
import 'package:reviseme/screens/subject/subject_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _title = 'Subjects';

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
  }

  static const _screens = <Widget>[
    SubjectList(),
    RevisionHistory(),
  ];

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
      body: _screens.elementAt(_selectedIndex),
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
