import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/CHURCH_SIGNUP_VAR.dart';

class ChurchSignupViewModel extends ChangeNotifier {
  // Core state
  ChurchModel _church = ChurchModel();
  FormValidation _validation = const FormValidation();
  ProgressModel _progress = const ProgressModel();
  
  // Loading and error states
  bool _isLoading = false;
  String? _errorMessage;
  
  // Collections
  List<ChurchSignupVar> _members = [];
  List<ChurchModel> _churches = [];
  List<ChurchLocation> _locations = [];
  
  // Selected items
  ChurchModel? _selectedChurch;
  ChurchLocation? _selectedLocation;
  UserModel? _currentUser;
  AdminModel? _currentAdmin;
  ApprovalStatus? _approvalStatus;
  
  // Form states
  String _currentChurchName = '';
  DateTime? _selectedEstablishedDate;
  File? _selectedLogoFile;
  String? _logoUploadUrl;
  
  // Contact form
  String _churchEmail = '';
  String _contactEmail = '';
  String _contactPhone = '';
  
  // Security form
  String _password = '';
  String _confirmPassword = '';
  PasswordStrength _passwordStrength = PasswordStrength.none;
  
  // Admin form
  String _adminFirstName = '';
  String _adminLastName = '';
  String _adminEmail = '';
  String _adminPhone = '';
  String _adminRole = 'Church Administrator';
  
  // Verification form
  File? _secCertificate;
  File? _faithStatement;
  List<File> _churchPhotos = [];
  
  // Loading states
  bool _isUploadingLogo = false;
  bool _isUploadingDocuments = false;
  bool _isAdminVerified = false;
  
  // Suggestions and caches
  List<String> _churchNameSuggestions = [];
  List<DateTime> _suggestedDates = [];
  List<PasswordRequirement> _passwordRequirements = [];
  List<String> _verificationDocuments = [];
  
  // API configuration
  static const String _baseUrl = 'https://your-api-endpoint.com/api';
  final ImagePicker _imagePicker = ImagePicker();

  // Core getters
  ChurchModel get church => _church;
  FormValidation get validation => _validation;
  ProgressModel get progress => _progress;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Collection getters
  List<ChurchSignupVar> get members => List.unmodifiable(_members);
  List<ChurchModel> get churches => List.unmodifiable(_churches);
  List<ChurchLocation> get locations => List.unmodifiable(_locations);
  
  // Selection getters
  ChurchModel? get selectedChurch => _selectedChurch;
  ChurchLocation? get selectedLocation => _selectedLocation;
  UserModel? get currentUser => _currentUser;
  AdminModel? get currentAdmin => _currentAdmin;
  ApprovalStatus? get approvalStatus => _approvalStatus;
  
  // Form getters
  String get currentChurchName => _currentChurchName;
  DateTime? get selectedEstablishedDate => _selectedEstablishedDate;
  File? get selectedLogoFile => _selectedLogoFile;
  String? get logoUploadUrl => _logoUploadUrl;
  
  // Contact getters
  String get churchEmail => _churchEmail;
  String get contactEmail => _contactEmail;
  String get contactPhone => _contactPhone;
  bool get isContactFormValid => _isContactFormValid();
  
  // Security getters
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  PasswordStrength get passwordStrength => _passwordStrength;
  List<PasswordRequirement> get passwordRequirements => List.unmodifiable(_passwordRequirements);
  bool get isPasswordFormValid => _isPasswordFormValid();
  
  // Admin getters
  String get adminFirstName => _adminFirstName;
  String get adminLastName => _adminLastName;
  String get adminEmail => _adminEmail;
  String get adminPhone => _adminPhone;
  String get adminRole => _adminRole;
  bool get isAdminFormValid => _isAdminFormValid();
  bool get isAdminVerified => _isAdminVerified;
  
  // Verification getters
  File? get secCertificate => _secCertificate;
  File? get faithStatement => _faithStatement;
  List<File> get churchPhotos => List.unmodifiable(_churchPhotos);
  bool get isUploadingLogo => _isUploadingLogo;
  bool get isUploadingDocuments => _isUploadingDocuments;
  bool get isVerificationFormValid => _isVerificationFormValid();
  
  // Suggestion getters
  List<String> get churchNameSuggestions => List.unmodifiable(_churchNameSuggestions);
  List<DateTime> get suggestedDates => List.unmodifiable(_suggestedDates);
  List<String> get verificationDocuments => List.unmodifiable(_verificationDocuments);

