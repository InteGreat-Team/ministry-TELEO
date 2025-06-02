
class UserModel {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String email;
  final String phone;
  final String? profilePictureUrl;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.email,
    required this.phone,
    this.profilePictureUrl,
  });

  // Convert user model to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday.toIso8601String(),
      'gender': gender,
      'username': username,
      'email': email,
      'phone': phone,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  // Create user model from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthday: DateTime.parse(json['birthday']),
      gender: json['gender'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      profilePictureUrl: json['profilePictureUrl'],
    );
  }
}