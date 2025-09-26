// CHURCH_CREATEVENTS_VAR.dart - Clean version without duplicates
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';

// --- EventDay ---
class EventDay {
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  EventDay({this.date, this.startTime, this.endTime});
}

// --- EventImage ---
class EventImage {
  Uint8List? imageBytes;
  String? imagePath;
  String? imageUrl;

  EventImage({this.imageBytes, this.imagePath, this.imageUrl});
}

// --- GuestInvite ---
class GuestInvite {
  final String username;
  final String fullName;
  final String churchName;

  GuestInvite(
      {required this.username,
      required this.fullName,
      required this.churchName});
}

// --- NotificationType Enum ---
enum NotificationType { success, error, warning }

// --- RegistrationFormConfig ---
class RegistrationFormConfig {
  Map<String, bool> fieldVisibility;
  bool consentRequired;
  String? consentFormUrl;
  String? consentMessage;
  Map<String, List<String>>? dropdownOptions;
  bool hasReadTerms;
  bool hasAcceptedTerms;

  RegistrationFormConfig({
    required this.fieldVisibility,
    required this.consentRequired,
    this.consentFormUrl,
    this.consentMessage,
    this.dropdownOptions,
    this.hasReadTerms = false,
    this.hasAcceptedTerms = false,
  });
}

// --- Main Event Model ---
class Event {
  // Compatibility for isOnline property
  bool get isOnline => isOnlineVenue ?? false;
  set isOnline(bool value) => isOnlineVenue = value;

  // Compatibility for eventLink property
  String? get eventLink => eventLinkVenue;
  set eventLink(String? value) => eventLinkVenue = value;

  String? title;
  String? description;
  List<String> tags = [];
  List<String> speakers = [];
  String? contactInfo;
  String? churchLandline;
  String? dressCode;

  bool isOneDay = true;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<EventDay>? eventDays;

  // Image properties
  Uint8List? imageBytes;
  String? imagePath;
  String? imageUrl;
  List<EventImage> additionalImages = [];

  // Registration form properties
  RegistrationFormConfig? registrationFormConfig;

  // Invitation and capacity management properties
  String? inviteType;
  int? expectedCapacity;
  int? customCapacity;
  List<GuestInvite>? invitedGuests;
  Map<String, int>? selectedRolesCounts;
  String? selectedChurchName;

  // Venue extension fields
  String? venueName;
  String? venueAddress;
  bool? isOnlineVenue;
  String? eventLinkVenue;
  bool? isOutsourcedVenue;
  String? meetingPlatform;

  // Publishing schedule
  DateTime? targetPublishDate;
  TimeOfDay? targetPublishTime;
  String? inviteMessage;

  Event();
}

// --- EventConstants ---
class EventConstants {
  static const int maxImages = 5;

  static const List<String> availableTags = [
    'Seminar',
    'Education',
    'Religious Celebrations',
    'Music',
    'Community',
    'Healing',
  ];

  // Validation patterns
  static const String philippineMobilePattern = r'^(09|\+639)\d{9}$';
  static const String namePattern = r'^[a-zA-Z\s\.\-]+$';
  static const String dressCodePattern = r'^[a-zA-Z0-9\s\-]+$';
  static const String titlePattern = r'[a-zA-Z0-9\s.,!?-]';

  // Field limits
  static const int landlineLength = 8;
  static const int mobileMaxLength = 13;
  static const int dressCodeMaxLength = 50;
}

// --- ValidationMessages ---
class ValidationMessages {
  static const String titleRequired = 'Event title is required';
  static const String tagsRequired = 'At least one tag is required';
  static const String descriptionRequired = 'Event description is required';
  static const String mobileRequired = 'Mobile number is required';
  static const String invalidMobile =
      'Please enter a valid Philippine mobile number';
  static const String invalidLandline =
      'Please enter a valid 8-digit Philippine landline number';
  static const String invalidDressCode =
      'Dress code should not contain special characters';
  static const String invalidSpeakerName =
      'Speaker name should only contain letters, spaces, periods, and hyphens';
  static const String maxImagesReached = 'Maximum of 5 images allowed';
  static const String fillRequiredFields = 'Please fill in all required fields';
  static const String imagePickError = 'Error picking image';
}

