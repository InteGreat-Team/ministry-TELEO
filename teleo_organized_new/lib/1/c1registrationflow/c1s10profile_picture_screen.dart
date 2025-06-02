import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'c1s11signup_complete_screen.dart';
import '../../3/c1widgets/back_button.dart';

class ProfilePictureScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String email;
  final String phone;
  final String password;
  final String verificationCode;
  final String location;

  const ProfilePictureScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.verificationCode,
    required this.location,
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      setState(() {
        _isUploading = true;
      });
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
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
      print('Error picking image from gallery: $e');
      _showErrorDialog('Failed to pick image from gallery');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      setState(() {
        _isUploading = true;
      });
      
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          _selectedImage = File(photo.path);
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
      print('Error picking image from camera: $e');
      _showErrorDialog('Failed to pick image from camera');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    
    setState(() {
      _isUploading = true;
    });
    
    try {
      // In a real app, you would upload the image to your server here
      // For this demo, we'll just simulate a network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Navigate to the next screen
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
              phone: widget.phone,
              password: widget.password,
              location: widget.location,
              profilePicture: _selectedImage,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print('Error uploading image: $e');
      _showErrorDialog('Failed to upload image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TeleoBackButton(),
              ),
              const SizedBox(height: 40),
              
              const Text(
                "Add a Profile Picture",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "This will help people recognize you",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              
              // Profile picture selection
              Center(
                child: GestureDetector(
                  onTap: _isUploading ? null : _showImageSourceOptions,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF002642),
                        width: 2,
                      ),
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _isUploading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : _selectedImage == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    color: Color(0xFF002642),
                                    size: 50,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Add Photo",
                                    style: TextStyle(
                                      color: Color(0xFF002642),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            : null,
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Skip and Next buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Row(
                  children: [
                    // Skip button
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
                                      phone: widget.phone,
                                      password: widget.password,
                                      location: widget.location,
                                    ),
                                  ),
                                );
                              },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
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
                    // Next button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: (_selectedImage != null && !_isUploading)
                            ? _uploadImage
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF002642),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        child: Text(
                          _isUploading ? 'Uploading...' : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
