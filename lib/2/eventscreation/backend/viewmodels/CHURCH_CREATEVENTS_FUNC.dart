// CREATE_EVENTS_FUNC.dart - Functions, ViewModels, and Business Logic
import 'package:flutter/material.dart';
import '../../frontend/widgets/confirmation_dialog.dart';
import '../../frontend/widgets/success_dialog.dart';
import '../../frontend/screens/CHURCH_CREATEEVENTS_9.dart';
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class EventTargetsViewModel extends ChangeNotifier {
  final EventTargetsVariables _variables;

  EventTargetsViewModel(this._variables);

  // Getters for accessing variables
  EventTargetsVariables get variables => _variables;

  // Date selection method
  Future<void> selectDate(BuildContext context) async {
    final today = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _variables.targetPublishDate ?? today,
      firstDate: today,
      lastDate: _variables.maxAllowedDate,
      helpText: EventTargetsConstants.datePickerHelpText,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: EventTargetsColors.yellowHighlight,
              onPrimary: EventTargetsColors.textBlack,
              onSurface: EventTargetsColors.textBlack,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: EventTargetsColors.yellowHighlight,
              ),
            ),
            dialogTheme: const DialogThemeData(
                backgroundColor: EventTargetsColors.backgroundWhite),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _variables.targetPublishDate) {
      _variables.targetPublishDate = picked;
      notifyListeners();
    }
  }

  // Time selection method
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _variables.targetPublishTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: EventTargetsColors.yellowHighlight,
              onPrimary: EventTargetsColors.textBlack,
              onSurface: EventTargetsColors.textBlack,
              surface: EventTargetsColors.backgroundWhite,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: EventTargetsColors.backgroundWhite,
              hourMinuteColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? EventTargetsColors.yellowHighlight
                      : Colors.grey.shade200),
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? EventTargetsColors.textBlack
                      : EventTargetsColors.textBlack),
              dialBackgroundColor: Colors.grey.shade100,
              dialHandColor: EventTargetsColors.yellowHighlight,
              dialTextColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? EventTargetsColors.backgroundWhite
                      : EventTargetsColors.textBlack),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: EventTargetsColors.yellowHighlight,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _variables.targetPublishTime) {
      _variables.targetPublishTime = picked;
      notifyListeners();
    }
  }

  // Notification management methods
  void dismissNotification() {
    _variables.showNotification = false;
    notifyListeners();
  }

  void dismissSuccessNotification() {
    _variables.showSuccessNotification = false;
    notifyListeners();
  }

  // Date formatting utility
  String formatDate(DateTime? date) {
    if (date == null) return EventTargetsConstants.naText;
    return '${date.month}/${date.day}/${date.year}';
  }

  // Get formatted list of event dates
  String getFormattedEventDates() {
    if (_variables.event == null) return EventTargetsConstants.naText;

    final event = _variables.event!;
    if (event.isOneDay || event.eventDays == null || event.eventDays!.isEmpty) {
      return '${EventTargetsConstants.eventOnText} ${formatDate(event.startDate)}';
    } else {
      // For multiple specific dates, list them all
      List<String> formattedDates = [];
      for (var day in event.eventDays!) {
        if (day.date != null) {
          formattedDates.add(formatDate(day.date));
        }
      }

      if (formattedDates.isEmpty) {
        return '${EventTargetsConstants.eventOnText} ${formatDate(event.startDate)}';
      } else if (formattedDates.length == 1) {
        return '${EventTargetsConstants.eventOnText} ${formattedDates[0]}';
      } else {
        // Join all dates with commas and "and" for the last one
        String lastDate = formattedDates.removeLast();
        if (formattedDates.length == 1) {
          return '${EventTargetsConstants.eventOnText} ${formattedDates[0]} and $lastDate';
        } else {
          return '${EventTargetsConstants.eventOnText} ${formattedDates.join(", ")} and $lastDate';
        }
      }
    }
  }

  // Dialog handling methods
  void showSendInvitesDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: EventTargetsConstants.sendInvitesTitle,
          message: EventTargetsConstants.sendInvitesMessage,
          negativeButtonText: EventTargetsConstants.noButtonText,
          positiveButtonText: EventTargetsConstants.yesButtonText,
          icon: Icons.search,
          onNegativePressed: () {
            Navigator.of(context).pop();
          },
          onPositivePressed: () {
            Navigator.of(context).pop();
            showSuccessSentDialog(context);
          },
        );
      },
    );
  }

  void showSuccessSentDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SuccessDialog(
          title: EventTargetsConstants.successSentTitle,
          message: EventTargetsConstants.successSentMessage,
          primaryButtonText: EventTargetsConstants.viewEventDetailsText,
          secondaryButtonText: EventTargetsConstants.backToMenuText,
          onPrimaryPressed: () {
            Navigator.of(context).pop();
            navigateToWaitingApproval(context);
          },
          onSecondaryPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        );
      },
    );
  }

  // Navigation methods
  void navigateToWaitingApproval(BuildContext context) {
    // Save event data first
    saveEventData();

    // Navigate to waiting approval screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EventWaitingApprovalScreen(event: _variables.event!),
      ),
    );
  }

  // Data persistence method
  void saveEventData() {
    if (_variables.event != null) {
      // Save target publish date and time
      _variables.event!.targetPublishDate = _variables.targetPublishDate;
      _variables.event!.targetPublishTime = _variables.targetPublishTime;

      // Save invite message
      _variables.event!.inviteMessage = _variables.inviteMessageController.text;
    }
  }

  // Form validation method
  bool validateForm(BuildContext context) {
    if (_variables.targetPublishDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(EventTargetsConstants.selectDateError)),
      );
      return false;
    }
    return true;
  }

  // Continue button handler
  void handleContinue(BuildContext context) {
    if (validateForm(context)) {
      showSendInvitesDialog(context);
    }
  }

  // Back button handler
  void handleBack(BuildContext context) {
    Navigator.pop(context);
  }

  // Extract role name from format "Role (count)"
  String extractRoleName(String role) {
    return role.split(' (')[0];
  }

  // Get notification message with date
  String getAutoPublishNotificationMessage() {
    return '${EventTargetsConstants.autoPublishNotification} (${formatDate(_variables.maxAllowedDate)}) if not published earlier.';
  }
}