// --- DateTimeValidation ---
class DateTimeValidation {
  static const String timeConflict =
      'Start time and end time cannot be the same';
  static const String endTimeBeforeStart = 'End time must be after start time';
  static const String duplicateDate = 'This date is already selected for Day';
  static const String formErrorIncomplete =
      'Please fill in all date and time fields correctly';
}

// --- EventLocationModel ---
class EventLocationModel {
  bool _isOnline = false;
  String? _eventLink;
  bool _isOutsourcedVenue = false;
  bool _isValidatingUrl = false;
  bool _urlValidated = false;
  String? _urlError;

  final List<String> _meetingPlatforms = [
    'Google Meet',
    'Zoom',
    'Microsoft Teams',
    'Others'
  ];
  String _selectedPlatform = 'Google Meet';
  bool _isCustomPlatform = false;

  // Getters
  bool get isOnline => _isOnline;
  String? get eventLink => _eventLink;
  bool get isOutsourcedVenue => _isOutsourcedVenue;
  bool get isValidatingUrl => _isValidatingUrl;
  bool get urlValidated => _urlValidated;
  String? get urlError => _urlError;
  List<String> get meetingPlatforms => _meetingPlatforms;
  String get selectedPlatform => _selectedPlatform;
  bool get isCustomPlatform => _isCustomPlatform;

  // Setters
  void setOnline(bool value) {
    _isOnline = value;
  }

  void setEventLink(String? value) {
    _eventLink = value;
  }

  void setOutsourcedVenue(bool value) {
    _isOutsourcedVenue = value;
  }

  void setValidatingUrl(bool value) {
    _isValidatingUrl = value;
  }

  void setUrlValidated(bool value) {
    _urlValidated = value;
  }

  void setUrlError(String? value) {
    _urlError = value;
  }

  void setSelectedPlatform(String value) {
    _selectedPlatform = value;
    _isCustomPlatform = value == 'Others';
  }

  void setCustomPlatform(bool value) {
    _isCustomPlatform = value;
  }
}

// --- EventApiErrorModel ---
class EventApiErrorModel {
  final String title;
  final String description;
  final String buttonText;
  final IconData errorIcon;
  final double iconSize;
  final Color iconColor;
  final Color buttonColor;

  const EventApiErrorModel({
    this.title = 'External System Not Integrated',
    this.description =
        'The "Outsource Event" feature connects to an external system that is not yet integrated with this application.',
    this.buttonText = 'Go Back',
    this.errorIcon = Icons.error_outline,
    this.iconSize = 80.0,
    this.iconColor = const Color(0xFF0A0A4A),
    this.buttonColor = const Color(0xFF0A0A4A),
  });
}

// --- LocationValidationResult ---
class LocationValidationResult {
  final bool isValid;
  final String? errorMessage;

  LocationValidationResult({required this.isValid, this.errorMessage});
}

// --- LocationValidationMessages ---
class LocationValidationMessages {
  static const String urlRequired = 'URL is required';
  static const String urlMustStartWithHttp =
      'URL must start with http:// or https://';
  static const String invalidGoogleMeetUrl =
      'Please enter a valid Google Meet URL';
  static const String invalidZoomUrl = 'Please enter a valid Zoom URL';
  static const String invalidTeamsUrl =
      'Please enter a valid Microsoft Teams URL';
  static const String urlNotAccessible = 'URL is not accessible';
  static const String invalidUrl = 'Invalid URL';
  static const String platformRequired = 'Please specify the meeting platform';
  static const String validWorkingUrl = 'Please enter a valid, working URL';
}

