import 'dart:io';
import 'package:flutter/material.dart';

// Enums - Define first to avoid reference issues
enum VerificationStatus {
  pending,
  inProgress,
  verified,
  rejected,
}

enum DocumentType {
  secCertificate,
  statementOfFaith,
  churchPhoto,
  other,
}

enum PasswordStrength {
  none,
  weak,
  fair,
  good,
  strong,
  veryStrong,
}

enum StepStatus {
  notStarted,
  inProgress,
  completed,
  skipped,
}

enum ApplicationStatus {
  pending,
  underReview,
  approved,
  rejected,
  moreInfoRequired,
}

// Main Church Model - Optimized
class ChurchModel {
  // Basic Information
  String? churchName;
  String? denomination;
  String? address;
  String? city;
  String? state;
  String? zipCode;
  String? country;
  String? phoneNumber;
  String? email;
  String? website;
  
  // Pastor Information
  String? pastorName;
  String? pastorEmail;
  String? pastorPhone;
  int? yearsInMinistry;
  
  // Church Details
  int? membershipSize;
  int? yearEstablished;
  String? serviceSchedule;
  List<String> ministries;
  String? missionStatement;
  
  // Admin Information
  List<AdminModel> admins;
  
  // Verification Documents
  List<VerificationDocument> documents;
  List<File> churchPhotos;
  VerificationStatus verificationStatus;
  
  // Application Tracking
  String? referenceCode;
  DateTime? submissionDate;
  ApprovalStatusModel? approvalStatus;
  String? approvalNotes;
  DateTime? approvalDate;
  
  // Progress Tracking
  double completionPercentage;
  List<String> completedSections;
  List<String> pendingSections;

  ChurchModel({
    this.churchName,
    this.denomination,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.phoneNumber,
    this.email,
    this.website,
    this.pastorName,
    this.pastorEmail,
    this.pastorPhone,
    this.yearsInMinistry,
    this.membershipSize,
    this.yearEstablished,
    this.serviceSchedule,
    this.ministries = const [],
    this.missionStatement,
    this.admins = const [],
    this.documents = const [],
    this.churchPhotos = const [],
    this.verificationStatus = VerificationStatus.pending,
    this.referenceCode,
    this.submissionDate,
    this.approvalStatus,
    this.approvalNotes,
    this.approvalDate,
    this.completionPercentage = 0.0,
    this.completedSections = const [],
    this.pendingSections = const [],
  });

  // Optimized completion calculation
  double calculateCompletionPercentage() {
    const requiredFields = [
      'churchName', 'denomination', 'address', 'city', 'state', 'zipCode',
      'phoneNumber', 'email', 'pastorName', 'pastorEmail', 'pastorPhone',
      'yearsInMinistry', 'membershipSize', 'yearEstablished', 'serviceSchedule',
      'ministries', 'missionStatement', 'admins', 'documents', 'churchPhotos'
    ];
    
    int completedFields = 0;
    
    if (_isNotEmpty(churchName)) completedFields++;
    if (_isNotEmpty(denomination)) completedFields++;
    if (_isNotEmpty(address)) completedFields++;
    if (_isNotEmpty(city)) completedFields++;
    if (_isNotEmpty(state)) completedFields++;
    if (_isNotEmpty(zipCode)) completedFields++;
    if (_isNotEmpty(phoneNumber)) completedFields++;
    if (_isNotEmpty(email)) completedFields++;
    if (_isNotEmpty(pastorName)) completedFields++;
    if (_isNotEmpty(pastorEmail)) completedFields++;
    if (_isNotEmpty(pastorPhone)) completedFields++;
    if (yearsInMinistry != null && yearsInMinistry! >= 0) completedFields++;
    if (membershipSize != null && membershipSize! > 0) completedFields++;
    if (yearEstablished != null && yearEstablished! > 1800) completedFields++;
    if (_isNotEmpty(serviceSchedule)) completedFields++;
    if (ministries.isNotEmpty) completedFields++;
    if (_isNotEmpty(missionStatement)) completedFields++;
    if (admins.isNotEmpty) completedFields++;
    if (documents.length >= 2) completedFields++;
    if (churchPhotos.isNotEmpty) completedFields++;
    
    return (completedFields / requiredFields.length) * 100;
  }

