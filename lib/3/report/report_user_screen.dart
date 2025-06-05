import 'package:flutter/material.dart';

class ReportUserScreen extends StatefulWidget {
  @override
  _ReportUserScreenState createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends State<ReportUserScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String? _selectedReason;

  final List<String> _reportReasons = [
    'Inappropriate or offensive language',
    'Harassment',
    'Bullying',
    'Spam',
    'Sharing misleading information',
    'Posting explicit content',
    'Threats or violent behavior',
    'Fraudulent activity',
    'Discriminatory remarks',
    'Violation of community guidelines',
    'Sharing personal or private information',
    'Others (please specify)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Report a User',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _buildSectionTitle('User to Report'),
            SizedBox(height: 8),
            _buildTextField(
              controller: _usernameController,
              hintText: 'Enter username',
              helperText:
                  'Please provide the username of the user you want to report',
            ),
            SizedBox(height: 24),
            _buildSectionTitle('Reason for Report'),
            SizedBox(height: 8),
            _buildDropdown(),
            SizedBox(height: 4),
            Text(
              'Choose a reason for reporting the user',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            _buildSectionTitle('Additional Details'),
            SizedBox(height: 8),
            _buildTextField(
              controller: _detailsController,
              hintText: 'Enter details',
              helperText:
                  'Provide additional information about the issue (optional)',
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
        value: _selectedReason,
        decoration: InputDecoration(
          hintText: 'Select a form of report',
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
        items:
            _reportReasons.map((String reason) {
              return DropdownMenuItem<String>(
                value: reason,
                child: Text(reason, style: TextStyle(fontSize: 14)),
              );
            }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedReason = newValue;
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
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(Icons.add_circle_outline, color: Colors.grey[500]),
              SizedBox(width: 12),
              Text(
                'Choose image to upload',
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
              Spacer(),
              Icon(Icons.arrow_upward, color: Colors.grey[500], size: 16),
            ],
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
    if (_usernameController.text.isEmpty) {
      _showErrorDialog('Please enter a username');
      return;
    }

    if (_selectedReason == null) {
      _showErrorDialog('Please select a reason for reporting');
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
            'Do you want to submit this report? This action cannot be undone.',
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
