class ChurchModel {
  final String name;
  final DateTime establishedDate;
  final String? logoUrl;
  final String? location;
  final String email;
  final String referenceCode;
  final List<String> verificationDocuments;
  
  // New fields for contact information
  final String churchEmail;
  final String contactEmail;
  final String contactPhone;
  
  // New field for secure account
  final String password;
  
  // New fields for admin information
  final String adminFirstName;
  final String adminLastName;
  final String adminEmail;
  final String adminPhone;
  
  ChurchModel({
    required this.name,
    required this.establishedDate,
    this.logoUrl,
    this.location,
    required this.email,
    required this.referenceCode,
    this.verificationDocuments = const [],
    this.churchEmail = '',
    this.contactEmail = '',
    this.contactPhone = '',
    this.password = '',
    this.adminFirstName = '',
    this.adminLastName = '',
    this.adminEmail = '',
    this.adminPhone = '',
  });
  
  // Copy with method for creating a new instance with updated values
  ChurchModel copyWith({
    String? name,
    DateTime? establishedDate,
    String? logoUrl,
    String? location,
    String? email,
    String? referenceCode,
    List<String>? verificationDocuments,
    String? churchEmail,
    String? contactEmail,
    String? contactPhone,
    String? password,
    String? adminFirstName,
    String? adminLastName,
    String? adminEmail,
    String? adminPhone,
  }) {
    return ChurchModel(
      name: name ?? this.name,
      establishedDate: establishedDate ?? this.establishedDate,
      logoUrl: logoUrl ?? this.logoUrl,
      location: location ?? this.location,
      email: email ?? this.email,
      referenceCode: referenceCode ?? this.referenceCode,
      verificationDocuments: verificationDocuments ?? this.verificationDocuments,
      churchEmail: churchEmail ?? this.churchEmail,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      password: password ?? this.password,
      adminFirstName: adminFirstName ?? this.adminFirstName,
      adminLastName: adminLastName ?? this.adminLastName,
      adminEmail: adminEmail ?? this.adminEmail,
      adminPhone: adminPhone ?? this.adminPhone,
    );
  }
  
  // Convert church model to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'establishedDate': establishedDate.toIso8601String(),
      'logoUrl': logoUrl,
      'location': location,
      'email': email,
      'referenceCode': referenceCode,
      'verificationDocuments': verificationDocuments,
      'churchEmail': churchEmail,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'password': password, // Note: In a real app, you should never store passwords in plain text
      'adminFirstName': adminFirstName,
      'adminLastName': adminLastName,
      'adminEmail': adminEmail,
      'adminPhone': adminPhone,
    };
  }
  
  // Create church model from JSON
  factory ChurchModel.fromJson(Map<String, dynamic> json) {
    return ChurchModel(
      name: json['name'] ?? '',
      establishedDate: json['establishedDate'] != null 
          ? DateTime.parse(json['establishedDate']) 
          : DateTime.now(),
      logoUrl: json['logoUrl'],
      location: json['location'],
      email: json['email'] ?? '',
      referenceCode: json['referenceCode'] ?? '',
      verificationDocuments: List<String>.from(json['verificationDocuments'] ?? []),
      churchEmail: json['churchEmail'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      password: json['password'] ?? '', // Note: In a real app, passwords should be handled securely
      adminFirstName: json['adminFirstName'] ?? '',
      adminLastName: json['adminLastName'] ?? '',
      adminEmail: json['adminEmail'] ?? '',
      adminPhone: json['adminPhone'] ?? '',
    );
  }
  
  // Create an empty church model (useful for initialization)
  factory ChurchModel.empty() {
    return ChurchModel(
      name: '',
      establishedDate: DateTime.now(),
      logoUrl: null,
      location: null,
      email: '',
      referenceCode: '',
      verificationDocuments: [],
      churchEmail: '',
      contactEmail: '',
      contactPhone: '',
      password: '',
      adminFirstName: '',
      adminLastName: '',
      adminEmail: '',
      adminPhone: '',
    );
  }
}