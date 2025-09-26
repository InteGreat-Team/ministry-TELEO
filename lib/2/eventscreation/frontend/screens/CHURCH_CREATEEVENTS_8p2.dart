import 'package:flutter/material.dart';
import 'models/event.dart';
import 'services/event_service.dart';
import 'c2s9caeventcreation.dart';
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import '../../backend/viewmodels/CHURCH_CREATEVENTS_FUNC.dart';

class EventCreationFinalStep extends StatelessWidget with ChurchCreateVentsVar, ChurchCreateVentsFunc {
  final Event event;

  const EventCreationFinalStep({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A4A),
        elevation: 0,
        title: const Text('Review Event'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color(0xFF0A0A4A),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Event Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildDetailItem('Title', event.title ?? 'No title provided'),
                      buildDetailItem('Description', event.description ?? 'No description provided'),
                      buildDetailItem('Date', event.startDate != null 
                          ? '${event.startDate!.month}/${event.startDate!.day}/${event.startDate!.year}'
                          : 'No date provided'),
                      buildDetailItem('Time', event.startTime != null && event.endTime != null
                          ? '${formatTime(event.startTime!)} - ${formatTime(event.endTime!)}'
                          : 'No time provided'),
                      buildDetailItem('Location', event.isOnline 
                          ? 'Online Event' 
                          : (event.venueName ?? 'No location provided')),
                      buildDetailItem('Dress Code', event.dressCode ?? 'Not specified'),
                      buildDetailItem('Contact Info', event.contactInfo ?? 'Not provided'),
                      
                      const SizedBox(height: 16),
                      const Text(
                        'Speakers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (event.speakers.isNotEmpty)
                        ...event.speakers.map((speaker) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $speaker'),
                        ))
                      else
                        const Text('No speakers specified'),
                        
                      const SizedBox(height: 16),
                      const Text(
                        'Invited Participants',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Invite Type: ${event.inviteType}'),
                      if (event.invitedChurches.isNotEmpty) ...[ 
                        const SizedBox(height: 8),
                        const Text(
                          'Invited Churches:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        ...event.invitedChurches.map((church) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• ${church.name}'),
                        )),
                      ],
                      if (event.invitedGuests.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Invited Guests:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        ...event.invitedGuests.map((guest) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• ${guest.fullName}'),
                        )),
                      ],
                    ],
                  ),
                ),
              ),
              Container(
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
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Save the event to the EventService
                          final eventService = EventService();
                          final eventMap = eventService.convertEventToMap(event);
                          eventService.addEvent(eventMap);
                          
                          // Navigate to the waiting approval screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventWaitingApprovalScreen(event: event),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0A4A),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
