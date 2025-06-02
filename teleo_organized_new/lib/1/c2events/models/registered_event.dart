import 'event.dart';

// Enum for registration types
enum RegistrationType {
  attendee,
  volunteer
}

// Class for registration details
class RegistrationDetails {
  final String fullName;
  final String? nickname;
  final String? email;
  final String? contactNumber;
  final DateTime registrationDate;
  
  // Volunteer-specific fields
  final String? tshirtSize;
  final String? primaryRole;
  final String? availability;
  final String? reasonForVolunteering;
  final bool hasUploadedCV;
  
  // Custom fields for service-specific details
  final Map<String, String> customFields;
  
  RegistrationDetails({
    required this.fullName,
    this.nickname,
    this.email,
    this.contactNumber,
    required this.registrationDate,
    this.tshirtSize,
    this.primaryRole,
    this.availability,
    this.reasonForVolunteering,
    this.hasUploadedCV = false,
    this.customFields = const {},
  });
  
  // Convenience getters for baptism details
  String? get childName => customFields['childName'];
  String? get serviceType => customFields['serviceType'];
  String? get dateOfBirth => customFields['dateOfBirth'];
  String? get recipientGender => customFields['gender'];
  String? get fatherName => customFields['fatherName'];
  String? get motherName => customFields['motherName'];
  String? get reasonForService => customFields['reasonForService'];
  String? get additionalInfo => customFields['additionalInfo'];
  
  // Wedding-specific getters
  String? get brideName => customFields['brideName'];
  String? get groomName => customFields['groomName'];
  String? get ceremonyType => customFields['ceremonyType'];
  String? get receptionVenue => customFields['receptionVenue'];
  String? get guestCount => customFields['guestCount'];
  
  // Funeral-specific getters
  String? get deceasedName => customFields['deceasedName'];
  String? get relationship => customFields['relationship'];
  String? get funeralHome => customFields['funeralHome'];
  
  // Prayer Request-specific getters
  String? get prayerIntention => customFields['prayerIntention'];
  String? get prayFor => customFields['prayFor'];

  get additionalNotes => null;

  get numberOfAttendees => null;

  get secondaryRole => null;

  get dietaryRestrictions => null;

  get emergencyContact => null;
}

// Main registered event class
class RegisteredEvent {
  final Event event;
  final RegistrationType type;
  final RegistrationDetails details;
  String? cancellationReason;
  String? cancellationFeedback;
  DateTime? cancellationDate;

  RegisteredEvent({
    required this.event,
    required this.type,
    required this.details,
    this.cancellationReason,
    this.cancellationFeedback,
    this.cancellationDate,
  });
  
  // Convenience getter to check if this is a volunteer registration
  bool get isVolunteer => type == RegistrationType.volunteer;
  
  // Convenience getter to check if this registration is cancelled
  bool get isCancelled => cancellationReason != null;
}

// Static class to manage registered events (in a real app, this would use a database)
class RegisteredEventManager {
  static final List<RegisteredEvent> _registeredEvents = [];
  
  // Getter for registered events
  static List<RegisteredEvent> get registeredEvents => _registeredEvents;

  // Add a new registered event
  static void addRegisteredEvent(RegisteredEvent event) {
    // Check if already registered for this event with the same type
    if (!isRegisteredWithType(event.event, event.type)) {
      _registeredEvents.add(event);
    }
  }

  // Get all registered events
  static List<RegisteredEvent> getRegisteredEvents() {
    return List.from(_registeredEvents); // Return a copy to prevent modification
  }

  // Register as attendee
  static void registerAsAttendee(Event event, String fullName, {
    String? nickname,
    String? email,
    String? contactNumber,
    Map<String, String> customFields = const {},
  }) {
    // Check if already registered as attendee for this event
    if (isRegisteredAsAttendee(event)) {
      return;
    }
    
    // Create registration details
    final details = RegistrationDetails(
      fullName: fullName,
      nickname: nickname,
      email: email,
      contactNumber: contactNumber,
      registrationDate: DateTime.now(),
      customFields: customFields,
    );
    
    // Create new registration
    final registration = RegisteredEvent(
      event: event,
      type: RegistrationType.attendee,
      details: details,
    );
    
    // Add to list
    _registeredEvents.add(registration);
  }
  
