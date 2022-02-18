import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/http.dart';
import 'package:reviseme/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        '/auth',
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

      Navigator.pushNamed(context, '/subjects');
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
