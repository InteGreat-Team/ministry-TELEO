//STEPS 7-11
// CREATE_EVENTS_FUNC.dart - Functions, ViewModels, and Business Logic
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/CHURCH_CREATEVENTS_VAR.dart';
import '../../frontend/screens/CHURCH_CREATEEVENTS_9.dart';
import '../../../eventscreation/frontend/widgets/event_app_bar.dart';
import '../../../eventscreation/frontend/widgets/confirmation_dialog.dart';
import '../../../eventscreation/frontend/widgets/required_asterisk.dart';
import '../../../eventscreation/frontend/widgets/step_indicator.dart';
import '../../../eventscreation/frontend/widgets/success_dialog.dart';
import '../../../c2eventscreation/models/event.dart';

// Your ViewModel and other classes go here...

class CreateEventViewModel extends ChangeNotifier {
  final Event _event = Event();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Controllers
  final List<TextEditingController> speakerControllers = [TextEditingController()];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController churchLandlineController = TextEditingController();
  final TextEditingController dressCodeController = TextEditingController();
  
  // Error messages
  Map<String, String> _errorMessages = {};
  
  // Getters
  Event get event => _event;
  Map<String, String> get errorMessages => _errorMessages;
  List<String> get availableTags => EventConstants.availableTags;
  int get maxImages => EventConstants.maxImages;
  
  CreateEventViewModel() {
    _initializeEvent();
  }
  
  void _initializeEvent() {
    _event.tags = [];
    _event.speakers = [];
    _event.additionalImages = [];
  }
  