class EventWaitingApprovalViewModel extends ChangeNotifier {
  final EventWaitingApprovalVariables _variables;

  EventWaitingApprovalViewModel(this._variables);

  // Getters for accessing variables
  EventWaitingApprovalVariables get variables => _variables;

  // Initialize the screen and start timer
  void initializeScreen(BuildContext context) {
    // Save the event to the EventService when this screen is first loaded
    saveEventToService();

    // Automatically navigate to event details after 5 seconds
    _variables.timer =
        Timer(EventWaitingApprovalConstants.autoNavigationDelay, () {
      if (context.mounted) {
        navigateToEventDetails(context);
      }
    });
  }

  void saveEventToService() {
    // Set the event status to PENDING

    // Save the event to the EventService
    final eventService = EventService();
    final eventMap = eventService.convertEventToMap(_variables.event!);
    eventService.addEvent(eventMap);

    _variables.eventSaved = true;
    notifyListeners();
  }

  void navigateToEventDetails(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(event: _variables.event!),
      ),
    );
  }

  void navigateBack(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void dispose() {
    _variables.dispose();
    super.dispose();
  }
}

class EventCreationFinalStepViewModel extends ChangeNotifier {
  final EventCreationFinalStepVariables _variables;

  EventCreationFinalStepViewModel(this._variables);

  // Getters for accessing variables
  EventCreationFinalStepVariables get variables => _variables;

  // Format time utility
  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // Get formatted date
  String getFormattedDate() {
    if (_variables.event?.startDate != null) {
      return '${_variables.event!.startDate!.month}/${_variables.event!.startDate!.day}/${_variables.event!.startDate!.year}';
    }
    return EventCreationFinalStepConstants.noDateProvided;
  }

  // Get formatted time range
  String getFormattedTimeRange() {
    if (_variables.event?.startTime != null &&
        _variables.event?.endTime != null) {
      return '${formatTime(_variables.event!.startTime!)} - ${formatTime(_variables.event!.endTime!)}';
    }
    return EventCreationFinalStepConstants.noTimeProvided;
  }

  // Get location text
  String getLocationText() {
    if (_variables.event?.isOnline == true) {
      return EventCreationFinalStepConstants.onlineEventText;
    }
    return _variables.event?.venueName ??
        EventCreationFinalStepConstants.noLocationProvided;
  }

  // Handle edit button
  void handleEdit(BuildContext context) {
    Navigator.pop(context);
  }

  // Handle submit button
  void handleSubmit(BuildContext context) {
    // Save the event to the EventService
    final eventService = EventService();
    final eventMap = eventService.convertEventToMap(_variables.event!);
    eventService.addEvent(eventMap);

    // Navigate to the waiting approval screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EventWaitingApprovalScreen(event: _variables.event!),
      ),
    );
  }
}

class EventDetailsViewModel extends ChangeNotifier {
  final EventDetailsVariables _variables;

  EventDetailsViewModel(this._variables);

  // Getters for accessing variables
  EventDetailsVariables get variables => _variables;

  // Initialize screen dependencies
  void initializeDependencies(BuildContext context) {
    if (!_variables.dependenciesInitialized) {
      final mediaQuery = MediaQuery.of(context);
      _variables.screenHeight = mediaQuery.size.height;
      _variables.screenWidth = mediaQuery.size.width;
      _variables.dependenciesInitialized = true;

      // Pre-load image after dependencies are initialized
      preloadImage(context);
    }
  }

