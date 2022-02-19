import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:reviseme/models/http.dart';
import 'package:reviseme/screens/root.dart';
import 'package:reviseme/screens/auth.dart';
import 'package:reviseme/screens/home.dart';
import 'package:reviseme/screens/subject.dart';
import 'package:reviseme/services/auth.dart';
import 'package:reviseme/services/subject.dart';
import 'package:reviseme/services/topic.dart';

void initLocator() {
  const String baseUrl = 'http://192.168.0.100:8000/api/';

  GetIt.I.registerSingleton(HttpClient(baseUrl: baseUrl));
  GetIt.I.registerSingleton<AuthService>(AuthService());
  GetIt.I.registerSingleton<SubjectService>(SubjectService());
  GetIt.I.registerSingleton<TopicService>(TopicService());
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
        Root.routeName: (context) => const Root(),
        AuthScreen.routeName: (context) => const AuthScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        SubjectScreen.routeName: (context) => const SubjectScreen(),
      },
    );
  }
}