  bool _isNotEmpty(String? value) => value?.trim().isNotEmpty == true;

  // Optimized reference code generation
  String generateReferenceCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final churchCode = (churchName?.length ?? 0) >= 2 
        ? churchName!.substring(0, 2).toUpperCase() 
        : 'CH';
    return 'CH$churchCode${timestamp.toString().substring(timestamp.toString().length - 6)}';
  }

  // Consolidated validation getters
  bool get isBasicInfoComplete => _isNotEmpty(churchName) && 
      _isNotEmpty(denomination) && _isNotEmpty(address) && 
      _isNotEmpty(city) && _isNotEmpty(state) && _isNotEmpty(zipCode) && 
      _isNotEmpty(phoneNumber) && _isNotEmpty(email);

  bool get isPastorInfoComplete => _isNotEmpty(pastorName) && 
      _isNotEmpty(pastorEmail) && _isNotEmpty(pastorPhone) && 
      yearsInMinistry != null && yearsInMinistry! >= 0;

  bool get isChurchDetailsComplete => membershipSize != null && 
      membershipSize! > 0 && yearEstablished != null && 
      yearEstablished! > 1800 && _isNotEmpty(serviceSchedule) && 
      ministries.isNotEmpty && _isNotEmpty(missionStatement);

  bool get isAdminInfoComplete => admins.isNotEmpty && 
      admins.every((admin) => admin.isComplete);

  bool get isVerificationComplete => documents.length >= 2 && 
      churchPhotos.isNotEmpty && documents.every((doc) => doc.isValid);

  bool get isReadyForSubmission => isBasicInfoComplete && 
      isPastorInfoComplete && isChurchDetailsComplete && 
      isAdminInfoComplete && isVerificationComplete;

  // Optimized JSON serialization
  Map<String, dynamic> toJson() => {
    'churchName': churchName,
    'denomination': denomination,
    'address': address,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'country': country,
    'phoneNumber': phoneNumber,
    'email': email,
    'website': website,
    'pastorName': pastorName,
    'pastorEmail': pastorEmail,
    'pastorPhone': pastorPhone,
    'yearsInMinistry': yearsInMinistry,
    'membershipSize': membershipSize,
    'yearEstablished': yearEstablished,
    'serviceSchedule': serviceSchedule,
    'ministries': ministries,
    'missionStatement': missionStatement,
    'admins': admins.map((admin) => admin.toJson()).toList(),
    'documents': documents.map((doc) => doc.toJson()).toList(),
    'churchPhotos': churchPhotos.map((photo) => photo.path).toList(),
    'verificationStatus': verificationStatus.name,
    'referenceCode': referenceCode,
    'submissionDate': submissionDate?.toIso8601String(),
    'approvalStatus': approvalStatus?.toJson(),
    'approvalNotes': approvalNotes,
    'approvalDate': approvalDate?.toIso8601String(),
    'completionPercentage': completionPercentage,
    'completedSections': completedSections,
    'pendingSections': pendingSections,
  };

  factory ChurchModel.fromJson(Map<String, dynamic> json) => ChurchModel(
    churchName: json['churchName'],
    denomination: json['denomination'],
    address: json['address'],
    city: json['city'],
    state: json['state'],
    zipCode: json['zipCode'],
    country: json['country'],
    phoneNumber: json['phoneNumber'],
    email: json['email'],
    website: json['website'],
    pastorName: json['pastorName'],
    pastorEmail: json['pastorEmail'],
    pastorPhone: json['pastorPhone'],
    yearsInMinistry: json['yearsInMinistry'],
    membershipSize: json['membershipSize'],
    yearEstablished: json['yearEstablished'],
    serviceSchedule: json['serviceSchedule'],
    ministries: List<String>.from(json['ministries'] ?? []),
    missionStatement: json['missionStatement'],
    admins: (json['admins'] as List?)?.map((admin) => AdminModel.fromJson(admin)).toList() ?? [],
    documents: (json['documents'] as List?)?.map((doc) => VerificationDocument.fromJson(doc)).toList() ?? [],
    churchPhotos: (json['churchPhotos'] as List?)?.map((photo) => File(photo)).toList() ?? [],
    verificationStatus: VerificationStatus.values.firstWhere(
      (status) => status.name == json['verificationStatus'],
      orElse: () => VerificationStatus.pending,
    ),
    referenceCode: json['referenceCode'],
    submissionDate: json['submissionDate'] != null ? DateTime.parse(json['submissionDate']) : null,
    approvalStatus: json['approvalStatus'] != null ? ApprovalStatusModel.fromJson(json['approvalStatus']) : null,
    approvalNotes: json['approvalNotes'],
    approvalDate: json['approvalDate'] != null ? DateTime.parse(json['approvalDate']) : null,
    completionPercentage: (json['completionPercentage'] ?? 0.0).toDouble(),
    completedSections: List<String>.from(json['completedSections'] ?? []),
    pendingSections: List<String>.from(json['pendingSections'] ?? []),
  );
}