// --- EventRegistrationFormModel ---
class EventRegistrationFormModel {
  final String pageTitle;
  final String subtitle;
  final String userInfoSectionTitle;
  final String emergencyContactSectionTitle;
  final String consentFormSectionTitle;
  final String backButtonText;
  final String completeButtonText;
  final Color titleColor;
  final double titleFontSize;
  final Color primaryColor;

  Map<String, bool> _fieldVisibility = {
    'name': true,
    'nickname': true,
    'sex': true,
    'email': true,
    'phoneNumber': true,
    'medications': true,
    'tshirtSize': true,
    'churchName': true,
    'churchPosition': true,
    'emergencyContactName': true,
    'emergencyContactNumber': true,
    'emergencyContactRelation': true,
  };

  Map<String, List<String>> _dropdownOptions = {
    'sex': ['Male', 'Female', 'Other'],
    'tshirtSize': ['S', 'M', 'L', 'XL'],
    'emergencyContactRelation': ['Spouse', 'Sibling', 'Parent', 'Other'],
  };

  bool _consentRequired = true;
  bool _hasReadTerms = false;
  bool _hasAcceptedTerms = false;

  EventRegistrationFormModel({
    this.pageTitle = 'Registration Form',
    this.subtitle = 'Use standard form or customize fields',
    this.userInfoSectionTitle = 'User Information',
    this.emergencyContactSectionTitle = 'Emergency Contact Information',
    this.consentFormSectionTitle = 'Consent Form and Waiver',
    this.backButtonText = 'Back',
    this.completeButtonText = 'Complete Form',
    this.titleColor = const Color(0xFF0A0A4A),
    this.titleFontSize = 24.0,
    this.primaryColor = const Color(0xFF0A0A4A),
  });

  // Getters
  Map<String, bool> get fieldVisibility => _fieldVisibility;
  Map<String, List<String>> get dropdownOptions => _dropdownOptions;
  bool get consentRequired => _consentRequired;
  bool get hasReadTerms => _hasReadTerms;
  bool get hasAcceptedTerms => _hasAcceptedTerms;

  // Setters
  void setFieldVisibility(String fieldName, bool visible) {
    _fieldVisibility[fieldName] = visible;
  }

  void setDropdownOptions(String fieldName, List<String> options) {
    _dropdownOptions[fieldName] = options;
  }

  void setConsentRequired(bool required) {
    _consentRequired = required;
  }

  void setHasReadTerms(bool read) {
    _hasReadTerms = read;
  }

  void setHasAcceptedTerms(bool accepted) {
    _hasAcceptedTerms = accepted;
  }
}

// --- RegistrationFormValidationMessages ---
class RegistrationFormValidationMessages {
  static const String consentFormUrlRequired =
      'Please provide a consent form URL';
  static const String consentMessageRequired =
      'Please provide a consent message';
  static const String consentNotAccepted =
      'Please view and accept the consent form before proceeding';
  static const String noFieldsVisible =
      'At least one registration field must be visible';
  static const String optionValueRequired = 'Please enter an option value';
  static const String minOneOptionRequired = 'At least one option is required';
}

// --- EventSummaryModel ---
class EventSummaryModel {
  final String pageTitle;
  final Color titleColor;
  final double titleFontSize;
  final Color primaryColor;
  final String backButtonText;
  final String confirmButtonText;
  final String dialogTitle;
  final String dialogMessage;
  final String dialogNoText;
  final String dialogYesText;
  final Color dialogBackgroundColor;
  final Color dialogIconColor;

  const EventSummaryModel({
    this.pageTitle = 'Event summary',
    this.titleColor = const Color(0xFF0A0A4A),
    this.titleFontSize = 24.0,
    this.primaryColor = const Color(0xFF0A0A4A),
    this.backButtonText = 'Back',
    this.confirmButtonText = 'Confirm Details',
    this.dialogTitle = 'Confirm Details',
    this.dialogMessage =
        'Do you want to proceed to the next step of event creation?',
    this.dialogNoText = 'No',
    this.dialogYesText = 'Yes',
    this.dialogBackgroundColor = const Color(0xFFF8F0F0),
    this.dialogIconColor = const Color.fromARGB(255, 254, 254, 254),
  });
}

