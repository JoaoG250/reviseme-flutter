class LoginResponse {
  final String authToken;

  LoginResponse({
    required this.authToken,
  });

  LoginResponse.fromJson(Map<String, dynamic> json)
      : authToken = json['authToken'];
}

class RegisterResponse {
  final int id;
  final String email;
  final String firstName;

  RegisterResponse({
    required this.id,
    required this.email,
    required this.firstName,
  });

  RegisterResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        firstName = json['firstName'];
}

class MeResponse {
  final int id;
  final String email;
  final String firstName;
  final String lastName;

  MeResponse({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  MeResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        firstName = json['firstName'],
        lastName = json['lastName'];
}