  // Image handling
  Future<void> pickImage() async {
    if (_totalImagesCount >= EventConstants.maxImages) {
      throw Exception(ValidationMessages.maxImagesReached);
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        Uint8List? imageBytes;
        String? imagePath;

        if (kIsWeb) {
          imageBytes = await image.readAsBytes();
        } else {
          imagePath = image.path;
          imageBytes = await File(imagePath).readAsBytes();
        }

        if (_event.imageBytes == null && _event.imagePath == null && _event.imageUrl == null) {
          _event.imageBytes = imageBytes;
          _event.imagePath = imagePath;
        } else {
          final eventImage = EventImage(
            imageBytes: imageBytes,
            imagePath: imagePath,
          );
          _event.additionalImages.add(eventImage);
        }
        notifyListeners();
      }
    } catch (e) {
      throw Exception('${ValidationMessages.imagePickError}: $e');
    }
  }
  
  void removeImage(int index) {
    if (index == -1) {
      _event.imageBytes = null;
      _event.imagePath = null;
      _event.imageUrl = null;
    } else {
      _event.additionalImages.removeAt(index);
    }
    notifyListeners();
  }
  
  bool get hasMainImage {
    return _event.imageBytes != null || _event.imagePath != null || _event.imageUrl != null;
  }
  
  int get _totalImagesCount {
    return (hasMainImage ? 1 : 0) + _event.additionalImages.length;
  }
  
  int get totalImagesCount => _totalImagesCount;
  
  // Tag handling
  void toggleTag(String tag) {
    if (_event.tags.contains(tag)) {
      _event.tags.remove(tag);
    } else {
      _event.tags.add(tag);
    }
    notifyListeners();
  }
  
  // Speaker handling
  void addSpeaker() {
    speakerControllers.add(TextEditingController());
    notifyListeners();
  }
  
  void removeSpeaker(int index) {
    if (speakerControllers.length > 1 || index > 0) {
      speakerControllers.removeAt(index);
      notifyListeners();
    }
  }
  
  // Form validation
  bool validateForm() {
    _errorMessages = {};
    bool isValid = true;

    // Validate title
    if (titleController.text.isEmpty) {
      _errorMessages['title'] = ValidationMessages.titleRequired;
      isValid = false;
    }

    // Validate tags
    if (_event.tags.isEmpty) {
      _errorMessages['tags'] = ValidationMessages.tagsRequired;
      isValid = false;
    }

    // Validate description
    if (descriptionController.text.isEmpty) {
      _errorMessages['description'] = ValidationMessages.descriptionRequired;
      isValid = false;
    }

    // Validate mobile number
    if (mobileNumberController.text.isEmpty) {
      _errorMessages['mobileNumber'] = ValidationMessages.mobileRequired;
      isValid = false;
    } else {
      final mobileNumber = mobileNumberController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (!RegExp(EventConstants.philippineMobilePattern).hasMatch(mobileNumber)) {
        _errorMessages['mobileNumber'] = ValidationMessages.invalidMobile;
        isValid = false;
      }
    }

    // Validate church landline
    if (churchLandlineController.text.isNotEmpty) {
      final landline = churchLandlineController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (landline.length != EventConstants.landlineLength) {
        _errorMessages['churchLandline'] = ValidationMessages.invalidLandline;
        isValid = false;
      }
    }

    // Validate dress code
    if (dressCodeController.text.isNotEmpty) {
      if (!RegExp(EventConstants.dressCodePattern).hasMatch(dressCodeController.text)) {
        _errorMessages['dressCode'] = ValidationMessages.invalidDressCode;
        isValid = false;
      }
    }

    // Validate speakers
    for (int i = 0; i < speakerControllers.length; i++) {
      final speakerText = speakerControllers[i].text;
      if (speakerText.isNotEmpty) {
        if (!RegExp(EventConstants.namePattern).hasMatch(speakerText)) {
          _errorMessages['speaker$i'] = ValidationMessages.invalidSpeakerName;
          isValid = false;
        }
      }
    }

    notifyListeners();
    return isValid;
  }
  
  // Save form data
  void saveFormData() {
    _event.title = titleController.text;
    _event.description = descriptionController.text;
    _event.contactInfo = mobileNumberController.text;
    _event.churchLandline = churchLandlineController.text.isEmpty ? null : churchLandlineController.text;
    _event.dressCode = dressCodeController.text;
    
    _event.speakers = speakerControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();
  }
  
  // Navigation helper
  bool canProceed() {
    if (validateForm()) {
      saveFormData();
      return true;
    }
    return false;
  }
  
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    mobileNumberController.dispose();
    churchLandlineController.dispose();
    dressCodeController.dispose();
    for (var controller in speakerControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class DateTimeViewModel extends ChangeNotifier {
  bool _isOneDay = true;
  List<EventDay> _eventDays = [];
  String? _timeError;
  Map<int, String> _dateErrors = {};

  // Getters
  bool get isOneDay => _isOneDay;
  List<EventDay> get eventDays => _eventDays;
  String? get timeError => _timeError;
  Map<int, String> get dateErrors => _dateErrors;

  void initializeEventDays(Event event) {
    _isOneDay = event.isOneDay;

    if (event.eventDays != null && event.eventDays!.isNotEmpty) {
      _eventDays = List.from(event.eventDays!);
    } else if (event.startDate != null) {
      _eventDays.add(EventDay(
        date: event.startDate,
        startTime: event.startTime,
        endTime: event.endTime,
      ));

      if (!_isOneDay && event.endDate != null && event.startDate != null && !_isSameDay(event.startDate!, event.endDate!)) {
        _eventDays.add(EventDay(
          date: event.endDate,
          startTime: event.startTime,
          endTime: event.endTime,
        ));
      }
    } else {
      _eventDays.add(EventDay());
    }
    notifyListeners();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void setEventType(bool isOneDay) {
    _isOneDay = isOneDay;
    if (_isOneDay && _eventDays.length > 1) {
      _eventDays = [_eventDays.first];
      _dateErrors.clear();
    }
    notifyListeners();
  }

  void updateEventDate(int dayIndex, DateTime date) {
    _eventDays[dayIndex].date = date;
    _dateErrors.remove(dayIndex);

    if (!_isOneDay && _eventDays.length > 1) {
      _validateUniqueDates(dayIndex);
    }
    notifyListeners();
  }

  void updateEventTime(int dayIndex, TimeOfDay time, bool isStartTime) {
    if (isStartTime) {
      _eventDays[dayIndex].startTime = time;
      if (_eventDays[dayIndex].endTime != null) {
        _validateTimes(dayIndex);
      }
    } else {
      _eventDays[dayIndex].endTime = time;
      if (_eventDays[dayIndex].startTime != null) {
        _validateTimes(dayIndex);
      }
    }
    notifyListeners();
  }

  void _validateUniqueDates(int changedIndex) {
    if (_isOneDay) return;

    _dateErrors.remove(changedIndex);

    if (_eventDays[changedIndex].date == null) return;

    for (int i = 0; i < _eventDays.length; i++) {
      if (i != changedIndex && _eventDays[i].date != null) {
        if (_isSameDay(_eventDays[changedIndex].date!, _eventDays[i].date!)) {
          _dateErrors[changedIndex] = '${DateTimeValidation.duplicateDate} ${i + 1}';
          return;
        }
      }
    }
  }

  void _validateTimes(int dayIndex) {
    final startTime = _eventDays[dayIndex].startTime;
    final endTime = _eventDays[dayIndex].endTime;

    if (startTime != null && endTime != null) {
      final startMinutes = startTime.hour * 60 + startTime.minute;
      final endMinutes = endTime.hour * 60 + endTime.minute;

      if (startMinutes == endMinutes) {
        _timeError = DateTimeValidation.timeConflict;
      } else if (startMinutes > endMinutes) {
        _timeError = DateTimeValidation.endTimeBeforeStart;
      } else {
        _timeError = null;
      }
    }
  }

  void addEventDay() {
    _eventDays.add(EventDay());
    _isOneDay = false;
    notifyListeners();
  }

  void removeEventDay(int index) {
    if (_eventDays.length > 1) {
      _eventDays.removeAt(index);
      _dateErrors.remove(index);

      Map<int, String> newDateErrors = {};
      _dateErrors.forEach((key, value) {
        if (key > index) {
          newDateErrors[key - 1] = value;
        } else if (key < index) {
          newDateErrors[key] = value;
        }
      });
      _dateErrors = newDateErrors;

      if (_eventDays.length == 1) {
        _isOneDay = true;
        _dateErrors.clear();
      }

      if (!_isOneDay && _eventDays.length > 1) {
        for (int i = 0; i < _eventDays.length; i++) {
          if (_eventDays[i].date != null) {
            _validateUniqueDates(i);
          }
        }
      }
      notifyListeners();
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return 'Select time';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  bool validateForm() {
    for (var day in _eventDays) {
      if (day.date == null || day.startTime == null || day.endTime == null) {
        return false;
      }
    }
    return _timeError == null && _dateErrors.isEmpty;
  }

  void saveEventData(Event event) {
    event.isOneDay = _isOneDay;

    if (_eventDays.isNotEmpty) {
      event.startDate = _eventDays[0].date;
      event.startTime = _eventDays[0].startTime;

      if (_isOneDay || _eventDays.length == 1) {
        event.endDate = _eventDays[0].date;
        event.endTime = _eventDays[0].endTime;
      } else {
        event.endDate = _eventDays.last.date;
        event.endTime = _eventDays.last.endTime;
      }

      event.eventDays = List.from(_eventDays);
    }
  }
}

class EventLocationViewModel extends ChangeNotifier {
  final EventLocationModel _model;
  final TextEditingController eventLinkController = TextEditingController();
  final TextEditingController customPlatformController = TextEditingController();

  EventLocationViewModel(this._model);

  // Getters
  EventLocationModel get model => _model;

  void initializeFromEvent(Event event) {
    _model.setOnline(event.isOnline ?? false);
    _model.setEventLink(event.eventLink);
    
    if (event.eventLink != null) {
      eventLinkController.text = event.eventLink!;
      validateUrl(event.eventLink!);
    }
    
    // Initialize platform selection if available from the event
    if (event.meetingPlatform != null) {
      if (_model.meetingPlatforms.contains(event.meetingPlatform)) {
        _model.setSelectedPlatform(event.meetingPlatform!);
      } else {
        _model.setSelectedPlatform('Others');
        customPlatformController.text = event.meetingPlatform!;
      }
    }
  }

  void setOnline(bool value) {
    _model.setOnline(value);
    notifyListeners();
  }

  void setOutsourcedVenue(bool value) {
    _model.setOutsourcedVenue(value);
    notifyListeners();
  }

  void setSelectedPlatform(String platform) {
    _model.setSelectedPlatform(platform);
    
    // Clear URL field when platform changes
    if (eventLinkController.text.isNotEmpty) {
      eventLinkController.clear();
      _model.setUrlValidated(false);
      _model.setUrlError(null);
    }
    notifyListeners();
  }

  void onUrlChanged(String value) {
    _model.setEventLink(value);
    if (value.isNotEmpty) {
      validateUrl(value);
    }
  }

  Future<bool> validateUrl(String url) async {
    if (url.isEmpty) {
      _model.setUrlError(LocationValidationMessages.urlRequired);
      _model.setUrlValidated(false);
      _model.setValidatingUrl(false);
      notifyListeners();
      return false;
    }

    // Check if URL starts with http:// or https://
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      _model.setUrlError(LocationValidationMessages.urlMustStartWithHttp);
      _model.setUrlValidated(false);
      _model.setValidatingUrl(false);
      notifyListeners();
      return false;
    }

    // Platform-specific URL validation
    if (!_model.isCustomPlatform) {
      bool isValidPlatformUrl = false;
      String platformName = '';

      switch (_model.selectedPlatform) {
        case 'Google Meet':
          isValidPlatformUrl = url.contains('meet.google.com');
          platformName = 'Google Meet';
          break;
        case 'Zoom':
          isValidPlatformUrl = url.contains('zoom.us');
          platformName = 'Zoom';
          break;
        case 'Microsoft Teams':
          isValidPlatformUrl = url.contains('teams.microsoft.com') || url.contains('teams.live.com');
          platformName = 'Microsoft Teams';
          break;
        default:
          isValidPlatformUrl = true;
      }

      if (!isValidPlatformUrl) {
        _model.setUrlError('Please enter a valid $platformName URL');
        _model.setUrlValidated(false);
        _model.setValidatingUrl(false);
        notifyListeners();
        return false;
      }
    }

    _model.setValidatingUrl(true);
    _model.setUrlError(null);
    notifyListeners();

    try {
      // Simulate URL validation - in real app, use http package
      await Future.delayed(const Duration(seconds: 1));
      
      _model.setValidatingUrl(false);
      _model.setUrlValidated(true);
      _model.setUrlError(null);
      notifyListeners();
      
      return true;
    } catch (e) {
      _model.setValidatingUrl(false);
      _model.setUrlError('${LocationValidationMessages.invalidUrl}: ${e.toString().split(':')[0]}');
      _model.setUrlValidated(false);
      notifyListeners();
      return false;
    }
  }

  String getUrlHintText() {
    if (_model.isCustomPlatform) {
      return 'https://';
    }
    
    switch (_model.selectedPlatform) {
      case 'Google Meet':
        return 'https://meet.google.com/xxx-xxxx-xxx';
      case 'Zoom':
        return 'https://zoom.us/j/xxxxxxxxxx';
      case 'Microsoft Teams':
        return 'https://teams.microsoft.com/l/meetup-join/...';
      default:
        return 'https://';
    }
  }

  String getValidationHelpText() {
    if (_model.isCustomPlatform) {
      return 'Please enter a valid, working URL (e.g., https://example.com)';
    }
    return 'Please enter a valid ${_model.selectedPlatform} URL';
  }

  Future<LocationValidationResult> validateOnlineEvent() async {
    if (eventLinkController.text.isEmpty) {
      return LocationValidationResult(
        isValid: false,
        errorMessage: 'Please enter a URL',
      );
    }
    
    // Check if custom platform is selected but not specified
    if (_model.isCustomPlatform && customPlatformController.text.isEmpty) {
      return LocationValidationResult(
        isValid: false,
        errorMessage: 'Please specify the meeting platform',
      );
    }
    
    final isValid = await validateUrl(eventLinkController.text);
    if (!isValid) {
      return LocationValidationResult(
        isValid: false,
        errorMessage: 'Please enter a valid, working URL',
      );
    }
    
    return LocationValidationResult(isValid: true);
  }

  void saveEventData(Event event) {
    event.isOnline = _model.isOnline;
    event.eventLink = _model.eventLink;
    event.isOutsourcedVenue = _model.isOutsourcedVenue;
    
    // Save meeting platform information
    if (_model.isOnline) {
      event.meetingPlatform = _model.isCustomPlatform 
          ? customPlatformController.text 
          : _model.selectedPlatform;
    }
  }

  @override
  void dispose() {
    eventLinkController.dispose();
    customPlatformController.dispose();
    super.dispose();
  }
}

class EventMapViewModel extends ChangeNotifier {
  final EventMapModel _model = EventMapModel();
  final TextEditingController searchController = TextEditingController();

  // Getters
  EventMapModel get model => _model;

  void initializeFromEvent(Event event) {
    // Initialize venue information if available from event
    if (event.venueName != null) {
      _model.setVenueName(event.venueName!);
    }
    if (event.venueAddress != null) {
      _model.setDistance('0.0km'); // Default distance, could be calculated
    }
  }

  void toggleSearch() {
    _model.setSearching(!_model.isSearching);
    notifyListeners();
  }

  void setSearching(bool searching) {
    _model.setSearching(searching);
    notifyListeners();
  }

  void selectLocation(String location) {
    _model.setVenueName(location);
    _model.setSearching(false);
    _model.addRecentLocation(location);
    searchController.clear();
    notifyListeners();
  }

  IconData getLocationIcon(int index) {
    if (index == 0) return Icons.home;
    if (index == 1) return Icons.location_on;
    return Icons.history;
  }

  Color getLocationIconColor(int index) {
    return index < 2 ? const Color.fromARGB(255, 6, 6, 118) : Colors.grey;
  }

  void saveVenueToEvent(Event event) {
    event.venueName = _model.venueName;
    event.venueAddress = _model.venueName;
  }

  void navigateToSummary(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventSummaryScreen(
          event: event,
          title: null,
          tags: const [],
          description: null,
          contactInfo: null,
          churchLandline: null,
          dressCode: null,
          speakers: const [],
          imageUrl: null,
          imagePath: null,
          imageBytes: null,
          additionalImages: const [],
          isOneDay: true,
          eventDays: const [],
          startDate: null,
          endDate: null,
          startTime: null,
          endTime: null,
          isOnline: false,
          eventLink: null,
          isOutsourcedVenue: false,
          meetingPlatform: null,
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class EventSummaryViewModel {
  final EventSummaryModel _model = const EventSummaryModel();
  late Event _event;
  late String? _title;
  late List<String> _tags;
  late String? _description;
  late String? _contactInfo;
  late String? _churchLandline;
  late String? _dressCode;
  late List<String> _speakers;
  late String? _imageUrl;
  late String? _imagePath;
  late Uint8List? _imageBytes;
  late List<EventImage> _additionalImages;
  late bool _isOneDay;
  late List<EventDay> _eventDays;
  late DateTime? _startDate;
  late DateTime? _endDate;
  late TimeOfDay? _startTime;
  late TimeOfDay? _endTime;
  late bool _isOnline;
  late String? _eventLink;
  late bool _isOutsourcedVenue;
  late String? _meetingPlatform;

  // Getters
  EventSummaryModel get model => _model;

  void initializeFromWidget(dynamic widget) {
    _event = widget.event;
    _title = widget.title;
    _tags = widget.tags;
    _description = widget.description;
    _contactInfo = widget.contactInfo;
    _churchLandline = widget.churchLandline;
    _dressCode = widget.dressCode;
    _speakers = widget.speakers;
    _imageUrl = widget.imageUrl;
    _imagePath = widget.imagePath;
    _imageBytes = widget.imageBytes;
    _additionalImages = widget.additionalImages;
    _isOneDay = widget.isOneDay;
    _eventDays = widget.eventDays;
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _startTime = widget.startTime;
    _endTime = widget.endTime;
    _isOnline = widget.isOnline;
    _eventLink = widget.eventLink;
    _isOutsourcedVenue = widget.isOutsourcedVenue;
    _meetingPlatform = widget.meetingPlatform;
  }

  List<EventDetailItem> getEventDetails() {
    return [
      EventDetailItem(
        label: 'Event Title',
        value: _title ?? _event.title ?? 'To be answered',
      ),
      EventDetailItem(
        label: 'Tags',
        value: (_tags.isNotEmpty ? _tags : _event.tags).isEmpty 
            ? 'None selected' 
            : (_tags.isNotEmpty ? _tags : _event.tags).join(', '),
      ),
      EventDetailItem(
        label: 'Event Description',
        value: _description ?? _event.description ?? 'To be answered',
      ),
      EventDetailItem(
        label: 'Speaker',
        value: (_speakers.isNotEmpty ? _speakers : _event.speakers).isEmpty 
            ? 'None specified' 
            : (_speakers.isNotEmpty ? _speakers : _event.speakers).join(', '),
      ),
      EventDetailItem(
        label: 'Event Date',
        value: _isOneDay ? 'One day event' : 'Multiple day event',
      ),
      EventDetailItem(
        label: 'Date',
        value: _isOneDay 
            ? _formatDate(_startDate)
            : '${_formatDate(_startDate)} - ${_formatDate(_endDate)}',
      ),
      EventDetailItem(
        label: 'Time',
        value: '${_formatTime(_startTime)} - ${_formatTime(_endTime)}',
      ),
      EventDetailItem(
        label: 'Event Setting',
        value: _isOnline ? 'Online' : 'Onsite',
      ),
      EventDetailItem(
        label: 'Venue/Location',
        value: _isOnline 
            ? (_eventLink ?? 'No link provided')
            : (_isOutsourcedVenue 
                ? 'Outsourced Event API (link)'
                : (_event.venueName ?? 'No venue specified')),
      ),
    ];
  }

  Widget buildEventImage() {
    if (_event.imageBytes != null && _event.imageBytes!.isNotEmpty) {
      return Image.memory(
        _event.imageBytes!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (_event.imageUrl != null && _event.imageUrl!.isNotEmpty) {
      return Image.network(
        _event.imageUrl!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    } else if (_event.imagePath != null && !kIsWeb) {
      return Image.file(
        File(_event.imagePath!),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    } else {
      return _buildPlaceholderImage();
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.image,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    
    return '$hour:$minute $period';
  }

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  void showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: _model.dialogBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle, 
                      size: 24, 
                      color: _model.dialogIconColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _model.dialogTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _model.dialogMessage,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF444444),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          _model.dialogNoText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleConfirmNavigation(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _model.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          _model.dialogYesText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleConfirmNavigation(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventRegistrationFormScreen(
          event: _event,
          title: _title,
          tags: _tags,
          description: _description,
          contactInfo: _contactInfo,
          churchLandline: _churchLandline,
          dressCode: _dressCode,
          speakers: _speakers,
          imageUrl: _imageUrl,
          imagePath: _imagePath,
          imageBytes: _imageBytes,
          additionalImages: _additionalImages,
          isOneDay: _isOneDay,
          eventDays: _eventDays,
          startDate: _startDate,
          endDate: _endDate,
          startTime: _startTime,
          endTime: _endTime,
          isOnline: _isOnline,
          eventLink: _eventLink,
          isOutsourcedVenue: _isOutsourcedVenue,
          meetingPlatform: _meetingPlatform,
        ),
      ),
    );
  }

  void dispose() {
    // Clean up any resources if needed
  }
}

class EventRegistrationFormViewModel extends ChangeNotifier {
  final EventRegistrationFormModel _model = const EventRegistrationFormModel();
  
  // Form field controllers
  final TextEditingController consentFormUrlController = TextEditingController();
  final TextEditingController consentMessageController = TextEditingController();
  
  // Text controllers for new options
  final Map<String, TextEditingController> _newOptionControllers = {
    'sex': TextEditingController(),
    'tshirtSize': TextEditingController(),
    'emergencyContactRelation': TextEditingController(),
  };

  // Getters
  EventRegistrationFormModel get model => _model;

  void initializeFromEvent(Event event) {
    // Initialize with default values
    consentFormUrlController.text = 'Consent Form and Waiver.com';
    consentMessageController.text = 'By checking this box, you hereby agree and consent to the:';
    
    // Load saved form configuration if available
    if (event.registrationFormConfig != null) {
      _model._fieldVisibility = Map.from(event.registrationFormConfig!.fieldVisibility);
      _model.setConsentRequired(event.registrationFormConfig!.consentRequired);
      consentFormUrlController.text = event.registrationFormConfig!.consentFormUrl ?? consentFormUrlController.text;
      consentMessageController.text = event.registrationFormConfig!.consentMessage ?? consentMessageController.text;
      _model.setHasReadTerms(event.registrationFormConfig!.hasReadTerms);
      _model.setHasAcceptedTerms(event.registrationFormConfig!.hasAcceptedTerms);
      
      // Load saved dropdown options if available
      if (event.registrationFormConfig!.dropdownOptions != null) {
        _model._dropdownOptions = Map.from(event.registrationFormConfig!.dropdownOptions!);
      }
    }
  }

  void toggleFieldVisibility(String fieldName) {
    _model.setFieldVisibility(fieldName, !(_model.fieldVisibility[fieldName] ?? true));
    notifyListeners();
  }

  void setConsentRequired(bool required) {
    _model.setConsentRequired(required);
    notifyListeners();
  }

  void addDropdownOption(String fieldName) {
    final controller = _newOptionControllers[fieldName];
    if (controller != null && controller.text.isNotEmpty) {
      _model.dropdownOptions[fieldName]!.add(controller.text);
      controller.clear();
      notifyListeners();
    } else {
      _showErrorMessage(RegistrationFormValidationMessages.optionValueRequired);
    }
  }

  void removeDropdownOption(String fieldName, int index) {
    if (_model.dropdownOptions[fieldName]!.length > 1) {
      _model.dropdownOptions[fieldName]!.removeAt(index);
      notifyListeners();
    } else {
      _showErrorMessage(RegistrationFormValidationMessages.minOneOptionRequired);
    }
  }

  void showAddOptionDialog(BuildContext context, String fieldName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF8F0F0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Option',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _newOptionControllers[fieldName],
                  decoration: InputDecoration(
                    hintText: 'Enter option value',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: _model.primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: _model.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: _model.primaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF444444),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_newOptionControllers[fieldName]!.text.isNotEmpty) {
                            addDropdownOption(fieldName);
                            Navigator.of(context).pop();
                          } else {
                            _showErrorMessage(RegistrationFormValidationMessages.optionValueRequired);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _model.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void navigateToConsentForm(BuildContext context, Event event) {
    if (consentFormUrlController.text.isEmpty) {
      _showErrorMessage(RegistrationFormValidationMessages.consentFormUrlRequired);
      return;
    }

    if (consentMessageController.text.isEmpty) {
      _showErrorMessage(RegistrationFormValidationMessages.consentMessageRequired);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConsentFormScreen(
          title: consentFormUrlController.text,
          content: consentMessageController.text,
          onAccept: (accepted) {
            _model.setHasReadTerms(true);
            _model.setHasAcceptedTerms(accepted);
            notifyListeners();

            if (accepted) {
              _showInfoMessage('Terms and conditions accepted');
            } else {
              _showInfoMessage('Terms and conditions viewed but not accepted');
            }
          },
          event: event,
        ),
      ),
    );
  }

  bool validateForm() {
    if (_model.consentRequired && consentFormUrlController.text.isEmpty) {
      _showErrorMessage(RegistrationFormValidationMessages.consentFormUrlRequired);
      return false;
    }

    if (_model.consentRequired && consentMessageController.text.isEmpty) {
      _showErrorMessage(RegistrationFormValidationMessages.consentMessageRequired);
      return false;
    }

    if (_model.consentRequired && !_model.hasAcceptedTerms) {
      _showErrorMessage(RegistrationFormValidationMessages.consentNotAccepted);
      return false;
    }

    // Check if at least one field is visible
    if (_model.fieldVisibility.values.every((visible) => !visible)) {
      _showErrorMessage(RegistrationFormValidationMessages.noFieldsVisible);
      return false;
    }

    return true;
  }

  void saveFormConfiguration(Event event) {
    // Create or update the registration form configuration
    final formConfig = RegistrationFormConfig(
      fieldVisibility: Map.from(_model.fieldVisibility),
      consentRequired: _model.consentRequired,
      consentFormUrl: consentFormUrlController.text,
      consentMessage: consentMessageController.text,
      dropdownOptions: Map.from(_model.dropdownOptions),
      hasReadTerms: _model.hasReadTerms,
      hasAcceptedTerms: _model.hasAcceptedTerms,
    );

    // Save to event
    event.registrationFormConfig = formConfig;
  }

  void handleCompleteForm(BuildContext context, Event event) {
    if (validateForm()) {
      saveFormConfiguration(event);

      // Navigate to invite screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventInviteScreen(event: event),
        ),
      );
    }
  }

  void _showInfoMessage(String message) {
    // Implementation would show info snackbar
    // This is a placeholder for the UI layer to handle
  }

  void _showErrorMessage(String message) {
    // Implementation would show error snackbar
    // This is a placeholder for the UI layer to handle
  }

  @override
  void dispose() {
    consentFormUrlController.dispose();
    consentMessageController.dispose();
    for (var controller in _newOptionControllers.values) {
      controller.dispose();
    }
    super.dispose();
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

  void handleComplete(BuildContext context, Function(bool) onAccept, Event event) {
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
  
  // Form controllers
  final TextEditingController customCapacityController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController guestChurchController = TextEditingController();

  // Getters
  EventInviteModel get model => _model;

  void initializeFromEvent(Event event) {
    // Initialize with event data if available
    _model.setInviteType(event.inviteType ?? 'Open Invite');
    _model.setExpectedCapacity(event.expectedCapacity ?? 500);
    
    if (event.customCapacity != null) {
      _model.setCustomCapacity(true);
      customCapacityController.text = event.customCapacity.toString();
    }
    
    if (event.invitedGuests != null) {
      _model.setInvitedGuestsUI(List.from(event.invitedGuests!));
    }
    
    if (event.selectedRolesCounts != null) {
      _model.setSelectedRolesCounts(Map.from(event.selectedRolesCounts!));
    }
    
    if (event.selectedChurchName != null) {
      // Find and set the selected church by name
      final church = _model.sampleChurches.firstWhere(
        (c) => c['name'] == event.selectedChurchName,
        orElse: () => {},
      );
      if (church.isNotEmpty) {
        _model.setSelectedChurch(church);
      }
    }
  }

  void setInviteType(String? type) {
    if (type != null) {
      _model.setInviteType(type);
      
      // Clear specific invite data when switching to open invite
      if (type == 'Open Invite') {
        _model.setSelectedChurch(null);
        _model.setSelectedRolesCounts({});
        _model.setInvitedGuestsUI([]);
        _model.setShowGuestForm(false);
      }
      
      notifyListeners();
    }
  }

  void setExpectedCapacity(int capacity, bool isCustom) {
    _model.setExpectedCapacity(capacity);
    _model.setCustomCapacity(isCustom);
    
    if (!isCustom) {
      customCapacityController.clear();
    }
    
    notifyListeners();
  }

  void setCustomCapacity(bool isCustom) {
    _model.setCustomCapacity(isCustom);
    
    if (isCustom) {
      // Focus on custom input
      if (customCapacityController.text.isNotEmpty) {
        final customValue = int.tryParse(customCapacityController.text);
        if (customValue != null && customValue > 0) {
          _model.setExpectedCapacity(customValue);
        }
      }
    } else {
      // Reset to default capacity
      _model.setExpectedCapacity(500);
      customCapacityController.clear();
    }
    
    notifyListeners();
  }

  void onCustomCapacityChanged(String value) {
    if (_model.isCustomCapacity) {
      final capacity = int.tryParse(value);
      if (capacity != null && capacity > 0) {
        _model.setExpectedCapacity(capacity);
        notifyListeners();
      }
    }
  }

  String? validateCustomCapacity(String? value) {
    if (_model.isCustomCapacity) {
      if (value == null || value.isEmpty) {
        return EventInviteValidationMessages.customCapacityRequired;
      }
      
      final capacity = int.tryParse(value);
      if (capacity == null || capacity <= 0) {
        return EventInviteValidationMessages.invalidCapacity;
      }
    }
    return null;
  }

  void onSearchChanged(String query) {
    _model.setSearchQuery(query);
    notifyListeners();
  }

  List<Map<String, dynamic>> getFilteredChurches() {
    if (_model.searchQuery.isEmpty) {
      return _model.sampleChurches;
    }
    
    return _model.sampleChurches.where((church) {
      return church['name'].toLowerCase().contains(_model.searchQuery.toLowerCase());
    }).toList();
  }

  void selectChurch(Map<String, dynamic> church) {
    _model.setSelectedChurch(church);
    // Clear previous role selections when selecting a new church
    _model.setSelectedRolesCounts({});
    notifyListeners();
  }

  void updateRoleCount(String role, int count) {
    _model.updateRoleCount(role, count);
    notifyListeners();
  }

  void toggleGuestForm() {
    _model.setShowGuestForm(!_model.showGuestForm);
    
    if (!_model.showGuestForm) {
      // Clear form when closing
      usernameController.clear();
      fullNameController.clear();
      guestChurchController.clear();
    }
    
    notifyListeners();
  }

  void cancelGuestForm() {
    _model.setShowGuestForm(false);
    usernameController.clear();
    fullNameController.clear();
    guestChurchController.clear();
    notifyListeners();
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return EventInviteValidationMessages.usernameRequired;
    }
    
    // Check for duplicate usernames
    final isDuplicate = _model.invitedGuestsUI.any((guest) => guest.username == value);
    if (isDuplicate) {
      return EventInviteValidationMessages.duplicateUsername;
    }
    
    return null;
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return EventInviteValidationMessages.fullNameRequired;
    }
    return null;
  }

  String? validateGuestChurch(String? value) {
    if (value == null || value.isEmpty) {
      return EventInviteValidationMessages.guestChurchRequired;
    }
    return null;
  }

  void addGuest() {
    // Validate form fields
    final usernameError = validateUsername(usernameController.text);
    final fullNameError = validateFullName(fullNameController.text);
    final churchError = validateGuestChurch(guestChurchController.text);
    
    if (usernameError != null || fullNameError != null || churchError != null) {
      showNotification(
        usernameError ?? fullNameError ?? churchError ?? 'Please fill all fields correctly',
        NotificationType.error,
      );
      return;
    }
    
    // Check capacity
    if (isCapacityReached()) {
      showNotification(
        EventInviteValidationMessages.capacityExceeded,
        NotificationType.error,
      );
      return;
    }
    
    // Add guest
    final guest = GuestInvite(
      username: usernameController.text.trim(),
      fullName: fullNameController.text.trim(),
      guestChurch: guestChurchController.text.trim(),
    );
    
    _model.addGuest(guest);
    
    // Clear form and hide
    usernameController.clear();
    fullNameController.clear();
    guestChurchController.clear();
    _model.setShowGuestForm(false);
    
    showNotification(
      'Guest added successfully',
      NotificationType.success,
    );
    
    notifyListeners();
  }

  void removeGuest(int index) {
    _model.removeGuest(index);
    showNotification(
      'Guest removed successfully',
      NotificationType.success,
    );
    notifyListeners();
  }

  int calculateTotalInvitedPeople() {
    int total = 0;
    
    // Add church role counts
    total += _model.selectedRolesCounts.values.fold(0, (sum, count) => sum + count);
    
    // Add individual guests
    total += _model.invitedGuestsUI.length;
    
    return total;
  }

  bool isCapacityReached() {
    return calculateTotalInvitedPeople() >= _model.expectedCapacity;
  }

  void showNotification(String message, NotificationType type) {
    _model.setNotificationMessage(message);
    _model.setNotificationType(type);
    _model.setShowNotification(true);
    notifyListeners();
    
    // Auto-hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      hideNotification();
    });
  }

  void hideNotification() {
    _model.setShowNotification(false);
    _model.setNotificationMessage(null);
    notifyListeners();
  }

  bool validateForm() {
    // Check invite type
    if (_model.inviteType.isEmpty) {
      showNotification(
        EventInviteValidationMessages.inviteTypeRequired,
        NotificationType.error,
      );
      return false;
    }
    
    // Check capacity
    if (_model.expectedCapacity <= 0) {
      showNotification(
        EventInviteValidationMessages.capacityRequired,
        NotificationType.error,
      );
      return false;
    }
    
    // Check custom capacity if selected
    if (_model.isCustomCapacity) {
      final customValue = int.tryParse(customCapacityController.text);
      if (customValue == null || customValue <= 0) {
        showNotification(
          EventInviteValidationMessages.invalidCapacity,
          NotificationType.error,
        );
        return false;
      }
    }
    
    // Check capacity limits for specific invites
    if (_model.inviteType == 'Specific Invites') {
      if (isCapacityReached()) {
        showNotification(
          EventInviteValidationMessages.capacityExceeded,
          NotificationType.error,
        );
        return false;
      }
    }
    
    return true;
  }

  void proceedToNext(BuildContext context, Event event, GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate() || !validateForm()) {
      return;
    }
    
    // Save data to event
    event.inviteType = _model.inviteType;
    event.expectedCapacity = _model.expectedCapacity;
    
    if (_model.isCustomCapacity) {
      event.customCapacity = _model.expectedCapacity;
    } else {
      event.customCapacity = null;
    }
    
    if (_model.selectedChurch != null) {
      event.selectedChurchName = _model.selectedChurch!['name'];
      event.selectedRolesCounts = Map.from(_model.selectedRolesCounts);
    }
    
    event.invitedGuests = List.from(_model.invitedGuestsUI);
    
    // Navigate to next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventTargetsScreen(event: event),
      ),
    );
  }

  @override
  void dispose() {
    customCapacityController.dispose();
    searchController.dispose();
    usernameController.dispose();
    fullNameController.dispose();
    guestChurchController.dispose();
    super.dispose();
  }
}

mixin EventTargetsScreenFunctions on ChurchCreateVentsVar {
  void initEventTargetsScreen(Event event) {
    // Initialize max allowed date (7 days from now)
    maxAllowedDate = DateTime.now().add(const Duration(days: 7));
    
    // Initialize target publish date and time from event if available
    targetPublishDate = event.targetPublishDate;
    targetPublishTime = event.targetPublishTime;
    
    // Initialize invite message
    inviteMessageController.text = event.inviteMessage ?? '';
  }
  
  String getFormattedEventDates(Event event) {
    if (event.isOneDay && event.startDate != null) {
      return dayFormatter.format(event.startDate!);
    } else if (!event.isOneDay && event.startDate != null && event.endDate != null) {
      return '${dayFormatter.format(event.startDate!)} - ${dayFormatter.format(event.endDate!)}';
    }
    return 'Date not set';
  }
  
  String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.day}/${date.year}';
  }
  
  Future<void> selectDate(BuildContext context, Function setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: targetPublishDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: maxAllowedDate!,
    );
    if (picked != null && picked != targetPublishDate) {
      setState(() {
        targetPublishDate = picked;
      });
    }
  }
  
  Future<void> selectTime(BuildContext context, Function setState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: targetPublishTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != targetPublishTime) {
      setState(() {
        targetPublishTime = picked;
      });
    }
  }
  
  void showSendInvitesDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Send Invites'),
          content: const Text('Are you ready to send invites for this event?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to final step
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventCreationFinalStep(event: event),
                  ),
                );
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
  
  void dismissSuccessNotification(Function setState) {
    setState(() {
      showSuccessNotification = false;
    });
  }
  
  void dismissNotification(Function setState) {
    setState(() {
      showNotification = false;
    });
  }
}

