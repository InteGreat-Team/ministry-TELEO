import 'package:flutter/material.dart';
import '../../c2events/models/event.dart';
import '../../c2events/models/registered_event.dart';

// Class for service details
class ServiceDetails {
  final String serviceType;
  final String location;
  final DateTime scheduledDate;
  final TimeOfDay scheduledTime;
  final String churchName;
  final String contactPerson;
  final String contactNumber;
  final String email;
  final DateTime bookingDate;

  // Common fields for all services
  final String? additionalInfo;

  // Service-specific fields
  final String? childName;
  final String? dateOfBirth;
  final String? gender;
  final String? fatherName;
  final String? motherName;
  final String? reasonForService;

  // Wedding-specific fields
  final String? brideName;
  final String? groomName;
  final String? ceremonyType;
  final String? receptionVenue;
  final String? guestCount;

  ServiceDetails({
    required this.serviceType,
    required this.location,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.churchName,
    required this.contactPerson,
    required this.contactNumber,
    required this.email,
    required this.bookingDate,
    this.childName,
    this.dateOfBirth,
    this.gender,
    this.fatherName,
    this.motherName,
    this.reasonForService,
    this.additionalInfo,
    this.brideName,
    this.groomName,
    this.ceremonyType,
    this.receptionVenue,
    this.guestCount,
  });

  // Create a map of custom fields for the event registration
  Map<String, String> getCustomFields() {
    final Map<String, String> fields = {};

    // Add common fields
    if (additionalInfo != null) fields['additionalInfo'] = additionalInfo!;
    if (reasonForService != null)
      fields['reasonForService'] = reasonForService!;

    // Add service-specific fields based on service type
    if (serviceType == 'Baptism') {
      if (childName != null) fields['childName'] = childName!;
      if (dateOfBirth != null) fields['dateOfBirth'] = dateOfBirth!;
      if (gender != null) fields['gender'] = gender!;
      if (fatherName != null) fields['fatherName'] = fatherName!;
      if (motherName != null) fields['motherName'] = motherName!;
    } else if (serviceType == 'Wedding') {
      if (brideName != null) fields['brideName'] = brideName!;
      if (groomName != null) fields['groomName'] = groomName!;
      if (ceremonyType != null) fields['ceremonyType'] = ceremonyType!;
      if (receptionVenue != null) fields['receptionVenue'] = receptionVenue!;
      if (guestCount != null) fields['guestCount'] = guestCount!;
    }

    return fields;
  }
}

// Class to manage registered services
class RegisteredServiceManager {
  static final List<ServiceDetails> _registeredServices = [];

  // Add a new service
  static void addService(ServiceDetails service) {
    _registeredServices.add(service);
  }

  // Get all registered services
  static List<ServiceDetails> getRegisteredServices() {
    return List.from(_registeredServices);
  }

  // Create an event from a service for display in appointments
  static Event createEventFromService(ServiceDetails service) {
    // Format the time properly
    final hour =
        service.scheduledTime.hourOfPeriod == 0
            ? 12
            : service.scheduledTime.hourOfPeriod;
    final minute = service.scheduledTime.minute.toString().padLeft(2, '0');
    final period = service.scheduledTime.period == DayPeriod.am ? 'AM' : 'PM';
    final formattedTime = '$hour:$minute $period';

    // Set color and icon based on service type
    Color serviceColor;
    String serviceText;

    // All service types use the same purple color scheme
    serviceColor = Colors.purple.shade800;

    // Set the service text based on service type
    switch (service.serviceType) {
      case 'Wedding':
        serviceText = 'WEDDING';
        break;
      case 'Baptism':
        serviceText = 'BAPTISM';
        break;
      case 'Funeral Service':
        serviceText = 'FUNERAL';
        break;
      default:
        serviceText = 'SERVICE';
    }

    // Create description based on service type
    String description;
    if (service.serviceType == 'Wedding') {
      description =
          'Wedding service for ${service.brideName ?? ""} and ${service.groomName ?? ""}';
    } else if (service.serviceType == 'Baptism') {
      description = 'Baptism service for ${service.childName ?? ""}';
    } else {
      description = '${service.serviceType} service';
    }

    return Event(
      title: service.serviceType,
      location: service.location,
      date:
          '${service.scheduledDate.day}/${service.scheduledDate.month}/${service.scheduledDate.year} - $formattedTime',
      tags: ['Service', service.serviceType],
      likes: 0,
      color: serviceColor,
      text: serviceText,
      isFeatured: false,
      startDate: service.scheduledDate,
      startTime: service.scheduledTime,
      endTime: TimeOfDay(
        hour: (service.scheduledTime.hour + 1) % 24,
        minute: service.scheduledTime.minute,
      ),
      venueName: service.churchName,
      description: description,
      contactInfo: service.contactNumber,
    );
  }

  // Register a service as an event in the appointments section
  static void registerServiceAsEvent(ServiceDetails service) {
    final event = createEventFromService(service);

    // Create registration details with service-specific information
    final details = RegistrationDetails(
      fullName: service.contactPerson,
      email: service.email,
      contactNumber: service.contactNumber,
      registrationDate: DateTime.now(),
      // Add custom fields based on service type
      customFields: service.getCustomFields(),
    );

    // Register the event with the service details
    final registeredEvent = RegisteredEvent(
      event: event,
      type: RegistrationType.attendee,
      details: details,
    );

    RegisteredEventManager.addRegisteredEvent(registeredEvent);
  }
}
