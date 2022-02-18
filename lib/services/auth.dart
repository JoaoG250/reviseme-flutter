import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:reviseme/models/auth.dart';
import 'package:reviseme/models/http.dart';

class AuthService {
  HttpClient get client => GetIt.I<HttpClient>();

  Future<LoginResponse> login(String email, String password) async {
    final response = await client.post('token/login/', {
      'email': email,
      'password': password,
    });
    final jsonData = json.decode(response.body);
    return LoginResponse.fromJson(jsonData);
  }

  Future<RegisterResponse> register(
      String email, String firstName, String password) async {
    final response = await client.post('users/', {
      'email': email,
      'first_name': firstName,
      'password': password,
    });
    final jsonData = json.decode(response.body);
    return RegisterResponse.fromJson(jsonData);
  }

  Future<MeResponse> me() async {
    final response = await client.get('users/me/');
    final jsonData = json.decode(response.body);
    return MeResponse.fromJson(jsonData);
  }
}
