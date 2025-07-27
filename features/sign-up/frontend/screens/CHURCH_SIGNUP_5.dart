import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../../backend/models/CHURCH_SIGNUP_VAR.dart'; // For ChurchModel
import '../../backend/viewmodels/CHURCH_SIGNUP_FUNC.dart'; // For ChurchSignupViewModel
import '../widgets/index.dart'; // For TeleoBackButton, CustomHeader, CustomElevatedButton, LoadingOverlay

class ChurchLogoScreen extends StatefulWidget {
  final ChurchModel church;

  const ChurchLogoScreen({
    super.key,
    required this.church,
  });

  @override
  State<ChurchLogoScreen> createState() => _ChurchLogoScreenState();
}

class _ChurchLogoScreenState extends State<ChurchLogoScreen> {
  File? _logoFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // If there's already a logo URL in the church model, we could download it here
    // and set _logoFile, but that would require additional logic and a network call.
    // For now, we'll assume _logoFile is set only by user selection.
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _logoFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ChurchSignupViewModel>(
          builder: (context, viewModel, child) {
            return LoadingOverlay(
              isLoading: viewModel.isUploadingLogo, // Use ViewModel's loading state
              message: 'Uploading logo...',
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
                    const SizedBox(height: 24),
                    
                    // Title and Subtitle
                    const CustomHeader(
                      title: "Church Logo",
                      subtitle: "Upload your church logo",
                      icon: Icons.church,
                      iconColor: Colors.black,
                    ),
                    const SizedBox(height: 32),
                    
                    // Logo preview
                    Expanded(
                      child: Center(
                        child: _logoFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  _logoFile!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.church,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                    
                    // Upload buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomElevatedButton(
                          onPressed: viewModel.isUploadingLogo ? null : () => _pickImage(ImageSource.camera),
                          text: 'Take Photo',
                          icon: Icons.camera_alt,
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black87,
                          height: 40,
                          width: 150, // Fixed width for consistency
                        ),
                        const SizedBox(width: 16),
                        CustomElevatedButton(
                          onPressed: viewModel.isUploadingLogo ? null : () => _pickImage(ImageSource.gallery),
                          text: 'Gallery',
                          icon: Icons.photo_library,
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black87,
                          height: 40,
                          width: 150, // Fixed width for consistency
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Next button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: CustomElevatedButton(
                        onPressed: _logoFile != null && !viewModel.isUploadingLogo
                            ? () => _navigateToNextScreen(viewModel)
                            : null,
                        text: 'Next',
                        backgroundColor: const Color(0xFF002642),
                        foregroundColor: Colors.white,
                        height: 56,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToNextScreen(ChurchSignupViewModel viewModel) {
    // In a real app, you would upload the logo via the ViewModel here
    // For now, we'll just update the church model with the local file path
    final updatedChurch = widget.church.copyWith(
      logoUrl: _logoFile?.path, // Assuming ChurchModel has a logoUrl field
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChurchContactScreen(
          church: updatedChurch,
        ),
      ),
    );
  }
}
