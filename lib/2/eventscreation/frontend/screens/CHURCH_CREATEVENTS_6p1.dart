import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:teleo_organized_new/1/c1homepage/nav_bar.dart';
import '../../../c2eventscreation/widgets/step_indicator.dart';
import '../../../c2eventscreation/widgets/required_asterisk.dart';
import '../../../c2eventscreation/widgets/event_app_bar.dart';
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import '../../backend/viewmodels/CHURCH_CREATEVENTS_FUNC.dart';
import '../screens/CHURCH_CREATEVENTS_7.dart';
import '../screens/CHURCH_CREATEVENTS_6p2.dart';

class EventRegistrationFormScreen extends StatefulWidget {
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

  const EventRegistrationFormScreen({
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
  State<EventRegistrationFormScreen> createState() =>
      _EventRegistrationFormScreenState();
}

class _EventRegistrationFormScreenState
    extends State<EventRegistrationFormScreen> {
  late EventRegistrationFormViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _viewModel = EventRegistrationFormViewModel();
    _viewModel.initializeFromEvent(widget.event);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => Navigator.pop(context),
        title: '',
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepIndicator(
                      currentStep: 5,
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
                          const SizedBox(height: 4),
                          Text(
                            _viewModel.model.subtitle,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // User Information Section
                          Text(
                            _viewModel.model.userInfoSectionTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Build form fields
                          ..._buildUserInfoFields(),

                          const SizedBox(height: 20),

                          // Emergency Contact Information Section
                          Text(
                            _viewModel.model.emergencyContactSectionTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          ..._buildEmergencyContactFields(),

                          const SizedBox(height: 20),

                          // Consent Form and Waiver Section
                          Text(
                            _viewModel.model.consentFormSectionTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          _buildConsentFormSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildUserInfoFields() {
    return [
      _buildFieldToggle(
        fieldName: 'name',
        fieldType: 'Text',
        label: 'Name',
      ),
      _buildFieldToggle(
        fieldName: 'nickname',
        fieldType: 'Text',
        label: 'Nickname',
      ),
      _buildDropdownFieldToggle(
        fieldName: 'sex',
        label: 'Sex',
      ),
      _buildFieldToggle(
        fieldName: 'email',
        fieldType: 'Email',
        label: 'Email',
      ),
      _buildFieldToggle(
        fieldName: 'phoneNumber',
        fieldType: 'Number',
        label: 'Phone Number',
      ),
      _buildFieldToggle(
        fieldName: 'medications',
        fieldType: 'Text',
        label: 'Medications',
      ),
      _buildDropdownFieldToggle(
        fieldName: 'tshirtSize',
        label: 'T-shirt Size',
      ),
      _buildFieldToggle(
        fieldName: 'churchName',
        fieldType: 'Text',
        label: 'Church Name',
      ),
      _buildFieldToggle(
        fieldName: 'churchPosition',
        fieldType: 'Text',
        label: 'Position in the Church',
      ),
    ];
  }

  List<Widget> _buildEmergencyContactFields() {
    return [
      _buildFieldToggle(
        fieldName: 'emergencyContactName',
        fieldType: 'Text',
        label: 'Emergency Contact Name',
      ),
      _buildFieldToggle(
        fieldName: 'emergencyContactNumber',
        fieldType: 'Text',
        label: 'Emergency Contact No.',
      ),
      _buildDropdownFieldToggle(
        fieldName: 'emergencyContactRelation',
        label: 'Relation',
      ),
    ];
  }

  Widget _buildConsentFormSection() {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Consent Form URL
            Row(
              children: [
                const Text(
                  '[Link]:',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _viewModel.consentFormUrlController,
                            decoration: const InputDecoration(
                              hintText: 'Enter consent form URL',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _viewModel.navigateToConsentForm(
                              context, widget.event),
                          child: const Icon(
                            Icons.open_in_new,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Consent Message
            const Text(
              'Consent form message:',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextFormField(
                controller: _viewModel.consentMessageController,
                decoration: const InputDecoration(
                  hintText: 'Enter consent message',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
                minLines: 10,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),

            const SizedBox(height: 16),

            // Consent Required Toggle
            Row(
              children: [
                Checkbox(
                  value: _viewModel.model.consentRequired,
                  onChanged: (value) =>
                      _viewModel.setConsentRequired(value ?? true),
                  activeColor: _viewModel.model.primaryColor,
                ),
                const Text('Require consent form agreement'),
              ],
            ),

            // Terms Status Indicator
            if (_viewModel.model.hasReadTerms)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(
                      _viewModel.model.hasAcceptedTerms
                          ? Icons.check_circle
                          : Icons.info,
                      color: _viewModel.model.hasAcceptedTerms
                          ? Colors.green
                          : Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _viewModel.model.hasAcceptedTerms
                          ? 'Consent form has been accepted'
                          : 'Consent form has been viewed but not accepted',
                      style: TextStyle(
                        color: _viewModel.model.hasAcceptedTerms
                            ? Colors.green
                            : Colors.orange,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

            // View Terms Button
            if (_viewModel.model.hasReadTerms)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton.icon(
                  onPressed: () =>
                      _viewModel.navigateToConsentForm(context, widget.event),
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('View Consent Form Again'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFieldToggle({
    required String fieldName,
    required String fieldType,
    required String label,
  }) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: _viewModel.model.fieldVisibility[fieldName] ?? true,
                onChanged: (value) =>
                    _viewModel.toggleFieldVisibility(fieldName),
                activeColor: Colors.green,
              ),
              const SizedBox(width: 4),
              Text(
                '[$fieldType] Label:',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdownFieldToggle({
    required String fieldName,
    required String label,
  }) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown field header
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _viewModel.model.fieldVisibility[fieldName] ?? true,
                    onChanged: (value) =>
                        _viewModel.toggleFieldVisibility(fieldName),
                    activeColor: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '[Dropdown] Label:',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dropdown options
            if (_viewModel.model.fieldVisibility[fieldName] ?? true)
              Padding(
                padding: const EdgeInsets.only(left: 40.0, bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Existing options
                    ..._viewModel.model.dropdownOptions[fieldName]!
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final option = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            // Add/Remove buttons
                            index == 0
                                ? IconButton(
                                    icon: Icon(Icons.add_circle,
                                        color: _viewModel.model.primaryColor,
                                        size: 20),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () =>
                                        _viewModel.showAddOptionDialog(
                                            context, fieldName),
                                  )
                                : IconButton(
                                    icon: Icon(Icons.remove_circle,
                                        color: _viewModel.model.primaryColor,
                                        size: 20),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => _viewModel
                                        .removeDropdownOption(fieldName, index),
                                  ),
                            const SizedBox(width: 8),
                            Text(
                              'Option ${index + 1}:',
                              style: const TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBottomButtons() {
    return Container(
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
              onPressed: () => Navigator.pop(context),
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
              onPressed: () =>
                  _viewModel.handleCompleteForm(context, widget.event),
              style: ElevatedButton.styleFrom(
                backgroundColor: _viewModel.model.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _viewModel.model.completeButtonText,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
