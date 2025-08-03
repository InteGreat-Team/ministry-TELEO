// lib/features/SIGNUP/frontend/screens/USER_PROFILEPICTURESCREEN_12.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:teleo_app/features/SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';
import 'package:teleo_app/features/3/c1widgets/back_button.dart';

class UserProfilePictureScreen12 extends StatelessWidget {
  static const routeName = '/user-profile-picture';

  const UserProfilePictureScreen12({super.key});

  Future<void> _showImageSourceActionSheet(BuildContext context, UserSignupViewModel viewModel) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a picture'),
              onTap: () {
                Navigator.pop(context);
                viewModel.pickAndUploadProfilePicture(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                viewModel.pickAndUploadProfilePicture(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserSignupViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TeleoBackButton(),
              ),
              const SizedBox(height: 40),
              const Text(
                "Add a profile picture",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "This helps others recognize you.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Center(
                child: GestureDetector(
                  onTap: viewModel.isUploadingProfilePicture || viewModel.isRegisteringUser
                      ? null
                      : () => _showImageSourceActionSheet(context, viewModel),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: viewModel.selectedProfilePicture != null
                        ? FileImage(viewModel.selectedProfilePicture!)
                        : null,
                    child: viewModel.selectedProfilePicture == null
                        ? Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.grey[600],
                          )
                        : null,
                  ),
                ),
              ),
              if (viewModel.profilePictureError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Text(
                      viewModel.profilePictureError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: viewModel.isUploadingProfilePicture || viewModel.isRegisteringUser
                      ? null
                      : () => viewModel.registerUser(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: viewModel.isUploadingProfilePicture || viewModel.isRegisteringUser
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Complete Signup',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: viewModel.isUploadingProfilePicture || viewModel.isRegisteringUser
                      ? null
                      : () => viewModel.registerUser(context), // Allow skipping picture
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Skip for now',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
