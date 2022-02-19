import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/http.dart';
import 'package:reviseme/screens/auth.dart';
import 'package:reviseme/screens/home.dart';
import 'package:reviseme/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  AuthService get service => GetIt.I<AuthService>();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    // Get token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } else {
      // Set token to api client singleton
      HttpClient apiClient = GetIt.I<HttpClient>();
      apiClient.setAuthorizationToken(token);

      // Update user info in shared preferences
      final meResponse = await service.me();
      prefs.setInt('userId', meResponse.id);
      prefs.setString('userEmail', meResponse.email);
      prefs.setString('userFirstName', meResponse.firstName);

      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeScreen.routeName,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