  // Private validation methods
  bool _isContactFormValid() => FormValidation.isEmailValid(_churchEmail) &&
      FormValidation.isEmailValid(_contactEmail) &&
      _isPhilippinesPhoneValid(_contactPhone);

  bool _isPasswordFormValid() => PasswordValidation.isValidPassword(_password) &&
      _password == _confirmPassword;

  bool _isAdminFormValid() => _adminFirstName.trim().isNotEmpty &&
      _adminLastName.trim().isNotEmpty &&
      FormValidation.isEmailValid(_adminEmail) &&
      _isPhilippinesPhoneValid(_adminPhone);

  bool _isVerificationFormValid() => _secCertificate != null &&
      _faithStatement != null && _churchPhotos.isNotEmpty;

  bool _isPhilippinesPhoneValid(String phone) {
    final cleanPhone = phone.replaceAll('+63', '').replaceAll(' ', '');
    return RegExp(r'^\d{10}$').hasMatch(cleanPhone);
  }

  // Core CRUD operations
  Future<bool> addMember(ChurchSignupVar member) async {
    return await _performApiOperation(
      operation: () async {
        final response = await http.post(
          Uri.parse('$_baseUrl/members'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(member.toJson()),
        );
        
        if (response.statusCode == 201) {
          _members.add(member);
          return true;
        }
        throw Exception('Failed to add member: ${response.body}');
      },
      fallback: () {
        _members.add(member);
        return true;
      },
    );
  }

  Future<void> fetchMembers() async {
    await _performApiOperation(
      operation: () async {
        final response = await http.get(
          Uri.parse('$_baseUrl/members'),
          headers: {'Content-Type': 'application/json'},
        );
        
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          _members = data.map((json) => ChurchSignupVar.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch members');
        }
      },
    );
  }

  Future<bool> updateMember(int index, ChurchSignupVar updatedMember) async {
    if (index < 0 || index >= _members.length) return false;
    
    return await _performApiOperation(
      operation: () async {
        // API call would go here
        _members[index] = updatedMember;
        return true;
      },
      fallback: () {
        _members[index] = updatedMember;
        return true;
      },
    );
  }

  Future<bool> removeMember(int index) async {
    if (index < 0 || index >= _members.length) return false;
    
    return await _performApiOperation(
      operation: () async {
        // API call would go here
        _members.removeAt(index);
        return true;
      },
      fallback: () {
        _members.removeAt(index);
        return true;
      },
    );
  }

  // Church management
  void updateChurchName(String name) {
    _currentChurchName = name;
    _church = ChurchModel(churchName: name);
    notifyListeners();
  }

  void updateEstablishedDate(DateTime date) {
    _selectedEstablishedDate = date;
    notifyListeners();
  }

  void selectLogoFile(File file) {
    _selectedLogoFile = file;
    notifyListeners();
  }

  void clearSelectedLogo() {
    _selectedLogoFile = null;
    _logoUploadUrl = null;
    notifyListeners();
  }

  // Contact management
  void updateChurchEmail(String email) {
    _churchEmail = email;
    notifyListeners();
  }

  void updateContactEmail(String email) {
    _contactEmail = email;
    notifyListeners();
  }

  void updateContactPhone(String phone) {
    _contactPhone = phone;
    notifyListeners();
  }

  // Security management
  void updatePassword(String password) {
    _password = password;
    _passwordStrength = PasswordValidation.getPasswordStrength(password);
    _passwordRequirements = _checkPasswordRequirements(password);
    notifyListeners();
  }

  void updateConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    notifyListeners();
  }

