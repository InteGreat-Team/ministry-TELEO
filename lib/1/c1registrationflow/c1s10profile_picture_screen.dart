import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'c1s11signup_complete_screen.dart';
import '../../3/c1widgets/back_button.dart';
import 'profile_upload_service.dart'; // <-- NEW: Upload Service

class ProfilePictureScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String email;
  final String password;
  final String verificationCode;
  final String? phoneNumber;
  final String address;
  final double lat;
  final double lng;
  final bool isEmailVerified;
  final bool hasAcceptedTerms;

  const ProfilePictureScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.email,
    required this.password,
    required this.verificationCode,
    required this.address,
    required this.lat,
    required this.lng,
    required this.phoneNumber,
    required this.isEmailVerified,
    required this.hasAcceptedTerms,
  });

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  File? _selectedImage;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _showImageSourceOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Choose Photo Source',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF002642),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSourceOption(
                  icon: Icons.photo_library_outlined,
                  title: 'Photo Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                _buildSourceOption(
                  icon: Icons.camera_alt_outlined,
                  title: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF002642).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF002642),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF002642),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source, imageQuality: 80);
      if (image != null) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Error',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF002642),
            ),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF002642),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);

    try {
      final uploadedUrl = await ProfileUploadService.uploadProfilePicture(_selectedImage!);
      if (uploadedUrl == null) throw Exception("Upload failed");

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupCompleteScreen(
              firstName: widget.firstName,
              lastName: widget.lastName,
              birthday: widget.birthday,
              gender: widget.gender,
              username: widget.username,
              email: widget.email,
              phoneNumber: widget.phoneNumber,
              password: widget.password,
              address: widget.address,
              lat: widget.lat,
              lng: widget.lng,
              profilePictureUrl: uploadedUrl, // <-- Pass URL
              hasAcceptedTerms: widget.hasAcceptedTerms,
              isEmailVerified: widget.isEmailVerified,
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorDialog('Failed to upload image: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final imageSize = isTablet ? 180.0 : screenWidth * 0.4;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 48.0 : 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TeleoBackButton(),
              ),
              
              const Spacer(flex: 1),
              
              // Title Section
              Center(
                child: Column(
                  children: [
                    Text(
                      "Lastly, put a face to the name!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 32 : 26,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF002642),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "This will help people recognize you",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(flex: 1),
              
              // Testing indicator
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.shade50,
                      Colors.orange.shade50,
                    ],
                  ),
                  border: Border.all(color: Colors.orange.shade200, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.science_outlined,
                        color: Colors.orange.shade700,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Testing Feature: Profile pictures won't reflect in your account yet",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _isUploading ? null : _showImageSourceOptions,
                      child: Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedImage != null 
                                ? const Color(0xFF002642)
                                : Colors.grey.shade300,
                            width: _selectedImage != null ? 3 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _isUploading
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 3,
                                  ),
                                ),
                              )
                            : _selectedImage == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF002642).withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add_a_photo_outlined,
                                          color: Color(0xFF002642),
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Add Photo",
                                        style: TextStyle(
                                          color: Color(0xFF002642),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Tap to choose",
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                      ),
                    ),
                    
                    if (_selectedImage != null && !_isUploading) ...[
                      const SizedBox(height: 14),
                      TextButton.icon(
                        onPressed: _showImageSourceOptions,
                        icon: const Icon(Icons.edit_outlined, size: 14),
                        label: const Text('Change Photo'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF002642),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Bottom Buttons
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _isUploading
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupCompleteScreen(
                                      firstName: widget.firstName,
                                      lastName: widget.lastName,
                                      birthday: widget.birthday,
                                      gender: widget.gender,
                                      username: widget.username,
                                      email: widget.email,
                                      phoneNumber: widget.phoneNumber,
                                      password: widget.password,
                                      address: widget.address,
                                      lat: widget.lat,
                                      lng: widget.lng,
                                      profilePictureUrl: null, // <-- Skipped
                                      hasAcceptedTerms: widget.hasAcceptedTerms,
                                      isEmailVerified: widget.isEmailVerified,
                                    ),
                                  ),
                                );
                              },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: (_selectedImage != null && !_isUploading) ? _uploadImage : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF002642),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isUploading) ...[
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              _isUploading ? 'Uploading...' : 'Continue',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
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
}