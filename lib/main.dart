import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:reviseme/models/http.dart';
import 'package:reviseme/screens/home.dart';
import 'package:reviseme/screens/auth.dart';
import 'package:reviseme/screens/subject/subjects.dart';
import 'package:reviseme/services/auth.dart';
import 'package:reviseme/services/subject.dart';

void initLocator() {
  const String baseUrl = 'http://192.168.0.100:8000/api/';

  GetIt.I.registerSingleton(HttpClient(baseUrl: baseUrl));
  GetIt.I.registerSingleton<AuthService>(AuthService());
  GetIt.I.registerSingleton<SubjectService>(SubjectService());
}

void main() {
  // Logger config
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    debugPrint('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  // Locator init
  initLocator();

  // Run app
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReviseMe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/auth': (context) => const AuthScreen(),
        '/subjects': (context) => const Subjects(),
      },
    );
  }
}
