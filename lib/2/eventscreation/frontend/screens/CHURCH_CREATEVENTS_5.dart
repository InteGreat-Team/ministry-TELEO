import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:teleo_organized_new/1/c1homepage/nav_bar.dart';
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import '../../backend/viewmodels/CHURCH_CREATEVENTS_FUNC.dart';
import '../../../c2eventscreation/widgets/step_indicator.dart';
import '../../../c2eventscreation/widgets/required_asterisk.dart';
import '../../../c2eventscreation/widgets/event_app_bar.dart';

class EventSummaryScreen extends StatefulWidget {
  final Event event;
  // c1-style carried fields
  final String? title;
  final List<String> tags;
  final String? description;
  final String? contactInfo;
  final String? churchLandline;
  final String? dressCode;
  final List<String> speakers;
  final String? imageUrl;
  final String? imagePath;
  final Uint8List? imageBytes;
  final List<EventImage> additionalImages;
  final bool isOneDay;
  final List<EventDay> eventDays;
  final DateTime? startDate;
  final DateTime? endDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final bool isOnline;
  final String? eventLink;
  final bool isOutsourcedVenue;
  final String? meetingPlatform;

  const EventSummaryScreen({
    super.key,
    required this.event,
    required this.title,
    required this.tags,
    required this.description,
    required this.contactInfo,
    required this.churchLandline,
    required this.dressCode,
    required this.speakers,
    required this.imageUrl,
    required this.imagePath,
    required this.imageBytes,
    required this.additionalImages,
    required this.isOneDay,
    required this.eventDays,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.isOnline,
    required this.eventLink,
    required this.isOutsourcedVenue,
    required this.meetingPlatform,
  });

  @override
  State<EventSummaryScreen> createState() => _EventSummaryScreenState();
}

class _EventSummaryScreenState extends State<EventSummaryScreen> {
  late EventSummaryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EventSummaryViewModel();
    _viewModel.initializeFromWidget(widget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => Navigator.pop(context), 
        title: '',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepIndicator(
                    currentStep: 4,
                    totalSteps: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _viewModel.model.pageTitle,
                          style: TextStyle(
                            color: _viewModel.model.titleColor,
                            fontSize: _viewModel.model.titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Event Image - Handle both web and mobile with black border
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: _buildEventImage(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Event Details
                        ..._viewModel.getEventDetails().map((detail) => 
                          _buildDetailRow(detail.label, detail.value)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Button section
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewModel.navigateBack(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _viewModel.model.primaryColor,
                      side: BorderSide(color: _viewModel.model.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _viewModel.model.backButtonText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _viewModel.showConfirmDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _viewModel.model.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _viewModel.model.confirmButtonText,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventImage() {
    return _viewModel.buildEventImage();
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