  // Save event to service
  void saveEventToService() {
    // Only save if not already saved
    if (!_variables.eventSaved && _variables.event?.title != null) {
      // Check if event already exists in the service
      final eventService = EventService();

      // Only add the event if it doesn't already exist
      if (!eventService.eventExists(_variables.event!.title!)) {
        final eventMap = eventService.convertEventToMap(_variables.event!);
        final added = eventService.addEvent(eventMap);

        if (added) {
          _variables.eventSaved = true;
          notifyListeners();
        }
      } else {
        // Event already exists, just mark as saved
        _variables.eventSaved = true;
        notifyListeners();
      }
    }
  }

  // Pre-load image with memory optimization
  void preloadImage(BuildContext context) {
    if (_variables.event?.imageBytes != null &&
        _variables.event!.imageBytes!.isNotEmpty) {
      _variables.cachedImage = MemoryImage(_variables.event!.imageBytes!);
    } else if (_variables.event?.imageUrl != null &&
        _variables.event!.imageUrl!.isNotEmpty) {
      _variables.cachedImage = NetworkImage(_variables.event!.imageUrl!);
    } else if (_variables.event?.imagePath != null && !kIsWeb) {
      _variables.cachedImage = FileImage(File(_variables.event!.imagePath!));
    }

    if (_variables.cachedImage != null) {
      // Precache image with reduced size
      precacheImage(_variables.cachedImage!, context).then((_) {
        _variables.isImageLoading = false;
        notifyListeners();
      }).catchError((error) {
        _variables.isImageLoading = false;
        _variables.cachedImage = null; // Clear on error
        notifyListeners();
      });
    } else {
      _variables.isImageLoading = false;
    }
  }

  // Optimized date formatting - reuse formatters
  String formatDate(DateTime? date) {
    if (date == null) return '';
    return _variables.dateFormatter.format(date);
  }

  String formatShortDate(DateTime? date) {
    if (date == null) return '';
    return _variables.shortDateFormatter.format(date);
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return '';

    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  // Toggle like functionality
  void toggleLike(BuildContext context) {
    if (_variables.hasLiked) {
      _variables.likeCount--;
    } else {
      _variables.likeCount++;
      // Show a brief animation or feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(EventDetailsConstants.youLikedEventText),
          duration: EventDetailsConstants.likeFeedbackDuration,
          backgroundColor: Color(0xFF0A0A4A),
        ),
      );
    }
    _variables.hasLiked = !_variables.hasLiked;
    notifyListeners();
  }

  // Toggle description expansion
  void toggleDescription() {
    _variables.isDescriptionExpanded = !_variables.isDescriptionExpanded;
    notifyListeners();
  }

  // Register for event
  void registerForEvent() {
    _variables.isRegistered = true;
    _variables.showRegistrationNotification = true;
    notifyListeners();

    // Auto-hide notification after 5 seconds
    Future.delayed(EventDetailsConstants.registrationNotificationDuration, () {
      _variables.showRegistrationNotification = false;
      notifyListeners();
    });
  }

  // Dismiss registration notification
  void dismissNotification() {
    _variables.showRegistrationNotification = false;
    notifyListeners();
  }

  // Copy event URL to clipboard
  void copyEventUrl(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _variables.eventUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(EventDetailsConstants.eventUrlCopiedText)),
    );
  }

  // Show share dialog
  void showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(EventDetailsConstants.shareEventTitle,
                style: TextStyle(fontSize: 18)),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event URL with copy button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _variables.eventUrl,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      copyEventUrl(context);
                      Navigator.of(context).pop();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              EventDetailsConstants.shareViaText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Simplified row of icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.facebook, color: Colors.blue),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              EventDetailsConstants.sharingViaFacebookText)),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat, color: Colors.green),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              EventDetailsConstants.sharingViaWhatsAppText)),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.email, color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text(EventDetailsConstants.sharingViaEmailText)),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.sms, color: Colors.orange),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text(EventDetailsConstants.sharingViaSMSText)),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Navigate back to events tab
  void navigateToEventsTab(BuildContext context) {
    // Pop until we reach the main navigation screen
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  // Show chat feature coming soon
  void showChatFeature(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(EventDetailsConstants.chatFeatureComingSoonText)),
    );
  }

  // Clean up resources
  void dispose() {
    // Clear any cached data
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    // Clear cached image
    _variables.cachedImage = null;

    super.dispose();
  }
}

