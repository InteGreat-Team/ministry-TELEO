import 'package:flutter/material.dart';
import 'package:teleo_organized_new/1/c1homepage/nav_bar.dart';
import 'dart:typed_data';
import '../../../c2eventscreation/widgets/step_indicator.dart';
import '../../../c2eventscreation/widgets/required_asterisk.dart';
import '../../../c2eventscreation/widgets/event_app_bar.dart';
import '../screens/CHURCH_CREATEVENTS_5.dart';
import '../screens/CHURCH_CREATEVENTS_4.dart';
import '../screens/CHURCH_CREATEVENTS_3p2.dart';
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import '../../backend/viewmodels/CHURCH_CREATEVENTS_FUNC.dart';
class EventLocationScreen extends StatefulWidget {
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

  const EventLocationScreen({
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
  });

  @override
  State<EventLocationScreen> createState() => _EventLocationScreenState();
}

class _EventLocationScreenState extends State<EventLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  late EventLocationViewModel _viewModel;
  late EventLocationModel _model;

  @override
  void initState() {
    super.initState();
    _model = EventLocationModel();
    _viewModel = EventLocationViewModel(_model);
    _viewModel.initializeFromEvent(widget.event);
    
    // Listen to view model changes
    _viewModel.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _showOutsourceDialog() {
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
                const Row(
                  children: [
                    Icon(Icons.search, size: 24, color: Color(0xFF0A0A4A)),
                    SizedBox(width: 8),
                    Text(
                      'Outsource Event',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Proceed to External API to outsource your event location?',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF444444),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'No',
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
                          Navigator.of(context).pop();
                          _viewModel.setOutsourcedVenue(true);
                          _viewModel.saveEventData(widget.event);
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventApiErrorScreen(event: widget.event),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0A4A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Yes',
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
                      currentStep: 3,
                      totalSteps: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Where is your event?',
                            style: TextStyle(
                              color: Color(0xFF0A0A4A),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Online/Onsite Selection
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _viewModel.setOnline(true),
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: _model.isOnline ? const Color(0xFFFFC107) : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFFFFC107),
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.computer,
                                          size: 40,
                                          color: _model.isOnline ? Colors.white : const Color(0xFFFFC107),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Online',
                                          style: TextStyle(
                                            color: _model.isOnline ? Colors.white : const Color(0xFFFFC107),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _viewModel.setOnline(false),
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: !_model.isOnline ? const Color(0xFFFFC107) : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFFFFC107),
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 40,
                                          color: !_model.isOnline ? Colors.white : const Color(0xFFFFC107),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Onsite',
                                          style: TextStyle(
                                            color: !_model.isOnline ? Colors.white : const Color(0xFFFFC107),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          if (_model.isOnline)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Meeting Platform Selection
                                const Row(
                                  children: [
                                    Text(
                                      'Select meeting platform',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    RequiredAsterisk(),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _model.selectedPlatform,
                                      isExpanded: true,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          _viewModel.setSelectedPlatform(newValue);
                                        }
                                      },
                                      items: _model.meetingPlatforms.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                
                                // Custom Platform Input
                                if (_model.isCustomPlatform) ...[
                                  const SizedBox(height: 8),
                                  const Row(
                                    children: [
                                      Text(
                                        'Specify platform',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      RequiredAsterisk(),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _viewModel.customPlatformController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter meeting platform name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                                
                                const SizedBox(height: 16),
                                
                                // URL Input Field
                                const Row(
                                  children: [
                                    Text(
                                      'Input your link',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    RequiredAsterisk(),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextFormField(
                                    controller: _viewModel.eventLinkController,
                                    decoration: InputDecoration(
                                      hintText: _viewModel.getUrlHintText(),
                                      prefixIcon: const Icon(Icons.link),
                                      suffixIcon: _model.isValidatingUrl 
                                        ? const SizedBox(
                                            width: 20, 
                                            height: 20, 
                                            child: CircularProgressIndicator(strokeWidth: 2)
                                          )
                                        : _model.urlValidated
                                          ? const Icon(Icons.check_circle, color: Colors.green)
                                          : null,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                                      errorStyle: const TextStyle(height: 0, color: Colors.transparent),
                                    ),
                                    keyboardType: TextInputType.url,
                                    onChanged: (value) => _viewModel.onUrlChanged(value),
                                  ),
                                ),
                                // Show error message below the field
                                if (_model.urlError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      _model.urlError!,
                                      style: const TextStyle(color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                                if (!_model.urlValidated && _model.urlError == null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      _viewModel.getValidationHelpText(),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Venue/Location *',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Radio<bool>(
                                      value: false,
                                      groupValue: _model.isOutsourcedVenue,
                                      onChanged: (value) => _viewModel.setOutsourcedVenue(value!),
                                      activeColor: const Color(0xFF0A0A4A),
                                    ),
                                    const Text('Provide my own'),
                                    const SizedBox(width: 16),
                                    Radio<bool>(
                                      value: true,
                                      groupValue: _model.isOutsourcedVenue,
                                      onChanged: (value) => _viewModel.setOutsourcedVenue(value!),
                                      activeColor: const Color(0xFF0A0A4A),
                                    ),
                                    const Text('Outsource Event'),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Button section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0A0A4A),
                          side: const BorderSide(color: Color(0xFF0A0A4A)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _handleContinuePressed();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0A4A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _model.isOnline ? 'Continue' : 'Location',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
              bottomNavigationBar: NavBar(
                currentIndex: 2, // Set to the correct index for Events
                onTap: (index) {
                  // Add navigation logic if needed
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleContinuePressed() async {
    if (_model.isOnline) {
      // Validate online event requirements
      final validationResult = await _viewModel.validateOnlineEvent();
      
      if (!validationResult.isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validationResult.errorMessage!)),
        );
        return;
      }
      
      _viewModel.saveEventData(widget.event);
      
      // Navigate to summary screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventSummaryScreen(
            event: widget.event,
            title: widget.title,
            tags: widget.tags,
            description: widget.description,
            contactInfo: widget.contactInfo,
            churchLandline: widget.churchLandline,
            dressCode: widget.dressCode,
            speakers: widget.speakers,
            imageUrl: widget.imageUrl,
            imagePath: widget.imagePath,
            imageBytes: widget.imageBytes,
            additionalImages: widget.additionalImages,
            isOneDay: widget.isOneDay,
            eventDays: widget.eventDays,
            startDate: widget.startDate,
            endDate: widget.endDate,
            startTime: widget.startTime,
            endTime: widget.endTime,
            isOnline: true,
            eventLink: _viewModel.eventLinkController.text,
            isOutsourcedVenue: false,
            meetingPlatform: _model.isCustomPlatform ? _viewModel.customPlatformController.text : _model.selectedPlatform,
          ),
        ),
      );
    } else {
      _viewModel.saveEventData(widget.event);
      
      if (_model.isOutsourcedVenue) {
        _showOutsourceDialog();
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventMapScreen(event: widget.event),
          ),
        );
      }
    }
  }
}
