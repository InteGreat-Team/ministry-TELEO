import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:teleo_organized_new/1/c1homepage/nav_bar.dart';
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import '../../backend/viewmodels/CHURCH_CREATEVENTS_FUNC.dart';
import '../../../c2eventscreation/widgets/event_app_bar.dart';
import '../../../c2eventscreation/widgets/required_asterisk.dart';
import '../../../c2eventscreation/widgets/step_indicator.dart';
import '../screens/CHURCH_CREATEVENTS_2.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateEventViewModel(),
      child: Consumer<CreateEventViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: EventAppBar(
              onBackPressed: () => Navigator.maybePop(context),
              title: '',
            ),
            body: Form(
              key: viewModel.formKey,
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
                                // Image Upload Area
                                _buildImageUploadArea(viewModel),
                                // Display selected images
                                if (viewModel.hasMainImage ||
                                    viewModel.event.additionalImages.isNotEmpty)
                                  _buildSelectedImagesGrid(viewModel),

                                // Event Title
                                const SizedBox(height: 20),
                                _buildEventTitleField(viewModel),

                                // Event Tags
                                const SizedBox(height: 20),
                                _buildEventTagsSection(viewModel),

                                // Event Description
                                const SizedBox(height: 20),
                                _buildEventDescriptionField(viewModel),

                                // Mobile Number
                                const SizedBox(height: 20),
                                _buildMobileNumberField(viewModel),

                                // Church Landline
                                const SizedBox(height: 16),
                                _buildChurchLandlineField(viewModel),

                                // Dress Code
                                const SizedBox(height: 16),
                                _buildDressCodeField(viewModel),

                                // Guest/Speaker
                                const SizedBox(height: 20),
                                _buildSpeakersSection(viewModel),

                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButtonBar(viewModel),
                ],
              ),
            ),
            bottomNavigationBar: NavBar(
              currentIndex: 2, // Set to the correct index for Events
              onTap: (index) {
                // Add navigation logic if needed
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageUploadArea(CreateEventViewModel viewModel) {
    return GestureDetector(
      onTap: () async {
        try {
          await viewModel.pickImage();
        } catch (e) {
          _showErrorSnackbar(e.toString());
        }
      },
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
            Icon(Icons.image, color: Colors.grey[600], size: 48),
            const SizedBox(height: 12),
            Text('Tap to upload image',
                style: TextStyle(color: Colors.grey[700], fontSize: 16)),
            const SizedBox(height: 8),
            Text('Supports: JPG, JPEG, PNG',
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            if (viewModel.totalImagesCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '${viewModel.totalImagesCount}/${viewModel.maxImages} ${viewModel.totalImagesCount == 1 ? 'image' : 'images'} selected',
                  style: TextStyle(
                    color: viewModel.totalImagesCount >= viewModel.maxImages
                        ? Colors.red
                        : Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagesGrid(CreateEventViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selected Images:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.5,
            children: [
              if (viewModel.hasMainImage)
                _buildCompactImageCard(
                  viewModel.event.imageBytes,
                  viewModel.event.imagePath,
                  'Image 1 (Main)',
                  onRemove: () => viewModel.removeImage(-1),
                ),
              ...List.generate(
                viewModel.event.additionalImages.length,
                (index) => _buildCompactImageCard(
                  viewModel.event.additionalImages[index].imageBytes,
                  viewModel.event.additionalImages[index].imagePath,
                  'Image ${index + 2}',
                  onRemove: () => viewModel.removeImage(index),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventTitleField(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Event Title',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const RequiredAsterisk(),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: viewModel.titleController,
          decoration: _getFilledInputDecoration().copyWith(
            hintText: 'Enter event title',
            errorText: viewModel.errorMessages['title'],
          ),
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(EventConstants.titlePattern)),
          ],
        ),
      ],
    );
  }

  Widget _buildEventTagsSection(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Event Tags',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const RequiredAsterisk(),
            if (viewModel.errorMessages.containsKey('tags'))
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  viewModel.errorMessages['tags']!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: viewModel.availableTags.map((tag) {
            final isSelected = viewModel.event.tags.contains(tag);
            return GestureDetector(
              onTap: () => viewModel.toggleTag(tag),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFC107) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFFC107)
                        : Colors.grey[400]!,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEventDescriptionField(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Event Description',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const RequiredAsterisk(),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: viewModel.descriptionController,
          decoration: _getFilledInputDecoration().copyWith(
            hintText: 'Enter event description',
            errorText: viewModel.errorMessages['description'],
          ),
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildMobileNumberField(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Mobile Number',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const RequiredAsterisk(),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: viewModel.mobileNumberController,
          decoration: _getFilledInputDecoration().copyWith(
            hintText: '(09123456789)',
            errorText: viewModel.errorMessages['mobileNumber'],
            prefixIcon: const Icon(Icons.phone_android),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9\+\-\s]')),
            LengthLimitingTextInputFormatter(EventConstants.mobileMaxLength),
          ],
        ),
      ],
    );
  }

  Widget _buildChurchLandlineField(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Church Landline',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(' (optional)',
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: viewModel.churchLandlineController,
          decoration: _getFilledInputDecoration().copyWith(
            hintText: 'Enter church landline/telephone number',
            prefixIcon: const Icon(Icons.phone),
            errorText: viewModel.errorMessages['churchLandline'],
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(EventConstants.landlineLength),
          ],
        ),
      ],
    );
  }

  Widget _buildDressCodeField(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dress Code (optional)',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: viewModel.dressCodeController,
          decoration: _getFilledInputDecoration().copyWith(
            hintText: 'E.g., Smart Casual',
            helperText: 'Only letters, numbers, spaces, and hyphens allowed',
            errorText: viewModel.errorMessages['dressCode'],
          ),
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(EventConstants.dressCodePattern)),
            LengthLimitingTextInputFormatter(EventConstants.dressCodeMaxLength),
          ],
        ),
      ],
    );
  }

  Widget _buildSpeakersSection(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Guest/Speaker',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          'Only letters, spaces, periods, and hyphens allowed',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.speakerControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: viewModel.speakerControllers[index],
                          decoration: _getFilledInputDecoration().copyWith(
                            hintText: index == 0
                                ? 'Enter speaker name'
                                : 'Guest/Speaker ${index + 1}',
                            errorText: viewModel.errorMessages['speaker$index'],
                          ),
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(EventConstants.namePattern)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: viewModel.speakerControllers.length > 1 ||
                                  index > 0
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed:
                            viewModel.speakerControllers.length > 1 || index > 0
                                ? () => viewModel.removeSpeaker(index)
                                : null,
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A4A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                onPressed: viewModel.addSpeaker,
                tooltip: 'Add New Guest/Speaker',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButtonBar(CreateEventViewModel viewModel) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.maybePop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0A0A4A),
                    side: const BorderSide(color: Color(0xFF0A0A4A)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Back'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (viewModel.canProceed()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChurchCreateEvent2(event: viewModel.event),
                        ),
                      );
                    } else {
                      _showErrorSnackbar(ValidationMessages.fillRequiredFields);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A0A4A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12)),
                GestureDetector(
                  onTap: onRemove,
                  child: const Icon(Icons.delete, color: Colors.red, size: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: imageBytes != null
                  ? Image.memory(imageBytes,
                      width: double.infinity, fit: BoxFit.cover)
                  : imagePath != null
                      ? Image.file(File(imagePath),
                          width: double.infinity, fit: BoxFit.cover)
                      : Container(
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image,
                              size: 30, color: Colors.grey),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _getFilledInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      hintStyle: TextStyle(color: Colors.grey[600]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red)),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