// Optimized Admin Model
class AdminModel {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? role;
  final String? hashedPassword;
  final DateTime? createdAt;
  final bool isActive;
  final SecuritySettings? securitySettings;

  const AdminModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.role,
    this.hashedPassword,
    this.createdAt,
    this.isActive = true,
    this.securitySettings,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
  
  bool get isComplete => firstName?.trim().isNotEmpty == true &&
      lastName?.trim().isNotEmpty == true &&
      email?.trim().isNotEmpty == true &&
      phoneNumber?.trim().isNotEmpty == true &&
      role?.trim().isNotEmpty == true &&
      hashedPassword?.trim().isNotEmpty == true;

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phoneNumber': phoneNumber,
    'role': role,
    'hashedPassword': hashedPassword,
    'createdAt': createdAt?.toIso8601String(),
    'isActive': isActive,
    'securitySettings': securitySettings?.toJson(),
  };

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
    phoneNumber: json['phoneNumber'],
    role: json['role'],
    hashedPassword: json['hashedPassword'],
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    isActive: json['isActive'] ?? true,
    securitySettings: json['securitySettings'] != null ? SecuritySettings.fromJson(json['securitySettings']) : null,
  );
}

// Optimized Security Settings
class SecuritySettings {
  final bool twoFactorEnabled;
  final DateTime? lastPasswordChange;
  final int failedLoginAttempts;
  final DateTime? lastLoginAttempt;
  final bool accountLocked;

  const SecuritySettings({
    this.twoFactorEnabled = false,
    this.lastPasswordChange,
    this.failedLoginAttempts = 0,
    this.lastLoginAttempt,
    this.accountLocked = false,
  });

  Map<String, dynamic> toJson() => {
    'twoFactorEnabled': twoFactorEnabled,
    'lastPasswordChange': lastPasswordChange?.toIso8601String(),
    'failedLoginAttempts': failedLoginAttempts,
    'lastLoginAttempt': lastLoginAttempt?.toIso8601String(),
    'accountLocked': accountLocked,
  };

  factory SecuritySettings.fromJson(Map<String, dynamic> json) => SecuritySettings(
    twoFactorEnabled: json['twoFactorEnabled'] ?? false,
    lastPasswordChange: json['lastPasswordChange'] != null ? DateTime.parse(json['lastPasswordChange']) : null,
    failedLoginAttempts: json['failedLoginAttempts'] ?? 0,
    lastLoginAttempt: json['lastLoginAttempt'] != null ? DateTime.parse(json['lastLoginAttempt']) : null,
    accountLocked: json['accountLocked'] ?? false,
  );
}

// Optimized Verification Document
class VerificationDocument {
  final String? fileName;
  final String? filePath;
  final DocumentType type;
  final int? fileSize;
  final DateTime? uploadDate;
  final bool isVerified;
  final String? verificationNotes;