// --- EventDetailItem ---
class EventDetailItem {
  final String label;
  final String value;

  const EventDetailItem({
    required this.label,
    required this.value,
  });
}

// --- ConsentFormModel ---
class ConsentFormModel {
  final String pageTitle;
  final String subtitle;
  final String checkboxText;
  final String cancelButtonText;
  final String acceptButtonText;
  final String scrollPromptText;
  final Color titleColor;
  final double titleFontSize;
  final Color primaryColor;
  final Color warningColor;

  bool _hasScrolledToBottom = false;
  bool _hasAccepted = false;
  bool _isScrollable = false;
  String? _content;

  ConsentFormModel({
    this.pageTitle = 'Consent Form and Waiver',
    this.subtitle = 'Please read the following terms and conditions carefully',
    this.checkboxText = 'I have read and agree to the terms and conditions',
    this.cancelButtonText = 'Cancel',
    this.acceptButtonText = 'Accept & Continue',
    this.scrollPromptText =
        'Please scroll to the bottom to read the entire document',
    this.titleColor = const Color(0xFF0A0A4A),
    this.titleFontSize = 24.0,
    this.primaryColor = const Color(0xFF0A0A4A),
    this.warningColor = Colors.orange,
  });

  // Getters
  bool get hasScrolledToBottom => _hasScrolledToBottom;
  bool get hasAccepted => _hasAccepted;
  bool get isScrollable => _isScrollable;
  String? get content => _content;

  // Setters
  void setHasScrolledToBottom(bool value) {
    _hasScrolledToBottom = value;
  }

  void setHasAccepted(bool value) {
    _hasAccepted = value;
  }

  void setIsScrollable(bool value) {
    _isScrollable = value;
  }

  void setContent(String? value) {
    _content = value;
  }
}

// --- ConsentFormValidationMessages ---
class ConsentFormValidationMessages {
  static const String mustReadDocument =
      'Please read the entire document before accepting';
  static const String mustAcceptTerms =
      'You must accept the terms to continue.';
}

// --- EventInviteModel ---
class EventInviteModel {
  final String pageTitle;
  final String subtitle;
  final String backButtonText;
  final String nextButtonText;
  final Color titleColor;
  final double titleFontSize;
  final Color navyBlue;

  String _inviteType = 'Open Invite';
  int _expectedCapacity = 500;
  bool _isCustomCapacity = false;
  String _searchQuery = '';
  Map<String, dynamic>? _selectedChurch;
  Map<String, int> _selectedRolesCounts = {};
  List<GuestInvite> _invitedGuestsUI = [];
  bool _showGuestForm = false;
  bool _showNotification = false;
  String? _notificationMessage;
  NotificationType _notificationType = NotificationType.success;

  // Sample church data
  final List<Map<String, dynamic>> _sampleChurches = [
    {
      'name': 'Sample Church Name',
      'members': 120,
      'roleCount': {'Admin': 5, 'Members': 100, 'Pastor/Leader': 10}
    },
    {
      'name': 'Sample Church Name 2',
      'members': 150,
      'roleCount': {'Admin': 6, 'Members': 130, 'Pastor/Leader': 8}
    },
    {
      'name': 'Sample Church Name 3',
      'members': 170,
      'roleCount': {'Admin': 7, 'Members': 150, 'Pastor/Leader': 8}
    },
    {
      'name': 'Sample Church Name 4',
      'members': 120,
      'roleCount': {'Admin': 4, 'Members': 105, 'Pastor/Leader': 6}
    },
  ];

  final List<String> _permanentRoles = ['Admin', 'Members', 'Pastor/Leader'];
  final List<int> _capacityOptions = [100, 200, 300, 500, 700, 1000];

