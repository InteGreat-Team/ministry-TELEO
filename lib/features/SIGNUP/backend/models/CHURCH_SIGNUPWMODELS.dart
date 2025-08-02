// lib/features/SIGNUP/backend/models/USER_SIGNUPMODELS.dart

class UserSignupData {
  String firstName;
  String lastName;

  UserSignupData({
    this.firstName = '',
    this.lastName = '',
  });

  // Getter for validation
  bool get isValid => firstName.isNotEmpty && lastName.isNotEmpty;

  // You can add methods for validation or conversion here if needed
  // Example: factory UserSignupData.fromJson(Map<String, dynamic> json) { ... }
  // Example: Map<String, dynamic> toJson() { ... }
}