class CreateEventViewModel extends ChangeNotifier {
  final Event _event = Event();
  final List<String> _selectedTags = [];
  final List<String> _speakers = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _churchLandlineController =
      TextEditingController();
  final TextEditingController _dressCodeController = TextEditingController();
  final TextEditingController _speakerController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  Event get event => _event;
  List<String> get selectedTags => _selectedTags;
  List<String> get speakers => _speakers;
  TextEditingController get titleController => _titleController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get contactInfoController => _contactInfoController;
  TextEditingController get churchLandlineController =>
      _churchLandlineController;
  TextEditingController get dressCodeController => _dressCodeController;
  TextEditingController get speakerController => _speakerController;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void toggleTag(String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    _event.tags = List.from(_selectedTags);
    notifyListeners();
  }

  void addSpeaker() {
    final speaker = _speakerController.text.trim();
    if (speaker.isNotEmpty && !_speakers.contains(speaker)) {
      _speakers.add(speaker);
      _event.speakers = List.from(_speakers);
      _speakerController.clear();
      notifyListeners();
    }
  }

  void removeSpeaker(int index) {
    if (index >= 0 && index < _speakers.length) {
      _speakers.removeAt(index);
      _event.speakers = List.from(_speakers);
      notifyListeners();
    }
  }

  bool validateForm() {
    _errorMessage = null;

    if (_titleController.text.trim().isEmpty) {
      _errorMessage = ValidationMessages.titleRequired;
      return false;
    }

    if (_selectedTags.isEmpty) {
      _errorMessage = ValidationMessages.tagsRequired;
      return false;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _errorMessage = ValidationMessages.descriptionRequired;
      return false;
    }

    if (_contactInfoController.text.trim().isEmpty) {
      _errorMessage = ValidationMessages.mobileRequired;
      return false;
    }

    // Validate mobile number format
    final mobilePattern = RegExp(EventConstants.philippineMobilePattern);
    if (!mobilePattern.hasMatch(_contactInfoController.text.trim())) {
      _errorMessage = ValidationMessages.invalidMobile;
      return false;
    }

    // Validate landline if provided
    if (_churchLandlineController.text.trim().isNotEmpty) {
      if (_churchLandlineController.text.trim().length !=
          EventConstants.landlineLength) {
        _errorMessage = ValidationMessages.invalidLandline;
        return false;
      }
    }

    return true;
  }

  void saveEventData() {
    _event.title = _titleController.text.trim();
    _event.description = _descriptionController.text.trim();
    _event.contactInfo = _contactInfoController.text.trim();
    _event.churchLandline = _churchLandlineController.text.trim();
    _event.dressCode = _dressCodeController.text.trim();
    _event.tags = List.from(_selectedTags);
    _event.speakers = List.from(_speakers);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contactInfoController.dispose();
    _churchLandlineController.dispose();
    _dressCodeController.dispose();
    _speakerController.dispose();
    super.dispose();
  }
}

class DateTimeViewModel extends ChangeNotifier {
  Event? _event;
  bool _isOneDay = true;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  List<EventDay> _eventDays = [];
  String? _errorMessage;

  // Getters
  bool get isOneDay => _isOneDay;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  TimeOfDay? get startTime => _startTime;
  TimeOfDay? get endTime => _endTime;
  List<EventDay> get eventDays => _eventDays;
  String? get errorMessage => _errorMessage;

  void initializeWithEvent(Event event) {
    _event = event;
    _isOneDay = event.isOneDay;
    _startDate = event.startDate;
    _endDate = event.endDate;
    _startTime = event.startTime;
    _endTime = event.endTime;
    _eventDays = event.eventDays ?? [];
    notifyListeners();
  }

  void setOneDay(bool isOneDay) {
    _isOneDay = isOneDay;
    _event?.isOneDay = isOneDay;

    if (isOneDay) {
      _eventDays.clear();
      _event?.eventDays?.clear();
    }

    notifyListeners();
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      _startDate = picked;
      _event?.startDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      _endDate = picked;
      _event?.endDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      _startTime = picked;
      _event?.startTime = picked;
      notifyListeners();
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      if (_startTime != null &&
          _timeToMinutes(picked) <= _timeToMinutes(_startTime!)) {
        _errorMessage = DateTimeValidation.endTimeBeforeStart;
      } else {
        _endTime = picked;
        _event?.endTime = picked;
        _errorMessage = null;
      }
      notifyListeners();
    }
  }

  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  void addEventDay() {
    _eventDays.add(EventDay());
    _event?.eventDays = List.from(_eventDays);
    notifyListeners();
  }

  void removeEventDay(int index) {
    if (index >= 0 && index < _eventDays.length) {
      _eventDays.removeAt(index);
      _event?.eventDays = List.from(_eventDays);
      notifyListeners();
    }
  }

  Future<void> selectEventDayDate(BuildContext context, int index) async {
    if (index < 0 || index >= _eventDays.length) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDays[index].date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      _eventDays[index].date = picked;
      _event?.eventDays = List.from(_eventDays);
      notifyListeners();
    }
  }

  bool validateDateTime() {
    _errorMessage = null;

    if (_isOneDay) {
      if (_startDate == null) {
        _errorMessage = 'Please select a start date';
        return false;
      }

      if (_startTime != null && _endTime != null) {
        if (_timeToMinutes(_startTime!) >= _timeToMinutes(_endTime!)) {
          _errorMessage = DateTimeValidation.endTimeBeforeStart;
          return false;
        }
      }
    } else {
      if (_eventDays.isEmpty) {
        _errorMessage = 'Please add at least one event day';
        return false;
      }

      for (int i = 0; i < _eventDays.length; i++) {
        final day = _eventDays[i];
        if (day.date == null) {
          _errorMessage = 'Please select date for Day ${i + 1}';
          return false;
        }

        if (day.startTime != null && day.endTime != null) {
          if (_timeToMinutes(day.startTime!) >= _timeToMinutes(day.endTime!)) {
            _errorMessage =
                'End time must be after start time for Day ${i + 1}';
            return false;
          }
        }
      }
    }

    return true;
  }
}

