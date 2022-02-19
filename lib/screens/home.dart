import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/http.dart';
import 'package:reviseme/screens/auth.dart';
import 'package:reviseme/widgets/daily_revisions.dart';
import 'package:reviseme/widgets/revision_history.dart';
import 'package:reviseme/widgets/subject/subject_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  String _title = 'Subjects';

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Remove token from api client singleton
    HttpClient apiClient = GetIt.I<HttpClient>();
    apiClient.removeAuthorizationToken();

    Navigator.of(context).pushNamedAndRemoveUntil(
      AuthScreen.routeName,
      (route) => false,
    );
  }

  static const _screens = <Widget>[
    DailyRevisions(),
    SubjectList(),
    RevisionHistory(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        _title = 'Daily Revisions';
        break;
      case 1:
        _title = 'Subjects';
        break;
      case 2:
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
            icon: Icon(Icons.today),
            label: 'Daily Revisions',
          ),
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
