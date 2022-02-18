import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/http.dart';
import 'package:reviseme/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthMode {
  login,
  register,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthService get service => GetIt.I<AuthService>();

  final _formKey = GlobalKey<FormState>();

  AuthMode _authMode = AuthMode.login;
  String? _email;
  String? _firstName;
  String? _password;

  void _changeAuthMode() {
    setState(() {
      if (_authMode == AuthMode.login) {
        _authMode = AuthMode.register;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  void _handleLoginSuccess(String token) async {
    // Save user token to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);

    // Set token to api client singleton
    HttpClient apiClient = GetIt.I<HttpClient>();
    apiClient.setAuthorizationToken(token);

    // Set user info to shared preferences
    final meResponse = await service.me();
    prefs.setInt('userId', meResponse.id);
    prefs.setString('userEmail', meResponse.email);
    prefs.setString('userFirstName', meResponse.firstName);
  }

  void _submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (_authMode == AuthMode.login) {
        // Log user in
        final loginResponse = await service.login(_email!, _password!);
        _handleLoginSuccess(loginResponse.authToken);
      } else {
        // Sign user up
        await service.register(
          _email!,
          _firstName!,
          _password!,
        );

        // Log user in
        final loginResponse = await service.login(_email!, _password!);
        _handleLoginSuccess(loginResponse.authToken);
      }
      Navigator.pushNamed(
        context,
        '/subjects',
      );
    }
  }

  Widget _buildButtons() {
    if (_authMode == AuthMode.login) {
      return Column(
        children: <Widget>[
          ElevatedButton(
            child: const Text('Login'),
            onPressed: _submit,
          ),
          TextButton(
            child: const Text('Dont have an account? Tap here to register.'),
            onPressed: _changeAuthMode,
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          ElevatedButton(
            child: const Text('Register'),
            onPressed: _submit,
          ),
          TextButton(
            child: const Text('Have an account? Click here to login.'),
            onPressed: _changeAuthMode,
          )
        ],
      );
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: _email,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              return null;
            },
            onSaved: (value) => _email = value,
          ),
          _authMode == AuthMode.register
              ? TextFormField(
                  initialValue: _firstName,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First Name is required';
                    }
                    return null;
                  },
                  onSaved: (value) => _firstName = value,
                )
              : Container(),
          TextFormField(
            initialValue: _password,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
            onSaved: (value) => _password = value,
            obscureText: true,
          ),
          const SizedBox(height: 12.0),
          _buildButtons(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _authMode == AuthMode.login
            ? const Text('Login')
            : const Text('Create account'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: _buildForm(),
      ),
    );
  }
}