class EventLocationViewModel extends ChangeNotifier {
  final EventLocationModel _model = EventLocationModel();
  Event? _event;

  // Getters
  EventLocationModel get model => _model;

  void initializeWithEvent(Event event) {
    _event = event;
    _model.setOnline(event.isOnline ?? false);
    _model.setEventLink(event.eventLink);
    _model.setOutsourcedVenue(event.isOutsourcedVenue ?? false);

    if (event.meetingPlatform != null) {
      _model.setSelectedPlatform(event.meetingPlatform!);
    }

    notifyListeners();
  }

  void setOnline(bool isOnline) {
    _model.setOnline(isOnline);
    _event?.isOnline = isOnline;

    if (!isOnline) {
      _model.setEventLink(null);
      _event?.eventLink = null;
    }

    notifyListeners();
  }

  void setOutsourcedVenue(bool isOutsourced) {
    _model.setOutsourcedVenue(isOutsourced);
    _event?.isOutsourcedVenue = isOutsourced;
    notifyListeners();
  }

  void setSelectedPlatform(String platform) {
    _model.setSelectedPlatform(platform);
    _event?.meetingPlatform = platform;
    notifyListeners();
  }

  Future<void> validateAndSetEventLink(String url) async {
    if (url.trim().isEmpty) {
      _model.setUrlError(LocationValidationMessages.urlRequired);
      notifyListeners();
      return;
    }

    _model.setValidatingUrl(true);
    _model.setUrlError(null);
    notifyListeners();

    final validation = await _validateUrl(url.trim());

    _model.setValidatingUrl(false);

    if (validation.isValid) {
      _model.setEventLink(url.trim());
      _model.setUrlValidated(true);
      _model.setUrlError(null);
      _event?.eventLink = url.trim();
    } else {
      _model.setUrlError(validation.errorMessage);
      _model.setUrlValidated(false);
    }

    notifyListeners();
  }

  Future<LocationValidationResult> _validateUrl(String url) async {
    // Basic URL format validation
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return LocationValidationResult(
        isValid: false,
        errorMessage: LocationValidationMessages.urlMustStartWithHttp,
      );
    }

    // Platform-specific validation
    final platform = _model.selectedPlatform.toLowerCase();

    if (platform.contains('google meet') && !url.contains('meet.google.com')) {
      return LocationValidationResult(
        isValid: false,
        errorMessage: LocationValidationMessages.invalidGoogleMeetUrl,
      );
    }

    if (platform.contains('zoom') && !url.contains('zoom.us')) {
      return LocationValidationResult(
        isValid: false,
        errorMessage: LocationValidationMessages.invalidZoomUrl,
      );
    }

    if (platform.contains('teams') && !url.contains('teams.microsoft.com')) {
      return LocationValidationResult(
        isValid: false,
        errorMessage: LocationValidationMessages.invalidTeamsUrl,
      );
    }

    // Try to validate URL accessibility
    try {
      final uri = Uri.parse(url);
      final response = await http.head(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode >= 200 && response.statusCode < 400) {
        return LocationValidationResult(isValid: true);
      } else {
        return LocationValidationResult(
          isValid: false,
          errorMessage: LocationValidationMessages.urlNotAccessible,
        );
      }
    } catch (e) {
      return LocationValidationResult(
        isValid: false,
        errorMessage: LocationValidationMessages.invalidUrl,
      );
    }
  }

  bool validateLocation() {
    if (_model.isOnline) {
      if (_model.eventLink == null || _model.eventLink!.trim().isEmpty) {
        _model.setUrlError(LocationValidationMessages.urlRequired);
        notifyListeners();
        return false;
      }

      if (!_model.urlValidated) {
        _model.setUrlError(LocationValidationMessages.validWorkingUrl);
        notifyListeners();
        return false;
      }
    }

    return true;
  }
}