  const VerificationDocument({
    this.fileName,
    this.filePath,
    required this.type,
    this.fileSize,
    this.uploadDate,
    this.isVerified = false,
    this.verificationNotes,
  });

  bool get isValid => fileName?.trim().isNotEmpty == true &&
      filePath?.trim().isNotEmpty == true &&
      fileSize != null && fileSize! > 0;

  String get displayName {
    switch (type) {
      case DocumentType.secCertificate: return 'SEC Certificate';
      case DocumentType.statementOfFaith: return 'Statement of Faith';
      case DocumentType.churchPhoto: return 'Church Photo';
      case DocumentType.other: return 'Other Document';
    }
  }

  Map<String, dynamic> toJson() => {
    'fileName': fileName,
    'filePath': filePath,
    'type': type.name,
    'fileSize': fileSize,
    'uploadDate': uploadDate?.toIso8601String(),
    'isVerified': isVerified,
    'verificationNotes': verificationNotes,
  };

  factory VerificationDocument.fromJson(Map<String, dynamic> json) => VerificationDocument(
    fileName: json['fileName'],
    filePath: json['filePath'],
    type: DocumentType.values.firstWhere(
      (type) => type.name == json['type'],
      orElse: () => DocumentType.other,
    ),
    fileSize: json['fileSize'],
    uploadDate: json['uploadDate'] != null ? DateTime.parse(json['uploadDate']) : null,
    isVerified: json['isVerified'] ?? false,
    verificationNotes: json['verificationNotes'],
  );
}

// Optimized Password Validation
class PasswordValidation {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSpecialChar;
  final PasswordStrength strength;

  const PasswordValidation({
    this.hasMinLength = false,
    this.hasUppercase = false,
    this.hasLowercase = false,
    this.hasNumber = false,
    this.hasSpecialChar = false,
    this.strength = PasswordStrength.weak,
  });

  bool get isValid => hasMinLength && hasUppercase && hasLowercase && hasNumber;
  
  int get score => [hasMinLength, hasUppercase, hasLowercase, hasNumber, hasSpecialChar]
      .where((requirement) => requirement).length;

  // Static validation methods
  static bool isValidPassword(String password) => 
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);

  static PasswordStrength getPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;
    
    final score = [
      password.length >= 8,
      RegExp(r'[A-Z]').hasMatch(password),
      RegExp(r'[a-z]').hasMatch(password),
      RegExp(r'\d').hasMatch(password),
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
    ].where((req) => req).length;

    switch (score) {
      case 0: case 1: return PasswordStrength.weak;
      case 2: return PasswordStrength.fair;
      case 3: return PasswordStrength.good;
      case 4: return PasswordStrength.strong;
      case 5: return PasswordStrength.veryStrong;
      default: return PasswordStrength.weak;
    }
  }

  static String? validatePassword(String? value) {
    if (value?.trim().isEmpty ?? true) return 'Password is required';
    if (!isValidPassword(value!)) {
      return 'Password must be at least 8 characters with 1 uppercase, 1 lowercase, and 1 digit';
    }
    return null;
  }
}

// Optimized Form Validation
class FormValidation {
  final Map<String, String> errors;
  final bool isValid;

  const FormValidation({
    this.errors = const {},
    this.isValid = false,
  });

  String? getError(String field) => errors[field];
  bool hasError(String field) => errors.containsKey(field);

  // Static validation methods
  static bool isEmailValid(String email) => 
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  
  static bool isPhoneValid(String phone) => 
      RegExp(r'^\+?[\d\s\-()]{10,}$').hasMatch(phone);

  static String? validateEmail(String? value) {
    if (value?.trim().isEmpty ?? true) return 'Email is required';
    if (!isEmailValid(value!)) return 'Please enter a valid email address';
    return null;
  }

  static String? validatePhone(String? value) {
    if (value?.trim().isEmpty ?? true) return 'Phone number is required';
    if (!isPhoneValid(value!)) return 'Please enter a valid phone number';
    return null;
  }
}

// Optimized Progress Model
class ProgressModel {
  final int currentStep;
  final int totalSteps;
  final double overallProgress;

