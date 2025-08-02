// user_model.dart
class UserModel {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String email;
  final String? phoneNumber;
  final String address;
  final double lat;
  final double lng;
  final String? profilePictureUrl;
  final bool hasAcceptedTerms;
  final bool isEmailVerified;
  final String password;
  final String userRole;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.email,
    this.phoneNumber,
    required this.address,
    required this.lat,
    required this.lng,
    this.profilePictureUrl,
    required this.hasAcceptedTerms,
    required this.isEmailVerified,
    required this.password,
    this.userRole = 'user', // <-- Default value
  });

  Map<String, dynamic> toJson() {
  final data = {
    'first_name': firstName,
    'last_name': lastName,
    'birthday': birthday.toIso8601String(),
    'gender': gender,
    'username': username,
    'email_address': email,
    'phone_number': phoneNumber,
    'location_address': address,
    'location_lat': lat,
    'location_lng': lng,
    'password': password,
    'role': userRole,
    'has_accepted_terms': hasAcceptedTerms,
    'is_email_verified': isEmailVerified,
  };

  // Only include profile_picture_url if not null and not empty
  if (profilePictureUrl != null && profilePictureUrl!.isNotEmpty) {
    data['profile_picture_url'] = profilePictureUrl;
  }

  return data;
}

}
