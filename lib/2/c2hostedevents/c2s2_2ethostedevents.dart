import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditEventPage extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EditEventPage({super.key, required this.eventData});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _contactInfoController;
  late TextEditingController _dressCodeController;
  late TextEditingController _locationController;
  late TextEditingController _eventFeeController;
  
  bool _isMultiDayEvent = false;
  DateTime _startDate = DateTime.now();
  List<DateTime> _additionalDates = [];
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 12, minute: 30);
  
  List<String> _selectedTags = [];
  final List<String> _availableTags = [
    'Seminar', 'Education', 'Religious Celebrations', 
    'Music', 'Community', 'Healing', 'Ex Tags'
  ];
  
  List<String> _speakers = ['Mr. Catubag', 'Youth Choir'];
  
  final String _defaultEventImageUrl = 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-5ie8lHl9F4eq57TmKSu8zKV6fzmIHK.png';
  
  // List to store multiple event images (up to 5)
  List<Map<String, dynamic>> _eventImages = [];
  final int _maxImages = 5;
  
  final ImagePicker _picker = ImagePicker();
  bool _imagesChanged = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing event data
    _titleController = TextEditingController(text: widget.eventData['title'] ?? 'PRAISE! Youth Worship Charity Concert');
    _descriptionController = TextEditingController(text: widget.eventData['description'] ?? 
      'Our event focuses on the sly brown fox jumped over the hedge and I don\'t know what else to put in here but this is where you put the event description and every breath you take, every move you make, what am I even saying.\n\nThis proceed will go to charity for the wicked. No one mourns the wicked. Let us be glad, let us be grateful, let us rejoicify that goodness could subdue.\n\nMona mona Lisa girl I need ya I like my girls pretty so fine one plus the nine how you got me going might just blow it I like my girls pretty in the face.\n\nYou and me and all of the people and I don\'t know why, I can\'t take my eyes off of you. Cause it\'s like that.');
    _contactInfoController = TextEditingController(text: widget.eventData['contactInfo'] ?? '0948925748');
    _dressCodeController = TextEditingController(text: widget.eventData['dressCode'] ?? 'Smart Casual');
    _locationController = TextEditingController(text: widget.eventData['location'] ?? 'Type Location with Maps...');
    _eventFeeController = TextEditingController(text: widget.eventData['eventFee'] ?? '200.00');
    
    // Initialize selected tags
    _selectedTags = widget.eventData['tags'] != null 
        ? List<String>.from(widget.eventData['tags']) 
        : ['Music', 'Community'];
    
    // Initialize speakers
    _speakers = widget.eventData['speakers'] != null 
        ? List<String>.from(widget.eventData['speakers']) 
        : ['Mr. Catubag', 'Youth Choir'];
    
    // Initialize event images
    if (widget.eventData['eventImages'] != null && widget.eventData['eventImages'] is List) {
      _eventImages = List<Map<String, dynamic>>.from(widget.eventData['eventImages']);
    } else {
      // Initialize with a default image if no images are provided
      _eventImages = [
        {
          'url': widget.eventData['imageUrl'] ?? _defaultEventImageUrl,
          'label': 'Main Event Image',
          'isDefault': true
        }
      ];
    }
    
    // Parse date and time if available
    if (widget.eventData['time'] != null) {
      final timeParts = widget.eventData['time'].toString().split(' - ');
      if (timeParts.length == 2) {
        try {
          final dateFormat = DateFormat('MMMM d, yyyy');
          final timeFormat = DateFormat('h:mm a');
          
          final datePart = timeParts[0].split(' ').sublist(0, 3).join(' ');
          final startTimePart = timeParts[0].split(' ').sublist(3).join(' ');
          final endTimePart = timeParts[1];
          
          _startDate = dateFormat.parse(datePart);
          
          final startTimeParsed = timeFormat.parse(startTimePart);
          _startTime = TimeOfDay(hour: startTimeParsed.hour, minute: startTimeParsed.minute);
          
          final endTimeParsed = timeFormat.parse(endTimePart);
          _endTime = TimeOfDay(hour: endTimeParsed.hour, minute: endTimeParsed.minute);
        } catch (e) {
          print('Error parsing date/time: $e');
        }
      }
    }
    
    // Check if it's a multi-day event
    _isMultiDayEvent = widget.eventData['isMultiDayEvent'] ?? false;
    
    // Initialize additional dates if available
    if (widget.eventData['additionalDates'] != null) {
      _additionalDates = List<DateTime>.from(widget.eventData['additionalDates'].map((date) => DateTime.parse(date)));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contactInfoController.dispose();
    _dressCodeController.dispose();
    _locationController.dispose();
    _eventFeeController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    final formattedDate = DateFormat('MM/dd/yyyy').format(date);
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$formattedDate, $hour:$minute $period';
  }

  // Check if a date is already used in the event
  bool _isDateAlreadyUsed(DateTime date, [int? excludeIndex]) {
    // Check if it's the same as the start date
    if (_isSameDay(date, _startDate)) {
      return true;
    }
    
    // Check if it's the same as any additional date (except the one being edited)
    for (int i = 0; i < _additionalDates.length; i++) {
      if (excludeIndex != null && i == excludeIndex) {
        continue; // Skip the date being edited
      }
      if (_isSameDay(date, _additionalDates[i])) {
        return true;
      }
    }
    
    return false;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate, [int? additionalDateIndex]) async {
    // Get the current date for validation
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    
    // Set initial date based on context
    DateTime initialDate;
    if (isStartDate) {
      // For start date, use current start date or today if it's in the past
      initialDate = _startDate.isBefore(today) ? today : _startDate;
    } else if (additionalDateIndex != null) {
      // For additional dates, use the existing date or day after start date
      initialDate = _additionalDates[additionalDateIndex].isBefore(today) 
          ? today 
          : _additionalDates[additionalDateIndex];
    } else {
      // Default case - day after start date
      initialDate = _startDate.add(const Duration(days: 1));
    }
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today, // Don't allow past dates
      lastDate: DateTime(2030),
      selectableDayPredicate: (DateTime day) {
        // For start date, only check if it's not in the past
        if (isStartDate) {
          return !day.isBefore(today);
        }
        
        // For additional dates, check if it's not in the past and not already used
        // (except for the date being edited)
        return !day.isBefore(today) && 
               !day.isBefore(_startDate) && 
               !_isDateAlreadyUsed(day, additionalDateIndex);
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          // If changing start date, need to check if it conflicts with additional dates
          final DateTime oldStartDate = _startDate;
          _startDate = picked;
          
          // If start date changed, validate all additional dates
          // Remove any additional dates that are now before the start date or duplicate
          _additionalDates = _additionalDates
              .where((date) => !date.isBefore(_startDate) && !_isSameDay(date, _startDate))
              .toList();
        } else if (additionalDateIndex != null) {
          // This should be safe now because of selectableDayPredicate, but double-check
          if (picked.isBefore(_startDate)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Additional dates must be after the start date')),
            );
            return;
          }
          
          if (_isDateAlreadyUsed(picked, additionalDateIndex)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('This date is already selected for another day')),
            );
            return;
          }
          
          _additionalDates[additionalDateIndex] = picked;
        }
      });
    }
  }

  // Helper method to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _addSpeaker() {
    setState(() {
      _speakers.add('');
    });
  }

  void _removeSpeaker(int index) {
    if (_speakers.length > 1) {
      setState(() {
        _speakers.removeAt(index);
      });
    }
  }

  void _updateSpeaker(int index, String value) {
    setState(() {
      _speakers[index] = value;
    });
  }

  void _addAnotherDay() {
    setState(() {
      // Get the current date for validation
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);
      
      // Find the next available date after the last date
      DateTime lastDate = _additionalDates.isNotEmpty 
          ? _additionalDates.last 
          : _startDate;
      
      // Start with the day after the last date
      DateTime newDate = lastDate.add(const Duration(days: 1));
      
      // Ensure the new date is not in the past
      if (newDate.isBefore(today)) {
        newDate = today;
      }
      
      // Keep incrementing the date until we find one that's not already used
      while (_isDateAlreadyUsed(newDate)) {
        newDate = newDate.add(const Duration(days: 1));
      }
      
      // Add the new date
      _additionalDates.add(newDate);
    });
  }

  void _removeDay(int index) {
    setState(() {
      _additionalDates.removeAt(index);
    });
  }

  Future<void> _pickImage(ImageSource source, {String label = ''}) async {
    try {
      // Check if we've reached the maximum number of images
      if (_eventImages.length >= _maxImages) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Maximum of $_maxImages images allowed')),
        );
        return;
      }
      
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        // Show dialog to get image label if not provided
        final String imageLabel = label.isEmpty 
            ? await _getImageLabel(context, 'Image ${_eventImages.length + 1}') 
            : label;
        
        setState(() {
          // Add the new image to the list
          _eventImages.add({
            'file': File(pickedFile.path),
            'url': 'https://example.com/uploaded_image_${DateTime.now().millisecondsSinceEpoch}.jpg', // Simulated URL
            'label': imageLabel,
            'isDefault': false
          });
          
          _imagesChanged = true;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // Method to get image label from user
  Future<String> _getImageLabel(BuildContext context, String defaultLabel) async {
    final TextEditingController labelController = TextEditingController(text: defaultLabel);
    String result = defaultLabel;
    
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Label'),
          content: TextField(
            controller: labelController,
            decoration: const InputDecoration(
              hintText: 'Enter a label for this image',
            ),
            maxLength: 30,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                result = labelController.text.isNotEmpty 
                    ? labelController.text 
                    : defaultLabel;
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    
    return result;
  }

  void _removeImage(int index) {
    setState(() {
      _eventImages.removeAt(index);
      _imagesChanged = true;
    });
  }

  void _editImageLabel(int index) async {
    final String newLabel = await _getImageLabel(context, _eventImages[index]['label']);
    
    setState(() {
      _eventImages[index]['label'] = newLabel;
      _imagesChanged = true;
    });
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Add this method after _showImagePickerOptions()
  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF000233),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Location',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 70), // Balance the cancel button
                  ],
                ),
              ),
              
              // Search bar
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.menu, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Select Location',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    Icon(Icons.search, color: Colors.grey[600]),
                  ],
                ),
              ),
              
              // Map placeholder
              Expanded(
                child: Stack(
                  children: [
                    // Map background
                    Container(
                      color: Colors.grey[200],
                      child: Image.network(
                        'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-p5XavYH28ez0KOqEKEgY1bE5CvohGs.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Text('Map Placeholder'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bottom venue info
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Venue Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      'Sample Street 12, Brgy. 222,\nCity, City, Bla Bla, 1011',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '0.0km',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Set the location and close the modal
                          setState(() {
                            _locationController.text = 'Sample Street 12, Brgy. 222, City, City, Bla Bla, 1011';
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF000233),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Choose this Location'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Add this helper method after _showLocationPicker()
  Widget _buildLocationListItem(String name, {bool isRecent = false}) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isRecent ? Colors.grey[200] : Colors.blue[50],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              isRecent ? Icons.history : Icons.location_on,
              color: isRecent ? Colors.grey[700] : Colors.blue,
              size: 20,
            ),
          ),
          title: Text(name),
          subtitle: const Text('Sample Street 12, Brgy. 222, City, City, Bla Bla, 1011'),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        const Divider(height: 1),
      ],
    );
  }

  // Validate Philippine mobile number
  bool _isValidPhilippineMobileNumber(String number) {
    // Philippine mobile numbers are 10 digits and start with 09
    final RegExp regex = RegExp(r'^09\d{8}$');
    return regex.hasMatch(number);
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Create updated event data
      final updatedEventData = Map<String, dynamic>.from(widget.eventData);
      
      // Update with new values
      updatedEventData['title'] = _titleController.text;
      updatedEventData['description'] = _descriptionController.text;
      updatedEventData['contactInfo'] = _contactInfoController.text;
      updatedEventData['dressCode'] = _dressCodeController.text;
      updatedEventData['location'] = _locationController.text;
      updatedEventData['eventFee'] = _eventFeeController.text;
      updatedEventData['tags'] = _selectedTags;
      updatedEventData['speakers'] = _speakers;
      updatedEventData['isMultiDayEvent'] = _isMultiDayEvent;
      updatedEventData['imagesChanged'] = _imagesChanged;
      
      // Important: Update the images data
      updatedEventData['eventImages'] = _eventImages;
      updatedEventData['imageUrl'] = _eventImages.isNotEmpty ? _eventImages[0]['url'] : _defaultEventImageUrl; // Main image for backward compatibility
      updatedEventData['additionalDates'] = _additionalDates.map((date) => date.toIso8601String()).toList();
      
      // Format date and time
      if (_isMultiDayEvent) {
        final List<String> dates = [DateFormat('MMMM d, yyyy').format(_startDate)];
        for (var date in _additionalDates) {
          dates.add(DateFormat('MMMM d, yyyy').format(date));
        }
        updatedEventData['time'] = '${dates.first} - ${dates.last}';
      } else {
        final startFormatted = DateFormat('MMMM d, yyyy').format(_startDate);
        final startTimeFormatted = _startTime.format(context);
        final endTimeFormatted = _endTime.format(context);
        updatedEventData['time'] = '$startFormatted $startTimeFormatted - $endTimeFormatted';
      }
      
      // Debug print to verify data
      print("Saving updated event data with images: ${updatedEventData['eventImages']}");
      
      // Return the updated data to the previous screen
      Navigator.pop(context, updatedEventData);
    }
  }

  // Show a confirmation dialog for canceling the event
  void _showCancelEventDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF3F51B5), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3F51B5).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_rounded,
                        color: Color(0xFF3F51B5),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Cancel Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Are you sure you want to cancel this event? This action cannot be undone.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('No'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Return with cancel flag
                          Navigator.pop(context, {'cancelled': true});
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Yes, Cancel Event'),
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF000233),
        foregroundColor: Colors.white,
        title: const Text('Edit Event Details'),
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        leadingWidth: 70,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Images
                const Text(
                  'Event Images',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                
                // Image carousel
                SizedBox(
                  height: 200,
                  child: _eventImages.isEmpty
                      ? Center(
                          child: Text(
                            'No images added',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _eventImages.length + (_eventImages.length < _maxImages ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Add image button at the end
                            if (index == _eventImages.length) {
                              return Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: InkWell(
                                  onTap: _showImagePickerOptions,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey[600]),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Add Image\n(${_eventImages.length}/$_maxImages)',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            
                            // Display existing images
                            final image = _eventImages[index];
                            return Stack(
                              children: [
                                Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                          child: image['file'] != null
                                              ? Image.file(
                                                  image['file'],
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  image['url'],
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                                                    );
                                                  },
                                                ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                image['label'] ?? 'Image ${index + 1}',
                                                style: const TextStyle(fontSize: 12),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () => _editImageLabel(index),
                                              child: const Icon(Icons.edit, size: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Remove button
                                if (!image['isDefault'] || _eventImages.length > 1)
                                  Positioned(
                                    top: 4,
                                    right: 12,
                                    child: InkWell(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                // Main image indicator
                                if (index == 0)
                                  Positioned(
                                    top: 4,
                                    left: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Main',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                ),
                
                const SizedBox(height: 16),
                
                // Event Title
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Event Title ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    counterText: '${_titleController.text.length}/50',
                  ),
                  style: const TextStyle(fontSize: 16),
                  maxLength: 50, // Limit to 50 characters
                  inputFormatters: [
                    // Prevent special characters
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event title';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Force rebuild to update counter
                    setState(() {});
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Event Tags
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Event Tags ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableTags.map((tag) {
                    final isSelected = _selectedTags.contains(tag);
                    return GestureDetector(
                      onTap: () => _toggleTag(tag),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFFC107) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFFC107) : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 16),
                
                // Event Description
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Event Description ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  style: const TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event description';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Contact Info
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Contact Info ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _contactInfoController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    hintText: '09XXXXXXXX',
                    helperText: 'Enter a valid Philippine mobile number (e.g., 0912345678)',
                    counterText: '${_contactInfoController.text.length}/10',
                  ),
                  style: const TextStyle(fontSize: 16),
                  maxLength: 10, // Exactly 10 digits for Philippine mobile numbers
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter contact information';
                    }
                    if (!_isValidPhilippineMobileNumber(value)) {
                      return 'Please enter a valid Philippine mobile number (09XXXXXXXX)';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Force rebuild to update counter
                    setState(() {});
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Dress Code
                const Text(
                  'Dress Code (optional)',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dressCodeController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    counterText: '${_dressCodeController.text.length}/50',
                  ),
                  style: const TextStyle(fontSize: 16),
                  maxLength: 50, // Limit to 50 characters
                  inputFormatters: [
                    // Prevent special characters
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                  ],
                  onChanged: (value) {
                    // Force rebuild to update counter
                    setState(() {});
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Guest/Speaker
                const Text(
                  'Guest/Speaker',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _speakers.length,
                  itemBuilder: (context, index) {
                    // Create a TextEditingController for each speaker
                    final TextEditingController speakerController = TextEditingController(text: _speakers[index]);
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (index > 0)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                'Guest/Speaker ${index + 1}',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          Expanded(
                            child: TextFormField(
                              controller: speakerController,
                              onChanged: (value) {
                                _updateSpeaker(index, value);
                                // Force rebuild to update counter
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                counterText: '${speakerController.text.length}/50',
                              ),
                              style: const TextStyle(fontSize: 16),
                              maxLength: 50, // Limit to 50 characters
                              inputFormatters: [
                                // Prevent special characters
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: Icon(
                                index == _speakers.length - 1 ? Icons.add_circle_outline : Icons.remove_circle_outline,
                                color: index == _speakers.length - 1 ? Colors.green : Colors.red,
                                size: 24,
                              ),
                              onPressed: index == _speakers.length - 1 ? _addSpeaker : () => _removeSpeaker(index),
                              padding: const EdgeInsets.all(12),
                              constraints: const BoxConstraints(),
                              splashRadius: 24,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Event Date
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Event Date ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: _isMultiDayEvent,
                      onChanged: (value) {
                        setState(() {
                          _isMultiDayEvent = value!;
                          if (!_isMultiDayEvent) {
                            _additionalDates.clear();
                          }
                        });
                      },
                    ),
                    const Text('One Day Event'),
                    const SizedBox(width: 16),
                    Radio<bool>(
                      value: true,
                      groupValue: _isMultiDayEvent,
                      onChanged: (value) {
                        setState(() {
                          _isMultiDayEvent = value!;
                        });
                      },
                    ),
                    const Text('Multiple Day Event'),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Event Date and Time
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Event Date and Time ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isMultiDayEvent
                              ? DateFormat('MM/dd/yyyy').format(_startDate)
                              : '${DateFormat('MM/dd/yyyy').format(_startDate)}, ${_startTime.format(context)} - ${_endTime.format(context)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, true),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        splashRadius: 24,
                      ),
                      if (!_isMultiDayEvent)
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () => _selectTime(context, true),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          splashRadius: 24,
                        ),
                    ],
                  ),
                ),
                
                if (_isMultiDayEvent) ...[
                  // Additional days
                  for (int i = 0; i < _additionalDates.length; i++) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Day ${i + 2} Event Date',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () => _removeDay(i),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          splashRadius: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateFormat('MM/dd/yyyy').format(_additionalDates[i]),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context, false, i),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                            splashRadius: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  // Add Another Day button
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: _addAnotherDay,
                    icon: const Icon(Icons.add_circle, color: Color(0xFF000233)),
                    label: const Text(
                      'Add Another Day',
                      style: TextStyle(color: Color(0xFF000233)),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Location
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Location ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.map, color: Color(0xFF000233)),
                      onPressed: _showLocationPicker,
                      padding: const EdgeInsets.all(12),
                      splashRadius: 24,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Event Fee
                const Text(
                  'Event Fee (optional)',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('P', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _eventFeeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        style: const TextStyle(fontSize: 16),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('/pax', style: TextStyle(fontSize: 16)),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Discard Edits'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF000233),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Update Edits'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}