  const ProgressModel({
    this.currentStep = 1,
    this.totalSteps = 9,
    this.overallProgress = 0.0,
  });

  double get progressPercentage => (currentStep / totalSteps) * 100;
  bool get isComplete => currentStep >= totalSteps;
}

// Optimized Approval Status Model
class ApprovalStatusModel {
  final String referenceCode;
  final ApplicationStatus status;
  final String statusMessage;
  final DateTime lastUpdated;
  final List<StatusUpdate> updates;
  final String? rejectionReason;
  final DateTime? approvalDate;
  final String? approverName;

  const ApprovalStatusModel({
    required this.referenceCode,
    required this.status,
    required this.statusMessage,
    required this.lastUpdated,
    this.updates = const [],
    this.rejectionReason,
    this.approvalDate,
    this.approverName,
  });

  bool get isApproved => status == ApplicationStatus.approved;
  bool get isPending => status == ApplicationStatus.pending;
  bool get isRejected => status == ApplicationStatus.rejected;
  bool get isUnderReview => status == ApplicationStatus.underReview;

  String get displayStatus {
    switch (status) {
      case ApplicationStatus.pending: return 'Pending Review';
      case ApplicationStatus.underReview: return 'Under Review';
      case ApplicationStatus.approved: return 'Approved';
      case ApplicationStatus.rejected: return 'Rejected';
      case ApplicationStatus.moreInfoRequired: return 'More Information Required';
    }
  }

  Map<String, dynamic> toJson() => {
    'referenceCode': referenceCode,
    'status': status.name,
    'statusMessage': statusMessage,
    'lastUpdated': lastUpdated.toIso8601String(),
    'updates': updates.map((update) => update.toJson()).toList(),
    'rejectionReason': rejectionReason,
    'approvalDate': approvalDate?.toIso8601String(),
    'approverName': approverName,
  };

  factory ApprovalStatusModel.fromJson(Map<String, dynamic> json) => ApprovalStatusModel(
    referenceCode: json['referenceCode'],
    status: ApplicationStatus.values.firstWhere((status) => status.name == json['status']),
    statusMessage: json['statusMessage'],
    lastUpdated: DateTime.parse(json['lastUpdated']),
    updates: (json['updates'] as List?)?.map((update) => StatusUpdate.fromJson(update)).toList() ?? [],
    rejectionReason: json['rejectionReason'],
    approvalDate: json['approvalDate'] != null ? DateTime.parse(json['approvalDate']) : null,
    approverName: json['approverName'],
  );
}

// Optimized Status Update
class StatusUpdate {
  final DateTime timestamp;
  final ApplicationStatus status;
  final String message;
  final String? updatedBy;

  const StatusUpdate({
    required this.timestamp,
    required this.status,
    required this.message,
    this.updatedBy,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'status': status.name,
    'message': message,
    'updatedBy': updatedBy,
  };

  factory StatusUpdate.fromJson(Map<String, dynamic> json) => StatusUpdate(
    timestamp: DateTime.parse(json['timestamp']),
    status: ApplicationStatus.values.firstWhere((status) => status.name == json['status']),
    message: json['message'],
    updatedBy: json['updatedBy'],
  );
}

// Constants - Optimized as static const
class ChurchSignupConstants {
  static const int minPasswordLength = 8;
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];
  static const int maxPhotos = 10;
  static const int maxDocuments = 5;
  
  static const List<String> denominations = [
    'Baptist', 'Methodist', 'Presbyterian', 'Lutheran', 'Pentecostal',
    'Catholic', 'Episcopal', 'Non-denominational', 'Other',
  ];
  
  static const List<String> adminRoles = [
    'Senior Pastor', 'Associate Pastor', 'Church Administrator',
    'Board Member', 'Treasurer', 'Secretary',
  ];
  
  static const List<String> ministryTypes = [
    'Youth Ministry', 'Children\'s Ministry', 'Music Ministry',
    'Outreach Ministry', 'Women\'s Ministry', 'Men\'s Ministry',
    'Senior Ministry', 'Prayer Ministry', 'Missions', 'Small Groups',
  ];
}
