import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReportBugScreen extends StatefulWidget {
  @override
  _ReportBugScreenState createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends State<ReportBugScreen> {
  final TextEditingController _detailsController = TextEditingController();
  String? _selectedBugType;
  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
      });
    }
  }

  final List<String> _bugTypes = [
    'App crashes unexpectedly',
    'Feature not working as intended',
    'Slow app performance',
    'Login or account issues',
    'UI layout problems (e.g. overlapping text)',
    'Notification issues',
    'Payment or checkout errors',
    'Syncing or data not updating',
    'Update problem',
    'Others (please specify)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _buildSectionTitle('Nature of Report'),
            SizedBox(height: 8),
            _buildDropdown(),
            SizedBox(height: 4),
            Text(
              'Choose a reason for reporting the issue',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            _buildSectionTitle('Details of the Report'),
            SizedBox(height: 8),
            _buildTextField(
              controller: _detailsController,
              hintText: 'Enter details',
              helperText: 'Provide additional information about the issue.',
              maxLines: 4,
            ),
            SizedBox(height: 24),
            _buildSectionTitle('Upload Images'),
            SizedBox(height: 8),
            _buildImageUpload(),
            SizedBox(height: 4),
            Text(
              'Provide images as proof to support your claim.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String helperText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          helperText,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedBugType,
        decoration: InputDecoration(
          hintText: 'Select a bug type',
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
        items:
            _bugTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type, style: TextStyle(fontSize: 14)),
              );
            }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedBugType = newValue;
          });
        },
      ),
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supported formats: png, jpg, jpeg, heic',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Text(
          'Max: 10 MB',
          style: TextStyle(
            fontSize: 12,
            color: Colors.red[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child:
                _imageFile == null
                    ? Row(
                      children: [
                        Icon(Icons.add_circle_outline, color: Colors.grey[500]),
                        SizedBox(width: 12),
                        Text(
                          'Choose image to upload',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.grey[500],
                          size: 16,
                        ),
                      ],
                    )
                    : Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _imageFile!.name,
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _imageFile = null;
                            });
                          },
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Submit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _submitReport() {
    // Validation
    if (_selectedBugType == null) {
      _showErrorDialog('Please select a bug type');
      return;
    }

    if (_detailsController.text.isEmpty) {
      _showErrorDialog('Please provide details about the issue');
      return;
    }

    // Show confirmation dialog
    _showConfirmationDialog();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Are You Sure?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Do you want to submit this bug report? This action cannot be undone.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close confirmation dialog
                _processReport();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _processReport() {
    // Simulate report processing
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ReportSuccessScreen()),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class ReportSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange[400],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Successful',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Thank you for your report. We\'ve received your complaint and it has been forwarded to our admin team for review.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to main screen or home
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1B3A4B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
