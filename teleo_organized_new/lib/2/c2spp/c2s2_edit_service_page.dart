import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;
import '../aws_connect.dart'; // Adjust the path
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EditServicePage extends StatefulWidget {
  final String title;
  final String description;
  final String cId; // ✅ Add this
  final String servName; // ✅ Add this
  final String servId;

  const EditServicePage({
    Key? key,
    required this.title,
    required this.description,
    required this.cId, // ✅
    required this.servName, // ✅
    required this.servId, // ✅ this is required
  }) : super(key: key);

  @override
  _EditServicePageState createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  late TextEditingController _descriptionController;
  String _requestFormType = 'Baptism Form';
  bool _fastBooking = true;
  bool _scheduledForLater = true;
  bool _toTheChurch = true;
  bool _toYourLocation = true;
  bool _divineLink = true;
  String _alternativeAddress =
      '2222 K Street, Samgyupsal, Salamat City, Napakasarap, Gutom 888';

  // Image variables
  Uint8List? _imageBytes;
  String? _imagePath;
  String? _imageUrl;
  bool _isUploading = false;

  // Time slots
  final List<String> _allTimeSlots = [
    '9:00 AM',
    '9:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
    '4:30 PM',
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
    '7:30 PM',
    '9:00 PM',
    '9:30 PM',
  ];

  final List<String> _selectedTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // Image picker function
  Future<void> _pickImage() async {
    try {
      setState(() {
        _isUploading = true;
      });

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
          _imageBytes = imageBytes;
          _imagePath = imagePath;
          _isUploading = false;
        });
      } else {
        setState(() {
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      _showErrorSnackbar("Error picking image: $e");
    }
  }

  void _removeImage() {
    setState(() {
      _imageBytes = null;
      _imagePath = null;
      _imageUrl = null;
    });
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return; // Check if widget is still mounted

    print('Showing error snackbar: $message'); // Debug log

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5), // Show for 5 seconds
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No app bar - we'll create a custom header
      body: Column(
        children: [
          // Custom header positioned at the very top with padding and drop shadow
          Container(
            width: double.infinity,
            // FIXED: Moved color inside BoxDecoration
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25), // 25% opacity
                  offset: const Offset(0, 4), // Y offset of 4
                  blurRadius: 4, // Blur of 4
                  spreadRadius: 0, // Spread of 0
                ),
              ],
            ),
            child: Column(
              children: [
                // Top padding to match the image
                const SizedBox(height: 16),

                // Header content with back button and title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      // Back button - simple arrow without background
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),

                      // Centered title
                      Expanded(
                        child: Center(
                          child: Text(
                            'Service Details',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      // Empty space to balance the back button
                      const SizedBox(width: 24),
                    ],
                  ),
                ),

                // Bottom padding to complete the header
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Content area - scrollable
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service title - now directly below header without blue outline
                    const Text(
                      'Baptism and Dedication',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Image upload section with dashed border
                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(8),
                      padding: const EdgeInsets.all(24),
                      color: Colors.grey.shade400,
                      strokeWidth: 1,
                      dashPattern: const [5, 5],
                      child: Container(
                        width: double.infinity,
                        color: Colors.grey.shade100,
                        child: Column(
                          children: [
                            // Show selected image or default icon
                            if (_imageBytes != null)
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: MemoryImage(_imageBytes!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Remove button
                                  GestureDetector(
                                    onTap: _removeImage,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.image,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),

                            const SizedBox(height: 16),

                            // Upload button with loading state
                            ElevatedButton(
                              onPressed: _isUploading ? null : _pickImage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                minimumSize: const Size(150, 40),
                              ),
                              child:
                                  _isUploading
                                      ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : const Text(
                                        'Upload media',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                            ),

                            const SizedBox(height: 12),

                            // Supported formats text
                            Text(
                              'Supports: JPG, JPEG, PNG, PDF, MOV, MP4, GIF',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description section - UPDATED with gray background
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' *',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Updated TextField with gray background instead of border
                          TextField(
                            controller: _descriptionController,
                            maxLines: 3,
                            maxLength: 200,
                            decoration: InputDecoration(
                              hintText:
                                  'This is what you put as description only limited 200 chars.',
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none, // Remove border
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none, // Remove border
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Request Form Type section - UPDATED with gray background
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Request Form Type',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' *',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Updated dropdown with gray background instead of border
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<String>(
                              value: _requestFormType,
                              isExpanded: true,
                              underline:
                                  Container(), // Remove the default underline
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _requestFormType = newValue;
                                  });
                                }
                              },
                              items:
                                  <String>[
                                    'Baptism Form',
                                    'Dedication Form',
                                    'Other Form',
                                  ].map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Reservation Mode section - UPDATED with blue square checkboxes
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Reservation Mode',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' *',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Updated checkbox styling
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                fillColor: MaterialStateProperty.resolveWith<
                                  Color
                                >((Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.blue; // Blue when checked
                                  }
                                  return Colors
                                      .grey
                                      .shade300; // Gray when unchecked
                                }),
                                checkColor: MaterialStateProperty.all(
                                  Colors.white,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  title: const Text('Fast Booking'),
                                  value: _fastBooking,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _fastBooking = value ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),

                                CheckboxListTile(
                                  title: const Text(
                                    'Scheduled for Later Booking',
                                  ),
                                  value: _scheduledForLater,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _scheduledForLater = value ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Service Mode section - UPDATED with blue square checkboxes
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Service Mode',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' *',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Updated checkbox styling
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                fillColor: MaterialStateProperty.resolveWith<
                                  Color
                                >((Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.blue; // Blue when checked
                                  }
                                  return Colors
                                      .grey
                                      .shade300; // Gray when unchecked
                                }),
                                checkColor: MaterialStateProperty.all(
                                  Colors.white,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  title: const Text('To the Church'),
                                  value: _toTheChurch,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _toTheChurch = value ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),

                                if (_toTheChurch)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '* Default church address will be used. Add an alternative address if this service is facilitated in another place.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        const Text(
                                          'Alternative Address',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        // Updated text field with gray background
                                        TextField(
                                          controller: TextEditingController(
                                            text: _alternativeAddress,
                                          ),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey.shade200,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                          ),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),

                                CheckboxListTile(
                                  title: const Text('To Your Location'),
                                  value: _toYourLocation,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _toYourLocation = value ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),

                                CheckboxListTile(
                                  title: const Text('Divine Link (Online)'),
                                  value: _divineLink,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _divineLink = value ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),

                                if (_divineLink)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32.0),
                                    child: Text(
                                      '* Link will be provided externally.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Active Time Slots section - UPDATED with pink background for PM slots
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Active Time Slots',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' *',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          // Time slots grid with updated styling
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 2.5,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                            itemCount: _allTimeSlots.length,
                            itemBuilder: (context, index) {
                              final timeSlot = _allTimeSlots[index];
                              final isSelected = _selectedTimeSlots.contains(
                                timeSlot,
                              );

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedTimeSlots.remove(timeSlot);
                                    } else {
                                      _selectedTimeSlots.add(timeSlot);
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? const Color(0xFFFFB3C0)
                                            : Colors
                                                .transparent, // Pink when selected, transparent when not
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ), // Rounded corners
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? Colors.transparent
                                              : Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      timeSlot,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Bottom buttons
                    Row(
                      children: [
                        // Back Button
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF000233),
                                width: 1,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                borderRadius: BorderRadius.circular(8),
                                child: const Center(
                                  child: Text(
                                    'Back',
                                    style: TextStyle(
                                      color: Color(0xFF000233),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Save Changes Button
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFF000233), // Dark navy blue
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  print('🧪 Save button tapped');
                                  if (_descriptionController.text.isEmpty ||
                                      _selectedTimeSlots.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please fill in all required fields',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  String reqFormType = _requestFormType;

                                  // ✅ Reservation Mode → serv_type
                                  String servType;
                                  if (_fastBooking && _scheduledForLater) {
                                    servType = 'C0003';
                                  } else if (_fastBooking) {
                                    servType = 'C0002';
                                  } else if (_scheduledForLater) {
                                    servType = 'C0001';
                                  } else {
                                    servType =
                                        'C0001'; // Fallback to default if neither is selected
                                  }

                                  // ✅ Service Mode → serv_mode (as comma-separated string)
                                  List<String> modeList = [];
                                  if (_toTheChurch)
                                    modeList.add('church_location');
                                  if (_toYourLocation)
                                    modeList.add('user_location');
                                  if (_divineLink) modeList.add('divine_link');
                                  String combinedMode = modeList.join(',');

                                  try {
                                    print('🧭 Uploading image if available...');
                                    String mediaUrl = "";

                                    // ✅ Step 1: Upload to S3 if an image is selected
                                    if (_imageBytes != null) {
                                      setState(() {
                                        _isUploading = true;
                                      });

                                      final uploader = S3UploadService();
                                      print('🔄 Initializing S3 uploader...');
                                      await uploader.init();

                                      final timestamp =
                                          DateTime.now().millisecondsSinceEpoch;
                                      final fileKey =
                                          "services/${widget.servId}_$timestamp.jpg";
                                      print('📝 Generated file key: $fileKey');

                                      try {
                                        print('📤 Starting image upload...');
                                        mediaUrl = await uploader.uploadFile(
                                          fileKey,
                                          _imageBytes!,
                                          'image/jpeg',
                                        );
                                        print(
                                          '✅ Image uploaded successfully: $mediaUrl',
                                        );
                                      } catch (uploadError) {
                                        setState(() {
                                          _isUploading = false;
                                        });
                                        print(
                                          '❌ Image upload failed: $uploadError',
                                        );
                                        _showErrorSnackbar(
                                          "Image upload failed: $uploadError",
                                        );
                                        return;
                                      }

                                      setState(() {
                                        _isUploading = false;
                                      });
                                    }

                                    print(
                                      '📤 Preparing payload for service update...',
                                    );
                                    final payload = {
                                      'c_id': widget.cId,
                                      'serv_id': widget.servId,
                                      'serv_name': widget.servName,
                                      'description':
                                          _descriptionController.text,
                                      'amount': 0,
                                      'serv_type': servType,
                                      'serv_mode': combinedMode,
                                      'timeslot': _selectedTimeSlots.join(','),
                                      'media': mediaUrl,
                                      'req_form_type': reqFormType,
                                    };

                                    print(
                                      '🔄 Sending update request to backend...',
                                    );
                                    final response = await http.put(
                                      Uri.parse(
                                        'http://192.168.254.102:3000/church_services/update',
                                      ),
                                      headers: {
                                        'Content-Type': 'application/json',
                                      },
                                      body: jsonEncode(payload),
                                    );

                                    if (response.statusCode == 200) {
                                      print('✅ Service updated successfully');
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            '✅ Service updated successfully',
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      print('❌ Server error: ${response.body}');
                                      _showErrorSnackbar(
                                        '❌ Failed to update service: ${response.body}',
                                      );
                                    }
                                  } catch (e) {
                                    print('❌ General error: $e');
                                    _showErrorSnackbar(
                                      'Something went wrong: $e',
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: const Center(
                                  child: Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
