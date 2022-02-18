import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/http.dart';
import 'package:reviseme/services/auth.dart';
import 'package:reviseme/utils/valitators.dart';
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
      // TODO: handle http errors
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
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    }
  }

  List<Widget> _buildButtons() {
    return [
      ElevatedButton(
        child: _authMode == AuthMode.login
            ? const Text('Login')
            : const Text('Register'),
        onPressed: _submit,
      ),
      TextButton(
        child: _authMode == AuthMode.login
            ? const Text('Dont have an account? Tap here to register.')
            : const Text('Have an account? Tap here to login.'),
        onPressed: _changeAuthMode,
      ),
    ];
  }

  List<Widget> _buildFormFields() {
    return [
      TextFormField(
        initialValue: _email,
        decoration: const InputDecoration(
          labelText: 'Email',
        ),
        validator: (value) => requiredValidator(value, 'Email'),
        onSaved: (value) => _email = value,
      ),
      _authMode == AuthMode.register
          ? TextFormField(
              initialValue: _firstName,
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
              validator: (value) => requiredValidator(value, 'First Name'),
              onSaved: (value) => _firstName = value,
            )
          : Container(),
      TextFormField(
        initialValue: _password,
        decoration: const InputDecoration(
          labelText: 'Password',
        ),
        validator: (value) => requiredValidator(value, 'Password'),
        onSaved: (value) => _password = value,
        obscureText: true,
      )
    ];
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          ..._buildFormFields(),
          const SizedBox(height: 20.0),
          ..._buildButtons(),
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