class EventSummaryViewModel extends ChangeNotifier {
  final EventSummaryModel _model = const EventSummaryModel();
  Event? _event;

  // Getters
  EventSummaryModel get model => _model;
  Event? get event => _event;

  void initializeWithEvent(Event event) {
    _event = event;
    notifyListeners();
  }

  List<EventDetailItem> getEventDetails() {
    if (_event == null) return [];

    final details = <EventDetailItem>[];

    if (_event!.title != null) {
      details.add(EventDetailItem(label: 'Title', value: _event!.title!));
    }

    if (_event!.description != null) {
      details.add(
          EventDetailItem(label: 'Description', value: _event!.description!));
    }

    if (_event!.tags.isNotEmpty) {
      details
          .add(EventDetailItem(label: 'Tags', value: _event!.tags.join(', ')));
    }

    if (_event!.speakers.isNotEmpty) {
      details.add(EventDetailItem(
          label: 'Speakers', value: _event!.speakers.join(', ')));
    }

    if (_event!.contactInfo != null) {
      details
          .add(EventDetailItem(label: 'Contact', value: _event!.contactInfo!));
    }

    if (_event!.dressCode != null) {
      details
          .add(EventDetailItem(label: 'Dress Code', value: _event!.dressCode!));
    }

    return details;
  }

  void showConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _model.dialogBackgroundColor,
        title: Text(_model.dialogTitle),
        content: Text(_model.dialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_model.dialogNoText),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(_model.dialogYesText),
          ),
        ],
      ),
    );
  }
}

class EventRegistrationFormViewModel extends ChangeNotifier {
  final EventRegistrationFormModel _model = const EventRegistrationFormModel();
  Event? _event;

  // Getters
  EventRegistrationFormModel get model => _model;

  void initializeWithEvent(Event event) {
    _event = event;

    // Initialize registration form config if not exists
    _event!.registrationFormConfig ??= RegistrationFormConfig(
      fieldVisibility: Map.from(_model.fieldVisibility),
      consentRequired: _model.consentRequired,
    );

    notifyListeners();
  }

  void toggleFieldVisibility(String fieldName) {
    final config = _event?.registrationFormConfig;
    if (config != null) {
      final currentVisibility = config.fieldVisibility[fieldName] ?? true;
      config.fieldVisibility[fieldName] = !currentVisibility;
      notifyListeners();
    }
  }

  void setConsentRequired(bool required) {
    final config = _event?.registrationFormConfig;
    if (config != null) {
      config.consentRequired = required;
      notifyListeners();
    }
  }

  void setConsentFormUrl(String url) {
    final config = _event?.registrationFormConfig;
    if (config != null) {
      config.consentFormUrl = url;
      notifyListeners();
    }
  }

  void setConsentMessage(String message) {
    final config = _event?.registrationFormConfig;
    if (config != null) {
      config.consentMessage = message;
      notifyListeners();
    }
  }

  void addDropdownOption(String fieldName, String option) {
    final config = _event?.registrationFormConfig;
    if (config != null) {
      config.dropdownOptions ??= {};
      config.dropdownOptions![fieldName] ??= [];

      if (!config.dropdownOptions![fieldName]!.contains(option)) {
        config.dropdownOptions![fieldName]!.add(option);
        notifyListeners();
      }
    }
  }

  void removeDropdownOption(String fieldName, int index) {
    final config = _event?.registrationFormConfig;
    if (config != null && config.dropdownOptions != null) {
      final options = config.dropdownOptions![fieldName];
      if (options != null && index >= 0 && index < options.length) {
        options.removeAt(index);
        notifyListeners();
      }
    }
  }

  bool validateForm() {
    final config = _event?.registrationFormConfig;
    if (config == null) return false;

    // Check if at least one field is visible
    final hasVisibleFields =
        config.fieldVisibility.values.any((visible) => visible);
    if (!hasVisibleFields) {
      return false;
    }

    // Validate consent form requirements
    if (config.consentRequired) {
      if (config.consentFormUrl == null ||
          config.consentFormUrl!.trim().isEmpty) {
        return false;
      }
    }

    return true;
  }
}

class ConsentFormViewModel extends ChangeNotifier {
  final ConsentFormModel _model = ConsentFormModel();

  // Getters
  ConsentFormModel get model => _model;

  void initializeFromEvent(Event event, String content) {
    _model.setContent(content);

    // Get registration form config from event
    final config = event.registrationFormConfig ??= RegistrationFormConfig(
      fieldVisibility: {},
      consentRequired: true,
      hasReadTerms: false,
      hasAcceptedTerms: false,
    );

    // Hydrate from existing config so back-navigation preserves state
    _model.setHasAccepted(config.hasAcceptedTerms);
    _model.setHasScrolledToBottom(config.hasReadTerms);

    // If consent isn't required, auto-pass
    if (!config.consentRequired) {
      _model.setHasScrolledToBottom(true);
      config.hasReadTerms = true;
      _model.setHasAccepted(true);
      config.hasAcceptedTerms = true;
    }
  }

