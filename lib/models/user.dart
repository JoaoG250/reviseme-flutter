class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String photo;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.photo,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        photo = json['photo'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'photo': photo,
      };
}
