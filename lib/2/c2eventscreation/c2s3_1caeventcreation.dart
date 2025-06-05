import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'models/event.dart';
import 'widgets/step_indicator.dart';
import 'widgets/required_asterisk.dart';
import 'c2s4caeventcreation.dart';
import 'c2s5caeventcreation.dart';
import 'c2s3_2caeventcreation.dart';
import 'widgets/event_app_bar.dart';

class EventLocationScreen extends StatefulWidget {
  final Event event;

  const EventLocationScreen({super.key, required this.event});

  @override
  State<EventLocationScreen> createState() => _EventLocationScreenState();
}

class _EventLocationScreenState extends State<EventLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isOnline = false;
  String? _eventLink;
  bool _isOutsourcedVenue = false;
  final TextEditingController _eventLinkController = TextEditingController();
  bool _isValidatingUrl = false;
  bool _urlValidated = false;
  String? _urlError;

  // Meeting platform options
  final List<String> _meetingPlatforms = ['Google Meet', 'Zoom', 'Microsoft Teams', 'Others'];
  String _selectedPlatform = 'Google Meet';
  final TextEditingController _customPlatformController = TextEditingController();
  bool _isCustomPlatform = false;

  @override
  void initState() {
    super.initState();
    _isOnline = widget.event.isOnline;
    _eventLink = widget.event.eventLink;
    if (_eventLink != null) {
      _eventLinkController.text = _eventLink!;
      _validateUrl(_eventLink!);
    }
    
    // Initialize platform selection if available from the event
    if (widget.event.meetingPlatform != null) {
      if (_meetingPlatforms.contains(widget.event.meetingPlatform)) {
        _selectedPlatform = widget.event.meetingPlatform!;
        _isCustomPlatform = false;
      } else {
        _selectedPlatform = 'Others';
        _customPlatformController.text = widget.event.meetingPlatform!;
        _isCustomPlatform = true;
      }
    }
  }

  Future<bool> _validateUrl(String url) async {
    if (url.isEmpty) {
      setState(() {
        _urlError = 'URL is required';
        _urlValidated = false;
        _isValidatingUrl = false;
      });
      return false;
    }

    // Check if URL starts with http:// or https://
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      setState(() {
        _urlError = 'URL must start with http:// or https://';
        _urlValidated = false;
        _isValidatingUrl = false;
      });
      return false;
    }

    // Platform-specific URL validation
    if (!_isCustomPlatform) {
      bool isValidPlatformUrl = false;
      String platformName = '';

      switch (_selectedPlatform) {
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
          isValidPlatformUrl = true; // For "Others", we just check if it's a valid URL
      }

      if (!isValidPlatformUrl) {
        setState(() {
          _urlError = 'Please enter a valid $platformName URL';
          _urlValidated = false;
          _isValidatingUrl = false;
        });
        return false;
      }
    }

    setState(() {
      _isValidatingUrl = true;
      _urlError = null;
    });

    try {
      final response = await http.head(Uri.parse(url)).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Connection timed out');
        },
      );
      
      setState(() {
        _isValidatingUrl = false;
        if (response.statusCode < 200 || response.statusCode >= 400) {
          _urlError = 'URL is not accessible (Status: ${response.statusCode})';
          _urlValidated = false;
        } else {
          _urlValidated = true;
          _urlError = null;
        }
      });
      
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (e) {
      setState(() {
        _isValidatingUrl = false;
        _urlError = 'Invalid URL: ${e.toString().split(':')[0]}';
        _urlValidated = false;
      });
      return false;
    }
  }

  void _showOutsourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF8F0F0), // Light pink/beige background
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
                          backgroundColor: const Color(0xFF444444), // Dark gray but not too dark
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
                          setState(() {
                            _isOutsourcedVenue = true;
                          });
                          
                          // Save event location information
                          _saveEventData();
                          
                          // Navigate to the API error screen instead of the map screen
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

  String _getPlatformHelpText(String platform) {
    switch (platform) {
      case 'Google Meet':
        return 'Example: https://meet.google.com/abc-defg-hij';
      case 'Zoom':
        return 'Example: https://zoom.us/j/1234567890';
      case 'Microsoft Teams':
        return 'Example: https://teams.microsoft.com/l/meetup-join/...';
      default:
        return '';
    }
  }

  void _saveEventData() {
    // Save event location information
    widget.event.isOnline = _isOnline;
    widget.event.eventLink = _eventLink;
    widget.event.isOutsourcedVenue = _isOutsourcedVenue;
    
    // Save meeting platform information
    if (_isOnline) {
      widget.event.meetingPlatform = _isCustomPlatform ? _customPlatformController.text : _selectedPlatform;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => Navigator.pop(context), title: '',
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
                              color: Color(0xFF0A0A4A), // Changed from red to navy blue
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
                                  onTap: () {
                                    setState(() {
                                      _isOnline = true;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: _isOnline ? const Color(0xFFFFC107) : Colors.white,
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
                                          color: _isOnline ? Colors.white : const Color(0xFFFFC107),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Online',
                                          style: TextStyle(
                                            color: _isOnline ? Colors.white : const Color(0xFFFFC107),
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
                                  onTap: () {
                                    setState(() {
                                      _isOnline = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: !_isOnline ? const Color(0xFFFFC107) : Colors.white,
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
                                          color: !_isOnline ? Colors.white : const Color(0xFFFFC107),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Onsite',
                                          style: TextStyle(
                                            color: !_isOnline ? Colors.white : const Color(0xFFFFC107),
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
                          if (_isOnline)
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
                                      value: _selectedPlatform,
                                      isExpanded: true,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            _selectedPlatform = newValue;
                                            _isCustomPlatform = newValue == 'Others';
                                            
                                            // Clear URL field when platform changes
                                            if (_eventLinkController.text.isNotEmpty) {
                                              _eventLinkController.clear();
                                              _urlValidated = false;
                                              _urlError = null;
                                            }
                                          });
                                        }
                                      },
                                      items: _meetingPlatforms.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                
                                // Custom Platform Input (only shown when "Others" is selected)
                                if (_isCustomPlatform) ...[
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
                                    controller: _customPlatformController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter meeting platform name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                                
                                const SizedBox(height: 16),
                                
                                // URL Input Field - UPDATED to match the second image with gray background
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
                                    controller: _eventLinkController,
                                    decoration: InputDecoration(
                                      hintText: _isCustomPlatform 
                                        ? 'https://' 
                                        : _selectedPlatform == 'Google Meet' 
                                          ? 'https://meet.google.com/xxx-xxxx-xxx'
                                          : _selectedPlatform == 'Zoom'
                                            ? 'https://zoom.us/j/xxxxxxxxxx'
                                            : 'https://teams.microsoft.com/l/meetup-join/...',
                                      prefixIcon: const Icon(Icons.link),
                                      suffixIcon: _isValidatingUrl 
                                        ? const SizedBox(
                                            width: 20, 
                                            height: 20, 
                                            child: CircularProgressIndicator(strokeWidth: 2)
                                          )
                                        : _urlValidated
                                          ? const Icon(Icons.check_circle, color: Colors.green)
                                          : null,
                                      // Remove all borders
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      // Add padding inside the field
                                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                                      // Don't show error inside the field
                                      errorStyle: const TextStyle(height: 0, color: Colors.transparent),
                                    ),
                                    keyboardType: TextInputType.url,
                                    onChanged: (value) {
                                      _eventLink = value;
                                      if (value.isNotEmpty) {
                                        _validateUrl(value);
                                      }
                                    },
                                  ),
                                ),
                                // Show error message below the field
                                if (_urlError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      _urlError!,
                                      style: const TextStyle(color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                                if (!_urlValidated && _urlError == null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      _isCustomPlatform
                                        ? 'Please enter a valid, working URL (e.g., https://example.com)'
                                        : 'Please enter a valid $_selectedPlatform URL',
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
                                      groupValue: _isOutsourcedVenue,
                                      onChanged: (value) {
                                        setState(() {
                                          _isOutsourcedVenue = value!;
                                        });
                                      },
                                      activeColor: const Color(0xFF0A0A4A), // Changed from red to navy blue
                                    ),
                                    const Text('Provide my own'),
                                    const SizedBox(width: 16),
                                    Radio<bool>(
                                      value: true,
                                      groupValue: _isOutsourcedVenue,
                                      onChanged: (value) {
                                        setState(() {
                                          _isOutsourcedVenue = value!;
                                        });
                                      },
                                      activeColor: const Color(0xFF0A0A4A), // Changed from red to navy blue
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                          // For online events, validate URL before proceeding
                          if (_isOnline) {
                            if (_eventLinkController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter a URL')),
                              );
                              return;
                            }
                            
                            // Check if custom platform is selected but not specified
                            if (_isCustomPlatform && _customPlatformController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please specify the meeting platform')),
                              );
                              return;
                            }
                            
                            final isValid = await _validateUrl(_eventLinkController.text);
                            if (!isValid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter a valid, working URL')),
                              );
                              return;
                            }
                            
                            // Save event location information
                            _saveEventData();
                            
                            // Go directly to summary
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventSummaryScreen(event: widget.event),
                              ),
                            );
                          } else {
                            // Save event location information
                            _saveEventData();
                            
                            // If onsite and outsourced, show dialog
                            if (_isOutsourcedVenue) {
                              _showOutsourceDialog();
                            } else {
                              // If onsite but not outsourced, go to map screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventMapScreen(event: widget.event),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0A4A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _isOnline ? 'Continue' : 'Location',
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
          ],
        ),
      ),
    );
  }
}