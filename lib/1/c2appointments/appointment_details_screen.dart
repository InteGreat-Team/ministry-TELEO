import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event_cancellation_screen.dart';
import 'volunteer_exit_form.dart';
import '../c2events/models/registered_event.dart';

class EventAppointmentDetailsScreen extends StatefulWidget {
  final RegisteredEvent registeredEvent;

  const EventAppointmentDetailsScreen({
    super.key,
    required this.registeredEvent,
  });

  @override
  State<EventAppointmentDetailsScreen> createState() =>
      _EventAppointmentDetailsScreenState();
}

class _EventAppointmentDetailsScreenState
    extends State<EventAppointmentDetailsScreen> {
  // Toggle for expandable sections
  bool _isRegistrationFormExpanded =
      true; // Default to expanded to show form details

  @override
  Widget build(BuildContext context) {
    final event = widget.registeredEvent.event;
    final details = widget.registeredEvent.details;
    final isVolunteer = widget.registeredEvent.isVolunteer;
    final isCancelled = widget.registeredEvent.isCancelled;
    final isService = event.tags.contains(
      'Service',
    ); // Check if this is a service event

    // Get service type from event tags
    String serviceType = 'Service';
    if (isService && event.tags.length > 1) {
      serviceType = event.tags[1];
    }

    // Format date and time
    String formattedDate = '';
    String formattedTime = '';

    if (event.startDate != null) {
      formattedDate = DateFormat('EEE, MMM d').format(event.startDate!);
    }

    if (event.startTime != null && event.endTime != null) {
      final startHour =
          event.startTime!.hourOfPeriod == 0
              ? 12
              : event.startTime!.hourOfPeriod;
      final startMinute = event.startTime!.minute.toString().padLeft(2, '0');
      final startPeriod = event.startTime!.period == DayPeriod.am ? 'AM' : 'PM';

      final endHour =
          event.endTime!.hourOfPeriod == 0 ? 12 : event.endTime!.hourOfPeriod;
      final endMinute = event.endTime!.minute.toString().padLeft(2, '0');
      final endPeriod = event.endTime!.period == DayPeriod.am ? 'AM' : 'PM';

      formattedTime =
          '$startHour:$startMinute $startPeriod - $endHour:$endMinute $endPeriod';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isService
              ? 'Service Appointment'
              : (isVolunteer ? 'Volunteer Appointment' : 'Event Appointment'),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF000233),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Reference # and Booking Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reference #:',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'AJSNDFB934U9382RFIWB',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Booking Date',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat(
                              'MMM d, yyyy',
                            ).format(details.registrationDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Event/Service/Volunteer Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        // Venue Info
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Venue Avatar
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isService ? Icons.church : Icons.event,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Venue Name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.venueName ?? 'Venue Name',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (event.venueAddress != null &&
                                      event.venueAddress!.isNotEmpty)
                                    Text(
                                      event.venueAddress!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 1),

                        // Details
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Color Block with appropriate label
                              Container(
                                width: 60,
                                height: 100,
                                color:
                                    isService
                                        ? Colors.purple.shade800
                                        : (isVolunteer
                                            ? Colors.green.shade800
                                            : Colors.blue.shade800),
                                child: Center(
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(
                                      isService
                                          ? _getServiceAbbreviation(serviceType)
                                          : (isVolunteer
                                              ? 'VOLUNTEER'
                                              : 'EVENT'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Details
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                            ),
                                            child: Icon(
                                              isService
                                                  ? _getServiceIcon(serviceType)
                                                  : (isVolunteer
                                                      ? Icons.volunteer_activism
                                                      : Icons.event),
                                              size: 16,
                                              color:
                                                  isService
                                                      ? Colors.purple.shade800
                                                      : (isVolunteer
                                                          ? Colors
                                                              .green
                                                              .shade800
                                                          : Colors
                                                              .blue
                                                              .shade800),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              isService
                                                  ? serviceType
                                                  : (event.title ?? 'Event'),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            formattedDate.isNotEmpty
                                                ? formattedDate
                                                : 'Date not specified',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            formattedTime.isNotEmpty
                                                ? formattedTime
                                                : 'Time not specified',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (isVolunteer &&
                                          details.primaryRole != null &&
                                          details.primaryRole!.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.work,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              details.primaryRole!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      if (isService) ...[
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              _getServiceIcon(serviceType),
                                              size: 14,
                                              color: Colors.purple.shade800,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                _getServiceForText(
                                                  serviceType,
                                                  details,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.purple.shade800,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Registration Form Section (Expandable)
            _buildExpandableSection(
              title: 'Submitted Registration Form',
              isExpanded: _isRegistrationFormExpanded,
              onTap: () {
                setState(() {
                  _isRegistrationFormExpanded = !_isRegistrationFormExpanded;
                });
              },
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Common fields for all registration types
                  _buildFormField('Name:', details.fullName),
                  _buildFormField('Email:', details.email ?? 'Not provided'),
                  _buildFormField(
                    'Phone:',
                    details.contactNumber ?? 'Not provided',
                  ),

                  // Service-specific fields
                  if (isService) ...[
                    _buildFormField('Service:', serviceType),

                    // Wedding-specific fields
                    if (serviceType == 'Wedding' ||
                        serviceType == 'Wedding Service') ...[
                      if (details.customFields['brideName'] != null)
                        _buildFormField(
                          'Bride:',
                          details.customFields['brideName']!,
                        ),
                      if (details.customFields['groomName'] != null)
                        _buildFormField(
                          'Groom:',
                          details.customFields['groomName']!,
                        ),
                      if (details.customFields['ceremonyType'] != null)
                        _buildFormField(
                          'Ceremony Type:',
                          details.customFields['ceremonyType']!,
                        ),
                      if (details.customFields['receptionVenue'] != null)
                        _buildFormField(
                          'Reception Venue:',
                          details.customFields['receptionVenue']!,
                        ),
                      if (details.customFields['guestCount'] != null)
                        _buildFormField(
                          'Guest Count:',
                          details.customFields['guestCount']!,
                        ),
                    ],

                    // Funeral-specific fields
                    if (serviceType == 'Funeral Service') ...[
                      if (details.customFields['deceasedName'] != null)
                        _buildFormField(
                          'Deceased:',
                          details.customFields['deceasedName']!,
                        ),
                      if (details.customFields['relationship'] != null)
                        _buildFormField(
                          'Relationship:',
                          details.customFields['relationship']!,
                        ),
                      if (details.customFields['funeralHome'] != null)
                        _buildFormField(
                          'Funeral Home:',
                          details.customFields['funeralHome']!,
                        ),
                    ],

                    // Baptism-specific fields
                    if (serviceType == 'Baptism') ...[
                      if (details.customFields['childName'] != null)
                        _buildFormField(
                          'Child:',
                          details.customFields['childName']!,
                        ),
                      if (details.customFields['dateOfBirth'] != null)
                        _buildFormField(
                          'Birth Date:',
                          details.customFields['dateOfBirth']!,
                        ),
                      if (details.customFields['gender'] != null)
                        _buildFormField(
                          'Gender:',
                          details.customFields['gender']!,
                        ),
                      if (details.customFields['fatherName'] != null)
                        _buildFormField(
                          'Father:',
                          details.customFields['fatherName']!,
                        ),
                      if (details.customFields['motherName'] != null)
                        _buildFormField(
                          'Mother:',
                          details.customFields['motherName']!,
                        ),
                    ],

                    // Prayer Request-specific fields
                    if (serviceType == 'Prayer Request') ...[
                      if (details.customFields['prayerIntention'] != null)
                        _buildFormField(
                          'Prayer Intention:',
                          details.customFields['prayerIntention']!,
                        ),
                      if (details.customFields['prayFor'] != null)
                        _buildFormField(
                          'Pray For:',
                          details.customFields['prayFor']!,
                        ),
                    ],

                    // Hospital Visit-specific fields
                    if (serviceType == 'Hospital Visit') ...[
                      if (details.customFields['patientName'] != null)
                        _buildFormField(
                          'Patient Name:',
                          details.customFields['patientName']!,
                        ),
                      if (details.customFields['hospitalName'] != null)
                        _buildFormField(
                          'Hospital Name:',
                          details.customFields['hospitalName']!,
                        ),
                      if (details.customFields['roomNumber'] != null)
                        _buildFormField(
                          'Room Number:',
                          details.customFields['roomNumber']!,
                        ),
                    ],

                    // Common additional fields for all services
                    if (details.customFields['reasonForService'] != null)
                      _buildFormField(
                        'Reason for Service:',
                        details.customFields['reasonForService']!,
                      ),
                    if (details.customFields['additionalInfo'] != null)
                      _buildFormField(
                        'Additional Info:',
                        details.customFields['additionalInfo']!,
                      ),
                  ],

                  // Event-specific fields (for regular attendees)
                  if (!isService && !isVolunteer) ...[
                    if (details.additionalNotes != null &&
                        details.additionalNotes!.isNotEmpty)
                      _buildFormField('Notes:', details.additionalNotes!),
                    if (details.numberOfAttendees != null)
                      _buildFormField(
                        'Attendees:',
                        details.numberOfAttendees.toString(),
                      ),
                  ],

                  // Volunteer-specific fields
                  if (isVolunteer) ...[
                    _buildFormField(
                      'Role:',
                      details.primaryRole ?? 'General Volunteer',
                    ),
                    if (details.secondaryRole != null &&
                        details.secondaryRole!.isNotEmpty)
                      _buildFormField(
                        'Secondary Role:',
                        details.secondaryRole!,
                      ),
                    _buildFormField(
                      'T-shirt Size:',
                      details.tshirtSize ?? 'Not provided',
                    ),
                    if (details.dietaryRestrictions != null &&
                        details.dietaryRestrictions!.isNotEmpty)
                      _buildFormField(
                        'Dietary Restrictions:',
                        details.dietaryRestrictions!,
                      ),
                    if (details.emergencyContact != null &&
                        details.emergencyContact!.isNotEmpty)
                      _buildFormField(
                        'Emergency Contact:',
                        details.emergencyContact!,
                      ),
                    if (details.additionalNotes != null &&
                        details.additionalNotes!.isNotEmpty)
                      _buildFormField(
                        'Additional Notes:',
                        details.additionalNotes!,
                      ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 80), // Space for the bottom button
          ],
        ),
      ),
      bottomSheet:
          !isCancelled
              ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (isVolunteer) {
                      // Navigate to volunteer exit form
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => VolunteerExitFormScreen(
                                registeredEvent: widget.registeredEvent,
                              ),
                        ),
                      ).then((value) {
                        if (value == true) {
                          setState(() {
                            // Refresh the UI
                          });
                        }
                      });
                    } else {
                      // Navigate to event cancellation screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EventCancellationScreen(
                                registeredEvent: widget.registeredEvent,
                              ),
                        ),
                      ).then((value) {
                        if (value == true) {
                          setState(() {
                            // Refresh the UI
                          });
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    elevation: 0,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isService
                        ? 'Cancel Service'
                        : (isVolunteer
                            ? 'Backout from Volunteering'
                            : 'Cancel Event Registration'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              : null,
    );
  }

  // Helper method to build form fields
  Widget _buildFormField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build expandable sections
  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: content,
          ),
      ],
    );
  }

  // Helper method to get service abbreviation for the rotated text
  String _getServiceAbbreviation(String serviceType) {
    switch (serviceType) {
      case 'Wedding':
      case 'Wedding Service':
        return 'WEDDING';
      case 'Funeral Service':
        return 'FUNERAL';
      case 'Prayer Request':
        return 'PRAYER';
      case 'Baptism':
        return 'BAPTISM';
      case 'Hospital Visit':
        return 'HOSPITAL';
      default:
        return 'SERVICE';
    }
  }

  // Helper method to get service icon
  IconData _getServiceIcon(String serviceType) {
    switch (serviceType) {
      case 'Wedding':
      case 'Wedding Service':
        return Icons.favorite;
      case 'Funeral Service':
        return Icons.church;
      case 'Prayer Request':
        return Icons.volunteer_activism;
      case 'Baptism':
        return Icons.child_care;
      case 'Hospital Visit':
        return Icons.local_hospital;
      default:
        return Icons.church;
    }
  }

  // Helper method to get the "Service for:" text
  String _getServiceForText(String serviceType, RegistrationDetails details) {
    switch (serviceType) {
      case 'Wedding':
      case 'Wedding Service':
        final brideName = details.customFields['brideName'] ?? '';
        final groomName = details.customFields['groomName'] ?? '';
        return 'Service for: ${brideName.isNotEmpty && groomName.isNotEmpty ? "$brideName & $groomName" : details.fullName}';
      case 'Funeral Service':
        final deceasedName = details.customFields['deceasedName'] ?? '';
        return 'Service for: ${deceasedName.isNotEmpty ? deceasedName : details.fullName}';
      case 'Baptism':
        final childName = details.customFields['childName'] ?? '';
        return 'Service for: ${childName.isNotEmpty ? childName : details.fullName}';
      case 'Prayer Request':
        final prayFor = details.customFields['prayFor'] ?? '';
        return 'Service for: ${prayFor.isNotEmpty ? prayFor : details.fullName}';
      case 'Hospital Visit':
        final patientName = details.customFields['patientName'] ?? '';
        return 'Service for: ${patientName.isNotEmpty ? patientName : details.fullName}';
      default:
        return 'Service for: ${details.fullName}';
    }
  }
}