  void detectScrollability(ScrollController scrollController) {
    if (!scrollController.hasClients) return;

    final max = scrollController.position.maxScrollExtent;
    if (max > 0) {
      _model.setIsScrollable(true);
    } else {
      _model.setIsScrollable(false);
      _model.setHasScrolledToBottom(true);
      // Update event config
      _updateEventConfig(hasReadTerms: true);
    }
    notifyListeners();
  }

  void handleScrollListener(ScrollController scrollController) {
    if (!scrollController.hasClients) return;

    final max = scrollController.position.maxScrollExtent;
    final offset = scrollController.offset;

    if (offset >= (max - 40.0) && !scrollController.position.outOfRange) {
      if (!_model.hasScrolledToBottom) {
        _model.setHasScrolledToBottom(true);
        _updateEventConfig(hasReadTerms: true);
        notifyListeners();
      }
    }
  }

  void toggleAccept(bool? value, BuildContext context) {
    final config = _getCurrentConfig();

    if (!config.consentRequired || _model.hasScrolledToBottom) {
      _model.setHasAccepted(value ?? false);
      _updateEventConfig(hasAcceptedTerms: _model.hasAccepted);
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ConsentFormValidationMessages.mustReadDocument),
          backgroundColor: _model.warningColor,
        ),
      );
    }
  }

  void handleComplete(
      BuildContext context, Function(bool) onAccept, Event event) {
    final config = _getCurrentConfig();

    if (config.consentRequired && !config.hasAcceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ConsentFormValidationMessages.mustAcceptTerms),
        ),
      );
      return;
    }

    // Inform parent callback
    onAccept(_model.hasAccepted);

    // Navigate to next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventInviteScreen(event: event),
      ),
    );
  }

  RegistrationFormConfig _getCurrentConfig() {
    // This would need to be passed from the parent or accessed through a global state
    // For now, return a default config
    return RegistrationFormConfig(
      fieldVisibility: {},
      consentRequired: true,
      hasReadTerms: _model.hasScrolledToBottom,
      hasAcceptedTerms: _model.hasAccepted,
    );
  }

  void _updateEventConfig({bool? hasReadTerms, bool? hasAcceptedTerms}) {
    // This would update the event's registration form config
    // Implementation depends on how the event is accessed globally
  }
}

class EventInviteViewModel extends ChangeNotifier {
  final EventInviteModel _model = EventInviteModel();
  Event? _event;

  // Getters
  EventInviteModel get model => _model;

  void initializeWithEvent(Event event) {
    _event = event;

    // Initialize event properties from model defaults
    _event!.inviteType = _model.inviteType;
    _event!.expectedCapacity = _model.expectedCapacity;

    notifyListeners();
  }

  void setInviteType(String type) {
    _model.setInviteType(type);
    _event?.inviteType = type;

    // Reset related fields when changing invite type
    if (type == 'Open Invite') {
      _model.setSelectedChurch(null);
      _model.setSelectedRolesCounts({});
      _model.setInvitedGuestsUI([]);
      _event?.selectedChurchName = null;
      _event?.selectedRolesCounts = null;
      _event?.invitedGuests = null;
    }

    notifyListeners();
  }

  void setExpectedCapacity(int capacity) {
    _model.setExpectedCapacity(capacity);
    _event?.expectedCapacity = capacity;
    notifyListeners();
  }

  void setCustomCapacity(bool isCustom) {
    _model.setCustomCapacity(isCustom);
    notifyListeners();
  }

  void updateCustomCapacity(int capacity) {
    _event?.customCapacity = capacity;
    _model.setExpectedCapacity(capacity);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _model.setSearchQuery(query);
    notifyListeners();
  }

  List<Map<String, dynamic>> getFilteredChurches() {
    if (_model.searchQuery.isEmpty) {
      return _model.sampleChurches;
    }

    return _model.sampleChurches.where((church) {
      return church['name']
          .toLowerCase()
          .contains(_model.searchQuery.toLowerCase());
    }).toList();
  }

  void selectChurch(Map<String, dynamic> church) {
    _model.setSelectedChurch(church);
    _event?.selectedChurchName = church['name'];

    // Initialize role counts from church data
    final roleCount = church['roleCount'] as Map<String, dynamic>;
    final initialCounts = <String, int>{};

    for (final role in _model.permanentRoles) {
      initialCounts[role] = 0;
    }

    _model.setSelectedRolesCounts(initialCounts);
    _event?.selectedRolesCounts = Map.from(initialCounts);

    notifyListeners();
  }

