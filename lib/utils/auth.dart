import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/http.dart';
import 'package:reviseme/screens/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  // Remove token from api client singleton
  HttpClient apiClient = GetIt.I<HttpClient>();
  apiClient.removeAuthorizationToken();

  await Navigator.of(context).pushNamedAndRemoveUntil(
    AuthScreen.routeName,
    (route) => false,
  );
}
