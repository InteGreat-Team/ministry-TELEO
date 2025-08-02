// lib/features/SIGNUP/backend/models/USER_SIGNUPMODELS.dart

class UserSignupData {
  String firstName;
  String lastName;
  DateTime? birthday;
  String? gender;
  String? username;
  String? address;
  double? lat;
  double? lng;
  String email; // NEW: Added email field
  String password; // NEW: Added password field

  UserSignupData({
    this.firstName = '',
    this.lastName = '',
    this.birthday,
    this.gender,
    this.username,
    this.address,
    this.lat,
    this.lng,
    this.email = '', // Initialize email
    this.password = '', // Initialize password
  });

  // Getter for validation (updated to include email and password)
  bool get isValid =>
      firstName.isNotEmpty &&
      lastName.isNotEmpty &&
      birthday != null &&
      gender != null &&
      username != null &&
      username!.isNotEmpty &&
      address != null &&
      address!.isNotEmpty &&
      lat != null &&
      lng != null &&
      email.isNotEmpty && // NEW: Validate email
      password.isNotEmpty; // NEW: Validate password

  // You can add methods for validation or conversion here if needed
  // Example: factory UserSignupData.fromJson(Map<String, dynamic> json) { ... }
  // Example: Map<String, dynamic> toJson() { ... }
}