  // Register as volunteer
  static void registerAsVolunteer(Event event, Map<String, dynamic> volunteerData) {
    // Check if already registered as volunteer for this event
    if (isVolunteerForEvent(event)) {
      return;
    }
    
    // Create registration details
    final details = RegistrationDetails(
      fullName: volunteerData['name'] ?? 'Volunteer',
      nickname: volunteerData['nickname'],
      email: volunteerData['email'],
      contactNumber: volunteerData['contactNumber'],
      registrationDate: DateTime.now(),
      tshirtSize: volunteerData['tshirtSize'],
      primaryRole: volunteerData['primaryRole'],
      availability: volunteerData['availability'],
      reasonForVolunteering: volunteerData['reasonForVolunteering'],
      hasUploadedCV: volunteerData['hasUploadedCV'] ?? false,
    );
    
    // Create new registration
    final registration = RegisteredEvent(
      event: event,
      type: RegistrationType.volunteer,
      details: details,
    );
    
    // Add to list
    _registeredEvents.add(registration);
  }
  
  // Cancel registration
  static void cancelRegistration(RegisteredEvent registeredEvent, {String? reason}) {
    final index = _registeredEvents.indexWhere((reg) => 
      reg.event.title == registeredEvent.event.title && 
      reg.details.fullName == registeredEvent.details.fullName &&
      reg.type == registeredEvent.type);
    
    if (index != -1) {
      _registeredEvents[index].cancellationReason = reason;
      _registeredEvents[index].cancellationDate = DateTime.now();
    }
  }
  
  // Check if registered for an event with a specific type
  static bool isRegisteredWithType(Event event, RegistrationType type) {
    return _registeredEvents.any((reg) => 
      reg.event.title == event.title && 
      reg.event.startDate == event.startDate &&
      reg.type == type &&
      reg.cancellationReason == null);
  }
  
  // Check if registered for an event (as either attendee or volunteer)
  static bool isRegisteredForEvent(Event event) {
    return _registeredEvents.any((reg) => 
      reg.event.title == event.title && 
      reg.event.startDate == event.startDate &&
      reg.cancellationReason == null);
  }
  
  // Check if registered as attendee
  static bool isRegisteredAsAttendee(Event event) {
    return _registeredEvents.any((reg) => 
      reg.event.title == event.title && 
      reg.event.startDate == event.startDate && 
      reg.type == RegistrationType.attendee &&
      reg.cancellationReason == null);
  }
  
  // Check if registered as volunteer
  static bool isVolunteerForEvent(Event event) {
    return _registeredEvents.any((reg) => 
      reg.event.title == event.title && 
      reg.event.startDate == event.startDate && 
      reg.type == RegistrationType.volunteer &&
      reg.cancellationReason == null);
  }
  
  // Get registration for an event
  static RegisteredEvent? getRegistrationForEvent(Event event) {
    try {
      return _registeredEvents.firstWhere(
        (reg) => reg.event.title == event.title && 
                reg.event.startDate == event.startDate &&
                reg.cancellationReason == null);
    } catch (e) {
      return null;
    }
  }
  
  // Get attendee registration for an event
  static RegisteredEvent? getAttendeeRegistrationForEvent(Event event) {
    try {
      return _registeredEvents.firstWhere(
        (reg) => reg.event.title == event.title && 
                reg.event.startDate == event.startDate &&
                reg.type == RegistrationType.attendee &&
                reg.cancellationReason == null);
    } catch (e) {
      return null;
    }
  }
  
  // Get volunteer registration for an event
  static RegisteredEvent? getVolunteerRegistrationForEvent(Event event) {
    try {
      return _registeredEvents.firstWhere(
        (reg) => reg.event.title == event.title && 
                reg.event.startDate == event.startDate &&
                reg.type == RegistrationType.volunteer &&
                reg.cancellationReason == null);
    } catch (e) {
      return null;
    }
  }

  static void updateRegisteredEvent(RegisteredEvent registeredEvent) {}
}