mixin EventCreationFinalStepFunctions on ChurchCreateVentsVar {
  Widget buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

mixin EventWaitingApprovalScreenFunctions on ChurchCreateVentsVar {
  void initEventWaitingApprovalScreen(Event event, BuildContext context) {
    eventSaved = true;
    
    // Start a timer to redirect after 3 seconds
    redirectTimer = Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailsScreen(event: event),
        ),
      );
    });
  }
  
  void disposeEventWaitingApprovalScreen() {
    redirectTimer?.cancel();
  }
}

mixin EventDetailsScreenFunctions on ChurchCreateVentsVar {
  void initEventDetailsScreen(Event event) {
    // Initialize like state (could be loaded from a service)
    hasLiked = false;
    likeCount = 42; // Sample like count
    
    // Initialize registration state
    isRegistered = false;
    
    // Format dates and times
    if (event.startDate != null) {
      formattedStartDate = dayFormatter.format(event.startDate!);
    }
    if (event.endDate != null) {
      formattedEndDate = dayFormatter.format(event.endDate!);
    }
    if (event.startTime != null) {
      formattedStartTime = _formatTimeOfDay(event.startTime!);
    }
    if (event.endTime != null) {
      formattedEndTime = _formatTimeOfDay(event.endTime!);
    }
  }
  
  void initEventDetailsScreenDependencies(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
  }
  
  void disposeEventDetailsScreen() {
    // Clean up any resources if needed
  }
  
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
  
  void toggleLike(Function setState) {
    setState(() {
      hasLiked = !hasLiked;
      likeCount += hasLiked ? 1 : -1;
    });
  }
  
  void toggleDescription(Function setState) {
    setState(() {
      isDescriptionExpanded = !isDescriptionExpanded;
    });
  }
  
  void registerForEvent(Function setState) {
    setState(() {
      isRegistered = true;
      showRegistrationNotification = true;
    });
    
    // Auto-dismiss notification after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showRegistrationNotification = false;
      });
    });
  }
  
  void navigateToEventsTab(BuildContext context) {
    // Navigate to events tab or home screen
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  
  Widget buildEventImage(double screenHeight) {
    return Container(
      height: screenHeight * 0.3,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/400x200'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  
  Widget buildInfoContainer({
    required Color backgroundColor,
    required Widget leading,
    required String title,
    required String subtitle,
    Color? subtitleColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subtitleColor ?? Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0A0A4A),
        ),
      ),
    );
  }
  
  Widget buildParticipantsList(Event event) {
    List<String> participants = [];
    
    // Add invited churches
    for (var church in event.invitedChurches) {
      participants.add(church.name);
    }
    
    // Add invited guests
    for (var guest in event.invitedGuests) {
      participants.add(guest.fullName);
    }
    
    if (participants.isEmpty) {
      return Text(
        'Open to all',
        style: TextStyle(color: Colors.grey[700]),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: participants.take(3).map((participant) => Text(
        participant,
        style: TextStyle(color: Colors.grey[700]),
      )).toList(),
    );
  }
  
  void showShareDialog(BuildContext context, String eventUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Share this event with others:'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  eventUrl,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                // Copy to clipboard
                Clipboard.setData(ClipboardData(text: eventUrl));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Event URL copied to clipboard')),
                );
              },
              child: const Text('Copy Link'),
            ),
          ],
        );
      },
    );
  }
}

