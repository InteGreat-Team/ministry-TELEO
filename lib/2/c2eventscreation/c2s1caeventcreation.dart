import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'models/event.dart';
import 'widgets/step_indicator.dart';
import 'widgets/required_asterisk.dart';
import 'c2s2caeventcreation.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'widgets/event_app_bar.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final Event _event = Event();
  final _formKey = GlobalKey<FormState>();
  final int _maxImages =
      5; // Maximum number of images allowed (including main image)

  final List<String> _availableTags = [
    'Seminar',
    'Education',
    'Religious Celebrations',
    'Music',
    'Community',
    'Healing',
  ];

  final List<TextEditingController> _speakerControllers = [
    TextEditingController(),
  ];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _churchLandlineController =
      TextEditingController();
  final TextEditingController _dressCodeController = TextEditingController();

  // Form validation error messages
  Map<String, String> _errorMessages = {};

  @override
  void initState() {
    super.initState();
    // Initialize empty tags list
    _event.tags = [];
    _event.speakers = [];
    _event.additionalImages = [];
  }

  // Simple image picker function
  Future<void> _pickImage() async {
    // Check if maximum number of images is reached
    if (_totalImagesCount >= _maxImages) {
      _showErrorSnackbar("Maximum of $_maxImages images allowed");
      return;
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        Uint8List? imageBytes;
        String? imagePath;

        // Load the image
        if (kIsWeb) {
          imageBytes = await image.readAsBytes();
        } else {
          imagePath = image.path;
          imageBytes = await File(imagePath).readAsBytes();
        }

        setState(() {
          if (_event.imageBytes == null &&
              _event.imagePath == null &&
              _event.imageUrl == null) {
            // Set as main image
            _event.imageBytes = imageBytes;
            _event.imagePath = imagePath;
          } else {
            // Add as additional image
            final eventImage = EventImage(
              imageBytes: imageBytes,
              imagePath: imagePath,
            );
            _event.additionalImages.add(eventImage);
          }
        });
      }
    } catch (e) {
      _showErrorSnackbar("Error picking image: $e");
    }
  }

  void _removeImage(int index) {
    if (index == -1) {
      // Remove main image
      setState(() {
        _event.imageBytes = null;
        _event.imagePath = null;
        _event.imageUrl = null;
      });
    } else {
      // Remove additional image
      setState(() {
        _event.additionalImages.removeAt(index);
      });
    }
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_event.tags.contains(tag)) {
        _event.tags.remove(tag);
      } else {
        _event.tags.add(tag);
      }
    });
  }

  void _addSpeaker() {
    setState(() {
      _speakerControllers.add(TextEditingController());
    });
  }

  void _removeSpeaker(int index) {
    setState(() {
      _speakerControllers.removeAt(index);
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  bool _validateForm() {
    setState(() {
      _errorMessages = {};
    });

    bool isValid = true;

    // Validate title
    if (_titleController.text.isEmpty) {
      _errorMessages['title'] = 'Event title is required';
      isValid = false;
    }

    // Validate tags
    if (_event.tags.isEmpty) {
      _errorMessages['tags'] = 'At least one tag is required';
      isValid = false;
    }

    // Validate description
    if (_descriptionController.text.isEmpty) {
      _errorMessages['description'] = 'Event description is required';
      isValid = false;
    }

    // Validate mobile number (Philippine format)
    if (_mobileNumberController.text.isEmpty) {
      _errorMessages['mobileNumber'] = 'Mobile number is required';
      isValid = false;
    } else {
      // Check if it's a valid Philippine mobile number
      final mobileNumber = _mobileNumberController.text.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      if (!RegExp(r'^(09|\+639)\d{9}$').hasMatch(mobileNumber)) {
        _errorMessages['mobileNumber'] =
            'Please enter a valid Philippine mobile number';
        isValid = false;
      }
    }

    // Validate church landline (Philippine format)
    if (_churchLandlineController.text.isNotEmpty) {
      final landline = _churchLandlineController.text.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      if (landline.length != 8) {
        _errorMessages['churchLandline'] =
            'Please enter a valid 8-digit Philippine landline number';
        isValid = false;
      }
    }

    // Validate dress code (no special characters)
    if (_dressCodeController.text.isNotEmpty) {
      if (!RegExp(r'^[a-zA-Z0-9\s\-]+$').hasMatch(_dressCodeController.text)) {
        _errorMessages['dressCode'] =
            'Dress code should not contain special characters';
        isValid = false;
      }
    }

    // Validate speakers (no special characters)
    for (int i = 0; i < _speakerControllers.length; i++) {
      final speakerText = _speakerControllers[i].text;
      if (speakerText.isNotEmpty) {
        if (!RegExp(r'^[a-zA-Z\s\.\-]+$').hasMatch(speakerText)) {
          _errorMessages['speaker$i'] =
              'Speaker name should only contain letters, spaces, periods, and hyphens';
          isValid = false;
        }
      }
    }

    return isValid;
  }

  void _saveFormData() {
    // Save form data
    _event.title = _titleController.text;
    _event.description = _descriptionController.text;
    _event.contactInfo = _mobileNumberController.text;
    _event.churchLandline =
        _churchLandlineController.text.isEmpty
            ? null
            : _churchLandlineController.text;
    _event.dressCode = _dressCodeController.text;

    // Save speakers
    _event.speakers =
        _speakerControllers
            .map((controller) => controller.text)
            .where((text) => text.isNotEmpty)
            .toList();
  }

  bool _hasMainImage() {
    return _event.imageBytes != null ||
        _event.imagePath != null ||
        _event.imageUrl != null;
  }

  int get _totalImagesCount {
    return (_hasMainImage() ? 1 : 0) + _event.additionalImages.length;
  }

  @override
  Widget build(BuildContext context) {
    // Define the input decoration for filled fields with rounded corners
    final InputDecoration filledInputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      hintStyle: TextStyle(color: Colors.grey[600]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );

    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => Navigator.maybePop(context),
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
                    const StepIndicator(currentStep: 1, totalSteps: 7),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'What is your event for?',
                            style: TextStyle(
                              color: Color(0xFF0A0A4A),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Simple Image Upload Area
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    color: Colors.grey[600],
                                    size: 48,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Tap to upload image',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Supports: JPG, JPEG, PNG',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (_totalImagesCount > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        '$_totalImagesCount/$_maxImages ${_totalImagesCount == 1 ? 'image' : 'images'} selected',
                                        style: TextStyle(
                                          color:
                                              _totalImagesCount >= _maxImages
                                                  ? Colors.red
                                                  : Colors.green[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          // Display selected images
                          if (_hasMainImage() ||
                              _event.additionalImages.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Selected Images:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Compact grid of images
                                  GridView.count(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 1.5,
                                    children: [
                                      // Main image (if exists)
                                      if (_hasMainImage())
                                        _buildCompactImageCard(
                                          _event.imageBytes,
                                          _event.imagePath,
                                          'Image 1 (Main)',
                                          onRemove: () => _removeImage(-1),
                                        ),

                                      // Additional images
                                      ...List.generate(
                                        _event.additionalImages.length,
                                        (index) => _buildCompactImageCard(
                                          _event
                                              .additionalImages[index]
                                              .imageBytes,
                                          _event
                                              .additionalImages[index]
                                              .imagePath,
                                          'Image ${index + 2}',
                                          onRemove: () => _removeImage(index),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          // Event Title
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                'Event Title',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const RequiredAsterisk(),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _titleController,
                            decoration: filledInputDecoration.copyWith(
                              hintText: 'Enter event title',
                              errorText: _errorMessages['title'],
                            ),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9\s.,!?-]'),
                              ),
                            ],
                          ),

                          // Event Tags
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                'Event Tags',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const RequiredAsterisk(),
                              if (_errorMessages.containsKey('tags'))
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    _errorMessages['tags']!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                _availableTags.map((tag) {
                                  final isSelected = _event.tags.contains(tag);
                                  return GestureDetector(
                                    onTap: () => _toggleTag(tag),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? const Color(0xFFFFC107)
                                                : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? const Color(0xFFFFC107)
                                                  : Colors.grey[400]!,
                                        ),
                                      ),
                                      child: Text(
                                        tag,
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),

                          // Event Description
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                'Event Description',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const RequiredAsterisk(),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: filledInputDecoration.copyWith(
                              hintText: 'Enter event description',
                              errorText: _errorMessages['description'],
                            ),
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                          ),

                          // Mobile Number
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                'Mobile Number',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const RequiredAsterisk(),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _mobileNumberController,
                            decoration: filledInputDecoration.copyWith(
                              hintText: '(09123456789)',
                              errorText: _errorMessages['mobileNumber'],
                              prefixIcon: const Icon(Icons.phone_android),
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9\+\-\s]'),
                              ),
                              LengthLimitingTextInputFormatter(13),
                            ],
                          ),

                          // Church Landline
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text(
                                'Church Landline',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ' (optional)',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _churchLandlineController,
                            decoration: filledInputDecoration.copyWith(
                              hintText:
                                  'Enter church landline/telephone number',
                              prefixIcon: const Icon(Icons.phone),
                              errorText: _errorMessages['churchLandline'],
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]'),
                              ),
                              LengthLimitingTextInputFormatter(
                                8,
                              ), // Limit to 8 digits for Philippine landlines
                            ],
                          ),

                          // Dress Code
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text(
                                'Dress Code (optional)',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _dressCodeController,
                            decoration: filledInputDecoration.copyWith(
                              hintText: 'E.g., Smart Casual',
                              helperText:
                                  'Only letters, numbers, spaces, and hyphens allowed',
                              errorText: _errorMessages['dressCode'],
                            ),
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9\s\-]'),
                              ),
                              LengthLimitingTextInputFormatter(
                                50,
                              ), // Limit to 50 characters
                            ],
                          ),

                          // Guest/Speaker
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                'Guest/Speaker',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Only letters, spaces, periods, and hyphens allowed',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Speaker fields with add button below
                          Column(
                            children: [
                              // Speaker fields
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _speakerControllers.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                _speakerControllers[index],
                                            decoration: filledInputDecoration.copyWith(
                                              hintText:
                                                  index == 0
                                                      ? 'Enter speaker name'
                                                      : 'Guest/Speaker ${index + 1}',
                                              errorText:
                                                  _errorMessages['speaker$index'],
                                            ),
                                            textCapitalization:
                                                TextCapitalization.words,
                                            keyboardType: TextInputType.name,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[a-zA-Z\s\.\-]'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: Icon(
                                            Icons.remove_circle,
                                            color:
                                                _speakerControllers.length >
                                                            1 ||
                                                        index > 0
                                                    ? Colors.red
                                                    : Colors.grey,
                                          ),
                                          onPressed:
                                              _speakerControllers.length > 1 ||
                                                      index > 0
                                                  ? () => _removeSpeaker(index)
                                                  : null,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              // Add button - positioned with no gap
                              Container(
                                width: 36,
                                height: 36,
                                margin: const EdgeInsets.only(top: 0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A0A4A),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: _addSpeaker,
                                  tooltip: 'Add New Guest/Speaker',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ],
                          ),

                          // Add extra space at the bottom for scrolling
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom button bar - Fixed to match screenshot
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Back button - with border only
                    Expanded(
                      child: SizedBox(
                        height: 48, // Fixed height for both buttons
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.maybePop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0A0A4A),
                            side: const BorderSide(color: Color(0xFF0A0A4A)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Back'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Continue button - filled
                    Expanded(
                      child: SizedBox(
                        height: 48, // Fixed height for both buttons
                        child: ElevatedButton(
                          onPressed: () {
                            if (_validateForm()) {
                              _saveFormData();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          EventDateScreen(event: _event),
                                ),
                              );
                            } else {
                              _showErrorSnackbar(
                                'Please fill in all required fields',
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A0A4A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Continue'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Display compact image card with label and remove button
  Widget _buildCompactImageCard(
    Uint8List? imageBytes,
    String? imagePath,
    String label, {
    required VoidCallback onRemove,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image label with remove button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                GestureDetector(
                  onTap: onRemove,
                  child: const Icon(Icons.delete, color: Colors.red, size: 18),
                ),
              ],
            ),
          ),

          // Image preview (smaller height)
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child:
                  imageBytes != null
                      ? Image.memory(
                        imageBytes,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                      : imagePath != null
                      ? Image.file(
                        File(imagePath),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
