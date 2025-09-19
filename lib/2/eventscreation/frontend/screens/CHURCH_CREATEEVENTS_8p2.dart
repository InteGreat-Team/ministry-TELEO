//CHURCH_CREATEEVENTS_8p2.dart
import 'package:flutter/material.dart';
import 'models/event.dart';
import 'services/event_service.dart';
import 'c2s9caeventcreation.dart';
import 'CREATE_EVENTS_VAR.dart';
import 'CREATE_EVENTS_FUNC.dart';

class EventCreationFinalStep extends StatelessWidget {
  final Event event;

  const EventCreationFinalStep({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final variables = EventCreationFinalStepVariables(event: event);
    final viewModel = EventCreationFinalStepViewModel(variables);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A4A),
        elevation: 0,
        title: const Text(EventCreationFinalStepConstants.screenTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => viewModel.handleEdit(context),
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
                        EventCreationFinalStepConstants.eventDetailsTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailItem('Title', event.title ?? EventCreationFinalStepConstants.noTitleProvided),
                      _buildDetailItem('Description', event.description ?? EventCreationFinalStepConstants.noDescriptionProvided),
                      _buildDetailItem('Date', viewModel.getFormattedDate()),
                      _buildDetailItem('Time', viewModel.getFormattedTimeRange()),
                      _buildDetailItem('Location', viewModel.getLocationText()),
                      _buildDetailItem('Dress Code', event.dressCode ?? EventCreationFinalStepConstants.notSpecified),
                      _buildDetailItem('Contact Info', event.contactInfo ?? EventCreationFinalStepConstants.notProvided),
                      
                      const SizedBox(height: 16),
                      const Text(
                        EventCreationFinalStepConstants.speakersTitle,
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
                        const Text(EventCreationFinalStepConstants.noSpeakersSpecified),
                        
                      const SizedBox(height: 16),
                      const Text(
                        EventCreationFinalStepConstants.invitedParticipantsTitle,
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
                          EventCreationFinalStepConstants.invitedChurchesLabel,
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
                          EventCreationFinalStepConstants.invitedGuestsLabel,
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
                        onPressed: () => viewModel.handleEdit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(EventCreationFinalStepConstants.editButtonText),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => viewModel.handleSubmit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0A4A),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(EventCreationFinalStepConstants.submitButtonText),
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

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