  List<PasswordRequirement> _checkPasswordRequirements(String password) {
    return [
      PasswordRequirement('At least 8 characters', password.length >= 8),
      PasswordRequirement('Contains uppercase letter', RegExp(r'[A-Z]').hasMatch(password)),
      PasswordRequirement('Contains lowercase letter', RegExp(r'[a-z]').hasMatch(password)),
      PasswordRequirement('Contains digit', RegExp(r'\d').hasMatch(password)),
      PasswordRequirement('Contains special character', RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)),
    ];
  }

  // Admin management
  void updateAdminFirstName(String firstName) {
    _adminFirstName = firstName;
    notifyListeners();
  }

  void updateAdminLastName(String lastName) {
    _adminLastName = lastName;
    notifyListeners();
  }

  void updateAdminEmail(String email) {
    _adminEmail = email;
    notifyListeners();
  }

  void updateAdminPhone(String phone) {
    _adminPhone = phone;
    notifyListeners();
  }

  void updateAdminRole(String role) {
    _adminRole = role;
    notifyListeners();
  }

  // Verification management
  void setSecCertificate(File? file) {
    _secCertificate = file;
    notifyListeners();
  }

  void setFaithStatement(File? file) {
    _faithStatement = file;
    notifyListeners();
  }

  void addChurchPhoto(File file) {
    if (_churchPhotos.length < ChurchSignupConstants.maxPhotos) {
      _churchPhotos.add(file);
      notifyListeners();
    }
  }

  void removeChurchPhoto(int index) {
    if (index >= 0 && index < _churchPhotos.length) {
      _churchPhotos.removeAt(index);
      notifyListeners();
    }
  }

  void clearChurchPhotos() {
    _churchPhotos.clear();
    notifyListeners();
  }

  // Document picking
  Future<void> pickDocument(DocumentType type) async {
    try {
      final XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        switch (type) {
          case DocumentType.secCertificate:
            _secCertificate = File(file.path);
            break;
          case DocumentType.statementOfFaith:
            _faithStatement = File(file.path);
            break;
          default:
            break;
        }
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to pick document: $e');
    }
  }

  Future<void> pickChurchPhoto() async {
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (file != null) {
        addChurchPhoto(File(file.path));
      }
    } catch (e) {
      _setError('Failed to pick photo: $e');
    }
  }

  Future<void> pickMultipleChurchPhotos() async {
    try {
      final List<XFile> files = await _imagePicker.pickMultipleMedia();
      for (final file in files) {
        if (_churchPhotos.length < ChurchSignupConstants.maxPhotos) {
          _churchPhotos.add(File(file.path));
        }
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to pick photos: $e');
    }
  }

  // Approval status checking
  Future<ApprovalStatus?> checkApprovalStatus(String referenceCode) async {
    return await _performApiOperation<ApprovalStatus?>(
      operation: () async {
        final response = await http.get(
          Uri.parse('$_baseUrl/approval-status/$referenceCode'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          _approvalStatus = ApprovalStatus.fromJson(data);
          return _approvalStatus;
        } else if (response.statusCode == 404) {
          throw Exception('Reference code not found');
        } else {
          throw Exception('Failed to check approval status');
        }
      },
      fallback: () {
        // Mock approval status for demo
        final isApproved = referenceCode.startsWith('CH');
        _approvalStatus = ApprovalStatus(
          referenceCode: referenceCode,
          status: isApproved ? 'approved' : 'pending',
          submittedDate: DateTime.now().subtract(const Duration(days: 3)),
          reviewedDate: isApproved ? DateTime.now() : null,
          churchName: 'Sample Church',
          reviewNotes: isApproved ? 'All documents verified successfully' : null,
        );
        return _approvalStatus;
      },
    );
  }

  // Application submission
  Future<bool> submitApplication() async {
    if (!_church.isReadyForSubmission) {
      _setError('Please complete all required fields');
      return false;
    }

    return await _performApiOperation(
      operation: () async {
        _church = ChurchModel(
          referenceCode: _generateReferenceCode(),
          submissionDate: DateTime.now(),
          verificationStatus: VerificationStatus.inProgress,
        );
        
        // Simulate API call
        await Future.delayed(const Duration(seconds: 3));
        return true;
      },
      fallback: () {
        _church = ChurchModel(
          referenceCode: _generateReferenceCode(),
          submissionDate: DateTime.now(),
          verificationStatus: VerificationStatus.pending,
        );
        return true;
      },
    );
  }

  // Utility methods
  String _generateReferenceCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final churchCode = _currentChurchName.length >= 2 
        ? _currentChurchName.substring(0, 2).toUpperCase() 
        : 'CH';
    return 'CH$churchCode${timestamp.toString().substring(timestamp.toString().length - 6)}';
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Generic API operation handler
  Future<T> _performApiOperation<T>({
    required Future<T> Function() operation,
    Future<T> Function()? fallback,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await operation();
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      if (fallback != null) {
        try {
          final result = await fallback();
          _setError('Operation completed locally (API connection failed)');
          _isLoading = false;
          return result;
        } catch (fallbackError) {
          _setError('Operation failed: $fallbackError');
        }
      } else {
        _setError('Operation failed: $e');
      }
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Validation methods
  bool isValidEmail(String email) => FormValidation.isEmailValid(email);
  bool isValidPhone(String phone) => FormValidation.isPhoneValid(phone);

  // Search methods
  List<String> searchDenominations(String query) {
    if (query.isEmpty) return ChurchSignupConstants.denominations;
    return ChurchSignupConstants.denominations
        .where((denomination) => denomination.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<String> searchMinistries(String query) {
    if (query.isEmpty) return ChurchSignupConstants.ministryTypes;
    return ChurchSignupConstants.ministryTypes
        .where((ministry) => ministry.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Reset and cleanup
  void resetForm() {
    _church = ChurchModel();
    _validation = const FormValidation();
    _progress = const ProgressModel();
    _members.clear();
    _churches.clear();
    _locations.clear();
    _selectedChurch = null;
    _selectedLocation = null;
    _currentUser = null;
    _currentAdmin = null;
    _approvalStatus = null;
    _currentChurchName = '';
    _selectedEstablishedDate = null;
    _selectedLogoFile = null;
    _logoUploadUrl = null;
    _churchEmail = '';
    _contactEmail = '';
    _contactPhone = '';
    _password = '';
    _confirmPassword = '';
    _passwordStrength = PasswordStrength.none;
    _adminFirstName = '';
    _adminLastName = '';
    _adminEmail = '';
    _adminPhone = '';
    _adminRole = 'Church Administrator';
    _secCertificate = null;
    _faithStatement = null;
    _churchPhotos.clear();
    _isLoading = false;
    _errorMessage = null;
    _isUploadingLogo = false;
    _isUploadingDocuments = false;
    _isAdminVerified = false;
    _churchNameSuggestions.clear();
    _suggestedDates.clear();
    _passwordRequirements.clear();
    _verificationDocuments.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}

// Supporting models that were missing
class ChurchSignupVar {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String address;
  final DateTime? birthDate;
  final String ministry;
  final bool isActive;

  const ChurchSignupVar({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.birthDate,
    required this.ministry,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phoneNumber': phoneNumber,
    'address': address,
    'birthDate': birthDate?.toIso8601String(),
    'ministry': ministry,
    'isActive': isActive,
  };

  factory ChurchSignupVar.fromJson(Map<String, dynamic> json) => ChurchSignupVar(
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    email: json['email'] ?? '',
    phoneNumber: json['phoneNumber'] ?? '',
    address: json['address'] ?? '',
    birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
    ministry: json['ministry'] ?? '',
    isActive: json['isActive'] ?? true,
  );
}

class ChurchLocation {
  final String name;
  final String address;
  final double distance;
  final String entrance;
  final double latitude;
  final double longitude;

  const ChurchLocation({
    required this.name,
    required this.address,
    required this.distance,
    required this.entrance,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'distance': distance,
    'entrance': entrance,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory ChurchLocation.fromJson(Map<String, dynamic> json) => ChurchLocation(
    name: json['name'] ?? '',
    address: json['address'] ?? '',
    distance: (json['distance'] ?? 0.0).toDouble(),
    entrance: json['entrance'] ?? '',
    latitude: (json['latitude'] ?? 0.0).toDouble(),
    longitude: (json['longitude'] ?? 0.0).toDouble(),
  );
}

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String? profileImageUrl;
  final DateTime? lastLogin;
  final bool isActive;

  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileImageUrl,
    this.lastLogin,
    this.isActive = true,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'profileImageUrl': profileImageUrl,
    'lastLogin': lastLogin?.toIso8601String(),
    'isActive': isActive,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    email: json['email'] ?? '',
    profileImageUrl: json['profileImageUrl'],
    lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
    isActive: json['isActive'] ?? true,
  );
}

class ApprovalStatus {
  final String referenceCode;
  final String status;
  final DateTime submittedDate;
  final DateTime? reviewedDate;
  final String? reviewNotes;
  final String churchName;

  const ApprovalStatus({
    required this.referenceCode,
    required this.status,
    required this.submittedDate,
    this.reviewedDate,
    this.reviewNotes,
    required this.churchName,
  });

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  Map<String, dynamic> toJson() => {
    'referenceCode': referenceCode,
    'status': status,
    'submittedDate': submittedDate.toIso8601String(),
    'reviewedDate': reviewedDate?.toIso8601String(),
    'reviewNotes': reviewNotes,
    'churchName': churchName,
  };

  factory ApprovalStatus.fromJson(Map<String, dynamic> json) => ApprovalStatus(
    referenceCode: json['referenceCode'] ?? '',
    status: json['status'] ?? 'pending',
    submittedDate: DateTime.parse(json['submittedDate']),
    reviewedDate: json['reviewedDate'] != null ? DateTime.parse(json['reviewedDate']) : null,
    reviewNotes: json['reviewNotes'],
    churchName: json['churchName'] ?? '',
  );
}

class PasswordRequirement {
  final String description;
  final bool isMet;

  const PasswordRequirement(this.description, this.isMet);
}