  void updateRoleCount(String role, int count) {
    final maxCount = _getMaxCountForRole(role);
    final finalCount = count.clamp(0, maxCount);

    _model.updateRoleCount(role, finalCount);

    // Update event
    _event?.selectedRolesCounts ??= {};
    if (finalCount <= 0) {
      _event?.selectedRolesCounts?.remove(role);
    } else {
      _event?.selectedRolesCounts![role] = finalCount;
    }

    notifyListeners();
  }

  int _getMaxCountForRole(String role) {
    final church = _model.selectedChurch;
    if (church == null) return 0;

    final roleCount = church['roleCount'] as Map<String, dynamic>;
    return roleCount[role] ?? 0;
  }

  void showGuestForm() {
    _model.setShowGuestForm(true);
    notifyListeners();
  }

  void hideGuestForm() {
    _model.setShowGuestForm(false);
    notifyListeners();
  }

  void addGuest(String username, String fullName, String guestChurch) {
    // Validate input
    if (username.trim().isEmpty ||
        fullName.trim().isEmpty ||
        guestChurch.trim().isEmpty) {
      _showNotification(EventInviteValidationMessages.fullNameRequired,
          NotificationType.error);
      return;
    }

    // Check for duplicate username
    final isDuplicate = _model.invitedGuestsUI
        .any((guest) => guest.username == username.trim());
    if (isDuplicate) {
      _showNotification(EventInviteValidationMessages.duplicateUsername,
          NotificationType.error);
      return;
    }

    // Check capacity
    final totalInvites = getTotalInviteCount() + 1;
    if (totalInvites > _model.expectedCapacity) {
      _showNotification(EventInviteValidationMessages.capacityExceeded,
          NotificationType.error);
      return;
    }

    final guest = GuestInvite(
      username: username.trim(),
      fullName: fullName.trim(),
      guestChurch: guestChurch.trim(),
    );

    _model.addGuest(guest);
    _event?.invitedGuests = List.from(_model.invitedGuestsUI);

    _showNotification('Guest added successfully!', NotificationType.success);
    hideGuestForm();
  }

  void removeGuest(int index) {
    _model.removeGuest(index);
    _event?.invitedGuests = List.from(_model.invitedGuestsUI);
    notifyListeners();
  }

  int getTotalInviteCount() {
    int total = 0;

    // Count role-based invites
    for (final count in _model.selectedRolesCounts.values) {
      total += count;
    }

    // Count individual guest invites
    total += _model.invitedGuestsUI.length;

    return total;
  }

  void _showNotification(String message, NotificationType type) {
    _model.setNotificationMessage(message);
    _model.setNotificationType(type);
    _model.setShowNotification(true);
    notifyListeners();

    // Auto-hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _model.setShowNotification(false);
      notifyListeners();
    });
  }

  void dismissNotification() {
    _model.setShowNotification(false);
    notifyListeners();
  }

  bool validateInvites() {
    if (_model.inviteType == 'Church Invite' && _model.selectedChurch == null) {
      _showNotification(
          'Please select a church to invite', NotificationType.error);
      return false;
    }

    if (_model.inviteType == 'Specific Invite' && getTotalInviteCount() == 0) {
      _showNotification(
          'Please add at least one invite', NotificationType.error);
      return false;
    }

    return true;
  }
}

class EventService {
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  final List<Map<String, dynamic>> _events = [];

  List<Map<String, dynamic>> get events => List.unmodifiable(_events);

  bool addEvent(Map<String, dynamic> eventMap) {
    try {
      _events.add(Map.from(eventMap));
      return true;
    } catch (e) {
      return false;
    }
  }

  bool eventExists(String title) {
    return _events.any((event) => event['title'] == title);
  }

  Map<String, dynamic> convertEventToMap(Event event) {
    return {
      'title': event.title,
      'description': event.description,
      'tags': event.tags,
      'speakers': event.speakers,
      'contactInfo': event.contactInfo,
      'churchLandline': event.churchLandline,
      'dressCode': event.dressCode,
      'isOneDay': event.isOneDay,
      'startDate': event.startDate?.toIso8601String(),
      'endDate': event.endDate?.toIso8601String(),
      'startTime': event.startTime != null
          ? '${event.startTime!.hour}:${event.startTime!.minute}'
          : null,
      'endTime': event.endTime != null
          ? '${event.endTime!.hour}:${event.endTime!.minute}'
          : null,
      'imageUrl': event.imageUrl,
      'imagePath': event.imagePath,
      'inviteType': event.inviteType,
      'expectedCapacity': event.expectedCapacity,
      'customCapacity': event.customCapacity,
      'selectedChurchName': event.selectedChurchName,
      'selectedRolesCounts': event.selectedRolesCounts,
      'invitedGuests': event.invitedGuests
          ?.map((guest) => {
                'username': guest.username,
                'fullName': guest.fullName,
                'guestChurch': guest.guestChurch,
              })
          .toList(),
    };
  }
}