  EventInviteModel({
    this.pageTitle = 'Event Invitations',
    this.subtitle = 'Manage who can attend your event',
    this.backButtonText = 'Back',
    this.nextButtonText = 'Continue',
    this.titleColor = const Color(0xFF0A0A4A),
    this.titleFontSize = 24.0,
    this.navyBlue = const Color(0xFF0A0A4A),
  });

  // Getters
  String get inviteType => _inviteType;
  int get expectedCapacity => _expectedCapacity;
  bool get isCustomCapacity => _isCustomCapacity;
  String get searchQuery => _searchQuery;
  Map<String, dynamic>? get selectedChurch => _selectedChurch;
  Map<String, int> get selectedRolesCounts => _selectedRolesCounts;
  List<GuestInvite> get invitedGuestsUI => _invitedGuestsUI;
  bool get showGuestForm => _showGuestForm;
  bool get showNotification => _showNotification;
  String? get notificationMessage => _notificationMessage;
  NotificationType get notificationType => _notificationType;
  List<Map<String, dynamic>> get sampleChurches => _sampleChurches;
  List<String> get permanentRoles => _permanentRoles;
  List<int> get capacityOptions => _capacityOptions;

  // Setters
  void setInviteType(String type) {
    _inviteType = type;
  }

  void setExpectedCapacity(int capacity) {
    _expectedCapacity = capacity;
  }

  void setCustomCapacity(bool isCustom) {
    _isCustomCapacity = isCustom;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
  }

  void setSelectedChurch(Map<String, dynamic>? church) {
    _selectedChurch = church;
  }

  void setSelectedRolesCounts(Map<String, int> counts) {
    _selectedRolesCounts = counts;
  }

  void setInvitedGuestsUI(List<GuestInvite> guests) {
    _invitedGuestsUI = guests;
  }

  void setShowGuestForm(bool show) {
    _showGuestForm = show;
  }

  void setShowNotification(bool show) {
    _showNotification = show;
  }

  void setNotificationMessage(String? message) {
    _notificationMessage = message;
  }

  void setNotificationType(NotificationType type) {
    _notificationType = type;
  }

  void addGuest(GuestInvite guest) {
    _invitedGuestsUI.add(guest);
  }

  void removeGuest(int index) {
    if (index >= 0 && index < _invitedGuestsUI.length) {
      _invitedGuestsUI.removeAt(index);
    }
  }

  void updateRoleCount(String role, int count) {
    if (count <= 0) {
      _selectedRolesCounts.remove(role);
    } else {
      _selectedRolesCounts[role] = count;
    }
  }
}

// --- EventInviteValidationMessages ---
class EventInviteValidationMessages {
  static const String inviteTypeRequired = 'Please select an invite type';
  static const String capacityRequired = 'Please set an expected capacity';
  static const String customCapacityRequired = 'Please enter a custom capacity';
  static const String invalidCapacity = 'Capacity must be a positive number';
  static const String usernameRequired = 'Username is required';
  static const String fullNameRequired = 'Full name is required';
  static const String guestChurchRequired = 'Church name is required';
  static const String capacityExceeded =
      'Total invites exceed expected capacity';
  static const String duplicateUsername =
      'This username has already been invited';
}

// --- EventMapModel ---
class EventMapModel {
  String? _venueName;
  bool _isSearching = false;
  final List<String> _recentLocations = [];
  String? _distance;

  // Getters
  String? get venueName => _venueName;
  bool get isSearching => _isSearching;
  List<String> get recentLocations => List.unmodifiable(_recentLocations);
  String? get distance => _distance;

  // Setters
  void setVenueName(String value) {
    _venueName = value;
  }

  void setSearching(bool value) {
    _isSearching = value;
  }

  void addRecentLocation(String value) {
    _recentLocations.insert(0, value);
  }

