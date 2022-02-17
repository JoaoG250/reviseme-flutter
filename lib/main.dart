import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:reviseme/models/http.dart';
import 'package:reviseme/screens/subject/subject_list.dart';
import 'package:reviseme/services/subject.dart';

void initLocator() {
  // TODO: Load token from local storage
  const token = '6bee4e52bdfa02e7c03b76eaba84a1b9835c681b';
  final headers = {'Authorization': 'Token $token'};
  final apiClient =
      HttpClient(baseUrl: 'http://192.168.0.100:8000/api/', headers: headers);
  GetIt.I.registerSingleton<SubjectService>(SubjectService(apiClient));
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SubjectList(),
    );
  }
}