mixin ChurchCreateVentsFunc on ChurchCreateVentsVar 
    with EventTargetsScreenFunctions, 
         EventCreationFinalStepFunctions,
         EventWaitingApprovalScreenFunctions,
         EventDetailsScreenFunctions {
  
  void initializeEventInviteScreen(Event event) {
    inviteType = event.inviteType ?? 'Open Invite';
    expectedCapacity = event.expectedCapacity ?? 500;
    if (event.customCapacity != null) {
      isCustomCapacity = true;
      customCapacityController.text = event.customCapacity!;
      
      // Initialize expected capacity from custom capacity if available
      final customCapacityValue = int.tryParse(event.customCapacity!);
      if (customCapacityValue != null) {
        expectedCapacity = customCapacityValue;
      }
    }
    
    // Initialize UI list with existing invited churches
    invitedChurchesUI = List.from(event.invitedChurches ?? []);
    
    // Initialize UI list with existing invited guests
    invitedGuestsUI = List.from(event.invitedGuests ?? []);
    
    // Initialize invite counts and total invited people
    initializeInviteCounts();
  }
  
  void disposeEventInviteScreen() {
    customCapacityController.dispose();
    searchController.dispose();
    usernameController.dispose();
    fullNameController.dispose();
    guestChurchController.dispose();
  }
  
  // Initialize invite counts from existing data
  void initializeInviteCounts() {
    churchInviteCounts.clear();
    totalInvitedPeople = 0;
    
    // Count people from existing church invites
    for (var church in invitedChurchesUI) {
      int churchTotal = 0;
      
      // Parse the roles and counts from the format "Role (count)"
      for (var roleString in church.roles) {
        final parts = roleString.split(' (');
        if (parts.length == 2) {
          final countStr = parts[1].replaceAll(')', '');
          final count = int.tryParse(countStr) ?? 0;
          churchTotal += count;
        }
      }
      
      churchInviteCounts[church.name] = churchTotal;
      totalInvitedPeople += churchTotal;
    }
    
    // Add individual guests to the total
    totalInvitedPeople += invitedGuestsUI.length;
  }

  // Calculate total invited people (sum of all church roles and individual guests)
  int calculateTotalInvitedPeople() {
    return totalInvitedPeople;
  }

  // Calculate total people that would be invited if current selection is added
  int calculateTotalWithCurrentSelection() {
    // Start with the current total of invited people
    int total = totalInvitedPeople;
    
    // If we're editing an existing church, subtract its current count
    if (selectedChurch != null) {
      final existingCount = churchInviteCounts[selectedChurch!['name']] ?? 0;
      total -= existingCount;
    }
    
    // Add counts from currently selected roles
    int selectedTotal = 0;
    selectedRolesCounts.forEach((role, count) {
      if (count > 0) {
        selectedTotal += count;
      }
    });
    
    return total + selectedTotal;
  }

  // Get remaining capacity
  int getRemainingCapacity() {
    return expectedCapacity - calculateTotalInvitedPeople();
  }

  // Check if adding the selected roles would exceed capacity
  bool wouldExceedCapacity() {
    if (inviteType == 'Open Invite') return false;
    
    int totalWithCurrentSelection = calculateTotalWithCurrentSelection();
    
    // Check if this would exceed capacity
    return totalWithCurrentSelection > expectedCapacity;
  }

  // Check if capacity limit is reached
  bool isCapacityReached() {
    if (inviteType == 'Open Invite') return false;
    int totalInvited = calculateTotalInvitedPeople();
    return totalInvited >= expectedCapacity;
  }

  void showErrorNotification(String message) {
    notificationMessage = message;
    notificationType = NotificationType.error;
    showNotification = true;
  }

  void showWarningNotification(String message) {
    notificationMessage = message;
    notificationType = NotificationType.warning;
    showNotification = true;
  }

  void showSuccessNotification(String message) {
    notificationMessage = message;
    notificationType = NotificationType.success;
    showNotification = true;
    
    // Auto-dismiss notification after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      showNotification = false;
    });
  }
  
  void dismissNotification() {
    showNotification = false;
  }

  // Update expected capacity from custom capacity input
  void updateExpectedCapacityFromCustomInput() {
    if (customCapacityController.text.isNotEmpty) {
      final customCapacityValue = int.tryParse(customCapacityController.text);
      if (customCapacityValue != null) {
        // Check if current invites exceed the new capacity
        int totalInvited = calculateTotalInvitedPeople();
        
        expectedCapacity = customCapacityValue;
        
        if (inviteType == 'Private' && totalInvited > expectedCapacity) {
          capacityErrorMessage = 'Warning: Your current invites ($totalInvited people) exceed the new capacity limit ($expectedCapacity people).';
          
          // Show warning notification
          showWarningNotification(capacityErrorMessage!);
        } else {
          capacityErrorMessage = null;
        }
      }
    }
  }

  // COMPLETELY REWRITTEN: Add church with roles function
  void addChurchWithRoles(Function setState) {
    if (selectedChurch != null && selectedRolesCounts.isNotEmpty) {
      // Create a list of roles with their counts
      List<String> roles = [];
      int totalPeopleToAdd = 0;

      selectedRolesCounts.forEach((role, count) {
        // Only add roles with count > 0
        if (count > 0) {
          roles.add("$role ($count)");
          totalPeopleToAdd += count;
        }
      });

      if (roles.isEmpty) {
        showErrorNotification('Please select at least one role with a count greater than 0');
        return;
      }

      int totalWithCurrentSelection = calculateTotalWithCurrentSelection();

      if (totalWithCurrentSelection > expectedCapacity) {
        capacityErrorMessage =
            'Cannot add these roles. It would exceed your capacity limit of $expectedCapacity people.';
        showErrorNotification(capacityErrorMessage!);
        return;
      }

      final newChurch = ChurchInvite(
        name: selectedChurch!['name'],
        members: selectedChurch!['members'],
        roles: roles,
      );

      // Store the church data temporarily
      final churchToAdd = selectedChurch;
      final rolesToAdd = Map<String, int>.from(selectedRolesCounts);
      
      // First, clear the selection state
      setState(() {
        selectedChurch = null;
        selectedRolesCounts = {};
        isInChurchSelectionMode = false;
      });

      // Then in a separate setState, add the church data
      // This ensures the UI updates correctly
      Future.microtask(() {
        setState(() {
          // Check if church is already in the list
          final existingIndex = invitedChurchesUI.indexWhere(
            (church) => church.name == churchToAdd!['name'],
          );

          if (existingIndex >= 0) {
            final existingCount = churchInviteCounts[churchToAdd!['name']] ?? 0;
            totalInvitedPeople -= existingCount;
            
            // Update roles if church already exists
            invitedChurchesUI[existingIndex] = newChurch;
            showSuccessNotification('Church roles updated successfully');
          } else {
            // Add new church with roles
            invitedChurchesUI.add(newChurch);
            showSuccessNotification('Church added successfully');
          }

          churchInviteCounts[churchToAdd!['name']] = totalPeopleToAdd;
          totalInvitedPeople += totalPeopleToAdd;
        });
      });
    }
  }

  void showRoleSelectionDialog(Function setState) {
    // Create a temporary map for role selection with counts
    Map<String, int> tempSelectedRolesCounts = Map.from(selectedRolesCounts);
    
    // Initialize with default values if empty
    for (var role in permanentRoles) {
      if (!tempSelectedRolesCounts.containsKey(role)) {
        tempSelectedRolesCounts[role] = 0;
      }
    }
    
    // Calculate the TOTAL number of people already invited across ALL churches and guests
    int totalAlreadyInvited = calculateTotalInvitedPeople();
    
    // If this church is already in the list, subtract its current counts to avoid double counting
    int currentChurchTotal = 0;
    if (selectedChurch != null) {
      currentChurchTotal = churchInviteCounts[selectedChurch!['name']] ?? 0;
      // Subtract this church's current contribution from the total
      totalAlreadyInvited -= currentChurchTotal;
    }
    
    // Calculate remaining capacity after accounting for all other invites
    int remainingCapacity = expectedCapacity - totalAlreadyInvited;
    
    // This would need to be implemented in the UI layer
    // The dialog implementation would go in the screen file
  }

  // REWRITTEN: Select church function
  void selectChurch(Map<String, dynamic> church, Function setState) {
    // Check if capacity is already reached
    if (inviteType == 'Private' && isCapacityReached()) {
      showErrorNotification('Cannot add more churches. You have reached your capacity limit of $expectedCapacity people.');
      return;
    }
    
    setState(() {
      selectedChurch = church;
      selectedRolesCounts = {};
      isInChurchSelectionMode = true;
    });
  }

  void removeChurch(String churchName, Function setState) {
    setState(() {
      // Subtract this church's count from the total before removing
      final churchCount = churchInviteCounts[churchName] ?? 0;
      totalInvitedPeople -= churchCount;
      
      // Remove the church from the invite counts map
      churchInviteCounts.remove(churchName);
      
      // Remove the church from the UI list
      invitedChurchesUI.removeWhere((church) => church.name == churchName);
    });
  }

  void editChurch(ChurchInvite church, Function setState) {
    // Find and select the church for editing
    final churchData = sampleChurches.firstWhere(
      (c) => c['name'] == church.name,
      orElse: () => {'name': church.name, 'members': church.members},
    );
    
    // Parse the roles and counts from the format "Role (count)"
    Map<String, int> roleCounts = {};
    for (var roleString in church.roles) {
      final parts = roleString.split(' (');
      if (parts.length == 2) {
        final role = parts[0];
        final countStr = parts[1].replaceAll(')', '');
        final count = int.tryParse(countStr) ?? 0;
        roleCounts[role] = count;
      }
    }
    
    setState(() {
      selectedChurch = churchData;
      selectedRolesCounts = roleCounts;
      isInChurchSelectionMode = true;
    });
  }

  void clearAllChurches(Function setState) {
    setState(() {
      // Clear all church-related data
      invitedChurchesUI.clear();
      churchInviteCounts.clear();
      
      // Recalculate total invited people (only guests remain)
      totalInvitedPeople = invitedGuestsUI.length;
    });
  }

  List<Map<String, dynamic>> getFilteredChurches() {
    if (searchQuery.isEmpty) {
      return sampleChurches;
    }
    
    return sampleChurches.where((church) => 
      church['name'].toString().toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  // REWRITTEN: Show add guest form
  void showAddGuestForm(Function setState) {
    // Check if capacity is already reached
    if (inviteType == 'Private' && isCapacityReached()) {
      showErrorNotification('Cannot add more guests. You have reached your capacity limit of $expectedCapacity people.');
      return;
    }
    
    // Clear form fields first
    usernameController.clear();
    fullNameController.clear();
    guestChurchController.clear();
    
    setState(() {
      showGuestForm = true;
    });
  }

  // REWRITTEN: Hide add guest form
  void hideAddGuestForm(Function setState) {
    setState(() {
      showGuestForm = false;
    });
  }

  // COMPLETELY REWRITTEN: Add guest function
  void addGuest(Function setState) {
    if (usernameController.text.isEmpty || 
        fullNameController.text.isEmpty || 
        guestChurchController.text.isEmpty) {
      showErrorNotification('Please fill in all guest information');
      return;
    }

    // Check if adding one more guest would exceed capacity
    if (inviteType == 'Private' && calculateTotalInvitedPeople() + 1 > expectedCapacity) {
      showErrorNotification('Cannot add more guests. It would exceed your capacity limit of $expectedCapacity people.');
      return;
    }

    // Store the guest data temporarily
    final username = usernameController.text.trim();
    final fullName = fullNameController.text.trim();
    final churchName = guestChurchController.text.trim();
    
    // First, hide the form
    setState(() {
      showGuestForm = false;
    });
    
    // Then in a separate setState, add the guest data
    // This ensures the UI updates correctly
    Future.microtask(() {
      setState(() {
        final newGuest = GuestInvite(
          username: username,
          fullName: fullName,
          churchName: churchName,
        );
        
        invitedGuestsUI.add(newGuest);
        totalInvitedPeople += 1; // Add 1 to the total for this guest
        showSuccessNotification('Guest added successfully');
      });
    });
  }

  void removeGuest(int index, Function setState) {
    setState(() {
      invitedGuestsUI.removeAt(index);
      totalInvitedPeople -= 1; // Subtract 1 from the total for this guest
    });
  }

  // Get color for capacity indicator
  Color getCapacityColor() {
    final totalInvited = calculateTotalInvitedPeople();
    final percentFilled = totalInvited / expectedCapacity;
    
    if (percentFilled >= 1.0) {
      return Colors.red;
    } else if (percentFilled >= 0.9) {
      return Colors.orange;
    } else if (percentFilled >= 0.7) {
      return Colors.amber;
    } else {
      return Colors.green;
    }
  }

  // Check if a church is already invited
  bool isChurchInvited(String churchName) {
    return invitedChurchesUI.any((church) => church.name == churchName);
  }

  // Save event data and navigate to next screen
  void saveAndContinue(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // Check if current invites exceed capacity
      if (inviteType == 'Private') {
        int totalInvited = calculateTotalInvitedPeople();
        if (totalInvited > expectedCapacity) {
          showErrorNotification('Cannot proceed. Your current invites ($totalInvited people) exceed the capacity limit ($expectedCapacity people). Please remove some invites or increase the capacity.');
          return;
        }
      }
      
      // Navigate to next screen would be implemented here
      // For now, just show success
      showSuccessNotification('Event data saved successfully');
    }
  }

  // Build a notification widget based on type
  Widget buildNotification() {
    if (!showNotification || notificationMessage == null) {
      return const SizedBox.shrink();
    }
    
    Color backgroundColor;
    IconData iconData;
    
    switch (notificationType) {
      case NotificationType.error:
        backgroundColor = Colors.red;
        iconData = Icons.error_outline;
        break;
      case NotificationType.warning:
        backgroundColor = Colors.orange;
        iconData = Icons.warning_amber_outlined;
        break;
      case NotificationType.success:
        backgroundColor = Colors.green;
        iconData = Icons.check_circle_outline;
        break;
      default:
        backgroundColor = Colors.blue;
        iconData = Icons.info_outline;
        break;
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: backgroundColor,
      child: Row(
        children: [
          Icon(iconData, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              notificationMessage!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.white),
            onPressed: dismissNotification,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class EventApiErrorViewModel {
  final EventApiErrorModel _errorModel = const EventApiErrorModel();

  EventApiErrorModel get errorModel => _errorModel;

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}

class EventSummaryViewModel {
  final EventSummaryModel _model = const EventSummaryModel();
  late Event _event;
  late String? _title;
  late List<String> _tags;
  late String? _description;
  late String? _contactInfo;
  late String? _churchLandline;
  late String? _dressCode;
  late List<String> _speakers;
  late String? _imageUrl;
  late String? _imagePath;
  late Uint8List? _imageBytes;
  late List<EventImage> _additionalImages;
  late bool _isOneDay;
  late List<EventDay> _eventDays;
  late DateTime? _startDate;
  late DateTime? _endDate;
  late TimeOfDay? _startTime;
  late TimeOfDay? _endTime;
  late bool _isOnline;
  late String? _eventLink;
  late bool _isOutsourcedVenue;
  late String? _meetingPlatform;

  // Getters
  EventSummaryModel get model => _model;

  void initializeFromWidget(dynamic widget) {
    _event = widget.event;
    _title = widget.title;
    _tags = widget.tags;
    _description = widget.description;
    _contactInfo = widget.contactInfo;
    _churchLandline = widget.churchLandline;
    _dressCode = widget.dressCode;
    _speakers = widget.speakers;
    _imageUrl = widget.imageUrl;
    _imagePath = widget.imagePath;
    _imageBytes = widget.imageBytes;
    _additionalImages = widget.additionalImages;
    _isOneDay = widget.isOneDay;
    _eventDays = widget.eventDays;
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _startTime = widget.startTime;
    _endTime = widget.endTime;
    _isOnline = widget.isOnline;
    _eventLink = widget.eventLink;
    _isOutsourcedVenue = widget.isOutsourcedVenue;
    _meetingPlatform = widget.meetingPlatform;
  }

  List<EventDetailItem> getEventDetails() {
    return [
      EventDetailItem(
        label: 'Event Title',
        value: _title ?? _event.title ?? 'To be answered',
      ),
      EventDetailItem(
        label: 'Tags',
        value: (_tags.isNotEmpty ? _tags : _event.tags).isEmpty 
            ? 'None selected' 
            : (_tags.isNotEmpty ? _tags : _event.tags).join(', '),
      ),
      EventDetailItem(
        label: 'Event Description',
        value: _description ?? _event.description ?? 'To be answered',
      ),
      EventDetailItem(
        label: 'Speaker',
        value: (_speakers.isNotEmpty ? _speakers : _event.speakers).isEmpty 
            ? 'None specified' 
            : (_speakers.isNotEmpty ? _speakers : _event.speakers).join(', '),
      ),
      EventDetailItem(
        label: 'Event Date',
        value: _isOneDay ? 'One day event' : 'Multiple day event',
      ),
      EventDetailItem(
        label: 'Date',
        value: _isOneDay 
            ? _formatDate(_startDate)
            : '${_formatDate(_startDate)} - ${_formatDate(_endDate)}',
      ),
      EventDetailItem(
        label: 'Time',
        value: '${_formatTime(_startTime)} - ${_formatTime(_endTime)}',
      ),
      EventDetailItem(
        label: 'Event Setting',
        value: _isOnline ? 'Online' : 'Onsite',
      ),
      EventDetailItem(
        label: 'Venue/Location',
        value: _isOnline 
            ? (_eventLink ?? 'No link provided')
            : (_isOutsourcedVenue 
                ? 'Outsourced Event API (link)'
                : (_event.venueName ?? 'No venue specified')),
      ),
    ];
  }

  Widget buildEventImage() {
    if (_event.imageBytes != null && _event.imageBytes!.isNotEmpty) {
      return Image.memory(
        _event.imageBytes!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (_event.imageUrl != null && _event.imageUrl!.isNotEmpty) {
      return Image.network(
        _event.imageUrl!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    } else if (_event.imagePath != null && !kIsWeb) {
      return Image.file(
        File(_event.imagePath!),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    } else {
      return _buildPlaceholderImage();
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.image,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    
    return '$hour:$minute $period';
  }

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  void showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: _model.dialogBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle, 
                      size: 24, 
                      color: _model.dialogIconColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _model.dialogTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _model.dialogMessage,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF444444),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          _model.dialogNoText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleConfirmNavigation(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _model.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          _model.dialogYesText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleConfirmNavigation(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventRegistrationFormScreen(
          event: _event,
          title: _title,
          tags: _tags,
          description: _description,
          contactInfo: _contactInfo,
          churchLandline: _churchLandline,
          dressCode: _dressCode,
          speakers: _speakers,
          imageUrl: _imageUrl,
          imagePath: _imagePath,
          imageBytes: _imageBytes,
          additionalImages: _additionalImages,
          isOneDay: _isOneDay,
          eventDays: _eventDays,
          startDate: _startDate,
          endDate: _endDate,
          startTime: _startTime,
          endTime: _endTime,
          isOnline: _isOnline,
          eventLink: _eventLink,
          isOutsourcedVenue: _isOutsourcedVenue,
          meetingPlatform: _meetingPlatform,
        ),
      ),
    );
  }

  void dispose() {
    // Clean up any resources if needed
  }
}