  void setDistance(String? value) {
    _distance = value;
  }
}

// --- Event model extensions for registration form ---
extension EventRegistrationExtension on Event {
  RegistrationFormConfig? get registrationFormConfigExtension =>
      this.registrationFormConfig;
  set registrationFormConfigExtension(RegistrationFormConfig? config) =>
      this.registrationFormConfig = config;
}

// --- ChurchInvite ---
class ChurchInvite {
  final String name;
  final int members;
  final List<String> roles;

  ChurchInvite({
    required this.name,
    required this.members,
    required this.roles,
  });
}

// --- ChurchCreateVentsVar ---
mixin ChurchCreateVentsVar {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String inviteType = 'Open Invite';
  int expectedCapacity = 500;
  final TextEditingController customCapacityController =
      TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final List<int> capacityOptions = [100, 200, 300, 500, 700, 1000];
  bool isCustomCapacity = false;
  String searchQuery = '';

  // Sample church data - limited to 4 entries
  final List<Map<String, dynamic>> sampleChurches = [
    {
      'name': 'Sample Church Name',
      'members': 120,
      'roleCount': {'Admin': 5, 'Members': 100, 'Pastor/Leader': 10}
    },
    {
      'name': 'Sample Church Name 2',
      'members': 150,
      'roleCount': {'Admin': 6, 'Members': 130, 'Pastor/Leader': 8}
    },
    {
      'name': 'Sample Church Name 3',
      'members': 170,
      'roleCount': {'Admin': 7, 'Members': 150, 'Pastor/Leader': 8}
    },
    {
      'name': 'Sample Church Name 4',
      'members': 120,
      'roleCount': {'Admin': 4, 'Members': 105, 'Pastor/Leader': 6}
    },
  ];

  // Selected church for role assignment
  Map<String, dynamic>? selectedChurch;

  // Permanent roles that cannot be removed
  final List<String> permanentRoles = ['Admin', 'Members', 'Pastor/Leader'];

  // Guest list with full information
  List<GuestInvite> invitedGuestsUI = [];
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController guestChurchController = TextEditingController();
  bool showGuestForm = false;

  // Selected roles with count
  Map<String, int> selectedRolesCounts = {};

  // List to track invited churches in the UI (separate from event.invitedChurches)
  List<ChurchInvite> invitedChurchesUI = [];

  // Map to track the total number of people invited per church
  final Map<String, int> churchInviteCounts = {};

  // Error message for capacity validation
  String? capacityErrorMessage;

  // Total number of people invited
  int totalInvitedPeople = 0;

  // Navy blue color used throughout the app
  final Color navyBlue = const Color(0xFF0A0A4A);
  // Medium forest green color for buttons
  final Color forestGreen = const Color(0xFF2E7D32);

  // Notification state
  String? notificationMessage;
  NotificationType? notificationType;
  bool showNotification = false;

  // New flag to track if we're in church selection mode
  bool isInChurchSelectionMode = false;

  // Variables for EventTargetsScreen (8p1)
  DateTime? targetPublishDate;
  TimeOfDay? targetPublishTime;
  final TextEditingController inviteMessageController = TextEditingController();
  DateTime? maxAllowedDate;
  bool showSuccessNotification = false;

  // Variables for EventWaitingApprovalScreen (9)
  Timer? redirectTimer;
  bool eventSaved = false;

  // Variables for EventDetailsScreen (10)
  bool hasLiked = false;
  int likeCount = 0;
  bool isDescriptionExpanded = false;
  bool isRegistered = false;
  bool showRegistrationNotification = false;
  double screenHeight = 0.0;
  String? formattedStartDate;
  String? formattedEndDate;
  String? formattedStartTime;
  String? formattedEndTime;
  final DateFormat monthFormatter = DateFormat('MMM');
  final DateFormat dayFormatter = DateFormat('EEEE, MMMM d, yyyy');
  final String eventUrl = 'https://example.com/event/123';
}
